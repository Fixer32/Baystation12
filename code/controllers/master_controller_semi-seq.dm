//Nothing spectacular, just a slightly more configurable MC.

var/global/datum/controller/game_controller/master_controller //Set in world.New()
var/global/controller_iteration1 = 0
var/global/controller_iteration2 = 0


var/global/last_tick_timeofday1 = world.timeofday
var/global/last_tick_timeofday2 = world.timeofday
var/global/last_tick_duration1 = 0
var/global/last_tick_duration2 = 0

var/global/obj/machinery/last_obj_processed			//Used for MC 'proc break' debugging
var/global/datum/disease/last_disease_processed		//Used for MC 'proc break' debugging
var/global/obj/machinery/last_machine_processed		//Used for MC 'proc break' debugging

datum/controller/game_controller
	var/processing = 0
	var/breather_ticks = 1		//a somewhat crude attempt to iron over the 'bumps' caused by high-cpu use by letting the MC have a breather for this many ticks after every step
	var/minimum_ticks1 = 10		//The minimum length of time between MC ticks
	var/minimum_ticks2 = 20		//The minimum length of time between MC ticks

	var/air_cost 		= 0
	var/sun_cost		= 0
	var/mobs_cost		= 0
	var/diseases_cost	= 0
	var/machines_cost	= 0
	var/objects_cost	= 0
	var/networks_cost	= 0
	var/powernets_cost	= 0
	var/ticker_cost		= 0
	var/total_cost1		= 0
	var/total_cost2		= 0

	var/even = 1

datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		if(istype(master_controller))
			del(master_controller)
		master_controller = src

	if(!air_master)
		air_master = new /datum/controller/air_system()
		air_master.setup()

	if(!job_master)
		job_master = new /datum/controller/occupations()
		if(job_master.SetupOccupations())
			world << "\red \b Job setup complete"
			job_master.LoadJobs("config/jobs.txt")

//	if(!tension_master)				tension_master = new /datum/tension()
	if(!syndicate_code_phrase)		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)	syndicate_code_response	= generate_code_phrase()
	if(!ticker)						ticker = new /datum/controller/gameticker()
	if(!emergency_shuttle)			emergency_shuttle = new /datum/shuttle_controller/emergency_shuttle()


datum/controller/game_controller/proc/setup()
	world.tick_lag = config.Ticklag

	createRandomZlevel()
	setup_objects()
	setupgenetics()
	setupfactions()

	for(var/i = 0, i < max_secret_rooms, i++)
		make_mining_asteroid_secret()

	spawn(0)
		if(ticker)
			ticker.pregame()

datum/controller/game_controller/proc/setup_objects()
	world << "\red \b Initializing objects"
	sleep(-1)
	for(var/obj/object in world)
		object.initialize()

	world << "\red \b Initializing pipe networks"
	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in world)
		machine.build_network()

	world << "\red \b Initializing atmos machinery."
	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in world)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	world << "\red \b Initializations complete."
	sleep(-1)


datum/controller/game_controller/proc/process()
	set background = 1

	processing = 1
	spawn(10)
		while(1)	//far more efficient than recursively calling ourself
			if(!Failsafe)	new /datum/controller/failsafe()
			if(processing)
				var/start_time_real = world.timeofday
				var/start_time = world.timeofday
				controller_iteration1++

				var/currenttime = world.timeofday
				last_tick_duration1 = (currenttime - last_tick_timeofday1) / 10
				last_tick_timeofday1 = currenttime

				if(!kill_air)
					air_master.current_cycle++
					var/success = air_master.process() //Changed so that a runtime does not crash the ticker.
					if(!success) //Runtimed.
						log_adminwarn("ZASALERT: air_system/tick() failed: [air_master.tick_progress]")
						air_master.failed_ticks++
						if(air_master.failed_ticks > 5)
							world << "<font color='red'><b>RUNTIMES IN ATMOS TICKER.  Killing air simulation!</font></b>"
							kill_air = 1
							air_master.failed_ticks = 0
				air_cost = (world.timeofday - start_time) / 10
				sleep(breather_ticks)

				var/i = 1
				while(i<=machines.len)
					var/obj/machinery/Machine = machines[i]
					if(Machine)
						if(Machine.process() != PROCESS_KILL)
							if(Machine)
								if(Machine.use_power)
									Machine.auto_use_power()
								i++
								continue
					machines.Cut(i,i+1)
				machines_cost = (world.timeofday - start_time) / 10
				sleep(breather_ticks)

				i = 1
				start_time = world.timeofday
				while(i<=powernets.len)
					var/datum/powernet/Powernet = powernets[i]
					if(Powernet)
						Powernet.reset()
						i++
						continue
					powernets.Cut(i,i+1)
				powernets_cost = (world.timeofday - start_time) / 10
				sleep(breather_ticks)

				i = 1
				start_time = world.timeofday
				while(i<=pipe_networks.len)
					var/datum/pipe_network/Network = pipe_networks[i]
					if(Network)
						Network.process()
						i++
						continue
					pipe_networks.Cut(i,i+1)
				networks_cost = (world.timeofday - start_time) / 10

				total_cost1 = sun_cost + mobs_cost + diseases_cost + objects_cost + ticker_cost

				sleep( minimum_ticks1 - max(world.timeofday-start_time_real,0) )	//to prevent long delays happening at midnight
			else
				sleep(10)

	spawn(0)
		while(1)	//far more efficient than recursively calling ourself
			if(!Failsafe)	new /datum/controller/failsafe()
			if(processing)
				var/start_time_real = world.timeofday
				var/start_time = world.timeofday
				controller_iteration2++

				var/currenttime = world.timeofday
				last_tick_duration2 = (currenttime - last_tick_timeofday2) / 10
				last_tick_timeofday2 = currenttime

				vote.process()

				sun.calc_position()
				sun_cost = (world.timeofday - start_time) / 10
				sleep(breather_ticks)

				var/i = 1
				while(i<=mob_list.len)
					var/mob/M = mob_list[i]
					if(M)
						M.Life()
						i++
						continue
					mob_list.Cut(i,i+1)
				mobs_cost = (world.timeofday - start_time) / 10
				sleep(breather_ticks)

				i = 1
				start_time = world.timeofday
				while(i<=active_diseases.len)
					var/datum/disease/Disease = active_diseases[i]
					if(Disease)
						Disease.process()
						i++
						continue
					active_diseases.Cut(i,i+1)
				diseases_cost = ((world.timeofday - start_time) / 10)
				sleep(breather_ticks)

				i = 1
				start_time = world.timeofday
				while(i<=processing_objects.len)
					var/obj/Object = processing_objects[i]
					if(Object)
						Object.process()
						i++
						continue
					processing_objects.Cut(i,i+1)
				objects_cost = (world.timeofday - start_time) / 10
				sleep(breather_ticks)

				start_time = world.timeofday
				ticker.process()
				ticker_cost = (world.timeofday - start_time) / 10

				total_cost2 = sun_cost + mobs_cost + diseases_cost + objects_cost + ticker_cost

				sleep( minimum_ticks2 - max(world.timeofday-start_time_real,0) )	//to prevent long delays happening at midnight
			else
				sleep(10)

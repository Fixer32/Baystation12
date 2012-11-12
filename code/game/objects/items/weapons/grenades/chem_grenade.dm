/obj/item/weapon/grenade/chem_grenade
	name = "Grenade Casing"
	icon_state = "chemg"
	item_state = "flashbang"
	desc = "A hand made chemical grenade."
	w_class = 2.0
	force = 2.0
	var/stage = 0
	var/path = 0
	var/obj/item/device/assembly_holder/detonator = null
	var/list/beakers = new/list()
	var/list/allowed_containers = list(/obj/item/weapon/reagent_containers/glass/beaker, /obj/item/weapon/reagent_containers/glass/bottle)
	var/affected_area = 3

	var/obj/item/weapon/circuitboard/circuit = null
	var/motion = 0
	var/direct = "SOUTH"

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src

	attack_self(mob/user as mob)
		if(path != 1) return

		if(stage!=2)
			user.machine = src
			var/dat = "<B> Grenade properties: </B>"
			if(beakers.len>=1)
				dat += "<BR> <B> Beaker one:</B> [beakers[1]] [beakers[1] ? "<A href='?src=\ref[src];beakerone=1'>Remove</A>" : ""]"
			if(beakers.len>=2)
				dat += "<BR> <B> Beaker two:</B> [beakers[2]] [beakers[2] ? "<A href='?src=\ref[src];beakertwo=1'>Remove</A>" : ""]"
			if(detonator)
				dat += "<BR> <B> Control attachment:</B> [detonator ? "<A href='?src=\ref[src];device=1'>[detonator]</A>" : "None"] [detonator ? "<A href='?src=\ref[src];rem_device=1'>Remove</A>" : ""]"

			user << browse(dat, "window=grenade")
			onclose(user, "grenade")
		else if(stage == 2 && !active && clown_check(user))
			user << "<span class='warning'>You prime \the [name]!</span>"

			log_attack("<font color='red'>[user.name] ([user.ckey]) primed \a [src].</font>")
			log_admin("ATTACK: [user] ([user.ckey]) primed \a [src].")
			message_admins("ATTACK: [user] ([user.ckey]) primed \a [src].")

			activate()
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W,/obj/item/device/assembly_holder) && (!stage || stage==1) && path != 2)
			var/obj/item/device/assembly_holder/det = W
			if(istype(det.a_left,det.a_right.type) || (!isigniter(det.a_left) && !isigniter(det.a_right)))
				user << "\red Assembly must contain one igniter."
				return
			if(!det.secured)
				user << "\red Assembly must be secured with screwdriver."
				return
			path = 1
			user << "\blue You add [W] to the metal casing."
			playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
			user.remove_from_mob(det)
			det.loc = src
			detonator = det
			icon_state = initial(icon_state) +"_ass"
			name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
			stage = 1
			add_fingerprint(user)
		else if(istype(W,/obj/item/weapon/screwdriver) && path != 2)
			if(stage == 1)
				path = 1
				if(beakers.len)
					user << "\blue You lock the assembly."
					name = "grenade"
				else
//					user << "\red You need to add at least one beaker before locking the assembly."
					user << "\blue You lock the empty assembly."
					name = "fake grenade"
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
				icon_state = initial(icon_state) +"_locked"
				stage = 2
			else if(stage == 2)
				if(active && prob(95))
					user << "\red You trigger the assembly!"
					explode()
					return
				else
					user << "\blue You unlock the assembly."
					playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
					name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
					icon_state = initial(icon_state) + (detonator?"_ass":"")
					stage = 1
					active = 0
		else if(is_type_in_list(W, allowed_containers) && (!stage || stage==1) && path != 2)
			path = 1
			if(beakers.len == 2)
				user << "\red The grenade can not hold more containers."
				return
			else
				W.transfer_fingerprints_to(src)
				if(W.reagents.total_volume)
					user << "\blue You add \the [W] to the assembly."
					user.drop_item()
					W.loc = src
					beakers += W
					stage = 1
					name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
				else
					user << "\red \the [W] is empty."
		if(path != 1)
			if(!istype(src.loc,/turf))
				user << "\red You need to put the canister on the ground to do that!"
			else
				switch(stage)
					if(0)
						if(istype(W, /obj/item/weapon/wrench))
							playsound(src.loc, 'Ratchet.ogg', 50, 1)
							if(do_after(user, 20))
								user << "\blue You wrench the canister in place."
								src.name = "Camera Assembly"
								src.anchored = 1
								src.stage = 1
								path = 2
					if(1)
						if(istype(W, /obj/item/weapon/wrench))
							playsound(src.loc, 'Ratchet.ogg', 50, 1)
							if(do_after(user, 20))
								user << "\blue You unfasten the canister."
								src.name = initial(name)
								src.anchored = 0
								src.stage = 0
								path = 0
						if(istype(W, /obj/item/device/multitool))
							playsound(src.loc, 'Deconstruct.ogg', 50, 1)
							user << "\blue You place the electronics inside the canister."
							src.circuit = W
							user.drop_item()
							W.loc = src
						if(istype(W, /obj/item/weapon/screwdriver) && circuit)
							playsound(src.loc, 'Screwdriver.ogg', 50, 1)
							user << "\blue You screw the circuitry into place."
							src.stage = 2
						if(istype(W, /obj/item/weapon/crowbar) && circuit)
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the circuitry."
							src.stage = 1
							circuit.loc = src.loc
							src.circuit = null
					if(2)
						if(istype(W, /obj/item/weapon/screwdriver) && circuit)
							playsound(src.loc, 'Screwdriver.ogg', 50, 1)
							user << "\blue You unfasten the circuitry."
							src.stage = 1
						if(istype(W, /obj/item/weapon/cable_coil))
							if(W:amount >= 1)
								playsound(src.loc, 'Deconstruct.ogg', 50, 1)
								if(do_after(user, 20))
									W:amount -= 1
									if(!W:amount) del(W)
									user << "\blue You add cabling to the canister."
									src.stage = 3
					if(3)
						if(istype(W, /obj/item/weapon/wirecutters))
							playsound(src.loc, 'wirecutter.ogg', 50, 1)
							user << "\blue You remove the cabling."
							src.stage = 2
							var/obj/item/weapon/cable_coil/A = new /obj/item/weapon/cable_coil( src.loc )
							A.add_fingerprint(user)
							A.amount = 1
						if(issignaler(W))
							playsound(src.loc, 'Deconstruct.ogg', 50, 1)
							user << "\blue You attach the wireless signaller unit to the circutry."
							user.drop_item()
							W.loc = src
							src.stage = 4
					if(4)
						if(istype(W, /obj/item/weapon/crowbar) && !motion)
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the remote signalling device."
							src.stage = 3
							var/obj/item/device/assembly/signaler/S = locate() in src
							if(S)
								S.loc = src.loc
							else
								S = new /obj/item/device/assembly/signaler( src.loc, 1 )
							S.add_fingerprint(user)
						if(isprox(W) && motion == 0)
							playsound(src.loc, 'Deconstruct.ogg', 50, 1)
							user << "\blue You attach the proximity sensor."
							user.drop_item()
							W.loc = src
							motion = 1
						if(istype(W, /obj/item/weapon/crowbar) && motion)
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the proximity sensor."
							var/obj/item/device/assembly/prox_sensor/S = locate() in src
							if(S)
								S.loc = src.loc
							else
								S = new /obj/item/device/assembly/prox_sensor( src.loc, 1 )
							S.add_fingerprint(user)
							motion = 0
						if(istype(W, /obj/item/stack/sheet/glass))
							if(W:amount >= 1)
								playsound(src.loc, 'Deconstruct.ogg', 50, 1)
								if(do_after(user, 20))
									if(W)
										W:use(1)
										user << "\blue You put in the glass lens."
										src.stage = 5
					if(5)
						if(istype(W, /obj/item/weapon/crowbar))
							playsound(src.loc, 'Crowbar.ogg', 50, 1)
							user << "\blue You remove the glass lens."
							src.stage = 4
							new /obj/item/stack/sheet/glass( src.loc, 2 )
						if(istype(W, /obj/item/weapon/screwdriver))
							playsound(src.loc, 'Screwdriver.ogg', 50, 1)
							user << "\blue You connect the lense."
							var/B
							if(motion == 1)
								B = new /obj/machinery/camera/motion( src.loc )
							else
								B = new /obj/machinery/camera( src.loc )
							B:network = "SS13"
							B:network = input(usr, "Which network would you like to connect this camera to?", "Set Network", "SS13")
							direct = input(user, "Direction?", "Assembling Camera", null) in list( "NORTH", "EAST", "SOUTH", "WEST" )
							B:dir = text2dir(direct)
							src.transfer_fingerprints_to(B)
							del(src)

	examine()
		set src in usr
		usr << desc
		if(detonator)
			usr << "With attached [detonator.name]"

	Topic(href, href_list)
		..()
		if (usr.stat || usr.restrained())
			return
		if (stage==2) return
		if (src.loc == usr)
			var/changed = 0
			if(href_list["beakerone"])
				if(beakers.len < 1)
					return
				var/obj/b1 = beakers[1]
				b1.loc = get_turf(src)
				beakers.Remove(b1)
				changed=1
			if(href_list["beakertwo"])
				if(beakers.len < 2)
					return
				var/obj/b2 = beakers[2]
				b2.loc = get_turf(src)
				beakers.Remove(b2)
				changed=1
			if(href_list["rem_device"])
				detonator.loc = get_turf(src)
				detonator = null
				changed=1
			if(href_list["device"])
				detonator.attack_self(usr)
			src.add_fingerprint(usr)

			if(changed)
				if(beakers.len==0 && !detonator)
					name = initial(name)
					path = 0
					stage = 0
				else
					name = "unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]"
					src.attack_self(usr)
			return

	activate(mob/user as mob)
		if(active) return
	
		if(detonator)
			if(!isigniter(detonator.a_left))
				detonator.a_left.activate()
				active = 1
			if(!isigniter(detonator.a_right))
				detonator.a_right.activate()
				active = 1
		if(active)
			icon_state = initial(icon_state) + "_active"

			if(user)
				log_attack("<font color='red'>[user.name] ([user.ckey]) primed \a [src]</font>")
				log_admin("ATTACK: [user] ([user.ckey]) primed \a [src]")
				message_admins("ATTACK: [user] ([user.ckey]) primed \a [src]")

		return

	proc/primed(var/primed = 1)
		if(active)
			icon_state = initial(icon_state) + (primed?"_primed":"_active")

	explode()
		if(!stage || stage<2) return

		//if(prob(reliability))
		var/has_reagents = 0
		for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
			if(G.reagents.total_volume) has_reagents = 1

		active = 0
		if(!has_reagents)
			icon_state = initial(icon_state) +"_locked"
			playsound(src.loc, 'sound/items/Screwdriver2.ogg', 50, 1)
			return

		playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)
		unacidable = 1

		for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
			G.reagents.trans_to(src, G.reagents.total_volume)

		if(src.reagents.total_volume) //The possible reactions didnt use up all reagents.
			var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
			steam.set_up(10, 0, get_turf(src))
			steam.attach(src)
			steam.start()

			for(var/atom/A in view(affected_area, src.loc))
				if( A == src ) continue
				src.reagents.reaction(A, 1, 10)


		invisibility = INVISIBILITY_MAXIMUM //Why am i doing this?
		spawn(50)		   //To make sure all reagents can work
			del(src)	   //correctly before deleting the grenade.
		/*else
			icon_state = initial(icon_state) + "_locked"
			crit_fail = 1
			for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
				G.loc = get_turf(src.loc)*/


/obj/item/weapon/grenade/chem_grenade/large
	name = "Large Chem Grenade"
	desc = "An oversized grenade that affects a larger area."
	icon_state = "large_grenade"
	allowed_containers = list(/obj/item/weapon/reagent_containers/glass)
	origin_tech = "combat=3;materials=3"
	affected_area = 4

/obj/item/weapon/grenade/chem_grenade/metalfoam
	name = "Metal-Foam Grenade"
	desc = "Used for emergency sealing of air breaches."
	path = 1
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 30)
		B2.reagents.add_reagent("foaming_agent", 10)
		B2.reagents.add_reagent("pacid", 10)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = initial(icon_state) +"_locked"

/obj/item/weapon/grenade/chem_grenade/incendiary
	name = "Incendiary Grenade"
	desc = "Used for clearing rooms of living things."
	path = 1
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 25)
		B2.reagents.add_reagent("plasma", 25)
		B2.reagents.add_reagent("sacid", 25)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = initial(icon_state) +"_locked"

/obj/item/weapon/grenade/chem_grenade/cleaner
	name = "Cleaner Grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	stage = 2
	path = 1

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 40)
		B2.reagents.add_reagent("water", 40)
		B2.reagents.add_reagent("cleaner", 10)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = initial(icon_state) +"_locked"

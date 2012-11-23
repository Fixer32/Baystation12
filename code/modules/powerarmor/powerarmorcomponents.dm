/obj/item/powerarmor
	name = "Generic power armor component"
	desc = "This is the base object, you should never see one."
	var/obj/item/clothing/suit/powered/parent //so the component knows which armor it belongs to.
	slowdown = 0 //how much the component slows down the wearer

	proc/toggle()
		return
		//The child objects will use this proc



/obj/item/powerarmor/power
	name = "Adminbus power armor power source"
	desc = "Runs on the rare Badminium molecule."

	process()
		return

	proc/checkpower()
		return 1

	plasma
		name = "Miniaturized plasma generator"
		desc = "Runs on plasma."
		slowdown = 1
		var/fuel = 0

		process()
			if (fuel > 0 && parent.active)
				fuel--
				spawn(50)
					process()
				return
			else if (parent.active)
				parent.powerdown(1)
				return

		checkpower()
			return fuel

	powercell
		name = "Powercell interface"
		desc = "Boring, but reliable."
		var/obj/item/weapon/cell/cell
		slowdown = 0.5

		process()
			if (cell && cell.charge > 0 && parent.active)
				cell.use(50)
				spawn(50)
					process()
				return
			else if (parent.active)
				parent.powerdown(1)
				return

		checkpower()
			return max(cell.charge, 0)

	nuclear
		name = "Miniaturized nuclear generator"
		desc = "For all your radioactive needs."
		slowdown = 1.5

		process()
			if(!crit_fail)
				if (prob(src.reliability)) return 1 //No failure
				if (prob(src.reliability))
					for (var/mob/M in range(0,src.parent)) //Only a minor failure, enjoy your radiation.
						if (src.parent in M.contents)
							M << "\red Your armor feels pleasantly warm for a moment."
						else
							M << "\red You feel a warm sensation."
						M.radiation += rand(1,40)
				else
					for (var/mob/M in range(rand(1,4),src.parent)) //Big failure, TIME FOR RADIATION BITCHES
						if (src.parent in M.contents)
							M << "\red Your armor's reactor overloads!"
						M << "\red You feel a wave of heat wash over you."
						M.radiation += 100
					crit_fail = 1 //broken~
					parent.powerdown(1)
				spawn(50)
					process()

		checkpower()
			return !crit_fail

/obj/item/powerarmor/reactive
	name = "Adminbus power armor reactive plating"
	desc = "Made with the rare Badminium molecule."
	var/list/togglearmor = list(melee = 250, bullet = 100, laser = 100,energy = 100, bomb = 100, bio = 100, rad = 100)
	 //Good lord an active energy axe does 150 damage a swing? Anyway, barring var editing, this armor loadout should be impervious to anything. Enjoy, badmins~ --NEO

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Reactive armor systems disengaged."
			if(0)
				usr << "\blue Reactive armor systems engaged."
		var/list/switchover = list()
		for (var/armorvar in parent.armor)
			switchover[armorvar] = togglearmor[armorvar]
			togglearmor[armorvar] = parent.armor[armorvar]
			parent.armor[armorvar] = switchover[armorvar]
			//Probably not the most elegant way to have the vars switch over, but it works. Also propagates the values to the other objects.
			if(parent.helm)
				parent.helm.armor[armorvar] = parent.armor[armorvar]
			if(parent.gloves)
				parent.gloves.armor[armorvar] = parent.armor[armorvar]
			if(parent.shoes)
				parent.shoes.armor[armorvar] = parent.armor[armorvar]

	centcomm
		name = "CentComm power armor reactive plating"
		desc = "Pretty effective against everything, not perfect though."
		togglearmor = list(melee = 90, bullet = 70, laser = 60,energy = 40, bomb = 75, bio = 75, rad = 75)
		slowdown = 2


/obj/item/powerarmor/servos
	name = "Adminbus power armor movement servos"
	desc = "Made with the rare Badminium molecule."
	var/toggleslowdown = 9

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Movement assist servos disengaged."
				parent.slowdown += toggleslowdown
			if(0)
				usr << "\blue Movement assist servos engaged."
				parent.slowdown -= toggleslowdown

/obj/item/powerarmor/atmoseal
	name = "Power armor atmospheric seals"
	desc = "Keeps the bad stuff out."
	slowdown = 1
	var/sealed = 0

	toggle(sudden = 0)
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Atmospheric seals disengaged."
				parent.gas_transfer_coefficient = 1
				parent.permeability_coefficient = 1
				parent.heat_protection = 0
				parent.cold_protection = 0
				parent.flags &= ~STOPSPRESSUREDMAGE
				if(parent.helm)
					parent.helm.gas_transfer_coefficient = 1
					parent.helm.permeability_coefficient = 1
					parent.helm.heat_protection = 0
					parent.helm.cold_protection = 0
					parent.flags &= ~STOPSPRESSUREDMAGE
				if(parent.gloves)
					parent.gloves.gas_transfer_coefficient = 1
					parent.gloves.permeability_coefficient = 1
					parent.gloves.heat_protection = 0
					parent.gloves.cold_protection = 0
				if(parent.shoes)
					parent.shoes.gas_transfer_coefficient = 1
					parent.shoes.permeability_coefficient = 1
					parent.shoes.heat_protection = 0
					parent.shoes.cold_protection = 0
				sealed = 0

			if(0)
				usr << "\blue Atmospheric seals engaged."
				parent.gas_transfer_coefficient = 0.01
				parent.permeability_coefficient = 0.02
				parent.heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
				parent.cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
				parent.flags |= STOPSPRESSUREDMAGE
				if(parent.helm)
					parent.helm.gas_transfer_coefficient = 0.01
					parent.helm.permeability_coefficient = 0.02
					parent.helm.heat_protection = HEAD
					parent.helm.cold_protection = HEAD
					parent.helm.flags |= STOPSPRESSUREDMAGE
				if(parent.gloves)
					parent.gloves.gas_transfer_coefficient = 0.01
					parent.gloves.permeability_coefficient = 0.02
					parent.gloves.heat_protection = HANDS
					parent.gloves.cold_protection = HANDS
				if(parent.shoes)
					parent.shoes.gas_transfer_coefficient = 0.01
					parent.shoes.permeability_coefficient = 0.02
					parent.shoes.heat_protection = FEET
					parent.shoes.cold_protection = FEET
				sealed = 1

	proc/toggle_head()
		return

	adminbus
		name = "Adminbus power armor atmospheric seals"
		desc = "Made with the rare Badminium molecule."
		slowdown = 0

	ironman
		name = "Ironman version of seals"
		desc = "Opens and closes face"
		var/face_open = 0

		toggle(sudden = 0)
//			face_open = parent.active
			switch(parent.active)
				if(1)
					if(!sudden)
						usr << "\blue Atmospheric seals disengaged."
					parent.gas_transfer_coefficient = 1
					parent.permeability_coefficient = 1
					parent.heat_protection = 0
					parent.cold_protection = 0
					parent.flags &= ~STOPSPRESSUREDMAGE
					if(parent.gloves)
						parent.gloves.gas_transfer_coefficient = 1
						parent.gloves.permeability_coefficient = 1
						parent.gloves.heat_protection = 0
						parent.gloves.cold_protection = 0
					if(parent.shoes)
						parent.shoes.gas_transfer_coefficient = 1
						parent.shoes.permeability_coefficient = 1
						parent.shoes.heat_protection = 0
						parent.shoes.cold_protection = 0
					sealed = 1
				if(0)
					usr << "\blue Atmospheric seals engaged."
					parent.gas_transfer_coefficient = 0.01
					parent.permeability_coefficient = 0.02
					parent.heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
					parent.cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
					parent.flags |= STOPSPRESSUREDMAGE
					if(parent.gloves)
						parent.gloves.gas_transfer_coefficient = 0.01
						parent.gloves.permeability_coefficient = 0.02
						parent.gloves.heat_protection = HANDS
						parent.gloves.cold_protection = HANDS
					if(parent.shoes)
						parent.shoes.gas_transfer_coefficient = 0.01
						parent.shoes.permeability_coefficient = 0.02
						parent.shoes.heat_protection = FEET
						parent.shoes.cold_protection = FEET
					sealed = 0
			switch(face_open)
				if(1)
//					usr << "\blue Face opened."
					parent.helm.gas_transfer_coefficient = 1
					parent.helm.permeability_coefficient = 1
					parent.helm.heat_protection = 0
					parent.helm.cold_protection = 0
					parent.helm.flags = FPRINT | TABLEPASS
					parent.helm.flags_inv = HIDEEARS
					parent.helm.icon_state = parent.helm:opened_iconstate
					parent.helm.flags &= ~STOPSPRESSUREDMAGE
				if(0)
//					usr << "\blue Face closed."
					parent.helm.gas_transfer_coefficient = 0.01
					parent.helm.permeability_coefficient = 0.02
					parent.helm.heat_protection = HEAD
					parent.helm.cold_protection = HEAD
					parent.helm.flags = initial(parent.helm.flags)
					parent.helm.flags_inv = initial(parent.helm.flags_inv)
					parent.helm.icon_state = parent.helm:closed_iconstate
					parent.helm.flags |= STOPSPRESSUREDMAGE
			if(istype(parent.loc,/mob/living/carbon/human))
				parent.loc:update_inv_head()

		toggle_head()
			if(!parent.helm || !istype(parent.helm,/obj/item/clothing/head/powered/ironman))
				usr << "\red Incompatible helmet"
				return
			face_open = !face_open
			switch(face_open)
				if(1)
					usr << "\blue Face opened."
					parent.helm.gas_transfer_coefficient = 1
					parent.helm.permeability_coefficient = 1
					parent.helm.heat_protection = 0
					parent.helm.flags = FPRINT | TABLEPASS
					parent.helm.flags_inv = HIDEEARS
					parent.helm.icon_state = parent.helm:opened_iconstate
					parent.helm.flags &= ~STOPSPRESSUREDMAGE
				if(0)
					usr << "\blue Face closed."
					parent.helm.gas_transfer_coefficient = 0.01
					parent.helm.permeability_coefficient = 0.02
					parent.helm.heat_protection = HEAD
					parent.helm.flags = initial(parent.helm.flags)
					parent.helm.flags_inv = initial(parent.helm.flags_inv)
					parent.helm.icon_state = parent.helm:closed_iconstate
					parent.helm.flags |= STOPSPRESSUREDMAGE
			if(istype(parent.loc,/mob/living/carbon/human))
				parent.loc:update_inv_head()

/obj/item/powerarmor/jetpack
	name = "Jetpack for powersuit"
	desc = "Allows spaceflights."
	var/active = 0
	var/datum/effect/effect/system/ion_trail_follow/ion_trail
	var/stabilization_on = 0

	New()
		..()
		src.ion_trail = new /datum/effect/effect/system/ion_trail_follow()
		src.ion_trail.set_up(src)

	proc/toggle_rockets()
		set name = "Toggle Suit Jetpack Stabilization"
		set category = "Object"
		src.stabilization_on = !( src.stabilization_on )
		usr << "You toggle the stabilization [stabilization_on? "on":"off"]."
		return

	proc/allow_thrust(num, mob/living/user as mob)
		if(!active)
			if(src.ion_trail) src.ion_trail.stop()
			return 0
		return 1

	toggle(sudden = 0)
		active = !parent.active
		switch(parent.active)
			if(1)
				if(!sudden)
					usr << "\blue Jetpack systems disengaged."
				if(src.ion_trail) src.ion_trail.stop()
			if(0)
				usr << "\blue Jetpack systems engaged."
				if(src.ion_trail) src.ion_trail.start()

	ironman
		name = "Jetpack of ironman suit"
		desc = "Integrated into ironman body-suit."
		slowdown = 0

/obj/item/weapon/reagent_containers/blood
	name = "BloodPack"
	desc = "Contains blood used for transfusion."
	icon = 'icons/obj/bloodpack.dmi'
	volume = 200

	var/blood_type = null

	New()
		..()
		if(blood_type != null)
			name = "BloodPack [blood_type]"
			reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))

	on_reagent_change()
		if (reagents.reagent_list.len > 0)
			var/the_volume = 0
			var/datum/reagent/B
			for(var/datum/reagent/A in reagents.reagent_list)
				if(A.volume > the_volume)
					the_volume = A.volume
					B = A
			if(B)
				icon_state = initial(icon_state)
				if(B.id == "blood")
					name = "BloodPack [B.data["blood_type"]]"
					desc = "Contains [reagents.total_volume] units, most of it is [B.data["blood_type"]] Blood"
				else
					name = "BloodPack [B.name]"
					desc = "Contains [reagents.total_volume] units, most of it is [B.name]"
		else
			name = "Empty BloodPack"
			desc = "It is devoid of any blood"
			icon_state = "empty"

/obj/item/weapon/reagent_containers/blood/APlus
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/empty
	name = "Empty BloodPack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "empty"
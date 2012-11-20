/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/coastline/pickable
	attackby(obj/item/O as obj, mob/user as mob)
		if (istype(O, /obj/item/weapon/reagent_containers))
			var/obj/item/weapon/reagent_containers/RG = O
			RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
			user.visible_message("\blue [user] fills the [RG] using \the [src].","\blue You fill the [RG] using \the [src].")
			return

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"

/turf/unsimulated/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

/turf/unsimulated/beach/water/pickable
	attackby(obj/item/O as obj, mob/user as mob)
		if (istype(O, /obj/item/weapon/reagent_containers))
			var/obj/item/weapon/reagent_containers/RG = O
			RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
			user.visible_message("\blue [user] fills the [RG] using \the [src].","\blue You fill the [RG] using \the [src].")
			return

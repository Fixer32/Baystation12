//bar shelf

/obj/structure/barshelf
	name = "drinks shelf"
	icon = 'icons/obj/barshelf.dmi'
	icon_state = "barshelf"
	anchored = 1
	density = 1
	opacity = 1
	var/max_contents=16

/obj/structure/barshelf/initialize()
	update_icon()

/obj/structure/barshelf/attackby(obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/reagent_containers/food/drinks) && contents.len<max_contents)
		user.drop_item()
		O.loc = src
		update_icon()
		src.updateUsrDialog()
	else
		..()

/obj/structure/barshelf/proc/interact(mob/user as mob)
	var/dat = "<TT><b>Select an item:</b><br>"

	if (contents.len == 0)
		dat += "<font color = 'red'>No product loaded!</font>"
	else
		for (var/obj/item/weapon/reagent_containers/food/drinks/O in contents)
			if(istype(O))
				dat += "<B>[O.name]</B>:"
				dat += "<a href='?src=\ref[src];take=\ref[O]'>Take</A>"
				dat += "<br>"

		dat += "</TT>"
	user << browse("<HEAD><TITLE>Bar Shelf</TITLE></HEAD><TT>[dat]</TT>", "window=barshelf")
	onclose(user, "barshelf")
	return

/obj/structure/barshelf/Topic(href, href_list)
	usr.machine = src

	var/obj/choice = locate(href_list["take"])

	if(!istype(choice)) // Sanity check, there are probably ways to press the button when it shouldn't be possible.
		return

	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		return
	if(ishuman(usr))
		if(!usr.get_active_hand())
			usr.put_in_hands(choice)
	else
		choice.loc = get_turf(src)
	update_icon()
	src.updateUsrDialog()
	return

/obj/structure/barshelf/attack_hand(mob/user as mob)
	user.machine = src
	interact(user)

/obj/structure/barshelf/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/item/weapon/reagent_containers/food/drinks/b in contents)
				del(b)
			del(src)
			return
		if(2.0)
			for(var/obj/item/weapon/reagent_containers/food/drinks/b in contents)
				if (prob(50)) b.loc = (get_turf(src))
				else del(b)
			del(src)
			return
		if(3.0)
			if (prob(50))
				for(var/obj/item/weapon/reagent_containers/food/drinks/b in contents)
					b.loc = (get_turf(src))
				del(src)
			return
		else
	return

/obj/structure/barshelf/update_icon()
	overlays = null
	var/i = 1
	for(var/obj/item/weapon/reagent_containers/food/drinks/b in contents)
		if(i>12) break
		var/icon/Id = new(b.icon,b.icon_state)
		Id.Scale(12,12)
		var/image/Img = image(Id)
		Img.pixel_y = (i<=6)?11:1
		if(i<=6)
			Img.pixel_x = (i-2)*4+2
		else
			Img.pixel_x = (i-8)*4+2
		overlays += Img
		i++

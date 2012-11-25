//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//trigger admin holder updates. This is hear as all Login() calls this proc.
	if(client.holder)
		client.update_admins(client.holder.rank)

	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id

/mob/Login()
	player_list |= src
	update_Login_details()
	world.update_status()

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = null				//remove hud items just in case
	if(hud_used)	del(hud_used)		//remove the hud objects
	hud_used = new /datum/hud(src)

	if(!dna)
		dna = new /datum/dna(null)
		if(dna)
			dna.real_name = real_name

	next_move = 1
	sight |= SEE_SELF
	..()

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE



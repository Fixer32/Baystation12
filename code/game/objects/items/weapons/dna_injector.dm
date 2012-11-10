/obj/item/weapon/dnainjector
	name = "DNA-Injector"
	desc = "This injects the person with DNA."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	var/dnatype = null
	var/dna = null
	var/block = null
	var/owner = null
	var/ue = null
	var/s_time = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/uses = 1
	var/nofail
	var/is_bullet = 0
	var/inuse = 0

/obj/item/weapon/dnainjector/attack_paw(mob/user as mob)
	return attack_hand(user)


/obj/item/weapon/dnainjector/proc/inject(mob/M as mob, mob/user as mob)
	if(istype(M,/mob/living))
		M.radiation += rand(20,50)

	if (!(NOCLONE in M.mutations)) // prevents drained people from having their DNA changed
		if (dnatype == "ui")
			if (!block) //isolated block?
				if (ue) //unique enzymes? yes
					M.dna.uni_identity = dna
					updateappearance(M, M.dna.uni_identity)
					M.real_name = ue
					M.name = ue
					uses--
				else //unique enzymes? no
					M.dna.uni_identity = dna
					updateappearance(M, M.dna.uni_identity)
					uses--
			else
				M.dna.uni_identity = setblock(M.dna.uni_identity,block,dna,3)
				updateappearance(M, M.dna.uni_identity)
				uses--
		if (dnatype == "se")
			if (!block) //isolated block?
				M.dna.struc_enzymes = dna
				domutcheck(M, null)
				uses--
			else
				M.dna.struc_enzymes = setblock(M.dna.struc_enzymes,block,dna,3)
				domutcheck(M, null,1)
				uses--

	spawn(0)//this prevents the collapse of space-time continuum
		user.drop_from_inventory(src)
		del(src)
	return uses

/obj/item/weapon/dnainjector/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob))
		return
	if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been injected with [name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [name] to inject [M.name] ([M.ckey])</font>")

	log_attack("<font color='red'>[user.name] ([user.ckey]) used the [name] to inject [M.name] ([M.ckey])</font>")

	log_admin("ATTACK: [user.name] ([user.ckey]) used the [name] to inject [M.name] ([M.ckey])")
	msg_admin_attack("ATTACK: [user.name] ([user.ckey]) used the [name] to inject [M.name] ([M.ckey])") //BS12 EDIT ALG

	if (user)
		if (istype(M, /mob/living/carbon/human))
			if(!inuse)
				var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
				O.source = user
				O.target = M
				O.item = src
				O.s_loc = user.loc
				O.t_loc = M.loc
				O.place = "dnainjector"
				src.inuse = 1
				spawn(50) // Not the best fix. There should be an failure proc, for /effect/equip_e/, which is called when the first initital checks fail
					inuse = 0
				M.requests += O
				if (dnatype == "se")
					if (isblockon(getblock(dna, 14,3),14) && istype(M, /mob/living/carbon/human))
						message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name] \red(MONKEY)")
						log_attack("[key_name(user)] injected [key_name(M)] with the [name] (MONKEY)")
					else
	//					message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
						log_attack("[key_name(user)] injected [key_name(M)] with the [name]")
				else
	//				message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
					log_attack("[key_name(user)] injected [key_name(M)] with the [name]")

				spawn( 0 )
					O.process()
					return
		else
			if(!inuse)

				for(var/mob/O in viewers(M, null))
					O.show_message(text("\red [] has been injected with [] by [].", M, src, user), 1)
					//Foreach goto(192)
				if (!(istype(M, /mob/living/carbon/human) || istype(M, /mob/living/carbon/monkey)))
					user << "\red Apparently it didn't work."
					return
				if (dnatype == "se")
					if (isblockon(getblock(dna, 14,3),14) && istype(M, /mob/living/carbon/human))
						message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name] \red(MONKEY)")
						log_game("[key_name(user)] injected [key_name(M)] with the [name] (MONKEY)")
					else
//						message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
						log_game("[key_name(user)] injected [key_name(M)] with the [name]")
				else
//					message_admins("[key_name_admin(user)] injected [key_name_admin(M)] with the [name]")
					log_game("[key_name(user)] injected [key_name(M)] with the [name]")
				inuse = 1
				inject(M, user)//Now we actually do the heavy lifting.
				spawn(50)
					inuse = 0
				/*
				A user injecting themselves could mean their own transformation and deletion of mob.
				I don't have the time to figure out how this code works so this will do for now.
				I did rearrange things a bit.
				*/
				if(user)//If the user still exists. Their mob may not.
					if(M)//Runtime fix: If the mob doesn't exist, mob.name doesnt work. - Nodrak
						user.show_message(text("\red You inject [M.name]"))
					else
						user.show_message(text("\red You finish the injection."))
	return



/obj/item/weapon/dnainjector/antihulk
	name = "DNA-Injector (Anti-Hulk)"
	desc = "Cures green skin."
	dnatype = "se"
	dna = "708"
	//block = 2
	New()
		..()
		block = HULKBLOCK

/obj/item/weapon/dnainjector/hulkmut
	name = "DNA-Injector (Hulk)"
	desc = "This will make you big and strong, but give you a bad skin condition."
	dnatype = "se"
	dna = "FED"
	//block = 2
	New()
		..()
		block = HULKBLOCK

/obj/item/weapon/dnainjector/xraymut
	name = "DNA-Injector (Xray)"
	desc = "Finally you can see what the Captain does."
	dnatype = "se"
	dna = "FED"
	//block = 8
	New()
		..()
		block = XRAYBLOCK

/obj/item/weapon/dnainjector/antixray
	name = "DNA-Injector (Anti-Xray)"
	desc = "It will make you see harder."
	dnatype = "se"
	dna = "708"
	//block = 8
	New()
		..()
		block = XRAYBLOCK

/////////////////////////////////////
/obj/item/weapon/dnainjector/antiglasses
	name = "DNA-Injector (Anti-Glasses)"
	desc = "Toss away those glasses!"
	dnatype = "se"
	dna = "708"
	New()
		..()
		block = GLASSESBLOCK

/obj/item/weapon/dnainjector/glassesmut
	name = "DNA-Injector (Glasses)"
	desc = "Will make you need dorkish glasses."
	dnatype = "se"
	dna = "BD6"
	New()
		..()
		block = GLASSESBLOCK

/obj/item/weapon/dnainjector/epimut
	name = "DNA-Injector (Epi.)"
	desc = "Shake shake shake the room!"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = EPILEPSYBLOCK

/obj/item/weapon/dnainjector/antiepi
	name = "DNA-Injector (Anti-Epi.)"
	desc = "Will fix you up from shaking the room."
	dnatype = "se"
	dna = "708"
	New()
		..()
		block = EPILEPSYBLOCK
////////////////////////////////////
/obj/item/weapon/dnainjector/anticough
	name = "DNA-Injector (Anti-Cough)"
	desc = "Will stop that awful noise."
	dnatype = "se"
	dna = "708"
	New()
		..()
		block = COUGHBLOCK

/obj/item/weapon/dnainjector/coughmut
	name = "DNA-Injector (Cough)"
	desc = "Will bring forth a sound of horror from your throat."
	dnatype = "se"
	dna = "BD6"
	New()
		..()
		block = COUGHBLOCK

/obj/item/weapon/dnainjector/clumsymut
	name = "DNA-Injector (Clumsy)"
	desc = "Makes clumsy minions."
	dnatype = "se"
	dna = "FA0"
	//block = 6
	New()
		..()
		block = CLUMSYBLOCK

/obj/item/weapon/dnainjector/anticlumsy
	name = "DNA-Injector (Anti-Clumy)"
	desc = "Cleans up confusion."
	dnatype = "se"
	dna = "708"
	//block = 6
	New()
		..()
		block = CLUMSYBLOCK

/obj/item/weapon/dnainjector/antitour
	name = "DNA-Injector (Anti-Tour.)"
	desc = "Will cure tourrets."
	dnatype = "se"
	dna = "708"
	New()
		..()
		block = TWITCHBLOCK

/obj/item/weapon/dnainjector/tourmut
	name = "DNA-Injector (Tour.)"
	desc = "Gives you a nasty case off tourrets."
	dnatype = "se"
	dna = "BD6"
	New()
		..()
		block = TWITCHBLOCK

/obj/item/weapon/dnainjector/stuttmut
	name = "DNA-Injector (Stutt.)"
	desc = "Makes you s-s-stuttterrr"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = NERVOUSBLOCK

/obj/item/weapon/dnainjector/antistutt
	name = "DNA-Injector (Anti-Stutt.)"
	desc = "Fixes that speaking impairment."
	dnatype = "se"
	dna = "708"
	New()
		..()
		block = NERVOUSBLOCK

/obj/item/weapon/dnainjector/antifire
	name = "DNA-Injector (Anti-Fire)"
	desc = "Cures fire."
	dnatype = "se"
	dna = "708"
	//block = 10
	New()
		..()
		block = FIREBLOCK

/obj/item/weapon/dnainjector/firemut
	name = "DNA-Injector (Fire)"
	desc = "Gives you fire."
	dnatype = "se"
	dna = "FED"
	//block = 10
	New()
		..()
		block = FIREBLOCK

/obj/item/weapon/dnainjector/blindmut
	name = "DNA-Injector (Blind)"
	desc = "Makes you not see anything."
	dnatype = "se"
	dna = "FA0"
	//block = 11
	New()
		..()
		block = BLINDBLOCK

/obj/item/weapon/dnainjector/antiblind
	name = "DNA-Injector (Anti-Blind)"
	desc = "ITS A MIRACLE!!!"
	dnatype = "se"
	dna = "708"
	//block = 11
	New()
		..()
		block = BLINDBLOCK

/obj/item/weapon/dnainjector/antitele
	name = "DNA-Injector (Anti-Tele.)"
	desc = "Will make you not able to control your mind."
	dnatype = "se"
	dna = "708"
	//block = 12
	New()
		..()
		block = TELEBLOCK

/obj/item/weapon/dnainjector/telemut
	name = "DNA-Injector (Tele.)"
	desc = "Super brain man!"
	dnatype = "se"
	dna = "FED"
	//block = 12
	New()
		..()
		block = TELEBLOCK

/obj/item/weapon/dnainjector/deafmut
	name = "DNA-Injector (Deaf)"
	desc = "Sorry, what did you say?"
	dnatype = "se"
	dna = "FA0"
	//block = 13
	New()
		..()
		block = DEAFBLOCK

/obj/item/weapon/dnainjector/antideaf
	name = "DNA-Injector (Anti-Deaf)"
	desc = "Will make you hear once more."
	dnatype = "se"
	dna = "708"
	//block = 13
	New()
		..()
		block = DEAFBLOCK

/obj/item/weapon/dnainjector/h2m
	name = "DNA-Injector (Human > Monkey)"
	desc = "Will make you a flea bag."
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = MONKEYBLOCK

/obj/item/weapon/dnainjector/m2h
	name = "DNA-Injector (Monkey > Human)"
	desc = "Will make you...less hairy."
	dnatype = "se"
	dna = "708"
	New()
		..()
		block = MONKEYBLOCK

/obj/item/weapon/dnainjector/headache
	name = "DNA-Injector (Headache)"
	desc = "Will make your head ache"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = HEADACHEBLOCK

/obj/item/weapon/dnainjector/noheadache
	name = "DNA-Injector (No Headache)"
	desc = "Will make your head not ache"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = HEADACHEBLOCK

/obj/item/weapon/dnainjector/nobreath
	name = "DNA-Injector (No Breath)"
	desc = "Will make you no breath"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = NOBREATHBLOCK

/obj/item/weapon/dnainjector/breath
	name = "DNA-Injector (Breath)"
	desc = "Will make you breath again"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = NOBREATHBLOCK

/obj/item/weapon/dnainjector/remoteview
	name = "DNA-Injector (Remoteview)"
	desc = "Will make you see through others' eyes"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = REMOTEVIEWBLOCK

/obj/item/weapon/dnainjector/noremoteview
	name = "DNA-Injector (No Remoteview)"
	desc = "Will make you not see through others"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = REMOTEVIEWBLOCK

/obj/item/weapon/dnainjector/regen
	name = "DNA-Injector (Regen)"
	desc = "Will make you heal over time"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = REGENERATEBLOCK

/obj/item/weapon/dnainjector/noregen
	name = "DNA-Injector (No Regen)"
	desc = "Will make you not heal over time"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = REGENERATEBLOCK

/obj/item/weapon/dnainjector/run
	name = "DNA-Injector (Run)"
	desc = "Will make you never encumber"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = INCREASERUNBLOCK

/obj/item/weapon/dnainjector/norun
	name = "DNA-Injector (No Run)"
	desc = "Will make you slow down again"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = INCREASERUNBLOCK

/obj/item/weapon/dnainjector/tsay
	name = "DNA-Injector (Telepathy)"
	desc = "Will make you talk via thougts"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = REMOTETALKBLOCK

/obj/item/weapon/dnainjector/notsay
	name = "DNA-Injector (No Telepathy)"
	desc = "Will make you no telepat"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = REMOTETALKBLOCK

/obj/item/weapon/dnainjector/morph
	name = "DNA-Injector (Morph)"
	desc = "Will make you able to change faces"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = MORPHBLOCK

/obj/item/weapon/dnainjector/nomorph
	name = "DNA-Injector (No Morph)"
	desc = "Will make you not able to change faces"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = MORPHBLOCK

/obj/item/weapon/dnainjector/lone
	name = "DNA-Injector (Lone)"
	desc = "Will make you alone"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = BLENDBLOCK

/obj/item/weapon/dnainjector/nolone
	name = "DNA-Injector (No Lone)"
	desc = "Will make you not alone"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = BLENDBLOCK

/obj/item/weapon/dnainjector/hallucination
	name = "DNA-Injector (Halucinations)"
	desc = "Will make you high"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = HALLUCINATIONBLOCK

/obj/item/weapon/dnainjector/nohallucination
	name = "DNA-Injector (No Hallucinations)"
	desc = "Will make you low"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = HALLUCINATIONBLOCK

/obj/item/weapon/dnainjector/noprints
	name = "DNA-Injector (No fingerprints)"
	desc = "Will make you leave no fingers"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = NOPRINTSBLOCK

/obj/item/weapon/dnainjector/prints
	name = "DNA-Injector (Fingerprints)"
	desc = "Will make you leave fingerprints"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = NOPRINTSBLOCK

/obj/item/weapon/dnainjector/shockimm
	name = "DNA-Injector (Shock Resist)"
	desc = "Will make you shock resistance"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = SHOCKIMMUNITYBLOCK

/obj/item/weapon/dnainjector/noshockimm
	name = "DNA-Injector (No Shock Resist)"
	desc = "Will make you no shock resistance"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = SHOCKIMMUNITYBLOCK

/obj/item/weapon/dnainjector/small
	name = "DNA-Injector (Halfling)"
	desc = "Will make you halfling"
	dnatype = "se"
	dna = "FA0"
	New()
		..()
		block = SMALLSIZEBLOCK

/obj/item/weapon/dnainjector/nosmall
	name = "DNA-Injector (Fulling)"
	desc = "Will make you no halfling"
	dnatype = "se"
	dna = "208"
	New()
		..()
		block = SMALLSIZEBLOCK

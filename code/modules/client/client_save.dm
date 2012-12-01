/datum/client_save
	var/ckey
	var/buildmode		= 0
	var/seeprayers		= 0
	var/muted			= 0
	var/last_message	= "" //Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message_count = 0 //contins a number of how many times a message identical to last_message was sent.
	var/warned			= 0
	var/listen_ooc		= 1
	var/move_delay		= 1
	var/deadchat		= 0
	var/changes			= 0
	var/played			= 0
	var/be_alien		= 0		//Check if that guy wants to be an alien
	var/be_pai			= 1		//Consider client when searching for players to recruit as a pAI
	var/be_syndicate    = 1     //Consider client for late-game autotraitor
	var/STFU_ghosts				//80+ people rounds are fun to admin when text flies faster than airport security
	var/STFU_radio				//80+ people rounds are fun to admin when text flies faster than airport security
	var/STFU_atklog		= 0
	var/STFU_log		= 0
	var/canplaysound	= 1
	var/next_allowed_topic_time = 10

	proc/save(var/client/C)
		ckey			= C.ckey
		buildmode		= C.buildmode
		seeprayers		= C.seeprayers
		muted			= C.muted
		last_message		= C.last_message
		last_message_count 	= C.last_message_count
		warned			= C.warned
		listen_ooc		= C.listen_ooc
		move_delay		= C.move_delay
		deadchat		= C.deadchat
		changes			= C.changes
		played			= C.played
		be_alien		= C.be_alien
		be_pai			= C.be_pai
		be_syndicate 		= C.be_syndicate
		STFU_ghosts		= C.STFU_ghosts
		STFU_radio		= C.STFU_radio
		STFU_atklog		= C.STFU_atklog
		STFU_log		= C.STFU_log
		canplaysound		= C.canplaysound
		next_allowed_topic_time = C.next_allowed_topic_time

	proc/recover(var/client/C)
		C.buildmode			= buildmode
		C.seeprayers			= seeprayers
		C.muted				= muted
		C.last_message			= last_message
		C.last_message_count 		= last_message_count
		C.warned			= warned
		C.listen_ooc			= listen_ooc
		C.move_delay			= move_delay
		C.deadchat			= deadchat
		C.changes			= changes
		C.played			= played
		C.be_alien			= be_alien
		C.be_pai			= be_pai
		C.be_syndicate 			= be_syndicate
		C.STFU_ghosts			= STFU_ghosts
		C.STFU_radio			= STFU_radio
		C.STFU_atklog			= STFU_atklog
		C.STFU_log			= STFU_log
		C.canplaysound			= canplaysound
		C.next_allowed_topic_time 	= next_allowed_topic_time

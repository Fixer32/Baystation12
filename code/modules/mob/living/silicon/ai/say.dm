/mob/living/silicon/ai/say(var/message)
	if(parent && istype(parent) && parent.stat != 2)
		parent.say(message)
		return
		//If there is a defined "parent" AI, it is actually an AI, and it is alive, anything the AI tries to say is said by the parent instead.
	if(parent && istype(parent) && parent.stat == 2 && length(message) >= 2)
		if ((copytext(message, 1, 3) == ":b") || (copytext(message, 1, 3) == ":B") || (copytext(message, 1, 3) == ":è") || (copytext(message, 1, 3) == ":È"))
			if(istype(src, /mob/living/silicon/pai))
				return ..(message)
			message = copytext(message, 3)
			message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
			robot_talk(message)
		else if (isAI(src) && ((copytext(message, 1, 3) == ":h") || (copytext(message, 1, 3) == ":H") || (copytext(message, 1, 3) == ":ð") || (copytext(message, 1, 3) == ":Ð")))
			if(isAI(src)&&client)//For patching directly into AI holopads.
				var/mob/living/silicon/ai/U = src
				message = copytext(message, 3)
				message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
				U.holopad_talk(message)
			else//Will not allow anyone by an active AI to use this function.
				src << "This function is not available to you."
				return
		else
			return
	..(message)

/mob/living/silicon/ai/say_understands(var/other)
	if (istype(other, /mob/living/carbon/human))
		return 1
	if (istype(other, /mob/living/silicon/robot))
		return 1
	if (istype(other, /mob/living/silicon/decoy))
		return 1
	if (istype(other, /mob/living/carbon/brain))
		return 1
	if (istype(other, /mob/living/silicon/pai))
		return 1
	return ..()

/mob/living/silicon/ai/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "queries, \"[text]\"";
	else if (ending == "!")
		return "declares, \"[text]\"";

	return "states, \"[text]\"";

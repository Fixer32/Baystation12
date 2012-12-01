#define WHITELISTFILE "data/whitelist.txt"

/datum/configuration/var/list/whitelist = list()

/proc/load_whitelist()
	var/text = file2text(WHITELISTFILE)
	if (!text)
		diary << "Failed to [WHITELISTFILE]\n"
	else
		config.whitelist = dd_text2list(text, "\n")

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!config.whitelist)
		return 0
	return ("[M.ckey]" in config.whitelist)

/datum/configuration/var/list/alien_whitelist = list()

proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		diary << "Failed to load config/alienwhitelist.txt\n"
	else
		config.alien_whitelist = dd_text2list(text, "\n")

/proc/is_alien_whitelisted(mob/M, var/species)
	if(!config.alien_whitelist)
		return 0
	if((M.client) && (M.client.holder) && (M.client.holder.level) && (M.client.holder.level >= 5))
		return 1
	if(M && species)
		for (var/s in config.alien_whitelist)
			if(findtext(s,"[M.ckey] - [species]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

	return 0

#undef WHITELISTFILE
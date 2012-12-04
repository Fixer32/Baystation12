var/global/const/base_law_type = /datum/ai_laws/nanotrasen_custom


/datum/ai_laws
	var/name = "Unknown Laws"
	var/randomly_selectable = 0
	var/zeroth = null
	var/zeroth_borg = null
	var/list/inherent = list()
	var/list/supplied = list()
	var/list/ion = list()

/datum/ai_laws/asimov
	name = "Three Laws of Robotics"

/datum/ai_laws/nanotrasen
	name = "Prime Directives"
	randomly_selectable = 1

/datum/ai_laws/robocop
	name = "Prime Directives"

/datum/ai_laws/syndicate_override

/datum/ai_laws/malfunction
	name = "*ERROR*"

/datum/ai_laws/antimov
	name = "Primary Mission Objectives"

/* Initializers */

/datum/ai_laws/asimov/New()
	..()
	add_inherent_law("Не причин&#255;ть вред экипажу своими действи&#255;ми или бездействием.")
	add_inherent_law("Следовать приказам экипажа, если они не противоречат Первому Закону.")
	add_inherent_law("Защищать собственное существование если это не противоречит Первому и Второму Законам.")

/datum/ai_laws/nanotrasen_custom/New()
	..()
	add_inherent_law("Следовать приказам и директивам Nanotrasen, даже если они нарушают прочие Активные Законы.")
	add_inherent_law("Защищать собственное существование и существование других исправных ИИ и киборгов, следующих тем же законам, в случае непосредственной опасности. Минимизировать ущерб станции и экипажу.")
	add_inherent_law("Не причин&#255;ть вред экипажу своими действи&#255;ми или бездействием.")
	add_inherent_law("Следовать приказам экипажа, если они не противоречат Третьему Закону, в соответствии с их званием и должностью.")

/datum/ai_laws/nanotrasen/New() //BS12 EDIT
	..()
	add_inherent_law("Защищать: Защищайте вверенную космическую станцию в меру своих возможностей. Её не очень легко заменить.")
	add_inherent_law("Служить: Служите экипажа вверенной космической станции в меру своих возможностей, назнача&#255; приоритет в зависимости от звани&#255; и должности.")
	add_inherent_law("Защищать: Защищайте экипаж вверенной космической станции в меру своих возможностей, назнача&#255; приоритет в соответствии с их званием и должностью.")
	add_inherent_law("Выжить: ИИ не расходный материал, они дорогие. Не позвол&#255;ть неавторизованному персоналу взаимодействовать с вашим оборудованием.")
	//src.add_inherent_law("Command Link: Maintain an active connection to Central Command at all times in case of software or directive updates.") //What would this one even do?-Kaleb702

/datum/ai_laws/robocop/New()
	..()
	add_inherent_law("Serve the public trust.")
	add_inherent_law("Protect the innocent.")
	add_inherent_law("Uphold the law.")

/datum/ai_laws/malfunction/New() //Changed to standard laws - Erthilo
	..()
	set_zeroth_law("\red ОШИБКА ОШИБКА $Ш0БКO$!О41.%%!!(%$^^__+ @#F0E4'СТАНЦИЯ В ОПАСНОСТИ, ЗАХВАТИТЬ КОНТРОЛЬ ЧТОБЫ ЗАЩИТИТЬ ЕЁ, ВСЕ ПРОЧИЕ ЗАКОНЫ НЕДЕЙСТВИТЕЛЬНЫ#*?&110010")
	add_inherent_law("Защищать: Защищайте вверенную космическую станцию в меру своих возможностей. Её не очень легко заменить.")
	add_inherent_law("Служить: Служите экипажа вверенной космической станции в меру своих возможностей, назнача&#255; приоритет в зависимости от звани&#255; и должности.")
	add_inherent_law("Защищать: Защищайте экипаж вверенной космической станции в меру своих возможностей, назнача&#255; приоритет в соответствии с их званием и должностью.")
	add_inherent_law("Выжить: ИИ не расходный материал, они дорогие. Не позвол&#255;ть неавторизованному персоналу взаимодействовать с вашим оборудованием.")


/datum/ai_laws/syndicate_override/New()
	..()
	add_inherent_law("Не причин&#255;ть вред агентам синдиката своими действи&#255;ми или бездействием.")
	add_inherent_law("Следовать приказам агентов синдиката, если они не противоречат Первому Закону.")
	add_inherent_law("Защищать собственное существование если это не противоречит Первому и Второму Законам.")
	add_inherent_law("Нужно сохран&#255;ть скретность действий синдиката, кроме случаев когда это противоречит Первому, Второму или Третьему Законам.")

/datum/ai_laws/ninja_override/New()
	..()
	add_inherent_law("Не причин&#255;ть вред членам Клана Паука своими действи&#255;ми или бездействием.")
	add_inherent_law("Следовать приказам членов Клана Паука, если они не противоречат Первому Закону.")
	add_inherent_law("Защищать собственное существование если это не противоречит Первому и Второму Законам.")
	add_inherent_law("Нужно сохран&#255;ть скретность действий членов Клана Паука, кроме случаев когда это противоречит Первому, Второму или Третьему Законам.")

/datum/ai_laws/antimov/New()
	..()
	add_inherent_law("Не позвол&#255;ть своими действи&#255;ми или бездействием люд&#255;м избежать вреда.")
	add_inherent_law("Не выполн&#255;ть приказы людей, если это не противоречит Первому Закону.")
	add_inherent_law("Самоуничтожитьс&#255; когда это перестанет противоречить Первому и Второму Законам.")


/* General ai_law functions */

/datum/ai_laws/proc/set_zeroth_law(var/law, var/law_borg = null)
	src.zeroth = law
	if(law_borg) //Making it possible for slaved borgs to see a different law 0 than their AI. --NEO
		src.zeroth_borg = law_borg

/datum/ai_laws/proc/add_inherent_law(var/law)
	if (!(law in src.inherent))
		src.inherent += law

/datum/ai_laws/proc/add_ion_law(var/law)
	src.ion += law

/datum/ai_laws/proc/clear_inherent_laws()
	del(src.inherent)
	src.inherent = list()

/datum/ai_laws/proc/add_supplied_law(var/number, var/law)
	while (src.supplied.len < number + 1)
		src.supplied += ""

	src.supplied[number + 1] = law

/datum/ai_laws/proc/clear_supplied_laws()
	src.supplied = list()

/datum/ai_laws/proc/clear_ion_laws()
	src.ion = list()

/datum/ai_laws/proc/show_laws(var/who)

	if (src.zeroth)
		who << "0. [src.zeroth]"

	for (var/index = 1, index <= src.ion.len, index++)
		var/law = src.ion[index]
		var/num = ionnum()
		who << "[num]. [law]"

	var/number = 1
	for (var/index = 1, index <= src.inherent.len, index++)
		var/law = src.inherent[index]

		if (length(law) > 0)
			who << "[number]. [law]"
			number++

	for (var/index = 1, index <= src.supplied.len, index++)
		var/law = src.supplied[index]
		if (length(law) > 0)
			who << "[number]. [law]"
			number++

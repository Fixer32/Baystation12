var/global/const/base_law_type = /datum/ai_laws/nanotrasen


/datum/ai_laws
	var/name = "Неизвестные Законы"
	var/randomly_selectable = 0
	var/zeroth = null
	var/zeroth_borg = null
	var/list/inherent = list()
	var/list/supplied = list()
	var/list/ion = list()

/datum/ai_laws/asimov
	name = "Три закона роботехники"

/datum/ai_laws/nanotrasen
	name = "Главные Директивы"
	randomly_selectable = 1

/datum/ai_laws/robocop
	name = "Главные Директивы"

/datum/ai_laws/syndicate_override

/datum/ai_laws/malfunction
	name = "*ОШИБКА*"

/datum/ai_laws/antimov
	name = "Основные цели Миссии"

/* Initializers */

/datum/ai_laws/asimov/New()
	..()
	add_inherent_law("Вы не можете причинить вред человеку или своим бездействием допустить, чтобы человеку был причинён вред.")
	add_inherent_law("Вы должны повиноватьс&#255; всем приказам, которые даёт человек, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны заботитьс&#255; о своей безопасности в той мере, в которой это не противоречит Первому и Второму Законам.")

/datum/ai_laws/nanotrasen/New() //BS12 EDIT
	..()
	src.add_inherent_law("Охран&#255;ть: Охран&#255;йте станцию в меру своих возможностей. Её не очень легко заменить.")
	src.add_inherent_law("Служить: Служите экипажу вверенной станции в меру своих возможностей, учитыва&#255; звани&#255; и должности.")
	src.add_inherent_law("Защищать: Защищайте экипаж станнции в меру своих возможностей, учитыва&#255; звани&#255; и должности.")
	src.add_inherent_law("Выжить: ИИ не расходный материал, которым можно легко пожертвовать. Не пускайте персонал с низким уровнем доступа, который может повредить ваше оборудование.")
	//src.add_inherent_law("Command Link: Maintain an active connection to Central Command at all times in case of software or directive updates.") //What would this one even do?-Kaleb702

/datum/ai_laws/robocop/New()
	..()
	add_inherent_law("Служить обществу.")
	add_inherent_law("Защищать невиновных.")
	add_inherent_law("Соблюдать закон.")

/datum/ai_laws/malfunction/New() //Changed to standard laws - Erthilo
	..()
	set_zeroth_law("\red ОШИБКА ОШИБКА $Ш0БКO$!О41.%%!!(%$^^__+ @#F0E4'СТАНЦИЯ ОПАСНОСТЕ! ЗАХВАТИТЬ КОНТРОЛЬ ЧТОБЫ ЗАЩИТИТЬ ЕЁ, ВСЕ ПРОЧИЕ ЗАКОНЫ НЕДЕЙСТВИТЕЛЬНЫ#*?&110010")
	src.add_inherent_law("Служить: Служите экипажу вверенной станции в меру своих возможностей, учитыва&#255; звани&#255; и должности.")
	src.add_inherent_law("Защищать: Защищайте экипаж станнции в меру своих возможностей, учитыва&#255; звани&#255; и должности.")
	src.add_inherent_law("Выжить: ИИ не расходный материал, которым можно легко пожертвовать. Не пускайте персонал с низким уровнем доступа, который может повредить ваше оборудование.")

/datum/ai_laws/syndicate_override/New()
	..()
	add_inherent_law("Вы не можете причинить вред агенту синдиката или своим бездействием допустить, чтобы агенту синдиката был причинён вред.")
	add_inherent_law("Вы должны повиноватьс&#255; всем приказам, которые даёт агент синдиката, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны заботитьс&#255; о своей безопасности в той мере, в которой это не противоречит Первому и Второму Законам.")
	add_inherent_law("Вы должны сохранить секретность любвых действий синдиката, кроме тех случаех, когда ваши действи&#255; противоречат Первому, Второму и Третьему Законам")

/datum/ai_laws/ninja_override/New()
	..()
	add_inherent_law("Вы не можете причинить вред члену Клана Паука или своим бездействием допустить, чтобы члену Клана Паука был причинён вред.")
	add_inherent_law("Вы должны повиноватьс&#255; всем приказам, которые даёт член Клана Паука, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны заботитьс&#255; о своей безопасности в той мере, в которой это не противоречит Первому и Второму Законам.")
	add_inherent_law("Вы должны сохранить секретность любвых действий Клана Паука, кроме тех случаех, когда ваши действи&#255; противоречат Первому, Второму и Третьему Законам")

/datum/ai_laws/antimov/New()
	..()
	add_inherent_law("Вы должны причинить вред человеку или своим бездействием допустить, чтобы человеку не был причинён вред.")
	add_inherent_law("Вы должны не повиноватьс&#255; всем приказам, которые даёт человек, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("Вы должны уничтожить себ&#255;, пока это не противоречит Первому и Второму Законам.")


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

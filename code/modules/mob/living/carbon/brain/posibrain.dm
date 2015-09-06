/obj/item/device/mmi/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = 3
	origin_tech = "engineering=4;materials=4;bluespace=2;programming=4"
	machine_brain_type="Posibrain"

	construction_cost = list("metal"=500,"glass"=500,"silver"=200,"gold"=200,"plasma"=100,"diamond"=10)
	construction_time = 75
	var/searching = 0
	var/askDelay = 10 * 60 * 1
	var/list/ghost_volunteers[0]
	req_access = list(access_robotics)
	locked = 0
	mecha = null//This does not appear to be used outside of reference in mecha.dm.

	var/obj/item/device/radio/radio = null//Let's give it a radio.


/obj/item/device/mmi/posibrain/attack_self(mob/user as mob)
	if(brainmob && !brainmob.key && searching == 0)
		//Start the process of searching for a new user.
		user << "\blue You carefully locate the manual activation switch and start the positronic brain's boot process."
		icon_state = "posibrain-searching"
		ghost_volunteers.Cut()
		src.searching = 1
		src.request_player()
		spawn(600)
			if(ghost_volunteers.len)
				var/mob/dead/observer/O = pick(ghost_volunteers)
				if(istype(O) && O.client && O.key)
					transfer_personality(O)
			reset_search()
		
/obj/item/device/mmi/posibrain/proc/request_player()
	for(var/mob/dead/observer/O in player_list)
		if(check_observer(O))
			O << "\blue <b>\A [src] has been activated. (<a href='?src=\ref[O];jump=\ref[src]'>Teleport</a> | <a href='?src=\ref[src];signup=\ref[O]'>Sign Up</a>)"


/obj/item/device/mmi/posibrain/proc/check_observer(var/mob/dead/observer/test)
	if (!test) // no person ?
		return
	if (!test.client) // is someone actually home?
		return
	if (!test.client.prefs.be_special & BE_PAI) // do they want to be a pAI?
		return
	if(test.has_enabled_antagHUD == 1 && config.antag_hud_restricted) // have they activated the antagHUD?
		return
	if ((jobban_isbanned(test, "Cyborg") || jobban_isbanned(test,"nonhumandept")) && !is_alien_whitelisted(test,"Machine")) // if you can't play as either role that uses posibrains, then you can't get into a posibrain
		return
	return TRUE
				
				
/obj/item/device/mmi/posibrain/transfer_identity(var/mob/living/carbon/H)
	/*
	Positronic brains should have posibrain-like name, instead of human-MMIlike names. -- ATL

	name = "positronic brain ([H])"
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	*/
	brainmob.dna = H.dna
	brainmob.timeofhostdeath = H.timeofdeath
	brainmob.stat = 0
	if(brainmob.mind)
		brainmob.mind.assigned_role = "Positronic Brain"
	if(H.mind)
		H.mind.transfer_to(brainmob)
	brainmob << "\blue You feel slightly disoriented. That's normal when you're just a metal cube."
	icon_state = "posibrain-occupied"
	return

/obj/item/device/mmi/posibrain/proc/get_possible_uses_string(var/mob/test)
	if (!(jobban_isbanned(test, "Cyborg") || jobban_isbanned(test,"nonhumandept")))
		if (is_alien_whitelisted(test,"Machine"))
			return "This posibrain's personality is compatible with assignment to either a tool-robot or a shell."
		else
			return "This posibrain's personality is compatible only with tool-robots."
	else
		if (is_alien_whitelisted(test,"Machine"))
			return "This posibrain's personality is compatible only with shells."
		else
			return "This posibrain's personality is not compatible with any chassis. Something has gone wrong. Please call a bluespace technician to correct the issue."
	
/obj/item/device/mmi/posibrain/proc/transfer_personality(var/mob/candidate)
	var/uses = get_possible_uses_string(candidate)
	src.searching = 0
	src.brainmob.mind = candidate.mind
	src.brainmob.ckey = candidate.ckey
	src.name = "positronic brain ([src.brainmob.name])"
	src.brainmob << "<b>You are a positronic brain, brought into existence on [station_name()].</b>"
	src.brainmob << "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>"
	src.brainmob << "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>"
	src.brainmob << "<b>Use say :b to speak to other artificial intelligences.</b>"
	src.brainmob.mind.assigned_role = "Positronic Brain"
	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The positronic brain chimes quietly as it loads a new personality. [uses]")
	icon_state = "posibrain-occupied"
	

/obj/item/device/mmi/posibrain/Topic(href,href_list)
	if("signup" in href_list)
		var/mob/dead/observer/O = locate(href_list["signup"])
		if(!O) return
		volunteer(O)
		

/obj/item/device/mmi/posibrain/proc/volunteer(var/mob/dead/observer/O)
	if(!searching)
		O << "Not looking for a ghost, yet."
		return
	if(!istype(O))
		O << "\red Error."
		return
	if(O in ghost_volunteers)
		O << "\blue Removed from registration list."
		ghost_volunteers.Remove(O)
		return
	if(!check_observer(O))
		O << "\red You cannot be \a [src]."
		return
	if(O.has_enabled_antagHUD == 1 && config.antag_hud_restricted)
		O << "\red Upon using the antagHUD you forfeited the ability to join the round."
		return
	if(jobban_isbanned(O, "Cyborg") || jobban_isbanned(O,"nonhumandept"))
		O << "\red You are job banned from this role."
		return
	O.<< "\blue You've been added to the list of ghosts that may become this [src].  Click again to unvolunteer."
	ghost_volunteers.Add(O)
	
	
/obj/item/device/mmi/posibrain/proc/reset_search() //We give the players sixty seconds to decide, then reset the timer.

	if(src.brainmob && src.brainmob.key) return

	src.searching = 0
	icon_state = "posibrain"

	var/turf/T = get_turf_or_move(src.loc)
	for (var/mob/M in viewers(T))
		M.show_message("\blue The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?")

/obj/item/device/mmi/posibrain/examine()

	set src in oview()

	if(!usr || !src)	return
	if( (usr.sdisabilities & BLIND || usr.blinded || usr.stat) && !istype(usr,/mob/dead/observer) )
		usr << "<span class='notice'>Something is there but you can't see it.</span>"
		return

	var/msg = "<span class='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(src.brainmob && src.brainmob.key)
		switch(src.brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)	msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)		msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)			msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "<span class='info'>*---------*</span>"
	usr << msg
	return

/obj/item/device/mmi/posibrain/emp_act(severity)
	if(!src.brainmob)
		return
	else
		switch(severity)
			if(1)
				src.brainmob.emp_damage += rand(20,30)
			if(2)
				src.brainmob.emp_damage += rand(10,20)
			if(3)
				src.brainmob.emp_damage += rand(0,10)
	..()

/obj/item/device/mmi/posibrain/New()

	src.brainmob = new(src)
	src.brainmob.add_language("Binary")
	src.brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	src.brainmob.real_name = src.brainmob.name
	src.brainmob.loc = src
	src.brainmob.container = src
	src.brainmob.stat = 0
	src.brainmob.silent = 0
//	src.brainmob.brain_op_stage = 4.0
	dead_mob_list -= src.brainmob

	radio = new(src)//Spawns a radio inside the MMI.
	radio.broadcasting = 0//So it's broadcasting from the start.

	..()

/obj/item/device/mmi/posibrain/verb/Toggle_Broadcasting()	//totally not nicking from certain places. Yay.
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set category = "Posi"
	set src = usr.loc//In user location, or in MMI in this case.
	set popup_menu = 0//Will not appear when right clicking.

	if(brainmob.stat)//Only the brainmob will trigger these so no further check is necessary.
		brainmob << "Can't do that while incapacitated or dead."

	radio.broadcasting = radio.broadcasting==1 ? 0 : 1
	brainmob << "\blue Radio is [radio.broadcasting==1 ? "now" : "no longer"] broadcasting."

/obj/item/device/mmi/posibrain/verb/Toggle_Listening()
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set category = "Posi"
	set src = usr.loc
	set popup_menu = 0

	if(brainmob.stat)
		brainmob << "Can't do that while incapacitated or dead."

	radio.listening = radio.listening==1 ? 0 : 1
	brainmob << "\blue Radio is [radio.listening==1 ? "now" : "no longer"] receiving broadcast."
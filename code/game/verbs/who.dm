
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder && (holder.rights & (R_ADMIN|R_MOD)))
		for(var/client/C in clients)
			var/entry = "\t[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as [C.holder.fakekey])</i>"
			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(C.mob))
						var/mob/dead/observer/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	src << msg

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/msg = ""
	var/modmsg = ""
	var/devmsg = ""
	var/eventmsg = ""
	var/dutymsg = ""
	var/num_duty_online = 0
	var/num_devs_online = 0
	var/num_mods_online = 0
	var/num_event_online = 0
	var/num_admins_online = 0
	if(holder)
		for(var/client/C in admins)
			if(C.holder.fakekey && !(holder.rights & (R_ADMIN|R_MOD)))
				continue
			if(C.holder.rights & R_ADMIN)
				msg += "\t[C] is a [C.holder.rank]"

				if(C.holder.fakekey)
					msg += " <i>(as [C.holder.fakekey])</i>"

				if(isobserver(C.mob))
					msg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					msg += " - Lobby"
				else
					msg += " - Playing"

				if(C.is_afk())
					msg += " (AFK)"
				msg += "\n"

				num_admins_online++
				continue

			else if((C.holder.rights & R_MOD) && !(C.holder.rights & R_FUN))
				modmsg += "\t[C] is a [C.holder.rank]"
				if(isobserver(C.mob))
					modmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					modmsg += " - Lobby"
				else
					modmsg += " - Playing"

				if(C.is_afk())
					modmsg += " (AFK)"
				modmsg += "\n"
				num_mods_online++
				continue

			else if (C.holder.rights & R_FUN)
				eventmsg += "\t[C] is a [C.holder.rank]"
				if(isobserver(C.mob))
					eventmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					eventmsg += " - Lobby"
				else
					eventmsg += " - Playing"

				if(C.is_afk())
					eventmsg += " (AFK)"
				eventmsg += "\n"
				num_event_online++
				continue

			else if(C.holder.rights & R_DEV)
				devmsg += "\t[C] is a [C.holder.rank]"
				if(isobserver(C.mob))
					devmsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					devmsg += " - Lobby"
				else
					devmsg += " - Playing"

				if(C.is_afk())
					devmsg += " (AFK)"
				devmsg += "\n"
				num_devs_online++
				continue

			else if(C.holder.rights & R_DUTYOFF)
				dutymsg += "\t[C]"
				if(isobserver(C.mob))
					dutymsg += " - Observing"
				else if(istype(C.mob,/mob/new_player))
					dutymsg += " - Lobby"
				else
					dutymsg += " - Playing"

				if(C.is_afk())
					dutymsg += " (AFK)"
				dutymsg += "\n"
				num_duty_online++
				continue

	else
		for(var/client/C in admins)
			if(C.holder.fakekey) //If anyone is given stealth you want to hide them. There is no point in +STEALTH otherwise, just add it to +ADMIN
				continue
			if(C.holder.rights & R_ADMIN)
				msg += "\t[C] is a [C.holder.rank]\n"
				num_admins_online++
			else if (C.holder.rights & R_MOD && !(C.holder.rights & R_FUN))
				modmsg += "\t[C] is a [C.holder.rank]\n"
				num_mods_online++
				continue
			else if (C.holder.rights & R_FUN)
				eventmsg += "\t[C] is a [C.holder.rank]\n"
				num_event_online++
				continue
			else if(C.holder.rights & R_DEV)
				devmsg += "\t[C] is a [C.holder.rank]\n"
				num_devs_online++
				continue

	var/eventwho = ""
	if(num_event_online)
		eventwho += "\n<b> Current Event Hosts([num_event_online]):</b>\n" + eventmsg

	if(num_duty_online)
		dutymsg = "\n<b> Current Duty Officers([num_duty_online]):</b>\n" + dutymsg

	msg = "<b>Current Admins ([num_admins_online]):</b>\n" + msg + "\n<b> Current Moderators([num_mods_online]):</b>\n" + modmsg + eventwho + "\n<b> Current Developers([num_devs_online]):</b>\n" + devmsg + dutymsg
	src << msg
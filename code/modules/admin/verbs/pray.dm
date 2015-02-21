/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			usr << "\red You cannot pray (muted)."
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	msg = "\blue \icon[cross] <b><font color=purple>PRAY: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[src]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[src]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;adminspawncookie=\ref[src]'>SC</a>):</b> [msg]"

	for(var/client/C in admins)
		if(C.holder.rights & (R_ADMIN|R_MOD|R_FUN) && (C.prefs.toggles & CHAT_PRAYER))
			C << msg
	usr << "Your prayers have been received by the gods."

	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

//Stealing the second var because why not)
/proc/Centcomm_announce(var/text , var/mob/Sender , var/silicon = 0 , var/iamessage)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	var/modmin = " (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>)"
	var/msg_start = "\blue <b><font color=orange>CENTCOMM"
	var/msg_end = ""

	if(silicon)
		msg_start += "(A.L.I.C.E.):</font>"
		msg_end = "(<A HREF='?_src_=holder;CentcommAIReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	else
		msg_start += "[iamessage ? " IA" : ""]:</font>"
		msg_end = "(<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]"

	for(var/client/C in admins)
		if(C.holder.rights & (R_ADMIN|R_MOD|R_FUN))
			if(C.holder.rights & R_MOD && !C.holder.rights & R_DUTYOFF)
				continue
			C << "[msg_start][key_name(Sender, 1)][modmin][msg_end]"
			continue
		if(C.holder.rights & (R_DUTYOFF))
			if(C.holder.rights & R_MOD)
				C << "[msg_start][key_name(Sender, 1)][msg_end]"
			else
				C << "[msg_start][key_name(Sender, 0, 1, 0)][msg_end]"

/proc/Syndicate_announce(var/text , var/mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "\blue <b><font color=crimson>SYNDICATE:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A HREF='?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	for(var/client/C in admins)
		if(C.holder.rights & (R_ADMIN|R_MOD|R_FUN))
			C << msg
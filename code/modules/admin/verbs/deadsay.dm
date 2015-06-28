/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!src.holder)
		src << "Only administrators may use this command."
		return
	if(!src.mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		src << "\red You cannot send DSAY messages (muted)."
		return

	if(!(prefs.toggles & CHAT_DEAD))
		src << "\red You have deadchat muted."
		return

	if (src.handle_spam_prevention(msg,MUTE_DEADCHAT))
		return

	var/stafftype = null

	if (src.holder.rights & R_MOD)
		stafftype = "MOD"
	if (src.holder.rights & R_ADMIN)
		stafftype = "ADMIN"
	if (src.holder.rights & R_DEV)
		stafftype = "DEV" // lol I find it necessary k? <.<
	if ((src.holder.rights & R_FUN) && !(R_ADMIN & src.holder.rights))
		stafftype = "EVENT"

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg) //We don't want to log empty messages
		return

	log_admin("DSAY: [key_name(src)] : [msg]")


	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[stafftype]([src.holder.fakekey ? pick("BADMIN", "hornigranny", "TLF", "scaredforshadows", "KSI", "Silnazi", "HerpEs", "BJ69", "SpoofedEdd", "Uhangay", "Wario90900", "Regarity", "MissPhareon", "LastFish", "unMportant", "Deurpyn", "Fatbeaver") : src.key])</span> says, <span class='message'>\"[msg]\"</span></span>"

	for (var/mob/M in player_list)
		if (istype(M, /mob/new_player))
			continue

		if(!M.client)
			continue

		if(!(M.client.prefs.toggles & CHAT_DEAD))
			continue

		if(M.client.holder && (M.client.holder.rights & (R_ADMIN|R_MOD|R_DEV|R_FUN))) // show the message to admins who have deadchat toggled on
			M.show_message(rendered, 2)
			continue

		if(M.stat == DEAD) // show the message to regular ghosts who have deadchat toggled on
			M.show_message(rendered, 2)

	feedback_add_details("admin_verb","D") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

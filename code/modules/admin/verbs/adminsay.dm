/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN))	return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("ASAY: [key_name(src)] : [msg]")

	if(check_rights(R_ADMIN,0))
		msg = "<span class='adminsay'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> (<a href='?_src_=holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights)
				C << msg

	feedback_add_details("admin_verb","M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mod_say(msg as text)
	set category = "Special Verbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_FUN))	return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_admin("MOD: [key_name(src)] : [msg]")

	if (!msg)
		return
	var/color = "mod"
	if (check_rights(R_ADMIN,0))
		color = "adminmod"
	for(var/client/C in admins)
		if((R_ADMIN|R_MOD|R_FUN) & C.holder.rights)
			C << "<span class='[color]'><span class='prefix'>MOD:</span> <EM>[key_name(src,1)]</EM> (<A HREF='?src=\ref[C.holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"

/client/proc/cmd_dev_say(msg as text)
	set category = "Developer"
	set name = "Desay"
	set hidden = 1

	if(!check_rights(R_DEV)) return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("DEV: [key_name(src)] : [msg]")

	if(check_rights(R_DEV,0))
		msg = "<span class='devsay'><span class='prefix'>DEV:</span> <EM>[key_name(usr, 0, 1, 0)]</EM>: <span class='message'>[msg]</span></span>"
		for(var/client/C in admins)
			if(R_DEV & C.holder.rights)
				C << msg

/client/proc/cmd_duty_say(msg as text)
	set category = "Admin"
	set name = "Dosay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_DUTYOFF)) return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	log_admin("DOSAY: [key_name(src)] : [msg]")

	if(check_rights(R_DUTYOFF,0))
		msg = "<span class='dutysay'><span class='prefix'>DOfficer:</span> <EM>[key_name(usr, 0, 1, 0)]</EM>: <span class='message'>[msg]</span></span>"
		for(var/client/C in admins)
			if(C.holder.rights & (R_ADMIN|R_DUTYOFF))
				C << msg
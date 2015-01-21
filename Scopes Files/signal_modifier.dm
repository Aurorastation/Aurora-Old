//Make a thing that changes id's on stuff to change what they do
//
// This is only the item, I have some plans on how this could work with minimal file
// editing but we will have to see first. Need to decide what it will change on everything too.
//
// Doors, Buttons, Shutters, Airpumps Injectors

/obj/item/device/signaltool
	name = "Signal Modifier"
	desc = "Used for modifying."  //and here
	icon_state = "multitool"
	flags = FPRINT | TABLEPASS| CONDUCT //check out
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	desc = "If you have this, it is a mistake." //here to
	matter = list("metal" = 20,"glass" = 50)
	origin_tech = "magnets=1;engineering=1"
	var/id_setting = null
	var/signal_setting = null
	var/mode = 0

	attack_self(mob/M as mob)
		switch(alert(usr, "What would you like to do", "[name] Settings", "Set", "Copy", "New",))
			if("New")
				change_tool_settings("id")
				change_tool_settings("freq")
				mode = 1
			if("Copy")
				mode = 0
			if("Set")
				mode = 1

	proc/change_ID(var/cur_setting)
		if(mode)
			if(!id_setting)
				usr << "\blue ID removed."
				return null
			else
				usr << "\blue ID changed."
				return id_setting
		else
			usr << "\blue ID copied."
			id_setting = cur_setting
			return id_setting

	proc/change_freq(var/cur_setting)
		if(mode)
			if(!signal_setting)
				usr << "\blue signal removed."
				return null
			else
				usr << "\blue signal changed."
				return signal_setting
		else
			usr << "\blue signal copied."
			signal_setting = cur_setting
			return signal_setting

	proc/change_tool_settings(var/setting)
		switch(setting)
			if("id")
				id_setting = get_setting(id_setting)
			if("freq")
				signal_setting = get_setting(signal_setting)

	proc/get_setting(var/prevname)
		var/str = trim(stripped_input(usr,"New setting:","Signal Altering", prevname, MAX_NAME_LEN))
		if(str==prevname)
			return prevname
		if(!str || !length(str)) //cancel
			usr << "\blue You blank the setting from the [name]"
			return null

		if(length(str) > 50)
			usr << "\red Text too long."
			return

		usr << "\blue You change the setting to [str]."
		return str

//frequency
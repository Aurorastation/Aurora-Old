//Make a thing that changes id's on stuff to change what they do

/obj/item/device/signaltool
	name = "Signal Modifyer"
	desc = "Used for Stuff."
	icon_state = "multitool"
	flags = FPRINT | TABLEPASS| CONDUCT //check out
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	desc = "Sound should really make a description for this." //here to
	m_amt = 50
	g_amt = 20
	origin_tech = "magnets=1;engineering=1"
	var/setting = null

	attack_self(mob/M as mob)
		var/prevname = "[setting]"
		var/str = trim(stripped_input(usr,"New ID tag:","Signal Altering", prevname, MAX_NAME_LEN))
		if(!str || !length(str) || str==prevname) //cancel
			return
		if(length(str) > 50)
			usr << "\red Text too long."
			return
		setting = str

//I secretly have no idea what I am doing with this stuff
//it could work
	attack(var/obj/machinery/O as obj)
		if(!setting)
			return
		if(!O.id)
			msg_scopes("no id thing")
		else
			if(O.id != setting)
				usr << "\blue You alter the componants signal id"
				O.id = setting
			else
				user << "\red The id's are the same"

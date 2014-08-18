//Make a thing that changes id's on stuff to change what they do
//
// This is only the item, I have some plans on how this could work with minimal file
// editing but we will have to see first. Need to decide what it will change on everything too.
//

/obj/item/device/signaltool
	name = "Signal Modifier"
	desc = "Used for Stuff."  //and here
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
			usr << "\blue You remove the tag from the [name]"
			setting = null
			return

		if(length(str) > 50)
			usr << "\red Text too long."
			return

		setting = str
		usr << "\blue You change the tag setting to [setting]"
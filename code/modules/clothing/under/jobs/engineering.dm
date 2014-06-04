//Contains: Engineering department jumpsuits
/obj/item/clothing/under/rank/chief_engineer
	desc = "It's a high visibility jumpsuit given to those engineers insane enough to achieve the rank of \"Chief engineer\". It has minor radiation shielding."
	name = "chief engineer's jumpsuit"
	icon_state = "chiefengineer"
	item_state = "g_suit"
	item_color = "chief"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/rank/atmospheric_technician
	desc = "It's a jumpsuit worn by atmospheric technicians."
	name = "atmospheric technician's jumpsuit"
	icon_state = "atmos"
	item_state = "atmos_suit"
	item_color = "atmos"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/rank/engineer
	desc = "It's an orange high visibility jumpsuit worn by engineers. It has minor radiation shielding."
	name = "engineer's jumpsuit"
	icon_state = "engine"
	item_state = "engi_suit"
	item_color = "engine"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	flags = FPRINT | TABLEPASS

/obj/item/clothing/under/rank/roboticist
	desc = "It's a slimming black with reinforced seams; great for industrial work."
	name = "roboticist's jumpsuit"
	icon_state = "robotics"
	item_state = "robotics"
	item_color = "robotics"

//Down below follows a partial attempt at getting the rolldown verb for jumpsuits.
//Issue: Sprites vanishing again... Hueh - Skull132
/*
/obj/item/clothing/under/rank/verb/rolldown()
	set name = "Roll Down Jumpsuit"
	set category = "Object"
	set src in usr

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	switch(icon_state)
		if("atmos")
			src.icon_state = "atmos_rd"
			src.item_color = "atmos_rd"
			src.item_state = "atmos_rd"
			usr << "You roll down the jumpsuit."
		if("atmos_rd")
			src.icon_state = "atmos"
			src.item_color = "atmos"
			src.item_state = "atmos"
			usr << "You roll the jumpsuit back up."
		if("engine")
			src.icon_state = "engine_rd"
			src.item_color = "engine_rd"
			src.item_state = "engine_rd"
			usr << "You roll down the jumpsuit."
		if("engine_rd")
			src.icon_state = "engine"
			src.item_color = "engine"
			src.item_state = "engine"
			usr << "You roll the jumpsuit back up."
		else
			usr << "You attempt to roll down your [src], before promptly realising how stupid it would be for you to expose your chest."
			return
	usr.update_inv_w_uniform() */


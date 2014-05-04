//Cheap to put a single item per file, but fuck it! - Skull132

/obj/structure/banner
	name = "Corporate Banner"
	desc = "A blue flag emblazoned with a golden logo of Nanotrasen hanging from a wooden stand."
	anchored = 1
	density = 1
	layer = 9
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner_down"

/obj/structure/banner/verb/toggle()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Banner"

	if(!usr.canmove || usr.stat || usr.restrained())
		return 0

	switch(icon_state)
		if("banner_down")
			src.icon_state = "banner_up"
			usr << "You scroll the cloth up."
		if("banner_up")
			src.icon_state = "banner_down"
			usr << "You let the cloth hang loose."
		else
			usr << "You feel slightly dumber."
			return

	src.update_icon()
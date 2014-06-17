/obj/item/clothing/suit/exoskeletonvest
	name = "Exoskeleton MK. IV"
	desc = "A patchwork of hydraulic piping, wires and plates of metal."
	icon_state = ""
	item_state = ""
	blood_overlay_type = "armor"
	w_class = 4
	armor = list(melee = 70, bullet = 10, laser = 10, energy = 10, bomb = 50, bio = 0, rad = 0)
	slowdown = 2
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

///obj/item/clothing/suit/exoskeletonvest/pickup(mob/living/user as mob)
//	if(

/obj/item/exo_parts/part/light_hydraulics
	name = "light hydraulics pack"
	desc = "A small, self-propelled pack with piping running out of it."
	icon_state = ""
	w_class = 3
	flags = FPRINT | CONDUCT
	origin_tech = "engineering=1;power=2"

/obj/item/exo_parts/chassis/light
	name = "light exoskeleton frame"
	desc = "A metallic skeletal structure mimmicking that of the human body."
	icon_state = ""
	w_class = 4
	var/state = 0
	var/created_name = "Exoskeleton Mk IV"
	flags = FPRINT | TABLEPASS | CONDUCT
	origin_tech = "engineering=2;biotech=2"

/obj/item/exo_parts/chassis/light/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", src.name, src.created_name),1,MAX_NAME_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return
		src.created_name = t
	else
		switch(state)
			if(0)
				if(istype(W, /obj/item/exo_parts/part/light_hydraulics))
					user.drop_item()
					del.W
					src.state++
					user << "<span class='notice'>You attach the [W] to the [src].</span>"
					src.name = "skeleton/hydraulics assembly"
					src.icon_state = ""
			if(1)
				if(istype(W, /obj/item/weapon/screwdriver))
					src.state++
					user << "<span class='notice'>You tighten the screws holding the hydraulic pack to the frame.</span>"
					src.icon_state = ""
			if(2)
				if(istype(W, /obj/item/weapon/wrench))
					src.state++
					user << "<span class='notice'>You tighten the hydraulic connections to the various ports.</span>"
					src.icon_state = ""
			if(3)
				if(istype(W, /obj/item/weapon/weldingtool))
					src.state++
					user << "<span class='notice'>You finalize the construction by welding the various seems together.</span>"
					var/turf/T = get_turf(src)
					var/obj/item/clothing/suit/exoskeletonvest/S = new /obj/item/clothing/suit/exoskeletonvest(T)
					S.name = src.created_name
					user.drop_from_inventory(src)
					del(src)
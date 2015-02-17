//Armbands
/obj/item/clothing/armband
	name = "red armband"
	desc = "A fancy red armband!"
	icon = 'icons/obj/clothing/ties.dmi'
	icon_state = "red"
	item_color = "red"
	var/obj/item/clothing/under/has_suit = null		//the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.

/obj/item/clothing/armband/New()
	..()
	inv_overlay = image("icon" = 'icons/obj/clothing/ties_overlay.dmi', "icon_state" = "[item_color? "[item_color]" : "[icon_state]"]")

/obj/item/clothing/armband/proc/on_attached(obj/item/clothing/under/S, mob/user as mob)
	if(!istype(S))
		return
	has_suit = S
	loc = has_suit
	has_suit.overlays += inv_overlay
	has_suit.update_clothing_icon()

	user << "<span class='notice'>You attach [src] to [has_suit].</span>"
	src.add_fingerprint(user)

/obj/item/clothing/armband/proc/on_removed(mob/user as mob)
	if(!has_suit)
		return
	has_suit.overlays -= inv_overlay
	has_suit = null
	usr.put_in_hands(src)
	src.add_fingerprint(user)
	has_suit.update_clothing_icon()

/obj/item/clothing/armband/attackby(obj/item/I, mob/user)
	..()

/obj/item/clothing/armband/attack_hand(mob/user as mob)
	if(has_suit)
		has_suit.remove_accessory(user)
		return
	..()
/obj/item/clothing/armband/cargo
	name = "cargo bay guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is brown."
	icon_state = "cargo"
	item_color = "cargo"

/obj/item/clothing/armband/engine
	name = "engineering guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is orange with a reflective strip!"
	icon_state = "engie"
	item_color = "engie"

/obj/item/clothing/armband/science
	name = "science guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is purple."
	icon_state = "rnd"
	item_color = "rnd"

/obj/item/clothing/armband/hydro
	name = "hydroponics guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is green and blue."
	icon_state = "hydro"
	item_color = "hydro"

/obj/item/clothing/armband/med
	name = "medical guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is white."
	icon_state = "med"
	item_color = "med"

/obj/item/clothing/armband/medgreen
	name = "medical guard armband"
	desc = "An armband, worn by the station's security forces to display which department they're assigned to. This one is white and green."
	icon_state = "medgreen"
	item_color = "medgreen"
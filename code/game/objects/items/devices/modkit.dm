#define MODKIT_HELMET 1
#define MODKIT_SUIT 2
#define MODKIT_FULL 3

/obj/item/device/modkit
	name = "hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user."
	icon_state = "modkit"
	var/parts = MODKIT_FULL
	var/list/from_helmet = list(/obj/item/clothing/head/helmet/space/rig)
	var/list/from_suit = list(/obj/item/clothing/suit/space/rig)
	var/list/to_helmet = list(/obj/item/clothing/head/cardborg)
	var/list/to_suit = list(/obj/item/clothing/suit/cardborg)

/obj/item/device/modkit/afterattack(obj/O, mob/user as mob)
	var/flag
	var/to_type

	for(var/i = 1, i <= from_helmet.len, i++)
//		msg_scopes("[from_helmet[i]]")
		if(istype(O, from_helmet[i]))
			to_type = to_helmet[i]
			flag = MODKIT_HELMET
			break

		if(istype(O, from_suit[i]))
			flag = MODKIT_SUIT
			to_type = to_suit[i]
			break

	if(!flag)
		return

	if(!(parts & flag))
		user << "<span class='warning'>This kit has no parts for this modification left.</span>"
		return
	if(istype(O,to_type))
		user << "<span class='notice'>[O] is already modified.</span>"
		return
	if(!isturf(O.loc))
		user << "<span class='warning'>[O] must be safely placed on the ground for modification.</span>"
		return
	playsound(user.loc, 'sound/items/Screwdriver.ogg', 100, 1)
	msg_scopes("[to_type]")
	var/N = new to_type(O.loc)
	user.visible_message("\red [user] opens \the [src] and modifies \the [O] into \the [N].","\red You open \the [src] and modify \the [O] into \the [N].")
	del(O)
	parts &= ~flag
	if(!parts)
		del(src)

/obj/item/device/modkit/tajaran
	name = "tajara hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user. This one looks like it's meant for Tajara."

//Keep the lists in matching orders to the relative type and keep the parents at the end.
// /obj/item/clothing/head/helmet/space/rig <- is a parent //i love you, sounds.
	from_helmet = list(/obj/item/clothing/head/helmet/space/rig/security, /obj/item/clothing/head/helmet/space/rig/medical, /obj/item/clothing/head/helmet/space/rig/atmos, /obj/item/clothing/head/helmet/space/rig)
	to_helmet = list(/obj/item/clothing/head/helmet/space/rig/security/tajara, /obj/item/clothing/head/helmet/space/rig/medical/tajara, /obj/item/clothing/head/helmet/space/rig/atmos/tajara, /obj/item/clothing/head/helmet/space/rig/tajara)

	from_suit = list(/obj/item/clothing/suit/space/rig/security, /obj/item/clothing/suit/space/rig/medical, /obj/item/clothing/suit/space/rig/atmos, /obj/item/clothing/suit/space/rig)
	to_suit = list(/obj/item/clothing/suit/space/rig/security/tajara, /obj/item/clothing/suit/space/rig/medical/tajara, /obj/item/clothing/suit/space/rig/atmos/tajara, /obj/item/clothing/suit/space/rig/tajara)

/obj/item/device/modkit/unathi
	name = "unathi hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user. This one looks like it's meant for Unathi."

	from_helmet = list(/obj/item/clothing/head/helmet/space/rig/security, /obj/item/clothing/head/helmet/space/rig/medical, /obj/item/clothing/head/helmet/space/rig/atmos, /obj/item/clothing/head/helmet/space/rig)
	to_helmet = list(/obj/item/clothing/head/helmet/space/rig/security/unathi, /obj/item/clothing/head/helmet/space/rig/medical/unathi, /obj/item/clothing/head/helmet/space/rig/atmos/unathi, /obj/item/clothing/head/helmet/space/rig/unathi)

	from_suit = list(/obj/item/clothing/suit/space/rig/security, /obj/item/clothing/suit/space/rig/medical, /obj/item/clothing/suit/space/rig/atmos, /obj/item/clothing/suit/space/rig)
	to_suit = list(/obj/item/clothing/suit/space/rig/security/unathi, /obj/item/clothing/suit/space/rig/medical/unathi, /obj/item/clothing/suit/space/rig/atmos/unathi, /obj/item/clothing/suit/space/rig/unathi)

/obj/item/device/modkit/skrell
	name = "skrell hardsuit modification kit"
	desc = "A kit containing all the needed tools and parts to modify a hardsuit for another user. This one looks like it's meant for Skrell."

	from_helmet = list(/obj/item/clothing/head/helmet/space/rig/security, /obj/item/clothing/head/helmet/space/rig/medical, /obj/item/clothing/head/helmet/space/rig/atmos, /obj/item/clothing/head/helmet/space/rig)
	to_helmet = list(/obj/item/clothing/head/helmet/space/rig/security/skrell, /obj/item/clothing/head/helmet/space/rig/medical/skrell, /obj/item/clothing/head/helmet/space/rig/atmos/skrell, /obj/item/clothing/head/helmet/space/rig/skrell)

	from_suit = list(/obj/item/clothing/suit/space/rig/security, /obj/item/clothing/suit/space/rig/medical, /obj/item/clothing/suit/space/rig/atmos, /obj/item/clothing/suit/space/rig)
	to_suit = list(/obj/item/clothing/suit/space/rig/security/skrell, /obj/item/clothing/suit/space/rig/medical/skrell, /obj/item/clothing/suit/space/rig/atmos/skrell, /obj/item/clothing/suit/space/rig/skrell)




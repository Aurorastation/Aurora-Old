/*
// Bluespace Technition and all their items.
// Only avaliable to people with +DEV and +DEVELOPER
// All items are ave canremove = 0 to avoid loos and thefts
// They are invincible.
// Suicide with them to exit in an rp way
//
// I really didn't expect most of this to work right but hey it does.
// - SoundScopes
*/

/client/proc/cmd_dev_bst()
	set category = "Debug"
	set name = "Spawn Bluespace Tech"
	set desc = "Spawns a Bluespace Tech to debug stuff"

	if(!check_rights(R_DEV))	return

	if(!holder)
		return //how did they get here?

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "\red The game hasn't started yet!"
		return

	//I couldn't get the normal way to work so this works.
	//This whole section looks like a hack, I don't like it.
	var/T = get_turf(usr)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, T)
	s.start()
	var/mob/living/carbon/human/bst/bst = new(get_turf(T))
//	bst.original_mob = usr
	bst.anchored = 1
	bst.ckey = usr.ckey
	bst.name = "Bluespace Technician"
	bst.real_name = "Bluespace Technician"
	bst.voice_name = "Bluespace Technician"
//	bst.h_style = "hair_crewcut"
//	bst.update_hair()

	//Items
	var/obj/item/clothing/under/U = new /obj/item/clothing/under/rank/centcom_officer/bst(bst)
	bst.equip_to_slot_or_del(U, slot_w_uniform)
	bst.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert/bst(bst), slot_l_ear)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/holding/bst(bst), slot_back)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(bst.back), slot_in_backpack)
	bst.equip_to_slot_or_del(new /obj/item/clothing/shoes/black/bst(bst), slot_shoes)
	bst.equip_to_slot_or_del(new /obj/item/clothing/head/beret(bst), slot_head)
	bst.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/bst(bst), slot_glasses)
	bst.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(bst), slot_belt)
	bst.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat/bst(bst), slot_gloves)
	if(bst.backbag == 1)
		bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(bst), slot_r_hand)
	else
		bst.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/t_scanner(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/signaltool(bst.back), slot_in_backpack)
		bst.equip_to_slot_or_del(new /obj/item/device/pda/captain/bst(bst.back), slot_in_backpack)

	//Implant because access
	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(bst)
	L.imp_in = bst
	L.implanted = 1
	var/datum/organ/external/affected = bst.organs_by_name["head"]
	affected.implants += L
	L.part = affected

	//Sort out ID
	var/obj/item/weapon/card/id/bst/id = new/obj/item/weapon/card/id/bst(bst)
	id.registered_name = bst.real_name
	id.assignment = "Bluespace Technician"
	id.name = "[id.assignment]"
	bst.equip_to_slot_or_del(id, slot_wear_id)
	bst.update_inv_wear_id()

	//Add the rest of the languages
	//Because universal speak doesn't work right.
	bst.add_language("Sinta'unathi")
	bst.add_language("Siik'Maas")
	bst.add_language("Skrellian")
	bst.add_language("Vox-pidgin")
	bst.add_language("Rootspeak")
	bst.add_language("Tradeband")
	bst.add_language("Gutter")
	bst.add_language("Sini")
	bst.add_language("Sign language")

/*	bst.bluespace_trail.set_up(src)
	bst.bluespace_trail.start()
	spawn(100)
		bst.bluepsace_trail.stop()
*/
	spawn(5)
		s.start()
		bst.anchored = 0
	log_debug("Bluespace Tech Spawned: X:[bst.x] Y:[bst.y] Z:[bst.z] User:[src]")
	feedback_add_details("admin_verb","BST")
	return 1

/mob/living/carbon/human/bst
	universal_speak = 1
	universal_understand = 1
	status_flags = GODMODE
	var/bluespace_trail = new /datum/effect/effect/system/ion_trail_follow

	can_inject(var/mob/user, var/error_msg, var/target_zone)
		user << "<span class='alert'>The [src] disarms you before you can inject them.</span>"
		user.drop_item()
		return 0

	suicide()
		src.custom_emote(1,"presses a button on his suit, followed by a polite bow.")
		spawn(10)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
			var/mob/dead/observer/ghost = new(src)	//Transfer safety to observer spawning proc.
			ghost.key = key
			ghost.mind.name = "[ghost.key] BSTech"
			ghost.name = "[ghost.key] BSTech"
			ghost.real_name = "[ghost.key] BSTech"
			ghost.voice_name = "[ghost.key] BSTech"
			del(src)

	say(var/message)
		var/verb = "says in a subdued tone"
		..(message, verb)

//Equipment. All should have canremove set to 0
//All items with a /bst need the attack_hand() proc overrided to stop people getting overpowered items.

//Bag o Holding
/obj/item/weapon/storage/backpack/holding/bst
	canremove = 0
	storage_slots = 20
	max_combined_w_class = 400

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the [src]. It's like it doesn't exist.</span>"
			return
		else
			..()

//Headset
/obj/item/device/radio/headset/ert/bst
	name = "Bluespace Technician's headset"
	desc = "Bluespace Technician's headset, 'BST' marked on the side."
	translate_binary = 1
	translate_hive = 1
	canremove = 0

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the [src]. It's like it doesn't exist.</span>"
			return
		else
			..()

//Clothes
/obj/item/clothing/under/rank/centcom_officer/bst
	name = "Bluespace Technician's Uniform"
	desc = "Bluespace Technician's Uniform, there is a logo on the sleve, it reads 'BST'."
	has_sensor = 0
	sensor_mode = 0
	canremove = 0

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the [src]. It's like it doesn't exist.</span>"
			return
		else
			..()

//Gloves
/obj/item/clothing/gloves/swat/bst
	name = "Bluespace Technician's gloves"
	desc = "A pair of modified gloves, 'BST' marked on the side."
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	canremove = 0

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the [src]. It's like it doesn't exist.</span>"
			return
		else
			..()

//Sunglasses
/obj/item/clothing/glasses/sunglasses/bst
	name = "Bluespace Technician's Glasses"
	desc = "A pair of sunglasses, these look modified, 'BST' marked on the side."
//	var/list/obj/item/clothing/glasses/hud/health/hud = null
	vision_flags = (SEE_TURFS|SEE_OBJS|SEE_MOBS)
	canremove = 0
/*	New()
		..()
		src.hud += new/obj/item/clothing/glasses/hud/security(src)
		src.hud += new/obj/item/clothing/glasses/hud/health(src)
		return
*/
	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the [src]. It's like it doesn't exist.</span>"
			return
		else
			..()

//Shoes
/obj/item/clothing/shoes/black/bst
	name = "Bluespace Technician's shoes"
	name = "Bluespace Technician's shoes, 'BST' marked on the side."
	icon_state = "black"
	item_color = "black"
	desc = "A pair of black shoes. 'BST' marked on the side."
	flags = NOSLIP
	canremove = 0

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the [src]. It's like it doesn't exist.</span>"
			return
		else
			..()

	negates_gravity()
		return 1 //Because Bluespace

//ID
/obj/item/weapon/card/id/bst
	icon_state = "centcom"
	desc = "An ID straight from Cent. Com, this one looks highly classified"
//	canremove = 0
	New()
		access = get_all_accesses()+get_all_centcom_access()+get_all_syndicate_access()

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the [src] ID. It's like it doesn't exist.</span>"
			return
		else
			..()

/obj/item/device/pda/captain/bst
	hidden = 1
	silent = 1
//	ttone = "DO SOMETHING HERE"

	attack_hand()
		if(!usr)
			return
		if(!istype(usr, /mob/living/carbon/human/bst))
			usr << "<span class='alert'>Your hand seems to go right through the pda. It's like it doesn't exist.</span>"
			return
		else
			..()

/mob/living/carbon/human/bst/restrained()
	return 0
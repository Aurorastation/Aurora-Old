/obj/item/weapon/storage/belt/fluff/jace_toolbelt //Jace's Toolbelt - Jace Evans - Wittme91
	name = "Jace's Toolbelt"
	desc = "A large, well-worn toolbelt."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "jace_belt"
	item_state = "jace_belt"
	can_hold = list(
		"/obj/item/weapon/crowbar",
		"/obj/item/weapon/screwdriver",
		"/obj/item/weapon/weldingtool",
		"/obj/item/weapon/wirecutters",
		"/obj/item/weapon/wrench",
		"/obj/item/device/multitool",
		"/obj/item/device/flashlight",
		"/obj/item/weapon/cable_coil",
		"/obj/item/device/t_scanner",
		"/obj/item/device/analyzer",
		"/obj/item/taperoll/engineering",
		"/obj/item/weapon/rcd",
		"/obj/item/weapon/rcd_ammo",
		"/obj/item/weapon/firealarm_electronics",
		"/obj/item/weapon/circuitboard",
		"/obj/item/weapon/airalarm_electronics",
		"/obj/item/weapon/airlock_electronics",
		"/obj/item/weapon/module/power_control",
		"/obj/item/weapon/cell",
		"/obj/item/weapon/hand_tele")
	storage_slots = 14
	max_combined_w_class = 42
	max_w_class = 3

/obj/item/clothing/tie/fluff/teranium_necklace //Teranium Necklace - Inis Tool-Truesight - Gollee
	name = "Teranium Necklace"
	desc = "A small electric blue crystal held on a fine metal chain."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "teranium_necklace"
	item_state = "teranium_necklace"
	item_color = "teranium_necklace"
	slot_flags = SLOT_MASK

/obj/item/weapon/lighter/zippo/fluff/nikolai_zippo //Silver Plated Lighter - Nikolai Petirosky - Nikolai the beast
	name = "Silver Plated Lighter"
	desc = "A silver lighter, adorned with many wear marks."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "nikolai_zippo"
	icon_on = "nikolai_zippoon"
	icon_off = "nikolai_zippo"

/obj/item/weapon/storage/box/fluff/nikolai_tin //Silver Cigar Tin - Nikolai Petirosky - Nikolai the beast
	name = "Silver Cigar Tin"
	desc = "A silver plated tin, a pleasant smell of tobacco eminating from it."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "nikolai_tin"
	storage_slots = 5
	max_w_class = 1
	max_combined_w_class = 5
	foldable = null
	can_hold = list(
		"/obj/item/clothing/mask/cigarette/cigar",
		"/obj/item/clothing/mask/cigarette/cigar/cohiba",
		"/obj/item/clothing/mask/cigarette/cigar/havana",
		"/obj/item/clothing/mask/cigarette")
	New()
		..()
		new /obj/item/clothing/mask/cigarette/cigar(src)
		new /obj/item/clothing/mask/cigarette/cigar(src)
		new /obj/item/clothing/mask/cigarette/cigar(src)
		new /obj/item/clothing/mask/cigarette/cigar(src)
		new /obj/item/clothing/mask/cigarette/cigar(src)
		return

/obj/item/clothing/suit/storage/fluff/edward_coat //Edward's Trenchcoat - Edward Smith - leore
	name = "Edward's Trenchcoat"
	desc = "A dusty old trenchcoat. It bears the faint initials E.S. on the collar."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "edward_coat"
	item_state = "edward_coat"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight,/obj/item/weapon/gun/energy,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/lighter,/obj/item/device/detective_scanner,/obj/item/device/taperecorder)

/* /obj/item/weapon/storage/wallet/fluff/faith_wallet //Worn Wallet - Faith Skirata - FaithSkirata
 *	name = "Worn Wallet"
 *	desc = "A synthetic leather wallet, marked with burns and tears throughout. It smells funny."
 *	icon = 'icons/obj/custom_items.dmi'
 *	icon_state = "faith_wallet"
 */

/obj/item/clothing/glasses/eyepatch/fluff/peter_eyepatch //Peter's Patch - Peter Thrushwood - farcry11 - DONE
	name = "Peter's Patch"
	desc = "A rather grungy looking eyepatch. If you're holding it, a certain man is probably freaking out right now."

/obj/item/clothing/shoes/sandal/fluff/raieed_sandals //Treasured Sandals - Raieed Amari - nikolaithebeast - DONE
	name = "Treasured Sandals"
	desc = "A pair of black sandals, which seem to hold the entire on themselves."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "raieed_sandals"
	item_state = "raieed_sandals"

/obj/item/clothing/suit/storage/fluff/raieed_labcoat //Treasured Labcoat - Raieed Amari - nikolaithebeast - DONE
	name = "Treasured Labcoat"
	desc = "A coat that seems to emanate the love that was put into its creation."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "raieed_labcoat_open"
	item_state = "raieed_labcoat"

/obj/item/weapon/folder/fluff/may_notebook //May Izumi's Notebook - May Izumi - lk600 - DONE
	name = "May Izumi's Notebook"
	desc = "A pink notebook that is covered in hearts and little manga stickers. It is filled with lots of questions, replies and conversations from her past. It has 'May Izumi' printed on the front."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "izumi_notebook"

/obj/item/clothing/under/dress/fluff/olivia_uniform //Waitress Uniform - Olivia Conrad - meowykins - DONE
	name = "Waitress Uniform"
	desc = "A modest uniform. the name-tag reads 'Olivia Conrad'."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "olivia_skirt"
	item_color = "olivia_skirt"
	item_state = "olivia_skirt"

/obj/item/clothing/head/hairflower/fluff/olivia_flower //White Flower - Olivia Conrad - meowykins - DONE
	name = "White flower"
	desc = "A white flower. It has a clip on the back."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "olivia_flower"
	item_state = "olivia_flower"

/obj/item/clothing/under/rank/fluff/steven_unfirom //Naval Working Uniform - Steven Machnaughton - sgtsammac - INVESTIGATE
	name = "Naval Working Uniform"
	desc = "A working unfirom of the NanoTrasen Navy."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "steven_uniform"
	item_color = "steven_uniform"
	item_state = "steven_uniform"

/obj/item/weapon/coin/fluff/sphere_coin //Rusty Coin - Yusani Thomas - f_sphere - DONE
	name = "Rusty Coin"
	desc = "A small, dirty coin. It looks like it has been around for ages."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "coin_sphere"

/obj/item/weapon/weldingtool/fluff/dae_welder //Custom built welding tool - Atalanta Cascadia - daetactica - DONE
	name = "welding tool"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "welder"

/obj/item/weapon/reagent_containers/glass/rag/fluff/rusty_handkerchief //handkerchief - Janet Fisher - rustysh4ckleford - DONE
	name = "Handkerchief"
	desc = "An ordinary handkerchief. It has what looks to be a washed out bloodstain on it."
	w_class = 1
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "janet_handkerchief"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5)
	volume = 5
	can_be_placed_into = null

/obj/item/weapon/reagent_containers/glass/rag/fluff/rusty_handkerchief/attack_self(mob/user as mob)
	user.visible_message("[user] holds [src] up to her face.")
	if(do_after(user,30))
		user.visible_message("[user] moves [src] away from her face.")
	return

/obj/item/weapon/reagent_containers/glass/rag/fluff/rusty_handkerchief/attack(atom/target as obj|turf|area, mob/user as mob , flag)
	if(ismob(target) && target.reagents && reagents.total_volume)
		user.visible_message("\red \The [target] has been smothered with \the [src] by \the [user]!", "\red You smother \the [target] with \the [src]!", "You hear some struggling and muffled cries of surprise")
		src.reagents.reaction(target, TOUCH)
		spawn(5) src.reagents.clear_reagents()
		return
	else
		..()

/obj/item/weapon/reagent_containers/glass/rag/fluff/rusty_handkerchief/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(A) && src in user)
		user.visible_message("[user] starts to wipe down [A] with [src]!")
		if(do_after(user,30))
			user.visible_message("[user] finishes wiping off the [A]!")
			A.clean_blood()
	return

/obj/item/weapon/reagent_containers/glass/rag/fluff/rusty_handkerchief/examine()
	if (!usr)
		return
	usr << "That's \a [src]."
	usr << desc
	return

/obj/item/clothing/tie/storage/knifeharness/fluff/skull132_harness //A crimson harness - No assign character (Allyn "Crimson" Adema) - skull132 - DONE
	name = "a crimson harness"
	desc = "An Unathi ceremonial harness with two pieces of crimson cloth draped across the heart of the wearer."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "skull_harness2"
	item_color = "skull_harness2"
	item_state = "skull_harness2"
	slots = 2

/*
/obj/item/clothing/tie/storage/knifeharness/fluff/skull132_harness/attackby(var/obj/item/O as obj, mob/user as mob)
	..()
	update()

/obj/item/clothing/tie/storage/knifeharness/fluff/skull132_harness/proc/updateskull()
	var/count = 0
	for(var/obj/item/I in hold)
		if(istype(I,/obj/item/weapon/hatchet/unathiknife))
			count++
	if(count>2) count = 2
	item_state = "skull_harness[count]"
	icon_state = item_state
	item_color = item_state

	if(istype(loc, /obj/item/clothing))
		var/obj/item/clothing/U = loc
		if(istype(U.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = U.loc
			H.update_inv_w_uniform()

/obj/item/clothing/tie/storage/knifeharness/fluff/skull132_harness/New()
	..()
	new /obj/item/weapon/hatchet/unathiknife(hold)
	new /obj/item/weapon/hatchet/unathiknife(hold)
*/

/obj/item/weapon/disk/fluff/nebula_chip //data chip - Roxy Wallace - nebulaflare - DONE
	name = "data chip"
	desc = "A small green chip."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "nebula_chip"
	w_class = 1

/obj/item/weapon/storage/fluff/nebula_glasses //chich eyewear - Roxy Wallace - nebulaflare - DONE
	name = "Chic Eyewear"
	desc = " A stylish pair of glasses. They look custom made."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "nebula_glasses"
	item_state = "glasses"
	flags = FPRINT | GLASSESCOVERSEYES
	slot_flags = SLOT_EYES
	can_hold = list(
		"/obj/item/weapon/disk/fluff/nebula_chip")
	storage_slots = 1
	max_combined_w_class = 1
	max_w_class = 1

/obj/item/weapon/storage/fluff/nebula_glasses/proc/can_use()
        if(!ismob(loc)) return 0
        var/mob/M = loc
        if(src in M.get_equipped_items())
                return 1
        else
                return 0

/obj/item/weapon/storage/fluff/nebula_glasses/MouseDrop(obj/over_object as obj, src_location, over_location)
        var/mob/M = usr
        if(!istype(over_object, /obj/screen))
                return ..()
        playsound(src.loc, "rustle", 50, 1, -5)
        if (!M.restrained() && !M.stat && can_use())
                switch(over_object.name)
                        if("r_hand")
                                M.u_equip(src)
                                M.put_in_r_hand(src)
                        if("l_hand")
                                M.u_equip(src)
                                M.put_in_l_hand(src)
                src.add_fingerprint(usr)
                return

/obj/item/clothing/mask/cigarette/pipe/fluff/tool_pipe //Worn pipe - Michael Tool - mrimatool - DONE
	name = "worn pipe"
	desc = "A worn wooden pipe with the initials S.F. scratched into the base."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "toolpipeoff"
	item_state = "pipeoff"
	icon_on = "toolpipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = 100

/obj/item/weapon/reagent_containers/food/drinks/flask/fluff/tool_flask //Worn flask - Michael Tool - mrimatool - DONE
	name = "worn flask"
	desc = "A metal flask wrapped in a leather fashion."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "tool_flask"
	volume = 60

/obj/item/weapon/melee/baton/fluff/omnivac_baton //Tiger Claw - Zander Moon - omnivac - DONE
	name = "Tiger Claw"
	desc = "A small energy dagger given to Golden Tigers meant to incapacitate people quickly."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "tigerclaw"
	item_state = "tigerclaw"

/obj/item/weapon/melee/baton/fluff/omnivac_baton/update_icon()
	if(status)
		icon_state = "tigerclaw_active"
		item_state = "tigerclaw_active"
	else
		icon_state = "tigerclaw"
		item_state = "tigerclaw"

/obj/item/weapon/melee/baton/fluff/omnivac_baton/attack_self(mob/user as mob)
	if(status && (CLUMSY in user.mutations) && prob(50))
		user << "\red You grab the [src] on the wrong side."
		user.Weaken(30)
		charges--
		if(charges < 1)
			status = 0
			update_icon()
		return
	if(charges > 0)
		status = !status
		user << "<span class='notice'>\The [src] is now [status ? "on" : "off"].</span>"
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		update_icon()
	else
		status = 0
		user << "<span class='warning'>\The [src] is out of charge.</span>"
	add_fingerprint(user)

/obj/item/device/modkit/fluff/omnivac_modkit //Ornate box - Zander Moon - omnivac - SPRITE
	name = "ornate box"
	desc = "An ornate box, containing the handle of an energy blade."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "omni_modkit"
	parts = MODKIT_HELMET
	from_helmet = /obj/item/weapon/melee
	to_helmet = /obj/item/weapon/melee/baton/fluff/omnivac_baton

/obj/item/clothing/head/soft/fluff/nebula_cap //Black baseball cap - Roxy Wallace - nebulaflare - DONE
	name = "black baseball cap"
	desc = "A black baseball cap."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "nebula_cap"
	item_color = "nebula_cap"

/obj/item/clothing/head/beret/centcom/officer/fluff/mirkoloio_beret //Navy beret - Fabian Goellstein - mirkoloio - DONE
	name = "navy beret"
	desc = "A NanoTrasen Navy beret, it has the name Goellstein inside of it. It has the NT Navy insignia on it."

/obj/item/device/pda/fluff/meowykins_pda //Data-Tablet - Miyako Yukimura - meowykins - DONE
	name = "Data-tablet"
	desc = "A black data-tablet"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "meowykins_pda"
	slot_flags = SLOT_ID | SLOT_BELT

/obj/item/weapon/storage/toolbox/mechanical/fluff/kaylee_toolbox //Kaylee's toolbox - Kaylee Summers - yeahchris - DONE
	name = "Kaylee's toolbox"
	desc = "A battered old red toolbox with fading paint. It used to have a name written on it in marker, but it has long since faded to the point of illegibility."
	icon_state = "red"
	item_state = "toolbox_red"

/obj/item/clothing/under/dress/fluff/heather_skirt //Black skirt - Heather Wyatt - meowykins - DONE
	name = "black skirt"
	desc = "A plain black and grey skirt"
	icon_state = "plaid_black"
	item_color = "plaid_black"
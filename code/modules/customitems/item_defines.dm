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
	name = "treasured sandals"
	desc = "A pair of black sandals, which seem to hold the entire world on themselves."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "raieed_sandals"
	item_state = "raieed_sandals"

/obj/item/clothing/suit/storage/fluff/raieed_labcoat //Treasured Labcoat - Raieed Amari - nikolaithebeast - DONE
	name = "torn labcoat"
	desc = "A old labcoat, torn beyond reorganization, but yet it still seems to be kept for."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "raieed_labcoat"
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
	desc = "A makeshift welding tool, seemingly made from old engine parts. It has a small sentence in what looks to be greek etched into its surface."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "welder"
	item_state = null

/obj/item/weapon/reagent_containers/glass/rag/fluff/rusty_handkerchief //handkerchief - Janet Fisher - rustysh4ckleford - DONE
	name = "Handkerchief"
	desc = "An ordinary handkerchief. It looks well used."
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
	w_class = 2
	New()
		..()
		new /obj/item/weapon/disk/fluff/nebula_chip(src)
		return

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
	can_hurt_mob = 0

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
	from_helmet = list(/obj/item/weapon/melee)
	to_helmet = list(/obj/item/weapon/melee/baton/fluff/omnivac_baton)

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

/obj/item/clothing/gloves/swat/fluff/hawk_gloves //Sharpshooter gloves - Hawk Silverstone - nebulaflare - DONE
	desc = "These tactical gloves are tailor made for a marksman."
	name = "\improper Sharpshooter Gloves"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "hawk_gloves"
	item_state = "swat_gl"

/obj/item/clothing/suit/storage/fluff/fabian_coat //NT Navy coat - Fabian Goellstein - mirkoloio - DONE
	name = "NT Navy coat"
	desc = "A working coat of the NanoTrasen Navy. The nameplate carries the letters 'GOELLSTEIN'."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "fabian_coat_open"
	item_state = "fabian_coat_open"

	verb/toggle()
		set name = "Toggle coat zipper"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(icon_state)
			if("fabian_coat_open")
				src.icon_state = "fabian_coat_closed"
				usr << "You zip the coat's zipper shut."
			if("fabian_coat_closed")
				src.icon_state = "fabian_coat_open"
				usr << "You unzip the coat's zipper."
			else
				usr << "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are."
				return
		usr.update_inv_wear_suit()	//so our overlays update

/obj/item/weapon/pen/fluff/eliza_pen //Fountain pen - Eliza Pond - forgottentraveller - DONE
	desc = "A pen with an outer cylinder of black obsidian with gold metal clip. Monogrammed with silver inlay 'V.M.'"
	name = "elegant pen"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "eliza_pen"
	item_state = "pen"
	var/ink = 1

/obj/item/weapon/pen/fluff/eliza_pen/attack_self(mob/user)
	switch(ink)
		if(1)
			ink = 2
			colour = "blue"
			user << "<span class='notice'>You cycle the pen to use the blue ink cartridge.</span>"
		if(2)
			ink = 3
			colour = "red"
			user << "<span class='notice'>You cycle the pen to use the red ink cartridge.</span>"
		if(3)
			ink = 1
			colour = "black"
			user << "<span class='notice'>You cycle the pen to use the black ink cartridge.</span>"

/obj/item/device/fluff/amy_player //Music player - Amy Heris - gollee - DONE - Modding
	name = "music player"
	desc = "An olive green HF24 in pristine condition, there is a small engraving on the back, reading 'To Amy, I will always be here for you, Varan.'"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "amy_player_off"
	item_state = "electornic"
	slot_flags = SLOT_BELT | SLOT_ID // | SLOT_EARS  wut
	w_class = 1
	var/playing = 0
	var/emped = 0
	var/fixed = 0
	var/list/songs = list("Lord of Light",
	"Second Chance",
	"Redoubt",
	"Affinity",
	"Dream Spark"
	)
/obj/item/clothing/ears/headphone
	name = "Headphone"
	desc = "Headphones made for special players..."
	icon_state = "earmuffs"
	item_state = "earmuffs"
	slot_flags = SLOT_EARS //| SLOT_TWOEARS



//Totally damned surprised this worked on the first go. Huh, well, it works! Considering integration into main code as well. - Skull132
/obj/item/device/fluff/amy_player/emp_act(severity)
	emped = 1
	icon_state = "amy_player_broken"
	playing = 0

/obj/item/device/fluff/amy_player/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (emped == 1)
		if(istype(O, /obj/item/weapon/screwdriver) && fixed == 0)
			fixed = 1
			user << "<span class='notice'>You unfasten the back panel.</span>"
		if(istype(O, /obj/item/device/multitool) && fixed == 1)
			fixed = 0
			user << "<span class='notice'>You quickly pulse a few fires, and reset the screen and device.</span>"
			emped = 0
			icon_state = "amy_player_off"


	return
//	else
//		user << "<span class='notice'>You see little reason to start hacking into the player's wiring.</span>"

/obj/item/device/fluff/amy_player/attack_self(mob/user)
	if(emped)
		user<< "<span class='notice'>The screen flickers and blinks with errors. It looks like it's about to give up the ghost.</span>"
	else if(playing == 0)
		var/mob/living/carbon/human/M = usr
		var/pickedsong = input("Select the song you want to play.","Songs", null, null) in songs
		if(istype(M.l_ear, /obj/item/clothing/ears/headphone) || istype(M.r_ear, /obj/item/clothing/ears/headphone))
			switch(pickedsong)
				if("Dream Spark")
					usr << sound('sound/mp3/dreamspark.ogg')
				if("Second Chance")
					usr << sound('sound/mp3/secondchance.ogg')
				if("Redoubt")
					usr << sound('sound/mp3/redoubt.ogg')
				if("Affinity")
					usr << sound('sound/mp3/affinity.ogg')
				if("Lord of Light")
					usr << sound('sound/mp3/lordoflight.ogg')
		else
			for(var/mob/I in view())
				switch(pickedsong)
					if("Dream Spark")
						I << sound('sound/mp3/dreamspark.ogg')
					if("Second Chance")
						I << sound('sound/mp3/secondchance.ogg')
					if("Redoubt")
						I << sound('sound/mp3/redoubt.ogg')
					if("Affinity")
						I << sound('sound/mp3/affinity.ogg')
					if("Lord of Light")
						I << sound('sound/mp3/lordoflight.ogg')
		user << "<span class='notice'>You turn on the music player, selecting a song. A song called '[pickedsong]' starts playing through the earbuds as the device sparks to life.</span>"
		icon_state = "amy_player_on"
		playing = 1
	else
		user << "<span class='notice'>You turn off the music player.</span>"
		playing = 0


/*			if(0)
				playing = 1
				icon_state = "amy_player_on"
				user << "<span class='notice'>You turn on the music player, selecting a song. A song called '[pick("Lord of Light","Second Chance","Redoubt", "Affinity","Dream Spark")]' starts playing through the earbuds as the device sparks to life.</span>"
			if(1)
				playing = 0
				icon_state = "amy_player_off"
				user << "<span class='notice'>You turn off the music player.</span>"*/
 // Respect.
/* 	Song list, from Gollee:
/	"Lord of Light"
/	"Second Chance"
/	"Redoubt"
/	"Affinity"
/	"Dream Spark"
*/

/obj/item/device/fluff/sten_synth //VoiceOS.V2 - Sten Asval - vtol - DONE
	name = "VoiceOS.V2"
	desc = "A text-to-speech device with an appearance that is not too futuristic. It looks slim and light. On the back of it there are initials in silver: SA."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "synth"
	item_state = "radio"
	w_class = 2.0
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_GLOVES

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("BOB'S A PERVERT!", "I HATE YOU ALL!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!")
	var/list/empmsg = list("Lusty Xenomorph Maid", "Tajara Nymphomaniac Se'xual Hea'Ling", "Uneth Hermaphrodite Tai'L S'ex", "Skrellian Pornstar Hen-Tai")
	var/emped = 0

	verb/synth()
		set name = "Use voice synth"
		set category = "Object"
		set src in usr

		if (usr.client)
			if(usr.client.prefs.muted & MUTE_IC)
				src << "\red You cannot speak in IC (muted)."
				return
		if(!ishuman(usr))
			usr << "\red You don't know how to use this!"
			return
		if(emped)
			for(var/mob/O in (viewers(usr)))
				O.show_message("<B>[usr]</B>'s voice synth starts showing obscene images of [pick(empmsg)], coupled with excessive moaning and questionable noises.",2)
			spawn(rand(5,30))
				for(var/mob/O in (viewers(usr)))
					O.show_message("<B>[usr]</B>'s voice synth starts sparking and finally explodes.",2)
				var/turf/T = get_turf(src.loc)
				explosion(T, 0, 0, 0, 1)
				del(src)
			return
		if(spamcheck)
			usr << "\red \The [src] needs to recharge!"
			return

		var/message = copytext(sanitize(input(usr, "Type a message?", "VoiceOS.V2", null)  as text),1,MAX_MESSAGE_LEN)
		if(!message)
			return
	//	message = capitalize(message)
		if ((src.loc == usr && usr.stat == 0))
			if(emagged)
				if(insults)
					for(var/mob/O in (viewers(usr)))
						O.show_message("<B>[usr]</B>'s voice synth blurts out, <FONT size=3>\"[pick(insultmsg)]\"</FONT>",2) // 2 stands for hearable message
					insults--
				else
					usr << "\red *BZZZZzzzzzt*"
			else
				for(var/mob/O in (viewers(usr)))
					O.show_message("<B>[usr]</B>'s voice synth rasps, \"[message]\"",2) // 2 stands for hearable message

			spamcheck = 1
			spawn(20)
				spamcheck = 0
			return

	attackby(obj/item/I, mob/usr)
		if(istype(I, /obj/item/weapon/card/emag) && !emagged)
			usr << "\red You overload \the [src]'s voice synthesizer."
			emagged = 1
			insults = rand(1, 3)//to prevent dickflooding
			return
		return

	emp_act(severity)
		emped = 1
		return

/obj/item/fluff/brenna_rock //Memento rock - Brenna Noton - mikalhvi - DONE
	name = "memento rock"
	desc = "A rounded-off chunk of a NanoTransen claimed asteroid." //I'm sorry. Too much description, nixed all of it.
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "rock"
	item_state = ""
	w_class = 2.0
	force = 2
	throwforce = 4
	attack_verb = list("bashed", "struck", "smashed", "bonked", "clobbered")

	attack(mob/living/carbon/human/M as mob, mob/user as mob)
		if(M == user)
			user << "You take a lick of the sandstone rock."
			if(prob(5))
				spawn(10)
					user << "Whilist attempting to lick the rock, you accidentally swallow it."
					M.apply_damage(rand(10,40), OXY)
					del(src)
		else
			..()

/obj/item/fluff/iris_bracelets //Silver bracelets - Iris Kilur - gollee - DONE
	name = "silver bracelets"
	desc = "Two silver bracelets, the scrolled one oversetting the other."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "iris_bracelets"
	item_state = ""
	w_class = 1.0
	slot_flags = SLOT_GLOVES

/obj/item/fluff/delivander_ring //Old wedding ring - Delivander Starbreeze - gollee - DONE
	name = "old wedding ring"
	desc = "A tarnished gold ring, there is writing inside it, “To Liura, forever.”"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "delivander_ring"
	item_state = ""
	w_class = 1.0
	slot_flags = SLOT_GLOVES

/obj/item/clothing/head/welding/fluff/buck_mask //Blue Panther's welding mask - Buck Bradely - bluesp34r - DONE
	name = "Blue Panther's welding mask"
	desc = "A welding mask. This one in particular has a hand-painted, blue jungle cat face on it. It looks absolutely ferocious!"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "bluepanther"
	item_state = "bluepanther"

/obj/item/clothing/gloves/fluff/amy_gloves //Red fingerless gloves - Amy Tilley - lk600 - DONE
	name = "Red fingerless gloves"
	desc = "A pair of red and black fingerless gloves that stretch up the arm. They look to be made of a soft wool and are well worn."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "amy_gloves"
	item_state = "amy_gloves"
	clipped = 1

/obj/item/clothing/tie/storage/fluff/cecillia_locket //Old locket - Cecillia Lambert - casperf1 - DONE
	name = "old locket"
	desc = "A dark metal locket, it seems at least sixty years old. The photo that was once inside is gone."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "cecillia_locket1" //Keep as one, to indicate glass.
	item_state = "cecillia_locket1"
	item_color = "cecillia_locket1"
	slots = 1

/obj/item/weapon/reagent_containers/pill/cecillia_pill
	name = "Cici's moonshine pill"
	desc = "Smells of home-made remedies."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("space_drugs", 5)
		reagents.add_reagent("paroxetine", 5)

/obj/item/clothing/tie/storage/fluff/cecillia_locket/New()
		..()
		new /obj/item/weapon/reagent_containers/pill/cecillia_pill(hold)
		return

/obj/item/weapon/storage/backpack/satchel/fluff/cecillia_satchel //Satchel-bag - Cecillia Lambert - casperf1 - SPRITE
	name = "satchel-bag"
	desc = "This looks old, is not yours and if you're wearing it, the original owner is probably dead."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "cecillia_satchel"
	item_state = "cecillia_satchel"

/obj/item/clothing/glasses/regular/fluff/cecillia_glasses //Red prescription glasses - Cecillia Lamber - casperf1 - DONE
	name = "red prescription glasses"
	desc = "These glasses have been prescribed for a terrible pair of eyes."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "cecillia_glasses"
	item_state = "cecillia_glasses"

/obj/item/clothing/suit/wintercoat/fluff/temple_coat //Red coat - Temple Zorion - deatacita - DONE
	name = "red coat"
	desc = "An old red and black winter-coat, there looks to be spots of dried blood on it."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "temple_coat"
	item_state = "temple_coat"

/obj/item/clothing/shoes/jackboots/fluff/peter_boots //Worn boots - Peter Thrushwood - farcry11 - DONE
	name = "worn boots"
	desc = "A worn pair of combat boots. They look walked-around in."

/obj/item/clothing/gloves/brown/fluff/peter_gloves //Cropped driving hloves - Peter Thrushwood - farcry11 - DONE
	name = "cropped driving gloves"
	desc = "A pair of high quality, fingerless driving gloves made of faux leather and faux velvet-leathern without and velvet within."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "peter_gloves"
	item_state = "peter_gloves"
	clipped = 1

/obj/item/clothing/under/fluff/peter_shirt //Plaid shirt - Peter Thrushwood - farcry11 - SPRITE
	name = "plaid shirt"
	desc = "A worn and rugged looking plaid button-up overshirt. The initials 'P.T.' are scrawled in pen on the neck tag."
	icon_state = "sl_suit"
	item_state = "sl_suit"
	item_color = "sl_suit"

/obj/item/clothing/head/det_hat/fluff/leo_hat //Tagged brown hat - Leo Wyatt - keinto - DONE
	name = "tagged brown hat"
	desc = "A worn mid 20th century brown hat. If you look closely at the back, you can see a an embedded tag from the 'Museum of Terran Culture and Technology'."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "leo_hat"
	item_state = "leo_hat"

/obj/item/clothing/suit/storage/det_suit/fluff/leo_coat //Tagged brown coat - Leo Wyatt - keinto - DONE
	name = "tagged brown coat"
	desc = "A worn mid 20th century brown trenchcoat. If you look closely at bottom of the back, you can see an embedded tag from the 'Museum of Terran Culture and Technology'."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "leo_coat"
	item_state = "leo_coat"

/obj/item/device/modkit/fluff/leo_modkit //Weapon case - Leo Wyatt - keinto - DONE
	name = "weapon case"
	desc = "A sturdy leather case, with a velvet covered interior.."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "leo_mod"
	parts = MODKIT_HELMET
	from_helmet = list(/obj/item/weapon/gun/projectile/detective/semiauto)
	to_helmet = list(/obj/item/weapon/gun/projectile/detective/semiauto/fluff/leo_gun)

/obj/item/weapon/gun/projectile/detective/semiauto/fluff/leo_gun //Instant Prosecutor - Leo Wyatt - keinto - DONE (stab)
	name = "\improper Instant Prosecutor"
	desc = "An original Colt 1911 pistol. Slightly worn on the edges, this gun has its name embedded on the side."

/obj/item/weapon/bikehorn/rubberducky/fluff/bryce_ducky //Sir Duckens - Bryce Hunt - mrmajestic - DONE
	name = "Sir Duckens"
	desc = "A important and manly looking duck. He adorns a official looking cap and sunglasses. The hair on the back of your neck tingles as you look at it."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "bryce_duck"

/obj/item/weapon/reagent_containers/food/drinks/fluff/bryce_mug //duck mug - Bryce Hunt - mrmajestic - DONE
	name = "\improper duck mug"
	desc = "A fashionable and reasonably large mug filled with a delicious smelling coffee drink. The mug adorns what looks to be a rubber duck."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "bryce_mug"
	volume = 30

/obj/item/clothing/gloves/black/fluff/lily_gloves //fitted gloves - Lily Has're - meowykins - DONE
	name = "fitted gloves"
	desc = "A pair of gloves, modified for non-human use. They're a sleek quality, made from lambskin."
	attack_verb = list("caressed")
	species_restricted = list("exclude","human")

/obj/item/weapon/storage/belt/utility/fluff/fortune_belt //Fortune's toolbelt - Fortune Bloise - swat43 - DONE
	name = "Fortune's toolbelt"
	desc = "'Nothing can beat the mechanic when you have this badboy with you,' small text on the belts side is written."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "fortune_belt"
	item_state = "fortune_belt"

/obj/item/weapon/storage/backpack/satchel/fluff/fortune_bag //Fortune's bag - Fortune Bloise - swat43 - DONE
	name = "Fortune's bag"
	desc = "'For the wolf to survive, he needs to chop off his own leg' - Fortunes friends. A nice black satchel with a mech and a heart painting on it."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "fortune_bag"
	item_state = "fortune_bag"

/obj/item/clothing/head/soft/fluff/mike_hat //BRI Hat - Mike Axel - Smifboy78 - DONE
	name = "BRI Hat"
	desc = "A black hat. It has the letters 'BRI' on the front."
	icon_state = "corpsoft"
	item_color = "corp"

/obj/item/toy/teddy/fluff/jenifer_bear //Doctor SnuggleBuns - Jenifer Clewett - bluesp34r - SPRITE
	name = "Doctor SnuggleBuns"
	desc = "A fluffy-wuffy brown teddy bear! This one is wearing a blue lab coat, much like a Chief Medical Officer!"
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "jenifer_bear"

/obj/item/toy/fluff/jenifer_bear_head
	name = "\improper teddybear head"
	desc = "The head of a brown teddy, cruelly torn from its original body. You can see stuffing fall out of it."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "jenifer_bear_head"
	w_class = 1
	force = 1
	throwforce = 1

/obj/item/clothing/mask/muzzle/fluff/summer_jaws // Metal Jaw - Summer Floyd - Hivefleetchicken - DONE
	name = "metal jaw"
	desc = "A heavy-looking hunk of steel fused with the mouth and vocal chords of anyone unfortunate enough to have to wear it. It looks like a rather poor replacement for a mouth."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "summer_jaws"
	item_state = "summer_jaws"
	w_class = 2.0
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_MASK
	var/spamcheck = 0

	verb/jaws()
		set name = "Speak"
		set category = "Object"
		set src in usr

		if (usr.client)
			if(usr.client.prefs.muted & MUTE_IC)
				src << "\red You cannot speak in IC (muted)."
				return
		if(!ishuman(usr))
			usr << "\red You don't know how to use this!"
			return
		if(spamcheck)
			usr << "\red Your jaws hurt!"
			return

		var/message = copytext(sanitize(input(usr, "Speak?", "Moving your mouth", null)  as text),1,MAX_MESSAGE_LEN)
		if(!message)
			return
//		message = whisper(message)
		if ((src.loc == usr && usr.stat == 0))
			for(var/mob/O in (viewers(usr)))
				O.show_message("<B>[usr]</B>'s jaws croak out, \"[message]\"",2) // 2 stands for hearable message

			spamcheck = 1
			spawn(20)
				spamcheck = 0
			return
/datum/job/intern
	title = "Intern"
	flag = INTERN
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	alt_titles = list("Engineering Apprentice","Nursing Intern","Lab Assistant","Security Cadet")

/datum/job/intern/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	if(H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Engineering Apprentice")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/engineer(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/hardhat(H), slot_head)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_eng(H), slot_l_ear)
			if("Nursing Intern")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/medical(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_med(H), slot_l_ear)
			if("Lab Assistant")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_l_ear)
			if("Security Cadet")
				H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/security2(H), slot_w_uniform)
				H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
				H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/under/color/white(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset(H), slot_l_ear)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1

/datum/job/intern/get_access(var/mob/living/carbon/human/H)
	if(H.mind.role_alt_title)
		switch(H.mind.role_alt_title)
			if("Engineering Apprentice")
				return list(access_engine, access_maint_tunnels, access_construction)
			if("Nursing Intern")
				return list(access_medical, access_surgery)
			if("Lab Assistant")
				return list(access_research, access_robotics)
			if("Security Cadet")
				return list(access_security, access_sec_doors, access_maint_tunnels)
	else
		return list()
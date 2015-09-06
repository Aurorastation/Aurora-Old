/client/proc/spawn_duty_officer()
	set category = "Special Verbs"
	set name = "Spawn Duty Officer"
	set desc = "Spawns a Duty Officer to do Duty"

	if(!check_rights(R_DUTYOFF))	return

	if(!holder)
		return //how did they get here?

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "\red The game hasn't started yet!"
		return

	if(istype(mob, /mob/new_player))
		src << "\red You can't be in the lobby to join as a duty officer"
		return

	if(mob.mind && mob.mind.special_role == "Duty Officer")
		src << "\red You are already a Duty Officer"
		verbs += /client/proc/returntobody
		return

	var/wasLiving = 0
	if(istype(mob, /mob/living))
		holder.original_mob = mob
		wasLiving = 1

	for (var/obj/effect/landmark/L in landmarks_list)
		if(L.name == "DutyOfficer")
			var/new_name = input(usr, "Pick a name","Name") as null|text
			var/mob/living/carbon/human/M = new(null)

			var/new_facial = input("Please select facial hair color.", "Character Generation") as color
			if(new_facial)
				M.r_facial = hex2num(copytext(new_facial, 2, 4))
				M.g_facial = hex2num(copytext(new_facial, 4, 6))
				M.b_facial = hex2num(copytext(new_facial, 6, 8))

			var/new_hair = input("Please select hair color.", "Character Generation") as color
			if(new_facial)
				M.r_hair = hex2num(copytext(new_hair, 2, 4))
				M.g_hair = hex2num(copytext(new_hair, 4, 6))
				M.b_hair = hex2num(copytext(new_hair, 6, 8))

			var/new_eyes = input("Please select eye color.", "Character Generation") as color
			if(new_eyes)
				M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
				M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
				M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

			var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as text

			if (!new_tone)
				new_tone = 35
			M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
			M.s_tone =  -M.s_tone + 35

			// hair
			var/list/all_hairs = typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair
			var/list/hairs = list()

			// loop through potential hairs
			for(var/x in all_hairs)
				var/datum/sprite_accessory/hair/H = new x
				hairs.Add(H.name)
				del(H)
			//hair
			var/new_hstyle = input(usr, "Select a hair style", "Grooming")  as null|anything in hair_styles_list
			if(new_hstyle)
				M.h_style = new_hstyle

			// facial hair
			var/new_fstyle = input(usr, "Select a facial hair style", "Grooming")  as null|anything in facial_hair_styles_list
			if(new_fstyle)
				M.f_style = new_fstyle

			var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
			if (new_gender)
				if(new_gender == "Male")
					M.gender = MALE
				else
					M.gender = FEMALE
			//M.rebuild_appearance()
			M.update_hair()
			M.update_body()
			M.check_dna(M)

			M.real_name = new_name
			M.name = new_name
			M.age = input("Enter your characters age:","Num") as null|num
			if(!M.age)
				M.age = rand(35,50)
			if(M.age < 33 || M.age > 60)
				src << "\red The age you selected was not in a valid range for a Duty Officer"
				if(M.age < 33)
					M.age = 33
				else
					M.age = 60
				src << "\red Your age has been set to [M.age]"

			M.dna.ready_dna(M)

			//Creates mind stuff.
			M.mind = new
			M.mind.current = M
			M.mind.original = M
			if(wasLiving)
				M.mind.admin_mob_placeholder = mob
			M.mind.assigned_role = "Central Command Duty Officer"
			M.mind.special_role = "Duty Officer"
			M.loc = L.loc
			M.key = key

			if(wasLiving)
				clearDutyJob(holder.original_mob)
				spawn(1)
					holder.original_mob.key = "@[key]"

			M.equip_if_possible(new /obj/item/clothing/under/rank/centcom/officer(M), slot_w_uniform)
			M.equip_if_possible(new /obj/item/clothing/shoes/centcom(M), slot_shoes)
			M.equip_if_possible(new /obj/item/clothing/gloves/white(M), slot_gloves)
			M.equip_if_possible(new /obj/item/device/radio/headset/ert(M), slot_l_ear)
			M.equip_if_possible(new /obj/item/clothing/glasses/sunglasses/sechud(M), slot_glasses)
			M.equip_if_possible(new /obj/item/clothing/head/beret/centcom/officer(M), slot_head)
			M.equip_if_possible(new /obj/item/weapon/reagent_containers/spray/pepper(M), slot_l_store)
			M.equip_if_possible(new /obj/item/device/taperecorder/duty_officer(M), slot_r_store)

			var/obj/item/weapon/storage/backpack/satchel/bag = new(M)
			bag.name = "officer's leather satchel"
			bag.desc = "A well cared for leather satchel for Nanotrasen officers."
			M.equip_if_possible(bag, slot_back)
			if(M.backbag == 1)
				M.equip_to_slot_or_del(new /obj/item/weapon/stamp/centcomm(M.back), slot_in_backpack)

			var /obj/item/weapon/storage/lockbox/lockbox = new(M)
			lockbox.req_access = list(access_cent_captain)
			lockbox.name = "A Duty Officer briefcase"
			lockbox.desc = "A smart looking briefcase with a NT logo on the side"
			lockbox.storage_slots = 8
			lockbox.max_combined_w_class = 16
			M.equip_if_possible(lockbox, slot_l_hand)

			var/obj/item/device/pda/central/pda = new(M)
			pda.owner = M.real_name
			pda.ownjob = "Central Command Duty Officer"
			pda.name = "PDA-[M.real_name] ([pda.ownjob])"

			M.equip_if_possible(pda, slot_belt)

			//Implant because access
			var/obj/item/weapon/implant/loyalty/imp = new/obj/item/weapon/implant/loyalty(M)
			imp.imp_in = M
			imp.implanted = 1
			var/datum/organ/external/affected = M.organs_by_name["head"]
			affected.implants += imp
			imp.part = affected

			var/obj/item/weapon/card/id/W = new(M)
			W.name = "[M.real_name]'s ID Card"
			W.icon_state = "centcom"
			W.item_state = "id_inv"
			W.access = get_all_accesses() + get_centcom_access("Duty Officer")
			W.assignment = "Central Command Duty Officer"
			W.registered_name = M.real_name
			M.equip_if_possible(W, slot_wear_id)

			verbs += /client/proc/returntobody
			break

/client/proc/returntobody()
	set name = "Return to mob"
	set desc = "The Duty is done, return to your original mob"
	set category = "Special Verbs"

	if(!check_rights(0))		return

	if(!mob.mind || mob.mind.special_role != "Duty Officer")
		verbs -= /client/proc/returntobody
		return

	if(!holder)		return

	var/mob/M = mob
	var/area/A = get_area(M)

	if(M.stat == DEAD)
		if(holder.original_mob)
			if(holder.original_mob.client)
				if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
					M.mind.special_role = null
					mob.ghostize(1)
					return
				else
					return
			holder.original_mob.key = key
			holder.original_mob = null
			return
		M.mind.special_role = null
		mob.ghostize(1)
		return

	if(!is_type_in_list(A,centcom_areas))
		src << "\red You need to be back at central to do this"
		return

	if(holder.original_mob)
		if(holder.original_mob == M)
			verbs -= /client/proc/returntobody
			return

		if(holder.original_mob.client)
			if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
				M.mind.special_role = null
				mob.ghostize(0)
			else
				return
		else
			holder.original_mob.key = key

		holder.original_mob = null
	else
		if(mob.mind.admin_mob_placeholder)
			if(mob.mind.admin_mob_placeholder.client)
				if(alert(src, "There is someone else in your old body.\nWould you like to ghost instead?", "There is someone else in your old body, you will be ghosted", "Yes", "No") == "Yes")
					M.mind.special_role = null
					mob.ghostize(0)
				else
					return
			else
				mob.mind.admin_mob_placeholder.key = key
			M.mind.admin_mob_placeholder = null
		else
			M.mind.special_role = null
			mob.ghostize(0)
	verbs -= /client/proc/returntobody
	del(M)

/proc/clearDutyJob(var/mob/living/carbon/human/M)
	spawn(9000)
		if(!M.client)
			var/oldjob = M.mind.assigned_role
			job_master.FreeRole(oldjob)
	return

/*
 *
 *New proc, SQL based, for custom item spawning starts here.
 *
 */

/proc/EquipCustomItems(mob/living/carbon/human/M)
	establish_db_connection()
	if(!dbcon.IsConnected())
		error("Custom item check failed: unable to connect to database.")
		return

	var/ckeyl = sanitizeSQL(M.ckey)
	var/DBQuery/query = dbcon.NewQuery("SELECT item, job, real_name FROM ss13_customitems WHERE ckey='[ckeyl]'")
	query.Execute()

	while(query.NextRow())
		var/path = query.item[1]
		var/jobs = query.item[2]
		var/char = query.item[3]

		if(char == M.real_name)
			path = trim(path)
			path = text2path(path)
			var/obj/item/Item = new path()
			var/ok = 0

			//ERT fluff items are speshul, K? K.
			//Because they use the jobs var for data carrying, they get to be made before a job check
			if(istype(Item,/obj/item/clothing/tie/ert_dogtags))
				var/obj/item/clothing/tie/ert_dogtags/I = Item
				var/datas = text2list(jobs, ",")
				I.rank = datas[1]
				I.surname = datas[2]
				I.spec = datas[3]
				I.desc = "[datas[1]] [datas[2]] - [datas[3]]"
				jobs = null
			if(istype(Item,/obj/item/clothing/suit/storage/ert))
				var/obj/item/clothing/suit/storage/ert/I = Item
				var/datas = text2list(jobs, ",")
				I.desc = "A militaristic duty jacket worn by members of the NanoTrasen Emergency Response Teams. The nameplate reads: [datas[1]] [datas[2]]."
				jobs = null

			//Job restriction check.
			if(jobs)
				jobs = text2list(jobs, ",")
				if(!M.mind.role_alt_title in jobs)
					del(Item)
					ok = 1
					continue

			//A place, where we have things that control item replacement and so on.
			if(istype(Item,/obj/item/device/radio/headset/))
				var/obj/item/device/radio/headset/I = Item
				for(var/obj/item/device/radio/headset/A in M)
					I.keyslot1 = A.keyslot1
					I.keyslot2 = A.keyslot2
					del(A)
					ok = M.equip_if_possible(I, slot_l_ear, 0)
					break
				I.recalculateChannels()
			else if(istype(Item,/obj/item/clothing/glasses/))
				var/obj/item/clothing/glasses/I = Item
				for(var/obj/item/clothing/glasses/A in M)
					del(A)
					M.glasses = null
					break
				ok = M.equip_if_possible(I, slot_glasses, 0)

			if(ok == 0)
				if(istype(M.back,/obj/item/weapon/storage) && M.back:contents.len < M.back:storage_slots) // Try to place it in something on the mob's back
					Item.loc = M.back
					ok = 1
					continue
				else if(ok == 0)
					for(var/obj/item/weapon/storage/S in M.contents) // Try to place it in any item that can store stuff, on the mob.
						if (S.contents.len < S.storage_slots)
							Item.loc = S
							ok = 1
							continue
				else if(ok == 0)// Finally, since everything else failed, place it on the ground
					Item.loc = get_turf(M.loc)

/*
 *Old procs for custom items start here
 *Includes list creation and spawn management
 *

/var/list/custom_items = list()

/hook/startup/proc/loadCustomItems()
	var/custom_items_file = file2text("config/custom_items.txt")
	custom_items = text2list(custom_items_file, "\n")
	return 1

proc/EquipCustomItems(mob/living/carbon/human/M)
	for(var/line in custom_items)
		// split & clean up
		var/list/Entry = text2list(line, ":")
		for(var/i = 1 to Entry.len)
			Entry[i] = trim(Entry[i])

		if(Entry.len < 3)
			continue;

		if(Entry[1] == M.ckey && Entry[2] == M.real_name)
			var/list/Paths = text2list(Entry[3], ",")
			for(var/P in Paths)
				var/ok = 0  // 1 if the item was placed successfully
				P = trim(P)
				var/path = text2path(P)
				if(!path) continue

				var/obj/item/Item = new path()
				if(istype(Item,/obj/item/weapon/card/id))
					//id card needs to replace the original ID
					if(M.ckey == "nerezza" && M.real_name == "Asher Spock" && M.mind.role_alt_title && M.mind.role_alt_title != "Emergency Physician")
						//only spawn ID if asher is joining as an emergency physician
						ok = 1
						del(Item)
						goto skip
					var/obj/item/weapon/card/id/I = Item
					for(var/obj/item/weapon/card/id/C in M)
						//default settings
						I.name = "[M.real_name]'s ID Card ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"
						I.registered_name = M.real_name
						I.access = C.access
						I.assignment = C.assignment
						I.blood_type = C.blood_type
						I.dna_hash = C.dna_hash
						I.fingerprint_hash = C.fingerprint_hash
						//I.pin = C.pin

/*						//custom stuff
						if(M.ckey == "fastler" && M.real_name == "Fastler Greay") //This is a Lifetime ID
							I.name = "[M.real_name]'s Lifetime ID Card ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"
						else if(M.ckey == "nerezza" && M.real_name == "Asher Spock") //This is an Odysseus Specialist ID
							I.name = "[M.real_name]'s Odysseus Specialist ID Card ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"
							I.access += list(access_robotics) //Station-based mecha pilots need this to access the recharge bay.
						else if(M.ckey == "roaper" && M.real_name == "Ian Colm") //This is a Technician ID
							I.name = "[M.real_name]'s Technician ID ([M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role])"
*/
						//replace old ID
						del(C)
						ok = M.equip_if_possible(I, slot_wear_id, 0)	//if 1, last argument deletes on fail
						break
/*				else if(istype(Item,/obj/item/weapon/storage/belt))
					if(M.ckey == "jakksergal" && M.real_name == "Nashi Ra'hal" && M.mind.role_alt_title && M.mind.role_alt_title != "Nurse" && M.mind.role_alt_title != "Chemist")
						ok = 1
						del(Item)
						goto skip
					var/obj/item/weapon/storage/belt/medical/fluff/nashi_belt/I = Item
					if(istype(M.belt,/obj/item/weapon/storage/belt))
						for(var/obj/item/weapon/storage/belt/B in M)
							del(B)
							M.belt=null
						ok = M.equip_if_possible(I, slot_belt, 0)
						break
					if(istype(M.belt,/obj/item/device/pda))
						for(var/obj/item/device/pda/Pda in M)
							M.belt=null
							M.equip_if_possible(Pda, slot_l_store, 0)
						ok = M.equip_if_possible(I, slot_belt, 0)*/
				else if(istype(Item,/obj/item/clothing/glasses))
					if(M.ckey == "casperf1" && M.real_name == "Cecillia Lambert")
						ok = 1
						del(Item)
						goto skip
					var/obj/item/clothing/glasses/regular/fluff/cecillia_glasses/I = Item
					if(istype(M.glasses,/obj/item/clothing/glasses))
						for(var/obj/item/clothing/glasses/B in M)
							del(B)
							M.glasses=null
						ok = M.equip_if_possible(I, slot_glasses, 0)
/*				else if(istype(Item,/obj/item/device/pda))
					if(M.ckey == "meowykins" && M.real_name == "Miyako Yukimura")
						ok = 1
						del(Item)
						goto skip
					var/obj/item/device/pda/fluff/meowykins_pda/I = Item
					if(istype(M.belt,/obj/item/device/pda))
						for(var/obj/item/device/pda/B in M)
							del(B)
							M.belt=null
						ok = M.equip_if_possible(I, slot_belt,0)
					if(istype(M.l_store,/obj/item/device/pda))
						for(var/obj/item/device/pda/B in M)
							del(B)
							M.l_store=null
						ok = M.equip_if_possible(I, slot_l_store,0)*/
				else if(istype(M.back,/obj/item/weapon/storage) && M.back:contents.len < M.back:storage_slots) // Try to place it in something on the mob's back
					Item.loc = M.back
					ok = 1

				else
					for(var/obj/item/weapon/storage/S in M.contents) // Try to place it in any item that can store stuff, on the mob.
						if (S.contents.len < S.storage_slots)
							Item.loc = S
							ok = 1
							break

				skip:
				if (ok == 0) // Finally, since everything else failed, place it on the ground
					Item.loc = get_turf(M.loc)*/
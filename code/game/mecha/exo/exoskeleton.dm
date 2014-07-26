/obj/mecha/combat/exoskeleton
	name = "Exoskeleton Mk. I"
	desc = "A prototype currently in development for special response and other purposes."
	icon_state = "exosuit" // need this
	initial_icon = "exosuit" // need this
	step_in = 2
	max_temperature = 7000 // DON'T FORGET TO TEST THIS
	health = 200
//	wreckage =  /obj/effect/decal/mecha_wreckage/exoskeleton
	internal_damage_threshold = 35
	deflect_chance = 25
	step_energy_drain = 4
	var/obj/item/clothing/glasses/hud/security/mech/hud
	max_equip = 3

	New()
		..()
		hud = new /obj/item/clothing/glasses/hud/security/mech(src)
		return

	moved_inside(var/mob/living/carbon/human/H as mob)
		if(..())
			if(H.glasses)
				occupant_message("<font color='red'>[H.glasses] prevent you from using [src] [hud]</font>")
			else
				H.glasses = hud
			return 1
		else
			return 0

	go_out()
		if(ishuman(occupant))
			var/mob/living/carbon/human/H = occupant
			if(H.glasses == hud)
				H.glasses = null
		..()
		return

/obj/item/clothing/glasses/hud/security/mech
	name = "Integrated Security Hud"

/obj/item/clothing/glasses/hud/security/mech/process_hud(var/mob/M)
	if(!M)	return
	if(!M.client)	return
	var/client/C = M.client
	var/image/holder
	for(var/mob/living/carbon/human/perp in view(get_turf(M)))
		if(M.see_invisible < perp.invisibility)
			continue
		if(!C) continue
		var/perpname = perp.name
		holder = perp.hud_list[ID_HUD]
		if(perp.wear_id)
			var/obj/item/weapon/card/id/I = perp.wear_id.GetID()
			if(I)
				perpname = I.registered_name
				holder.icon_state = "hud[ckey(I.GetJobName())]"
				C.images += holder
			else
				perpname = perp.name
				holder.icon_state = "hudunknown"
				C.images += holder
		else
			perpname = perp.name
			holder.icon_state = "hudunknown"
			C.images += holder

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				holder = perp.hud_list[WANTED_HUD]
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						C.images += holder
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						C.images += holder
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						C.images += holder
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
						holder.icon_state = "hudreleased"
						C.images += holder
						break
		for(var/obj/item/weapon/implant/I in perp)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/tracking))
					holder = perp.hud_list[IMPTRACK_HUD]
					holder.icon_state = "hud_imp_tracking"
					C.images += holder
				if(istype(I,/obj/item/weapon/implant/loyalty))
					holder = perp.hud_list[IMPLOYAL_HUD]
					holder.icon_state = "hud_imp_loyal"
					C.images += holder
				if(istype(I,/obj/item/weapon/implant/chem))
					holder = perp.hud_list[IMPCHEM_HUD]
					holder.icon_state = "hud_imp_chem"
					C.images += holder

/*/obj/mecha/exoskeleton/exoskeleton/melee_action(target as obj|mob|turf)
	force = 30
	var/melee_cooldown2 = 10
	var/melee_can_hit2 = 1
//	var/list/destroyable_obj = list(/obj/mecha, /obj/structure/window, /obj/structure/grille, /turf/simulated/wall)
	internal_damage_threshold = 50
	maint_access = 0
	//add_req_access = 0
	//operation_req_access = list(access_hos)
	damage_absorption = list("brute"=0.7,"fire"=1,"bullet"=0.7,"laser"=0.85,"energy"=1,"bomb"=0.8)

	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = safepick(oview(1,src))
	if(!melee_can_hit2 || !istype(target, /atom)) return
	if(istype(target, /mob/living))
		var/mob/living/M = target
		if(src.occupant.a_intent == "hurt")
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			if(damtype == "brute")
				step_away(M,src,15)
			/*
			if(M.stat>1)
				M.gib()
				melee_can_hit = 0
				if(do_after(melee_cooldown))
					melee_can_hit = 1
				return
			*/
			if(istype(target, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = target
	//			if (M.health <= 0) return

				var/datum/organ/external/temp = H.get_organ(pick("chest", "chest", "chest", "head"))
				if(temp)
					var/update = 0
					switch(damtype)
						if("brute")
							H.Paralyse(1)
							update |= temp.take_damage(rand(force/2, force), 0)
						if("fire")
							update |= temp.take_damage(0, rand(force/2, force))
						if("tox")
							if(H.reagents)
								if(H.reagents.get_reagent_amount("carpotoxin") + force < force*2)
									H.reagents.add_reagent("carpotoxin", force)
								if(H.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
									H.reagents.add_reagent("cryptobiolin", force)
						else
							return
					if(update)	H.UpdateDamageIcon()
				H.updatehealth()

			else
				switch(damtype)
					if("brute")
						M.Paralyse(1)
						M.take_overall_damage(rand(force/2, force))
					if("fire")
						M.take_overall_damage(0, rand(force/2, force))
					if("tox")
						if(M.reagents)
							if(M.reagents.get_reagent_amount("carpotoxin") + force < force*2)
								M.reagents.add_reagent("carpotoxin", force)
							if(M.reagents.get_reagent_amount("cryptobiolin") + force < force*2)
								M.reagents.add_reagent("cryptobiolin", force)
					else
						return
				M.updatehealth()
			src.occupant_message("You hit [target].")
			src.visible_message("<font color='red'><b>[src.name] hits [target].</b></font>")
		else
			step_away(M,src)
			src.occupant_message("You push [target] out of the way.")
			src.visible_message("[src] pushes [target] out of the way.")

		melee_can_hit2 = 0
		if(do_after(melee_cooldown2))
			melee_can_hit2 = 1
		return

/*	else
		if(damtype == "brute")
			for(var/target_type in src.destroyable_obj)
				if(istype(target, target_type) && hascall(target, "attackby"))
					src.occupant_message("You hit [target].")
					src.visible_message("<font color='red'><b>[src.name] hits [target] for no damage.</b></font>")
					if(!istype(target, /turf/simulated/wall))
						target:attackby(src,src.occupant)
/*					else if(prob(5))
						target:dismantle_wall(1)
						src.occupant_message("\blue You smash through the wall.")
						src.visible_message("<b>[src.name] smashes through the wall</b>")
						playsound(src, 'sound/weapons/smash.ogg', 50, 1)*/
					melee_can_hit2 = 0
					if(do_after(melee_cooldown2))
						melee_can_hit2 = 1
					break
	return */ */
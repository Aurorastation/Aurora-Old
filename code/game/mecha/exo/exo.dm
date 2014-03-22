/obj/mecha/exoskeleton/exoskeletonother
	name = "Exo"
	desc = "Exoing Exo"
	icon_state = "ripley" // need this
	initial_icon = "ripley" // need this
	step_in = 2
	max_temperature = 20000 // DON'T FORGET TO TEST THIS
	health = 300
	wreckage =  /obj/effect/decal/mecha_wreckage/ripley
	internal_damage_threshold = 25
	deflect_chance = 50
	step_energy_drain = 8
	var/obj/item/clothing/glasses/hud/security/mech/hud

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
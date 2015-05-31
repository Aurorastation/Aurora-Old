
//todo
/datum/artifact_effect/cellcharge
	effecttype = "cellcharge"
	effect_type = 3

/datum/artifact_effect/cellcharge/DoEffectTouch(var/mob/user)
	if(user)
		if(istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			for (var/obj/item/weapon/cell/D in R.contents)
				D.charge += rand() * 100 + 50
				R << "\blue SYSTEM ALERT: Large energy boost detected!"
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species.flags & IS_SYNTHETIC)
				H.nutrition += rand() * 100 + 50
				H << "\blue Your batteries gain a quick boost of energy!"
		return 1

/datum/artifact_effect/cellcharge/DoEffectAura()
	if(holder)
		for (var/obj/machinery/power/apc/C in range(200, holder))
			for (var/obj/item/weapon/cell/B in C.contents)
				B.charge += 25
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 25
		for (var/mob/living/silicon/robot/M in mob_list)
			for (var/obj/item/weapon/cell/D in M.contents)
				D.charge += 25
				M << "\blue SYSTEM ALERT: Energy boost detected!"
		for (var/mob/living/carbon/human/H in range(effectrange,holder))
			if(H.species.flags & IS_SYNTHETIC)
				H.nutrition += 25
				H << "\blue Your batteries gain a quick boost of energy!"
		return 1

/datum/artifact_effect/cellcharge/DoEffectPulse()
	if(holder)
		for (var/obj/machinery/power/apc/C in range(200, holder))
			for (var/obj/item/weapon/cell/B in C.contents)
				B.charge += rand() * 100
		for (var/obj/machinery/power/smes/S in range (src.effectrange,src))
			S.charge += 250
		for (var/mob/living/silicon/robot/M in mob_list)
			for (var/obj/item/weapon/cell/D in M.contents)
				D.charge += rand() * 100
				M << "\blue SYSTEM ALERT: Energy boost detected!"
		for (var/mob/living/carbon/human/H in range(effectrange,holder))
			if(H.species.flags & IS_SYNTHETIC)
				H.nutrition += rand() * 100
				H << "\blue Your batteries gain a quick boost of energy!"
		return 1

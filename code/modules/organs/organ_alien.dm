//DIONA ORGANS.
/datum/organ/internal/diona
	removed_type = /obj/item/organ/diona

/datum/organ/internal/diona/process()
	return

/datum/organ/internal/diona/strata
	name = "neural strata"
	parent_organ = "chest"

/datum/organ/internal/diona/bladder
	name = "gas bladder"
	parent_organ = "head"

/datum/organ/internal/diona/polyp
	name = "polyp segment"
	parent_organ = "groin"

/datum/organ/internal/diona/ligament
	name = "anchoring ligament"
	parent_organ = "groin"

/datum/organ/internal/diona/node
	name = "receptor node"
	parent_organ = "head"
	removed_type = /obj/item/organ/diona/node

/datum/organ/internal/diona/nutrients
	name = "nutrient vessel"
	parent_organ = "chest"
	removed_type = /obj/item/organ/diona/nutrients

/obj/item/organ/diona
	name = "diona nymph"
	icon = 'icons/obj/objects.dmi'
	icon_state = "nymph"
	organ_tag = "special" // Turns into a nymph instantly, no transplanting possible.

/obj/item/organ/diona/removed(var/mob/living/target,var/mob/living/user)

	..()
	var/mob/living/carbon/human/H = target
	if(!istype(target))
		del(src)

	if(!H.internal_organs.len)
		H.death()

	//This is a terrible hack and I should be ashamed.
	var/datum/seed/diona = seed_types["diona"]
	if(!diona)
		del(src)

	spawn(1) // So it has time to be thrown about by the gib() proc.
		var/mob/living/carbon/monkey/diona/D = new(get_turf(src))
		diona.request_player(D)
		del(src)

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/diona/nutrients
	name = "nutrient vessel"
	organ_tag = "nutrient vessel"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/diona/nutrients/removed()
	return

/obj/item/organ/diona/node
	name = "receptor node"
	organ_tag = "receptor node"
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/organ/diona/node/removed()
	return

//CORTICAL BORER ORGANS.
/datum/organ/internal/borer
	name = "cortical borer"
	parent_organ = "head"
	removed_type = /obj/item/organ/borer
	vital = 1

/datum/organ/internal/borer/process()

	// Borer husks regenerate health, feel no pain, and are resistant to stuns and brainloss.
	for(var/chem in list("tricordrazine","tramadol","hyperzine","alkysine"))
		if(owner.reagents.get_reagent_amount(chem) < 3)
			owner.reagents.add_reagent(chem, 5)

	// They're also super gross and ooze ichor.
	if(prob(5))
		var/mob/living/carbon/human/H = owner
		if(!istype(H))
			return

		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in H.vessel.reagent_list
		blood_splatter(H,B,1)
		var/obj/effect/decal/cleanable/blood/splatter/goo = locate() in get_turf(owner)
		if(goo)
			goo.name = "husk ichor"
			goo.desc = "It's thick and stinks of decay."
			goo.basecolor = "#412464"
			goo.update_icon()

/obj/item/organ/borer
	name = "cortical borer"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borer"
	organ_tag = "brain"
	desc = "A disgusting space slug."

/obj/item/organ/borer/removed(var/mob/living/target,var/mob/living/user)

	..()

	var/mob/living/simple_animal/borer/B = target.has_brain_worms()
	if(B)
		B.leave_host()
		B.ckey = target.ckey

	spawn(0)
		del(src)

//XENOMORPH ORGANS
/datum/organ/internal/xenos/eggsac
	name = "egg sac"
	parent_organ = "groin"
	removed_type = /obj/item/organ/xenos/eggsac

/datum/organ/internal/xenos/plasmavessel
	name = "plasma vessel"
	parent_organ = "chest"
	removed_type = /obj/item/organ/xenos/plasmavessel
	var/stored_plasma = 0
	var/max_plasma = 500

/datum/organ/internal/xenos/plasmavessel/queen
	name = "bloated plasma vessel"
	stored_plasma = 200
	max_plasma = 500

/datum/organ/internal/xenos/plasmavessel/sentinel
	stored_plasma = 100
	max_plasma = 250

/datum/organ/internal/xenos/plasmavessel/hunter
	name = "tiny plasma vessel"
	stored_plasma = 100
	max_plasma = 150

/datum/organ/internal/xenos/acidgland
	name = "acid gland"
	parent_organ = "head"
	removed_type = /obj/item/organ/xenos/acidgland

/datum/organ/internal/xenos/hivenode
	name = "hive node"
	parent_organ = "chest"
	removed_type = /obj/item/organ/xenos/hivenode

/datum/organ/internal/xenos/resinspinner
	name = "resin spinner"
	parent_organ = "head"
	removed_type = /obj/item/organ/xenos/resinspinner

/obj/item/organ/xenos
	name = "xeno organ"
	icon = 'icons/effects/blood.dmi'
	desc = "It smells like an accident in a chemical factory."

/obj/item/organ/xenos/eggsac
	name = "egg sac"
	icon_state = "xgibmid1"
	organ_tag = "egg sac"

/obj/item/organ/xenos/plasmavessel
	name = "plasma vessel"
	icon_state = "xgibdown1"
	organ_tag = "plasma vessel"

/obj/item/organ/xenos/acidgland
	name = "acid gland"
	icon_state = "xgibtorso"
	organ_tag = "acid gland"

/obj/item/organ/xenos/hivenode
	name = "hive node"
	icon_state = "xgibmid2"
	organ_tag = "hive node"

/obj/item/organ/xenos/resinspinner
	name = "hive node"
	icon_state = "xgibmid2"
	organ_tag = "resin spinner"

//VOX ORGANS.
/datum/organ/internal/stack
	name = "cortical stack"
	removed_type = /obj/item/organ/stack
	parent_organ = "head"
	robotic = 2
	vital = 1
	var/backup_time = 0
	var/datum/mind/backup

/datum/organ/internal/stack/process()
	if(owner && owner.stat != 2 && !is_broken())
		backup_time = world.time
		if(owner.mind) backup = owner.mind

/datum/organ/internal/stack/vox
	removed_type = /obj/item/organ/stack/vox

/datum/organ/internal/stack/vox/stack

/obj/item/organ/stack
	name = "cortical stack"
	icon_state = "brain-prosthetic"
	organ_tag = "stack"
	robotic = 2

/obj/item/organ/stack/vox
	name = "vox cortical stack"

/datum/organ/internal/machine
	removed_type = /obj/item/organ/machine

/datum/organ/internal/machine/process()
	return

/datum/organ/internal/machine/radiator
	name = "internal cooling unit"
	parent_organ = "chest"
	robotic = 2
	min_bruised_damage = 15
	min_broken_damage = 40
	removed_type = /obj/item/organ/machine/radiator

/obj/item/organ/machine/radiator
	name = "internal cooling unit"
	icon_state = "radiator"
	organ_tag = "radiator"
	organ_type = /datum/organ/internal/machine/radiator
	robotic = 2

/obj/item/organ/machine/radiator/exposed_to_the_world()
	var/obj/item/robot_parts/robot_component/radiator/Radiator = new(src.loc)
	if(organ_data.damage)
		Radiator.brute = organ_data.damage
	del(src)
	return Radiator

/datum/organ/internal/machine/bladder
	name = "chemical containment"
	parent_organ = "groin"
	robotic = 2
	removed_type = /obj/item/organ/machine/bladder

/datum/organ/internal/machine/bladder/process()
	if(status & ORGAN_CUT_AWAY)
		return

	if(is_bruised())
		var/leakSmall = rand(1,5)
		if(owner.reagents.total_volume > 0)
			owner.reagents.remove_any(leakSmall)
		if(owner.reagents.maximum_volume > 500)
			owner.reagents.maximum_volume -= leakSmall

	if(is_broken())
		var/leakLarge = rand(25,50)
		if(owner.reagents.total_volume > 0)
			owner.reagents.remove_any(leakLarge)
		if(owner.reagents.maximum_volume > 0)
			if(owner.reagents.maximum_volume < leakLarge)
				owner.reagents.maximum_volume = 0
			else
				owner.reagents.maximum_volume -= leakLarge

	if(owner.reagents.reagent_list.len)
		if(owner.reagents.has_reagent("sacid") || owner.reagents.has_reagent("pacid"))
			take_damage(rand(0,2.5), 1)

/obj/item/organ/machine/bladder
	name = "chemical containment"
	icon_state = "bladder"
	organ_tag = "chemical containment"
	organ_type = /datum/organ/internal/machine/bladder
	robotic = 2

/obj/item/organ/machine/bladder/replaced(var/mob/living/carbon/human/target)
	if(istype(target) && (target.species.flags & IS_SYNTHETIC))
		if(target.reagents.maximum_volume < 1000)
			target.reagents.maximum_volume = 1000

	..()

/obj/item/organ/machine/bladder/removed(var/mob/living/target, var/mob/living/user)
	..()

	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/Machine = target
		if(Machine.species.flags & IS_SYNTHETIC)
			Machine.reagents.clear_reagents()
			Machine.reagents.maximum_volume = 0

/obj/item/organ/machine/bladder/exposed_to_the_world()
	var/obj/item/robot_parts/robot_component/bladder/Bladder = new(src.loc)
	if(organ_data.damage)
		Bladder.brute = organ_data.damage
	del(src)
	return Bladder

/datum/organ/internal/machine/diagnosis_unit
	name = "diagnosis unit"
	parent_organ = "head"
	robotic = 2
	removed_type = /obj/item/organ/machine/diagnosis_unit

/obj/item/organ/machine/diagnosis_unit
	name = "diagnosis unit"
	icon_state = "diagnosis_unit"
	organ_tag = "diagnosis unit"
	organ_type = /datum/organ/internal/machine/diagnosis_unit
	robotic = 2

/obj/item/organ/machine/diagnosis_unit/exposed_to_the_world()
	var/obj/item/robot_parts/robot_component/diagnosis_unit/Diagnosis_unit = new(src.loc)
	if(organ_data.damage)
		Diagnosis_unit.brute = organ_data.damage
	del(src)
	return Diagnosis_unit

/obj/item/organ/eyes/robot
	name = "camera"
	organ_tag = "eyes"
	organ_type = /datum/organ/internal/eyes/robot
	robotic = 2

/obj/item/organ/eyes/robot/exposed_to_the_world()
	var/obj/item/robot_parts/robot_component/camera/Eyes = new(src.loc)
	if(organ_data.damage)
		Eyes.brute = organ_data.damage
	del(src)
	return Eyes

/obj/item/organ/vaurca/neuralsocket
    name = "neural socket"
    organ_tag = "neural socket"
    icon = 'icons/mob/alien_organs.dmi'
    icon_state = "neural_socket"

/obj/item/organ/vaurca/neuralsocket/removed()
	return

/obj/item/organ/vaurca/breathingapparatus
    name = "breathing apparatus"
    organ_tag = "breathing apparatus"
    icon = 'icons/mob/alien_organs.dmi'
    icon_state = "breathing_app"

/obj/item/organ/vaurca/breathingapparatus/removed()
	return

/obj/item/organ/vaurca/tracheae
    name = "tracheae"
    organ_tag = "tracheae"
    icon = 'icons/mob/alien_organs.dmi'
    icon_state = "tracheae"
/obj/item/organ/vaurca/tracheae/removed()
	return

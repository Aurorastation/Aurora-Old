

/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 25
	health = 25

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	break_stuff_probability = 2

	faction = "carp"

	var/attackv = "nashes"

/mob/living/simple_animal/hostile/carp/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/FindTarget()
	. = ..()
	if(.)
		custom_emote(1,"[attackv] at [.]")

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

//////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////SPACE RAKK! Or, namely, critters!////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/carp/critter
	name = "winged critter"
	desc = "An apparently winged creature, bat-like in appearance, with sharp teeth and claws."
	icon_state = "critter"
	icon_living = "critter"
	icon_dead = "critter_dead"
	attackv = "swoops"
	
// Holographic carp for the holodeck
	
/mob/living/simple_animal/hostile/carp/hologram
	name = "space carp"
	desc = "A solid light image of a ferocious, fang-bearing creature resembling a fish. It flickers inconsistently but appears to be able to affect solid matter."
	icon_state = "holocarp"
	icon_living = "holocarp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	meat_type = null
	var/datum/effect/effect/system/spark_spread/spark_system // for when they die
	
	
/mob/living/simple_animal/hostile/carp/hologram/New(loc)
	. = ..(loc)
	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	
	
/mob/living/simple_animal/hostile/carp/hologram/death()
	src.spark_system.start() // sparks for holograms! Hurray!
	stat = DEAD
	density = 0
	. = ..()
	src.visible_message("[src] sparks and then flickers out of existence.")
	del(src)
	
	
/mob/living/simple_animal/hostile/carp/hologram/gib()
	return death()
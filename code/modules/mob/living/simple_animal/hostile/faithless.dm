/mob/living/simple_animal/hostile/faithless
	name = "Faithless"
	desc = "The Wish Granter's faith in humanity, incarnate"
	icon_state = "faithless"
	icon_living = "faithless"
	icon_dead = "faithless_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "passes through the"
	response_disarm = "shoves"
	response_harm = "hits the"
	speed = -1
	maxHealth = 80
	health = 80

	harm_intent_damage = 10
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "grips"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4

	faction = "faithless"

/mob/living/simple_animal/hostile/faithless/Process_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/faithless/FindTarget()
	. = ..()
	if(.)
		emote("wails at [.]")

/mob/living/simple_animal/hostile/faithless/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(12))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////Faithless for Skull to use//////////////////////////////////////
/////////////They will lack the /hostile/ parent, meaning, they won't go apeshit////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/faithless
	name = "Faithless"
	desc = "The Wish Granter's faith in humanity, incarnate"
	icon_state = "faithlessold"
	icon_living = "faithlessold"
	icon_dead = "faithlessold_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "passes through the"
	response_disarm = "shoves"
	response_harm = "hits the"
	maxHealth = 200
	health = 200
	universal_speak = 1
	universal_understand = 1
	stop_automated_movement = 1
	wander = 0

	harm_intent_damage = 20
	melee_damage_lower = 20
	melee_damage_upper = 30
	attacktext = "grips"
	attack_sound = 'sound/hallucinations/growl1.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4

/mob/living/simple_animal/faithless/attackby(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
	if(istype(target, /mob/living))
		var/mob/M = target
		M.bodytemperature -= 15 * TEMPERATURE_DAMAGE_COEFFICIENT
	return 1

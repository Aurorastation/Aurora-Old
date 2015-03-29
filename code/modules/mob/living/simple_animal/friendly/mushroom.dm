/mob/living/simple_animal/mushroom
	name = "walking mushroom"
	desc = "It's a massive mushroom... with legs?"
	icon = 'icons/mob/livestock.dmi'
	icon_state = "walkingmushroom"
	icon_living = "walkingmushroom"
	icon_dead = "walkingmushroom_d"
	small = 1
	speak_chance = 0
	turns_per_move = 1
	maxHealth = 5
	health = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "whacks the"
	harm_intent_damage = 5
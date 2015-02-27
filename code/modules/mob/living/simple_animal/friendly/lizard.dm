/mob/living/simple_animal/lizard
	name = "Lizard"
	desc = "A cute tiny lizard."
	icon = 'icons/mob/critter.dmi'
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard-dead"
	small = 1
	speak_emote = list("hisses")
	health = 5
	maxHealth = 5
	attacktext = "bites"
	attacktext = "bites"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	holder_type = /obj/item/weapon/holder/lizard

/mob/living/simple_animal/lizard/MouseDrop(atom/over_object)

	var/mob/living/carbon/H = over_object
	if(!istype(H)) return ..()
	if(in_range(usr, src))
		if(H.a_intent == "help")
			get_scooped(H)
			return

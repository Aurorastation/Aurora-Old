//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0


/obj/structure/mirror/attack_hand(mob/user as mob)
	if(shattered)	return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/userloc = H.loc
		
		var/list/hair_styles = H.valid_hairstyles_for_this_mob()
		var/list/facial_styles = H.valid_facialhairstyles_for_this_mob()
		
		if (facial_styles.len > 1) //handle facial hair (if necessary)
			var/new_style = input(user, "Select a facial hair style", "Grooming")  as null|anything in facial_styles
			if(userloc != H.loc) return	//no tele-grooming
			if(new_style)
				H.f_style = new_style

		//handle normal hair
		if (hair_styles.len)
			var/new_style = input(user, "Select a hair style", "Grooming")  as null|anything in hair_styles
			if(userloc != H.loc) return	//no tele-grooming
			if(new_style)
				H.h_style = new_style
		
		//machines can change their eye colours in the mirror
		if (istype(H.species,/datum/species/machine))
			var/new_eyes = input(user, "Choose your new eye colour.", "Robotic Eyes") as color|null
			if(new_eyes)
				var/list/new_eyes_as_values = htmlcolour_to_values(new_eyes)
				H.r_eyes=new_eyes_as_values[1]
				H.g_eyes=new_eyes_as_values[2]
				H.b_eyes=new_eyes_as_values[3]
				H.update_hair() // need to do a full rebuild here
				H.update_body()
				return 
		H.update_hair()


/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"


/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.damage * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()


/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)


/obj/structure/mirror/attack_alien(mob/user as mob)
	if(islarva(user)) return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()


/obj/structure/mirror/attack_slime(mob/user as mob)
	var/mob/living/carbon/slime/S = user
	if (!S.is_adult)
		return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()
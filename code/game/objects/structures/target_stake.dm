// Basically they are for the firing range
/obj/structure/target_stake
	name = "target stake"
	desc = "A thin platform with negatively-magnetized wheels."
	icon = 'icons/obj/objects.dmi'
	icon_state = "target_stake"
	density = 0
	flags = CONDUCT
	var/obj/item/target/pinned_target // the current pinned target
	var/mob/living/buckled_mob

	Move()
		..()
		// Move the pinned target along with the stake
		if(pinned_target in view(3, src))
			pinned_target.loc = loc

		else // Sanity check: if the pinned target can't be found in immediate view
			pinned_target = null
			density = 0

	attackby(obj/item/W as obj, mob/user as mob)
		// Putting objects on the stake. Most importantly, targets
		if(pinned_target)
			return // Clear the stake first!
		if(buckled_mob)
			return // Clear the stake first!

		if(istype(W, /obj/item/target))
			density = 0
			W.density = 0
			user.drop_item(src)
			W.loc = loc
			W.layer = 3.1
			pinned_target = W
			user << "You slide the target into the stake."
		return

	attack_hand(mob/user as mob)
		// taking pinned targets off!
		if(pinned_target)
			density = 0
			pinned_target.density = 0
			pinned_target.layer = OBJ_LAYER

			pinned_target.loc = user.loc
			if(ishuman(user))
				if(!user.get_active_hand())
					user.put_in_hands(pinned_target)
					user << "You take the target out of the stake."
			else
				pinned_target.loc = get_turf(user)
				user << "You take the target out of the stake."

			pinned_target = null


/obj/structure/target_stake/Del()
	unbuckle()
	..()
	return

/obj/structure/target_stake/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/target_stake/attack_hand(mob/user as mob)
	manual_unbuckle(user)
	return

/obj/structure/target_stake/MouseDrop(atom/over_object)
	return

/obj/structure/target_stake/MouseDrop_T(mob/M as mob, mob/user as mob)
	if(!istype(M)) return
	buckle_mob(M, user)
	return


/obj/structure/target_stake/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			if(!buckled_mob.mob_has_gravity(buckled_mob.loc))
				buckled_mob.float(1)

			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null

	return

/obj/structure/target_stake/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] was unbuckled by [user.name]!",\
					"You were unbuckled from [src] by [user.name].",\
					"You hear metal clanking")
			else
				buckled_mob.visible_message(\
					"\blue [buckled_mob.name] unbuckled \himself!",\
					"You unbuckle yourself from [src].",\
					"You hear metal clanking")
			unbuckle()
			src.add_fingerprint(user)
	return

/obj/structure/target_stake/Move()
	..()
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			buckled_mob.loc = src.loc
		else
			buckled_mob = null

/obj/structure/target_stake/proc/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return
	if(pinned_target)
		return

	if (istype(M, /mob/living/carbon/slime))
		user << "The [M] is too squishy to buckle in."
		return

	unbuckle()

	if (M == usr)
		M.visible_message(\
			"\blue [M.name] buckles in!",\
			"You buckle yourself to [src].",\
			"You hear metal clanking")
	else
		M.visible_message(\
			"\blue [M.name] is buckled in to [src] by [user.name]!",\
			"You are buckled in to [src] by [user.name].",\
			"You hear metal clanking")
	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
//	if(!M.mob_has_gravity(M.loc))
//		M.float(0)
	src.buckled_mob = M
	src.add_fingerprint(user)
	return
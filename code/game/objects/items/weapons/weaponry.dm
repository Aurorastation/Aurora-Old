/obj/item/weapon/banhammer
	desc = "A banhammer"
	name = "banhammer"
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 2.0
	throw_speed = 7
	throw_range = 15
	attack_verb = list("banned")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is hitting \himself with the [src.name]! It looks like \he's trying to ban \himself from life.</b>"
		return (BRUTELOSS|FIRELOSS|TOXLOSS|OXYLOSS)

/obj/item/weapon/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullrod"
	item_state = "nullrod"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 15
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = 2

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/nullrod/attack(mob/M as mob, mob/living/user as mob) //Paste from old-code to decult with a null rod.

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	msg_admin_attack("[key_name_admin(user)] attacked [key_name_admin(M)] with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if (!(istype(user, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
		user << "\red You don't have the dexterity to do this!"
		return

	if ((CLUMSY in user.mutations) && prob(50))
		user << "\red The rod slips out of your hand and hits your head."
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if(M.stat !=2 && ishuman(M))
		var/mob/living/K = M
		if(K.mind in ticker.mode.cult)
			if(K == user)	//Because apparently Doomberg deconverted himself. Wtf.
				return
			user.visible_message("\blue [user] starts trying to captivate [K]'s attention with the [src].", "\blue You begin trying to shed light into [K]'s mind.")
			K.take_overall_damage(0, 10)
			if(do_after(user, 15))
				K.visible_message("\red [user] waves the [src] over [K]'s head, [K]'s look captivated by it.", "\red [user] wave's the [src] over your head. <b>You see a foreign light, asking you to follow it. Its presence burns and blinds.</b>")
				var/choice = alert(K,"Do you want to give up your goal?","Become cleansed","Resist","Give in")
				switch(choice)
					if("Resist")
						K.visible_message("\red The gaze in [K]'s eyes remains determined.", "\blue You turn away from the light, remaining true to your dark lord. The light burns you due to rejection!")
						K.say("*scream")
						K.take_overall_damage(5, 15)
					if("Give in")
						K.visible_message("\blue [K]'s eyes become clearer, the evil gone, but not without leaving scars.")
						K.take_overall_damage(15, 30) //Nur'sie ain't a kind host to turn away from. Suffer.
						ticker.mode.remove_cultist(K.mind, 0)
			else
				user.visible_message("\red [user]'s concentration is broken!", "\red Your concentration is broken! You and your target need to stay uninterrupted for longer!")
				return
		else if(M.mind && M.mind.vampire)
			if(!(VAMP_FULL in M.mind.vampire.powers))
				user << "\red The rod burns cold in your hand, filling you with grim determination.  You feel the creature's power weaken."
				M << "<span class='warning'>The nullrod's power interferes with your own!  They are on to you!</span>"
				M.mind.vampire.nullified = max(8, M.mind.vampire.nullified + 8)
		//..() Ported from readapted vamp null code.  Original seen down there.  This doesn't need to be here since it's in the loops now.
		else
			user << "\red The rod appears to do nothing."
			for(var/mob/O in viewers(M, null))
				O.show_message(text("\red [] waves [] over []'s head.", user, src, M), 1)
			return

/obj/item/weapon/nullrod/afterattack(atom/A, mob/user as mob)
	if (istype(A, /turf/simulated/floor))
		user << "\blue You hit the floor with the [src]."
		call(/obj/effect/rune/proc/revealrunes)(src)

/obj/item/weapon/sord
	name = "\improper SORD"
	desc = "This thing is so unspeakably shitty you are having a hard time even holding it."
	icon_state = "sord"
	item_state = "sord"
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	force = 2
	throwforce = 1
	sharp = 1
	edge = 1
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is impaling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)

/obj/item/weapon/sord/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/claymore
	name = "claymore"
	desc = "What are you standing around staring at this for? Get to killing!"
	icon_state = "claymore"
	item_state = "claymore"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	force = 40
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 4
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	IsShield()
		return 1

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is falling on the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return(BRUTELOSS)

/obj/item/weapon/claymore/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/katana
	name = "katana"
	desc = "Woefully underpowered in D20"
	icon_state = "katana"
	item_state = "katana"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 40
	throwforce = 10
	sharp = 1
	edge = 1
	w_class = 4
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is slitting \his stomach open with the [src.name]! It looks like \he's trying to commit seppuku.</b>"
		return(BRUTELOSS)

/obj/item/weapon/katana/IsShield()
		return 1

/obj/item/weapon/katana/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()

/obj/item/weapon/harpoon
	name = "harpoon"
	sharp = 1
	edge = 0
	desc = "Tharr she blows!"
	icon_state = "harpoon"
	item_state = "harpoon"
	force = 20
	throwforce = 15
	w_class = 3
	attack_verb = list("jabbed","stabbed","ripped")

/obj/item/weapon/canesword
	name = "thin sword"
	sharp = 1
	edge = 1
	desc = "A thin, sharp blade with an elegant handle."
	icon_state = "canesword"
	item_state = "canesword"
	force = 20
	throwforce = 10
	w_class = 4 //there ain't no way in fuck you're shoving this inside your rucksack. No way.
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] brings the blade up to \his throat, and in one rapid motion slits \his throat open!</b>"
		return(BRUTELOSS)

//Using a modified cane, with a storage var, instead of a box. Because the box idea is meh, in terms of the interface.
/obj/item/weapon/cane/syndie
	var/obj/item/weapon/canesword/sword	//For holding the blade
	var/locked	//A small lock, so that you can't accidentally unsheathe it

	New()
		sword = new /obj/item/weapon/canesword()
		locked = 1
		..()

	proc/unsheathe(mob/user as mob)
		if(sword)
			user.put_in_hands(sword)
			user.visible_message("\blue [user] takes the handle and draws a sword from inside the [src].", "\blue You take the [src] by the handle and draw out a sharp blade from it.")
			sword.add_fingerprint(user)
			add_fingerprint(user)
			sword = null
			icon_state = "cane_empty"
			update_icon()

	proc/toggle_lock(mob/user as mob)
		if(sword)
			switch(locked)
				if(1)
					locked = 0
					user << "\blue You twist and unlock the sword handle from the [src]."
				if(0)
					locked = 1
					user << "\blue You twist and lock the sword handle to the [src]."

	attack_self(mob/user as mob)
		if(iscarbon(user))
			toggle_lock(user)

	attack_hand(mob/user as mob)
		if(!locked)
			unsheathe(user)
		else
			..()

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(istype(W, /obj/item/weapon/canesword) && !sword)
			user.u_equip(W)
			W.loc = src
			sword = W
			W.dropped(user)
			W.add_fingerprint(user)
			add_fingerprint(user)
			icon_state = "cane"
			user << "\blue You sheathe the sword, and lock its handle to the [src]."
			locked = 1
			update_icon()

obj/item/weapon/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon_state = "wiredrod"
	item_state = "rods"
	flags = CONDUCT
	force = 8
	throwforce = 10
	w_class = 3
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")


obj/item/weapon/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/weapon/shard))
		var/obj/item/weapon/twohanded/spear/S = new /obj/item/weapon/twohanded/spear

		user.put_in_hands(S)
		user << "<span class='notice'>You fasten the glass shard to the top of the rod with the cable.</span>"
		del(I)
		del(src)
		update_icon(user)

	else if(istype(I, /obj/item/weapon/wirecutters))
		var/obj/item/weapon/melee/baton/cattleprod/P = new /obj/item/weapon/melee/baton/cattleprod

		user.put_in_hands(P)
		user << "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>"
		del(I)
		del(src)
		update_icon(user)
	update_icon(user)

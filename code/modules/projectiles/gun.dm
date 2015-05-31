/obj/item/weapon/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/gun.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags =  FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	matter = list("metal" = 2000)
	w_class = 3.0
	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5.0
	origin_tech = "combat=1"
	attack_verb = list("struck", "hit", "bashed")

	var/fire_sound = 'sound/weapons/Gunshot.ogg'
	var/obj/item/projectile/in_chamber = null
	var/caliber = ""
	var/silenced = 0
	var/recoil = 0
	var/ejectshell = 1
	var/clumsy_check = 1
	var/tmp/list/mob/living/target //List of who yer targeting.
	var/tmp/lock_time = -100
	var/tmp/mouthshoot = 0 ///To stop people from suiciding twice... >.>
	var/projectiles_per_shot = 1 //projectiles per shot.  burstfire weapons.
	var/automatic = 0 //Used to determine if you can target multiple people.
	var/tmp/mob/living/last_moved_mob //Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = 0 //So that it doesn't spam them with the fact they cannot hit them.
	var/firerate = 0 	//0 for keep shooting until aim is lowered
						// 1 for one bullet after tarrget moves and aim is lowered
	var/fire_delay = 6
	var/last_fired = 0
	var/fire_cooldown = 0 //burst fire code
	var/last_bursted = 0 //burst cooldowns
	var/wielded = 0

	var/fire_delay_unwielded = 0 //If these are set it will change the respected fields, if not they are ignored
	var/fire_delay_wielded = 0 //so that we're dealing with fire_delay modification
	var/wieldsound = null
	var/unwieldsound = null
	var/force_unwielded = 0 //Force modification, because striking someone with a rifle held in two hands -hurts-
	var/force_wielded = 0

	var/accuracy = 0 //goes into projectile.dm to provide individual offsets for each gun.  negative to increase base accuracy
	var/rangedrop = 0 //how much accuracy the average gun loses for every tile

	proc/can_wield() //Override in order to make a weapon two handed, remember to add toggle_wield(mob/user as mob) in the weapon somewhere
		return 0	//Override /Fire(..) to force the weapon to be two handed

	proc/ready_to_fire()
		if(world.time >= last_fired + fire_delay)
			last_fired = world.time
			return 1
		else
			return 0

	proc/burst_delay()
		if(world.time >= last_bursted + 2 + fire_cooldown*3)
			return 1
		else
			return 0

	proc/set_burst()
		last_bursted = world.time

	proc/load_into_chamber()
		return 0

	proc/special_check(var/mob/M) //Placeholder for any special checks, like detective's revolver.
		return 1

	emp_act(severity)
		for(var/obj/O in contents)
			O.emp_act(severity)

/obj/item/weapon/gun/afterattack(atom/A as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)
	if(flag)	return //It's adjacent, is the user, or is on the user's person
	if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/weapon/gun/energy))	return//Shouldnt flag take care of this?
	if(user && user.client && user.client.gun_mode && !(A in target))
		PreFire(A,user,params) //They're using the new gun system, locate what they're aiming at.
	else
		if (!burst_delay())
			if (world.time % 3) //to prevent spam
				user << "<span class='warning'>[src] is not ready to burst again!"
			return
		else
			for (var/i = 0; i < projectiles_per_shot; i++)
				Fire(A,user,params) //Otherwise, fire normally.
				if(fire_cooldown)
					sleep(fire_cooldown)
			set_burst()


/obj/item/weapon/gun/proc/isHandgun()
	return 1

/obj/item/weapon/gun/proc/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)//TODO: go over this
	//Exclude lasertag guns from the CLUMSY check.
	if(clumsy_check)
		if(istype(user, /mob/living))
			var/mob/living/M = user
			if ((CLUMSY in M.mutations) && prob(50))
				M << "<span class='danger'>[src] blows up in your face.</span>"
				M.take_organ_damage(0,20)
				M.drop_item()
				del(src)
				return

	if (!user.IsAdvancedToolUser())
		user << "\red You don't have the dexterity to do this!"
		return
	if(istype(user, /mob/living))
		var/mob/living/M = user
		if (HULK in M.mutations)
			M << "\red Your meaty finger is much too large for the trigger guard!"
			return
	if(ishuman(user))
		if(user.dna && user.dna.mutantrace == "adamantine")
			user << "\red Your metal fingers don't fit in the trigger guard!"
			return

	add_fingerprint(user)

	var/turf/curloc = get_turf(user)
	var/turf/targloc = get_turf(target)
	if (!istype(targloc) || !istype(curloc))
		return

	if(!special_check(user))
		return

	if (!ready_to_fire())
		if (world.time % 3) //to prevent spam
			user << "<span class='warning'>[src] is not ready to fire again!"
		return

	if(!load_into_chamber()) //CHECK
		return click_empty(user)

	if(!in_chamber)
		return

	in_chamber.firer = user
	in_chamber.def_zone = user.zone_sel.selecting
	if(targloc == curloc)
		user.bullet_act(in_chamber)
		del(in_chamber)
		update_icon()
		return

	if(recoil)
		spawn()
			shake_camera(user, recoil + 1, recoil)

	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		playsound(user, fire_sound, 50, 1)
		user.visible_message("<span class='warning'>[user] fires [src][reflex ? " by reflex":""]!</span>", \
		"<span class='warning'>You fire [src][reflex ? "by reflex":""]!</span>", \
		"You hear a [istype(in_chamber, /obj/item/projectile/beam) ? "laser blast" : "gunshot"]!")

	in_chamber.original = target
	in_chamber.loc = get_turf(user)
	in_chamber.starting = get_turf(user)
	in_chamber.shot_from = src
	in_chamber.silenced = silenced
	in_chamber.current = curloc
	in_chamber.yo = targloc.y - curloc.y
	in_chamber.xo = targloc.x - curloc.x
	
	user.AllowedToClickAgainAfter(CLICK_CD_RANGE) // 
	
	if(istype(user, /mob/living/carbon))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			in_chamber.yo += rand(-2,2)
			in_chamber.xo += rand(-2,2)
		else if(mob.shock_stage > 70)
			in_chamber.yo += rand(-1,1)
			in_chamber.xo += rand(-1,1)

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			in_chamber.p_x = text2num(mouse_control["icon-x"])
		if(mouse_control["icon-y"])
			in_chamber.p_y = text2num(mouse_control["icon-y"])

	spawn()
		if(in_chamber)
			in_chamber.process()
	sleep(1)
	in_chamber = null

	update_icon()

	if(user.hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()

	if(istype(src, /obj/item/weapon/gun/projectile) && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.gloves)
			H.gsr = 1
		else
			var/obj/item/clothing/G = H.gloves
			G.gsr = 1


/obj/item/weapon/gun/proc/can_fire()
	return load_into_chamber()

/obj/item/weapon/gun/proc/can_hit(var/mob/living/target as mob, var/mob/living/user as mob)
	return in_chamber.check_fire(target,user)

/obj/item/weapon/gun/proc/click_empty(mob/user = null)
	if (user)
		user.visible_message("*click click*", "\red <b>*click*</b>")
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	else
		src.visible_message("*click click*")
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)

/obj/item/weapon/gun/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	var/obj/item/weapon/gun/O = user.get_active_hand()
	if(istype(O,/obj/item/weapon/gun/projectile/shotgun)) //Since you need two hands to fire a shotgun this will make you hit yourself if you try with one hand.
		if(!wielded)
			return ..()

	//Suicide handling.
	if (M == user && user.zone_sel.selecting == "mouth" && !mouthshoot)
		mouthshoot = 1
		M.visible_message("\red [user] sticks their gun in their mouth, ready to pull the trigger...")
		if(!do_after(user, 40))
			M.visible_message("\blue [user] decided life was worth living")
			mouthshoot = 0
			return
		if (load_into_chamber())
			user.visible_message("<span class = 'warning'>[user] pulls the trigger.</span>")
			if(silenced)
				playsound(user, fire_sound, 10, 1)
			else
				playsound(user, fire_sound, 50, 1)
			if(istype(in_chamber, /obj/item/projectile/beam/lastertag))
				user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
				mouthshoot = 0
				return

			if(istype(in_chamber, /obj/item/projectile/beam/practice))
				user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a practice gun.</span>")
				mouthshoot = 0
				return

			in_chamber.on_hit(M)
			if (in_chamber.damage_type != HALLOSS)
				user.apply_damage(in_chamber.damage*2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp=1)
				user.death()
			else
				user << "<span class = 'notice'>Ow...</span>"
				user.apply_effect(110,AGONY,0)
			del(in_chamber)
			mouthshoot = 0
			return
		else
			click_empty(user)
			mouthshoot = 0
			return

	if (load_into_chamber())
		//Point blank shooting if on harm intent or target we were targeting.
		if(user.a_intent == "hurt")
			user.visible_message("\red <b> \The [user] fires \the [src] point blank at [M]!</b>")
			in_chamber.damage *= 1.3
			Fire(M,user)
			return
		else if(target && M in target)
			Fire(M,user) ///Otherwise, shoot!
			return
	else
		return ..() //Pistolwhippin'

//Wielding weapons

/*  This is what you place on the weapon that you want to wield
/obj/item/weapon/gun/[path to gun]/verb/wield()
	set name = "Wield"
	set category = "Object"
	set src in usr

	toggle_wield(usr)
*/

/obj/item/weapon/gun/proc/toggle_wield(mob/user as mob)
	if(!can_wield())
		return
	if(!istype(user.get_active_hand(), /obj/item/weapon/gun))
		user << "<span class='warning'>You need to be holding the [name] in your active hand</span>"
		return

	if( istype(user,/mob/living/carbon/monkey) )
		user << "<span class='warning'>It's too heavy for you to stabilize properly.</span>"
		return
	if(wielded) //Trying to unwield it
		unwield()
		user << "<span class='notice'>You are no-longer stabilizing the [name] with both hands.</span>"
		if (src.unwieldsound)
			playsound(src.loc, unwieldsound, 50, 1)

		var/obj/item/weapon/gun/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()
		else
			O = user.get_active_hand()
			if(O && istype(O))
				O.unwield()
		return

	else //Trying to wield it
		if(user.get_inactive_hand())
			user << "<span class='warning'>You need your other hand to be empty</span>"
			return
		wieldg()
		user << "<span class='notice'>You stabilize the [initial(name)] with both hands.</span>"
		if (src.wieldsound)
			playsound(src.loc, wieldsound, 50, 1)

		var/obj/item/weapon/gun/offhand/O = new(user) ////Let's reserve his other hand~
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on the [initial(name)]"
		user.put_in_inactive_hand(O)
	return

/obj/item/weapon/gun/mob_can_equip(M as mob, slot)
	//Cannot equip wielded items.
	if(can_wield())
		if(wielded)
			M << "<span class='warning'>Lower the [initial(name)] first!</span>"
			return 0

	return ..()

/obj/item/weapon/gun/dropped(mob/living/user as mob)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(can_wield())
		if(user)
			var/obj/item/weapon/gun/O = user.get_inactive_hand()
			if(istype(O))
				O.unwield()
		return	unwield()

/obj/item/weapon/gun/pickup(mob/user)
	if(can_wield())
		unwield()

/obj/item/weapon/gun/proc/unwield()
	wielded = 0
	if(force_unwielded && force_wielded)
		force = force_unwielded
	if(fire_delay_unwielded && fire_delay_wielded)
		fire_delay = fire_delay_unwielded

/obj/item/weapon/gun/proc/wieldg()
	wielded = 1
	if(force_wielded)
		force = force_wielded
	if(fire_delay_wielded)
		fire_delay = fire_delay_wielded

///////////OFFHAND///////////////
/obj/item/weapon/gun/offhand
	w_class = 5.0
	icon = 'icons/obj/weapons.dmi' //mainly because we can't have nice things, right? Right.
	icon_state = "offhand"
	item_state = "nothing" //Overrides item_state in /obj/item/weapon/gun
	name = "offhand"

	unwield()
		spawn(1)
			del(src)

	wieldg()
		spawn(1)
			del(src)

	dropped(mob/living/user as mob)
		if(user)
			var/obj/item/weapon/gun/O = user.get_inactive_hand()
			if(istype(O))
				user << "<span class='notice'>You are no-longer stabilizing the [name] with both hands.</span>"
				O.unwield()
				unwield()
		if(src)
			del(src)

/obj/item/weapon/gun/offhand/mob_can_equip(M as mob, slot)
	return 0 //Because you can't equip your hand yet somehow you can
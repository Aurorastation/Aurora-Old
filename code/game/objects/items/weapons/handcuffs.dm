/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	matter = list("metal" = 500)
	origin_tech = "materials=1"
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes

/obj/item/weapon/handcuffs/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(istype(src, /obj/item/weapon/handcuffs/cyborg) && isrobot(user))
		if(!C.handcuffed)
			var/turf/p_loc = user.loc
			var/turf/p_loc_m = C.loc
			playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
			for(var/mob/O in viewers(user, null))
				O.show_message("\red <B>[user] is trying to put handcuffs on [C]!</B>", 1)
			spawn(30)
				if(!C)	return
				if(p_loc == user.loc && p_loc_m == C.loc)
					C.handcuffed = new /obj/item/weapon/handcuffs(C)
					C.update_inv_handcuffed()

	else
		if ((CLUMSY in usr.mutations) && prob(50))
			usr << "\red Uh ... how do those things work?!"
			if (istype(C, /mob/living/carbon/human))
				if(!C.handcuffed)
					var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
					O.source = user
					O.target = user
					O.item = user.get_active_hand()
					O.s_loc = user.loc
					O.t_loc = user.loc
					O.place = "handcuff"
					C.requests += O
					spawn( 0 )
						O.process()
				return
			return
		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey")
			usr << "\red You don't have the dexterity to do this!"
			return
		if (istype(C, /mob/living/carbon/human))
			if(!C.handcuffed)

				C.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [C.name] ([C.ckey])</font>")
				msg_admin_attack("[key_name_admin(user)] attempted to handcuff [key_name_admin(C)] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[C.x];Y=[C.y];Z=[C.z]'>JMP</a>")

				var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
				O.source = user
				O.target = C
				O.item = user.get_active_hand()
				O.s_loc = user.loc
				O.t_loc = C.loc
				O.place = "handcuff"
				C.requests += O
				spawn( 0 )
					if(istype(src, /obj/item/weapon/handcuffs/cable))
						feedback_add_details("handcuffs","C")
						playsound(src.loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
					else
						feedback_add_details("handcuffs","H")
						playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					O.process()
			return
		else
			if(!C.handcuffed)
				var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey(  )
				O.source = user
				O.target = C
				O.item = user.get_active_hand()
				O.s_loc = user.loc
				O.t_loc = C.loc
				O.place = "handcuff"
				C.requests += O
				spawn( 0 )
					if(istype(src, /obj/item/weapon/handcuffs/cable))
						playsound(src.loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
					else
						playsound(src.loc, 'sound/weapons/handcuffs.ogg', 30, 1, -2)
					O.process()
			return
	return

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()
	if (last_chew + 26 > world.time) return

	var/mob/living/carbon/human/H = A
	if (!H.handcuffed) return
	if (H.a_intent != "hurt") return
	if (H.zone_sel.selecting != "mouth") return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/datum/organ/external/O = H.organs_by_name[H.hand?"l_hand":"r_hand"]
	if (!O) return

	var/s = "\red [H.name] chews on \his [O.display_name]!"
	H.visible_message(s, "\red You chew on your [O.display_name]!")
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] ([H.ckey])</font>")
	log_attack("[s] ([H.ckey])")

	if(O.take_damage(3,0,1,1,"teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s

/obj/item/weapon/handcuffs/cable/red
	color = "#DD0000"

/obj/item/weapon/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/weapon/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/weapon/handcuffs/cable/green
	color = "#00DD00"

/obj/item/weapon/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/weapon/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/weapon/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/weapon/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if(R.get_amount() > 0)
			R.use(1)
			var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod

			user.put_in_hands(W)
			user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"
			del(src)
			update_icon(user)

/obj/item/weapon/handcuffs/cyborg
	dispenser = 1

/obj/item/weapon/handcuffs/ziptie
	name = "zipties"
	desc = "Sturdy, and reliable. Likely used to restain unruly people."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "ziptie"
	var/singular_name = "ziptie"
	var/amount = 1
	var/max_amount = 6

/obj/item/weapon/handcuffs/ziptie/New(var/loc, var/amount=null)
	..()
	if (amount)
		src.amount=amount
	return

/obj/item/weapon/handcuffs/ziptie/Del()
	if (src && usr && usr.machine==src)
		usr << browse(null, "window=stack")
	..()

/obj/item/weapon/handcuffs/ziptie/examine()
	set src in view(1)
	..()
	usr << "There are [src.amount] [src.singular_name]\s in the stack."
	return

/obj/item/weapon/handcuffs/ziptie/proc/use(var/amount)
	src.amount-=amount
	if (src.amount<=0)
		var/oldsrc = src
		src = null //dont kill proc after del()
		if(usr)
			usr.before_take_item(oldsrc)
		del(oldsrc)
	return

/obj/item/weapon/handcuffs/ziptie/proc/add_to_stacks(mob/usr as mob)
	var/obj/item/weapon/handcuffs/ziptie/oldsrc = src
	src = null
	for (var/obj/item/weapon/handcuffs/ziptie/N in usr.loc)
		if (N==oldsrc)
			continue
		if (!istype(N, oldsrc.type))
			continue
		if (N.amount>=N.max_amount)
			continue
		oldsrc.attackby(N, usr)
		usr << "You add new [N.singular_name] to the stack. It now contains [N.amount] [N.singular_name]\s."
		if(!oldsrc)
			break

/obj/item/weapon/handcuffs/ziptie/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/weapon/handcuffs/ziptie/F = new src.type( user, 1)
		F.copy_evidences(src)
		user.put_in_hands(F)
		src.add_fingerprint(user)
		F.add_fingerprint(user)
		use(1)
		if (src && usr.machine==src)
			spawn(0) src.interact(usr)
	else
		..()
	return

/obj/item/weapon/handcuffs/ziptie/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, src.type))
		var/obj/item/weapon/handcuffs/ziptie/S = W
		if (S.amount >= max_amount)
			return 1
		var/to_transfer as num
		if (user.get_inactive_hand()==src)
			to_transfer = 1
		else
			to_transfer = min(src.amount, S.max_amount-S.amount)
		S.amount+=to_transfer
		if (S && usr.machine==S)
			spawn(0) S.interact(usr)
		src.use(to_transfer)
		if (src && usr.machine==src)
			spawn(0) src.interact(usr)
	else return ..()

/obj/item/weapon/handcuffs/ziptie/proc/copy_evidences(obj/item/weapon/handcuffs/ziptie/from as obj)
	src.blood_DNA = from.blood_DNA
	src.fingerprints  = from.fingerprints
	src.fingerprintshidden  = from.fingerprintshidden
	src.fingerprintslast  = from.fingerprintslast



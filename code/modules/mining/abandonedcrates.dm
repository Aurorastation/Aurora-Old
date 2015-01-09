/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/code = null
	var/lastattempt = null
	var/attempts = 2
	locked = 1
	var/min = 1
	var/max = 10

/obj/structure/closet/crate/secure/loot/New()
	..()
	code = rand(min,max)
	var/loot = rand(1,70)
	switch(loot)
		if(1)
			new/obj/item/weapon/pickaxe/diamond(src)
		if(2 to 3)
			new/obj/item/weapon/pickaxe/gold(src)
		if(4 to 5)
			new/obj/item/weapon/pickaxe/silver(src)
		if(6)
			new/obj/item/weapon/pickaxe/plasmacutter(src)
		if(7 to 8)
			for(var/i = 0, i < 2, i++)
				new/obj/item/weapon/pickaxe/drill(src)
		if(9)
			for(var/i = 0, i < 3, i++)
				new/obj/machinery/portable_atmospherics/hydroponics(src)
		if(10)
			for(var/i = 0, i < 3, i++)
				new/obj/item/weapon/reagent_containers/glass/beaker/noreact(src)
		if(11 to 13)
			new/obj/item/weapon/melee/classic_baton(src)
		if(14)
			return
		if(15)
			new/obj/item/clothing/under/chameleon(src)
			for(var/i = 0, i < 7, i++)
				new/obj/item/clothing/tie/horrible(src)
		if(16)
			new/obj/item/clothing/under/shorts(src)
			new/obj/item/clothing/under/shorts/red(src)
			new/obj/item/clothing/under/shorts/blue(src)
		//Dummy crates start here.
		if(17 to 29)
			return
		//Dummy crates end here.
		if(30)
			new/obj/item/weapon/melee/baton(src)

//Code modified to make things less boomy, and offer more chances with more difficulty.
/obj/structure/closet/crate/secure/loot/togglelock(mob/user as mob)
	if(locked)
//		user << "<span class='notice'>The crate is locked with a Deca-code lock.</span>"
//		var/input = input(usr, "Enter digit from [min] to [max].", "Deca-Code Lock", "") as num
		if(in_range(src, user))
			if (attempts >= 0)
				user << "<span class='notice'>The crate is locked with a Deca-code lock.</span>"
				var/input = input(usr, "Enter digit from [min] to [max].", "Deca-Code Lock", "") as num
				input = Clamp(input, 0, 10)
				if (input == code)
					user << "<span class='notice'>The crate unlocks!</span>"
					locked = 0
					overlays.Cut()
					overlays += greenlight
				else if (input == null || input > max || input < min)
					user << "<span class='notice'>You leave the crate alone.</span>"
				else
					user << "<span class='warning'>A red light flashes.</span>"
					lastattempt = input
					attempts--
					if (attempts == 0)
						user << "<span class='danger'>The crate's anti-tamper system will activate after this try, locking the crate down!</span>"
/*					var/turf/T = get_turf(src.loc) Coding out the explosion, because I'm nice like that. Don't make me regret this.
					explosion(T, 0, 1, 4, 4)
					del(src)*/
	//				tampered = 1
			if (attempts < 0)
				user << "<span class='notice'>The crate's anti-tamper system is activated, and the crate is locked down.</span>"

		else
			user << "<span class='notice'>You attempt to interact with the device using a hand gesture, but it appears this crate is from before the DECANECT came out.</span>"
			return
	else
		return ..()

/obj/structure/closet/crate/secure/loot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(locked)
		if (istype(W, /obj/item/weapon/card/emag))
			user << "<span class='notice'>The crate unlocks!</span>"
			locked = 0
		if (istype(W, /obj/item/device/multitool))
			user << "<span class='notice'>DECA-CODE LOCK REPORT:</span>"
			if (attempts == 1)
				user << "<span class='warning'>* Anti-Tamper System will activate on next failed access attempt.</span>"
			else
				user << "<span class='notice'>* Anti-Tamper System will activate after [src.attempts] failed access attempts.</span>"
			if (lastattempt == null)
				user << "<span class='notice'> has been made to open the crate thus far.</span>"
				return
			// hot and cold
			if (code > lastattempt)
				user << "<span class='notice'>* Last access attempt lower than expected code.</span>"
			else
				user << "<span class='notice'>* Last access attempt higher than expected code.</span>"
		else ..()
	else ..()

/obj/structure/closet/crate/secure/loot/bullet_act(var/obj/item/projectile/Proj)
	if(rand(1,7)==1)
		var/turf/T = get_turf(src.loc)
		explosion(T, 0, 1, 4, 4)
		for(var/mob/O in viewers(src, 6))
			if((O.client && !( O.blinded )))
				O << "<span class='warning'>The crate's anti-tamper system overloads, causing an explosion.</span>"
		del(src)
		return

//	One way of doing this. Let's try another.
//  Other way didn't work. Yup.

/*	if(health <= 10 && rand(1,5) == 1)
		var/turf/T = get_turf(src.loc)
		explosion(T, 0, 1, 4, 4)
		for(var/mob/O in viewers(user, 6))
			if((O.client && !( O.blinded )))
				O << "<span class='warning'>The crate's anti-tamper system overloads, causing an explosion.</span>"
		viewers << "<span class='warning'>The crate's anti-tamper system overloads, causing an explosion.</span>"
		del(src)
		return*/
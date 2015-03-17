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
				new/obj/item/weapon/ore/diamond(src)
		if(9)
			new/obj/item/weapon/pickaxe/drill(src)
		if(10 to 12)
			for(var/i = 0, i < 5, i++)
				new/obj/item/seeds/lemonseed(src)
		if(13 to 16)
			var/seeds = rand(1,15)
			switch(seeds)
				if(1 to 3)
					new/obj/item/seeds/nettleseed(src)
				if(4 to 8)
					new/obj/item/seeds/berryseed(src)
					new/obj/item/seeds/berryseed(src)
					new/obj/item/seeds/berryseed(src)
				if(9 to 12)
					new/obj/item/seeds/appleseed(src)
					new/obj/item/seeds/appleseed(src)
					new/obj/item/seeds/appleseed(src)
				if(13)
					new/obj/item/seeds/bluespacetomatoseed(src)
				if(14)
					new/obj/item/seeds/sugarcaneseed(src)
				if(15)
					new/obj/item/seeds/plastiseed(src)
		if(17)
			new/obj/item/weapon/reagent_containers/glass/beaker/noreact(src)
		if(18)
			new/obj/item/bluespace_crystal(src)
			if(prob(10))
				new/obj/item/bluespace_crystal(src)
		if(19)
			new/obj/item/seeds/kudzuseed(src)
		if(20)
			new/obj/item/weapon/shield/energy(src)
		if(21)
			new/obj/item/weapon/coin/iron(src)
			if(prob(25))
				new/obj/item/weapon/coin/silver(src)
		if(22)
			if(prob(10))
				new/obj/item/weapon/coin/adamantine(src)
				new/obj/item/weapon/coin/gold(src)
			else
				new/obj/item/weapon/paper/crumpled(src)
		if(23 to 25)
			var/nutrient = rand(1,3)
			switch(nutrient)
				if(1)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/ez(src)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/ez(src)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/ez(src)
				if(2)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/l4z(src)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/l4z(src)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/l4z(src)
				if(3)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/rh(src)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/rh(src)
					new/obj/item/weapon/reagent_containers/glass/fertilizer/rh(src)
		if(26 to 30)
			for(var/i = 0, i < 5, i++)
				new/obj/item/stack/sheet/metal(src)
		if(31 to 35)
			for(var/i = 0, i < 5, i++)
				new/obj/item/stack/sheet/glass(src)
		if(36 to 37)
			new/obj/item/stack/sheet/glass/plasmaglass(src)
			new/obj/item/stack/sheet/glass/plasmaglass(src)
		if(38 to 39)
			new/obj/item/stack/sheet/plasteel(src)
			new/obj/item/stack/sheet/plasteel(src)
		if(40 to 45)
			new/obj/item/stack/rods(src)
			new/obj/item/stack/rods(src)
			new/obj/item/stack/rods(src)
			new/obj/item/weapon/shard(src)
			new/obj/item/weapon/shard(src)
			new/obj/item/weapon/shard(src)
		if(46)
			new/obj/item/weapon/storage/belt/champion(src)
		if(47)
			new/obj/item/weapon/rcd_ammo(src)
			new/obj/item/weapon/rcd_ammo(src)
			new/obj/item/weapon/rcd_ammo(src)
			if(prob(10))
				new/obj/item/weapon/rcd(src)
		if(48)
			var/pills = rand(1,15)
			switch(pills)
				if(1 to 4)
					new/obj/item/weapon/storage/pill_bottle/antitox(src)
				if(5 to 8)
					new/obj/item/weapon/storage/pill_bottle/inaprovaline(src)
				if(9 to 12)
					new/obj/item/weapon/storage/pill_bottle/kelotane(src)
				if(13)
					new/obj/item/weapon/storage/pill_bottle/dice(src)
				if(14)
					new/obj/item/weapon/storage/pill_bottle/happy(src)
				if(15)
					new/obj/item/weapon/storage/pill_bottle/zoom(src)
		if(49 to 52)
			var/cash = rand(1,7)
			switch(cash)
				if(1 to 3)
					new/obj/item/weapon/spacecash/c10(src)
					new/obj/item/weapon/spacecash/c1(src)
					new/obj/item/weapon/spacecash/c1(src)
					new/obj/item/weapon/spacecash/c1(src)
				if(4 to 6)
					new/obj/item/weapon/spacecash/c20(src)
				if(7)
					new/obj/item/weapon/spacecash/c50(src)
		if(53)
			if(prob(15))
				new/obj/item/weapon/spacecash/c500(src)
			else
				new/obj/item/weapon/spacecash/c1(src)
		if(54 to 60)
			if(prob(50))
				new/obj/item/weapon/ore/strangerock(src)
				new/obj/item/weapon/ore/strangerock(src)
				new/obj/item/weapon/ore/strangerock(src)
				new/obj/item/weapon/ore/slag(src)
				new/obj/item/weapon/ore/slag(src)
			else
				new/obj/item/weapon/ore/gold(src)
				new/obj/item/weapon/shard(src)
		if(61 to 62)
			new/obj/item/weapon/paper/crumpled/bloody(src)
			var/gibs = rand(1,4)
			switch(gibs)
				if(1)
					new/obj/item/weapon/organ/r_leg(src)
					new/obj/item/weapon/organ/l_arm(src)
				if(2)
					new/obj/item/weapon/organ/head(src)
					new/obj/item/weapon/organ/l_hand(src)
				if(3)
					new/obj/item/weapon/organ/r_foot(src)
					new/obj/item/weapon/organ/r_arm(src)
				if(4)
					new/obj/item/weapon/organ/l_leg(src)
					new/obj/item/weapon/organ/head(src)

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
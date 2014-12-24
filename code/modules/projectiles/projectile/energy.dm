/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	flag = "energy"


/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	nodamage = 1
	/*
	stun = 10
	weaken = 10
	stutter = 10
	*/
	agony = 50
	damage_type = HALLOSS
	//Damage will be handled on the MOB side, to prevent window shattering.



/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	damage = 40
	damage_type = CLONE
	irradiate = 40



/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	weaken = 5


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	damage_type = TOX
	irradiate = 70
	nodamage = 0

//	weaken = 10
//	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/plasma
	name = "plasma bolt"
	icon_state = "energy"
	damage = 20
	damage_type = TOX
	irradiate = 40

/obj/item/projectile/energy/electrode/instant
	name = "electrode"
	icon_state = "spark"
	nodamage = 1
	stun = 10
	weaken = 10
	stutter = 10

/obj/item/projectile/energy/electrode/high
	name = "electrode"
	icon_state = "spark"
	nodamage = 1
	/*
	stun = 10
	weaken = 10
	stutter = 10
	*/
	agony = 70
	damage_type = HALLOSS


/obj/item/projectile/energy/mining //not in the game.  i'll play with it later probably.
	name = "electrode"
	icon_state = "spark"
	damage = 5
	kill_count = 3
	var/life = 5

	Bump(atom/A)
		A.bullet_act(src, def_zone)
		src.life -= 1
		if(life <= 0)
			del(src)
		return

/turf/simulated/mineral/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/energy/mining))
		src.GetDrilled()
		..()
	return 0

/obj/structure/boulder/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/energy/mining))
		del(src)
		..()
	return 0
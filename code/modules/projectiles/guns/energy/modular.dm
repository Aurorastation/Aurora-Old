/obj/item/weapon/gun/energy/laser/modular/
	name = "basic protolaser"
	desc = "A basic, modular laser rifle."
	icon_state = "modpistol"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	matter = list("metal" = 2000)
	origin_tech = "combat=3;magnets=2"
	projectile_type = "/obj/item/projectile/beam/reallyweak"
	fire_delay = 16
	cell_type = "/obj/item/weapon/cell"

	var/canzoom = 0
	zoomdevicename = "scan screen"
	var/open = 0

	var/upgradepointtotal = 16 //KNOWN BUG: Crashes if you try to VV it with a lot of stuff inside.  By a lot, I mean 'everything.'  At least in all my tests.
	var/upgradepoints = 0

	//Changeable part mods//

	var/obj/item/weapon/stock_parts/micro_laser/lasertype
	var/obj/item/weapon/stock_parts/manipulator/delaymod
	var/obj/item/weapon/stock_parts/scanning_module/targetmod
	var/obj/item/weapon/stock_parts/console_screen/screen
	var/obj/item/weapon/stock_parts/capacitor/powermod
//	var/obj/item/weapon/stock_parts/matter_bin/heatsink //i have no idea what this is for yet so.

	var/hasscreen = 0 // for scoping.

/*sprites pending
/obj/item/weapon/gun/energy/laser/modular/advanced //better version of the rifle.
	name = "advanced protolaser"
	desc = "A protolaser with an improved frame, capable of holding more upgrades."
	icon_state = "modpistol"
	upgradepointtotal = 22
*/
/*
/obj/item/weapon/gun/energy/laser/modular/advanced/bluespace //for admins.  maybe r&d with cell nerf if feeling generous
	name = "bluespace protolaser"
	desc = "A highly-advanced laser, capable of holding all your upgrades.  Powered by bluespace."
	icon_state = "modpistol"
	upgradepointtotal = 35 //enough for everything
	cell_type = "/obj/item/weapon/cell/infinite"
*/

/obj/item/weapon/gun/energy/laser/modular/pistol/crap // small modular laser pistol.
	name = "basic protopistol"
	desc = "A basic laser pistol prototype."
	icon_state = "modpistolopen"
	open = 1
	upgradepointtotal = 8 //can barely fit anything

/obj/item/weapon/gun/energy/laser/modular/pistol // small modular laser pistol.
	name = "protopistol"
	desc = "A basic, modular laser pistol."
	icon_state = "modpistolopen"
	open = 1
	w_class = 3 // leave it at three until protorifle is implemented.  then severely nerf pistol points.
	upgradepointtotal = 16 //current protopistol is at protorifle point totals.

/obj/item/weapon/gun/energy/laser/modular/pistol/advanced //better version of the pistol
	name = "advanced protopistol"
	desc = "A protopistol with an improved frame, capable of holding more upgrades."
	icon_state = "modpistolopen"
	open = 1
	upgradepointtotal = 22

/obj/item/weapon/gun/energy/laser/modular/pistol/advanced/bluespace //for admins
	name = "bluespace protopistol"
	desc = "A highly-advanced pistol, capable of holding all your upgrades and then some.  Powered by bluespace."
	icon_state = "modpistolopen"
	upgradepointtotal = 666 //enough for all of the things
	open = 1
	cell_type = "/obj/item/weapon/cell/infinite"

/obj/item/weapon/gun/energy/laser/modular/attackby(obj/item/W, mob/user) //the modding stuffs

	if (istype(W, /obj/item/weapon/screwdriver))
		if(open == 1)
			user << "<span class='notice'>You secure the parts and close the [src].</span>"
			open = 0
			checkparts() //applies the upgrades.
			icon_state = "modpistol"
		else if(open == 0)
			user << "<span class='notice'>You open the gun and remove the parts from [src].</span>"
			open = 1
			upgradepoints = 0 //you open the gun and everything falls out.  reset this stuff here.
			hasscreen = 0
			canzoom = 0
			icon_state = "modpistolopen"
			/*
			Have it reset all the gun's stats here.  Do it after the gun has stats.  Gun does not have stats yet
			*/
			if(lasertype) //if lasertype exists ie is not null
				lasertype.loc = get_turf(src.loc)
				lasertype = null // drop to floor and set to null
			if(delaymod)
				delaymod.loc = get_turf(src.loc)
				delaymod = null
			if(targetmod)
				targetmod.loc = get_turf(src.loc)
				targetmod = null
			if(powermod)
				powermod.loc = get_turf(src.loc)
				powermod = null
			if(screen)
				screen.loc = get_turf(src.loc)
				screen = null
/*			if(heatsink)
				heatsink.loc = get_turf(src.loc)
				heatsink = null */
/*			if(cell_type)
				cell_type.loc = get_turf(src.loc)
				cell_type = null
*/
			checkparts() //resets all values since everything popped out.

	if (open == 1)
		if (istype(W, /obj/item/weapon/stock_parts/micro_laser))
			if (!lasertype)
				lasertype = W
				if(lasertype.rating == 1)
					if(assignpoints(3, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [lasertype.name] in [src].</span>"
					else
						lasertype = null
						return
				else if(lasertype.rating == 2)
					if(assignpoints(5, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [lasertype.name] in [src].</span>"
					else
						lasertype = null
						return
				else if(lasertype.rating == 3)
					if(assignpoints(8, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [lasertype.name] in [src].</span>"
					else
						lasertype = null
						return

			else if (lasertype)
				user << "<span class='notice'>There's already a laser inside!</span>"

		else if (istype(W, /obj/item/weapon/stock_parts/manipulator))
			if (!delaymod)
				delaymod = W
				user.drop_item()
				W.loc = src
				user << "<span class='notice'>You install a [delaymod.name] in [src].</span>"
				if(delaymod.rating == 1)
					if(assignpoints(2, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [delaymod.name] in [src].</span>"
					else
						delaymod = null
						return
				else if(delaymod.rating == 2)
					if(assignpoints(4, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [delaymod.name] in [src].</span>"
					else
						delaymod = null
						return
				else if(delaymod.rating == 3)
					if(assignpoints(8, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [delaymod.name] in [src].</span>"
					else
						delaymod = null
						return

			else if (delaymod)
				user << "<span class='notice'>There's already a manipulator inside!</span>"

		else if (istype(W, /obj/item/weapon/stock_parts/scanning_module))
			if (!targetmod)
				targetmod = W
				if(targetmod.rating == 1)
					if(assignpoints(1, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [targetmod.name] in [src].</span>"
					else
						targetmod = null
						return
				else if(targetmod.rating == 2)
					if(assignpoints(3, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [targetmod.name] in [src].</span>"
					else
						targetmod = null
						return

				else if(targetmod.rating == 3)
					if(assignpoints(6, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [targetmod.name] in [src].</span>"
					else
						targetmod = null
						return

			else if (targetmod)
				user << "<span class='notice'>There's already a scanning module inside!</span>"

		else if (istype(W, /obj/item/weapon/stock_parts/console_screen))
			if (!screen)
				screen = W
				if(assignpoints(2, user))
					user.drop_item()
					W.loc = src
					hasscreen = 1
					user << "<span class='notice'>You install a screen in [src].</span>"
				else
					screen = null
					return


			else if (screen)
				user << "<span class='notice'>There's already a screen inside!</span>"
		else if (istype(W, /obj/item/weapon/stock_parts/capacitor))
			if (!powermod)
				powermod = W
				if(powermod.rating == 1)
					if(assignpoints(1, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [powermod.name] in [src].</span>"
					else
						powermod = null
						return

				else if(powermod.rating == 2)
					if(assignpoints(3, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [powermod.name] in [src].</span>"
					else
						powermod = null
						return

				else if(powermod.rating == 3)
					if(assignpoints(6, user))
						user.drop_item()
						W.loc = src
						user << "<span class='notice'>You install a [powermod.name] in [src].</span>"
					else
						powermod = null
						return


			else if (powermod)
				user << "<span class='notice'>There's already a capacitor inside!</span>"

/*		else if (istype(W, /obj/item/weapon/stock_parts/matter_bin))
			if (!heatsink)
				user.drop_item()
				W.loc = src
				heatsink = W
				user << "<span class='notice'>You install a [heatsink.name] in [src].</span>"
				if(heatsink.rating == 1)
					upgradepoints += 2
				else if(heatsink.rating == 2)
					upgradepoints += 5
				else if(heatsink.rating == 3)
					upgradepoints += 10

			else if (heatsink)
				user << "<span class='notice'>There's already a heatsink inside!</span>"
*/
/obj/item/weapon/gun/energy/laser/modular/proc/checkparts() //updates parts and values

	if(!lasertype)
		projectile_type = "/obj/item/projectile/beam/reallyweak"
		charge_cost = 150
	else if(lasertype.rating == 1)
		projectile_type = "/obj/item/projectile/beam/green" // preferably a green laser.  expecting standard 40 damage.
		charge_cost = 200
	else if(lasertype.rating == 2)
		projectile_type = "/obj/item/projectile/beam/blue" //powerful.  eight shots with highest-end power equipment.
		charge_cost = 500
	else if(lasertype.rating == 3)
		projectile_type = "/obj/item/projectile/beam/violet" //extremely high-powered.  you get four shots -with- top-tier powermods.  less without.
		charge_cost = 1000

	if(!delaymod)
		fire_delay = 16
	else if(delaymod.rating == 1)
		fire_delay = 8
	else if(delaymod.rating == 2)
		fire_delay = 4
	else if(delaymod.rating == 3)
		fire_delay = 2

	if(!targetmod)
		rangedrop = 5
		accuracy = 30 //positive.  subtracts to 0 accuracy base, 30 if aimed.  fully accurate up to two tiles *if aimed*, -15% per tile after
		canzoom = 0
	else if(targetmod.rating == 1)
		rangedrop = 0
		accuracy = -30 //standard accuracy.  standard gun.
		canzoom = 0
	else if(targetmod.rating == 2)
		rangedrop = 0
		accuracy = -60 //Fully accurate up to 6 tiles aimed. 15% drop per tile after that for ~-120% accuracy at 14 tiles.  If you want to snipe things, get phasic.
		canzoom = 1 //advanced and up scanning modules let you zoom in. good luck hitting without phasic though pal.  good luck.
	else if(targetmod.rating == 3)
		rangedrop = -5 //Accurate aimed up to 12 tiles.  20% miss at 14.  9 tiles and 50% miss at 14 without aiming.
		accuracy = -110 //If you're paying a premium for accuracy, you can have accuracy.
		canzoom = 1

	if(!powermod)
		charge_cost = 1.5*charge_cost
	else if(powermod.rating == 1)
		charge_cost = charge_cost
	else if(powermod.rating == 2)
		charge_cost = charge_cost/2
	else if(powermod.rating == 3)
		charge_cost = charge_cost/4

/*	if(!heatsink)

	else if(heatsink.rating == 1)

	else if(heatsink.rating == 2)

	else if(heatsink.rating == 3)*/

/obj/item/weapon/gun/energy/laser/modular/proc/assignpoints(var/newpoints, var/mob/user as mob)
	if((upgradepointtotal) >= (upgradepoints + newpoints))
		upgradepoints += newpoints
		user << "<span class='notice'>You have used [upgradepoints]/[upgradepointtotal] upgrade points.  This upgrade costs [newpoints] points.</span>"
		return 1
	else
		user << "<span class='notice'>The frame cannot handle this many upgrades!</span>"
		user << "<span class='notice'>You have used [upgradepoints]/[upgradepointtotal] upgrade points.  This upgrade costs [newpoints] points.</span>"
		return 0

/obj/item/weapon/gun/energy/laser/modular/Fire(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, params, reflex = 0)
	if(open == 1)
		user << "<span class='notice'>Secure the gun with a screwdriver first!</span>"
		return
	..()

/obj/item/weapon/gun/energy/laser/modular/dropped(mob/user)
	user.client.view = world.view

/obj/item/weapon/gun/energy/laser/modular/verb/scope()
	set category = "Object"
	set name = "Use Scan-Screen"
	set popup_menu = 1

	zoom()
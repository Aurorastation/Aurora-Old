//My attempt into things
//first block of code taken and modified from twohanded.dm
//HOPEFULLY it provides a result worth.. Keeping.
//Intent: make it so that rifles (ion rifle, laser rifle, whatever) need to be grasped with two hands to be effective
//Method: this below: if wielded, a rifle will have a normal fire_delay; if unwielded, it'll have doubled fire_delay
//
//NOTE: Due to how the parenting is set up, a /rifle/ parent is required for both projectile and energy weapons, seperately. I think. Easiest way of doing this <.<
//Also, may encounter problems with weapons that already have procs in place.
//
//If this works... All I can say is: I expected this to be tonnes harder.
//
//TO DO: Fix the onmob things
//
//CONTAINS:
//Laser Rifle
//Practice Laser
//Ion Rifle
//Sniper Rifle
//Laser Cannon
//Pulse Rifle
//Pulse Destroyed -- you use this, and I'll kill you
//
//--Skull132
//
//	Please check gun.dm for infomation on making a weapon able to be used with two hands
//	- SoundScopes

/obj/item/weapon/gun/energy/rifle/verb/wield()
	set name = "Wield"
	set category = "Object"
	set src in usr

	toggle_wield(usr)

/obj/item/weapon/gun/energy/rifle
	can_wield()
		return 1

	update_icon()
		var/ratio = power_supply.charge / power_supply.maxcharge
		ratio = round(ratio, 0.25) * 100
		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"
		return

/obj/item/weapon/gun/energy/rifle/attack_self(mob/user as mob)
	toggle_wield(user)
	..()

///////////LASER RIFLE//////////////
/obj/item/weapon/gun/energy/rifle/laser
	name = "laser rifle"
	desc = "a basic weapon designed to kill with concentrated energy bolts"
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BACK
	w_class = 4
	matter = list("metal" = 2000)
	charge_cost = 50 //odd numbers due to a requirement to have 20 shots. Easiest way.
	origin_tech = "combat=3;magnets=2"
	projectile_type = "/obj/item/projectile/beam"
	fire_delay_wielded = 6 //6 is normal fire_delay
	fire_delay_unwielded = 24 //4x difference, let's be an arse about this, and push the issue
	force_wielded = 10 //10 is amped force, due to better grip
	force_unwielded = 5 //5 is normal force
	rangedrop = -5 //lasers are more accurate than bullets. fully accurate up to three tiles unaimed. 40% miss at 7 tiles.  aimed: 6 tiles accurate, 10% miss at 7
/*
/obj/item/weapon/gun/energy/rifle/laser/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "laser[wielded]"
	return

Commenting out right now, due to a lack of sprites existing. I hate on-mob weapon sprites...*/

///////////PRACTICE LASER//////////////

/obj/item/weapon/gun/energy/rifle/laser/practice
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	projectile_type = "/obj/item/projectile/beam/practice"
	clumsy_check = 0

	isHandgun()
		return 1


///////////ION RIFLE//////////////

/obj/item/weapon/gun/energy/rifle/ionrifle
	name = "ion rifle"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats"
	icon_state = "ionrifle"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = "combat=2;magnets=4"
	w_class = 4.0
	flags =  FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BACK
	charge_cost = 100
	projectile_type = "/obj/item/projectile/ion"
	fire_delay_wielded = 6 //6 is normal fire_delay
	fire_delay_unwielded = 24 //4x difference, let's be an arse about this, and push the issue
	force_wielded = 10
	force_unwielded = 5

/obj/item/weapon/gun/energy/rifle/ionrifle/emp_act(severity)
	if(severity <= 2)
		power_supply.use(round(power_supply.maxcharge / severity))
		update_icon()
	else
		return

///obj/item/weapon/gun/energy/rifle/ionrifle/update_icon()  //Currently only here to fuck with the on-mob icons.
//	icon_state = "ionrifle[wielded]"
//	return

///////////SNIPER RIFLE//////////////
//This is going to create issues... Yup.
//After initial compile: ooooor not... Wtf.

/obj/item/weapon/gun/energy/rifle/sniperrifle
	name = "L.W.A.P. Sniper Rifle"
	desc = "A rifle constructed of lightweight materials, fitted with a SMART aiming-system scope."
	icon = 'icons/obj/gun.dmi'
	icon_state = "sniper"
	fire_sound = 'sound/weapons/marauder.ogg'
	origin_tech = "combat=6;materials=5;powerstorage=4"
	projectile_type = "/obj/item/projectile/beam/sniper"
	slot_flags = SLOT_BACK
	charge_cost = 250
	fire_delay = 35
	w_class = 4.0
	fire_delay_wielded = 35 //35 is normal fire_delay -- this is going to suck. Yiss, what we want!
	fire_delay_unwielded = 105 //3x difference, let's be an arse about this, and push the issue
	zoomdevicename = "sniper scope"

	accuracy = -110
	rangedrop = -2 // fully accurate up to first 10 tiles.  the last 4 zoomed tiles you are on your

/obj/item/weapon/gun/energy/rifle/sniperrifle/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	zoom()

/obj/item/weapon/gun/energy/rifle/sniperrifle/ready_to_fire()
	if(!zoom)
		return 0
	if(world.time >= last_fired + fire_delay)
		last_fired = world.time
		return 1
	else
		return 0

///////////LASER CANNON//////////////

/obj/item/weapon/gun/energy/rifle/lasercannon
	name = "laser cannon"
	desc = "With the L.A.S.E.R. cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = "combat=4;materials=3;powerstorage=3"
	projectile_type = "/obj/item/projectile/beam/heavylaser"
	slot_flags = SLOT_BACK //Just realized... Going to need A LOT more on-back sprites now... FECK...
	w_class = 4 //original didn't have this... I have no sodding idea as to WHY, seeing that it's a C-A-N-N-O-N! Let's limit all the things!
	fire_delay_wielded = 8
	fire_delay_unwielded = 24

///////////PULSE RIFLE///////////////

/obj/item/weapon/gun/energy/rifle/pulse_rifle
	name = "pulse rifle"
	desc = "A heavy-duty, pulse-based energy weapon, preferred by front-line combat personnel."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	force = 10
	fire_sound = 'sound/weapons/pulse.ogg'
	charge_cost = 200
	projectile_type = "/obj/item/projectile/beam/pulse"
	cell_type = "/obj/item/weapon/cell/super"
	w_class = 4
	slot_flags = SLOT_BACK //Just realized... Going to need A LOT more on-back sprites now... FECK...
	var/mode = 2
	fire_delay_wielded = 8
	fire_delay_unwielded = 24

//	attack_self(mob/living/user as mob)
//Let's do some magical things, make this a verb, yes?
//Needs some testing done, primary concerns: useability (when restrained, etc.) and icon updating
	verb/toggle()
		set name = "Switch weapon mode"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(mode)
			if(2)
				mode = 0
				charge_cost = 100
				fire_sound = 'sound/weapons/Taser.ogg'
				usr << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
			if(0)
				mode = 1
				charge_cost = 100
				fire_sound = 'sound/weapons/Laser.ogg'
				usr << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
			if(1)
				mode = 2
				charge_cost = 200
				fire_sound = 'sound/weapons/pulse.ogg'
				usr << "\red [src.name] is now set to DESTROY."
				projectile_type = "/obj/item/projectile/beam/pulse"
		return

///////////PULSE DESTROYER///////////////
//For the love of fuck, NEVER USE THIS WEAPON

/obj/item/weapon/gun/energy/rifle/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon."
	cell_type = "/obj/item/weapon/cell/infinite"

	attack_self(mob/living/user as mob)
		user << "\red [src.name] has three settings, and they are all DESTROY."

///////////ENERGY RIFLE///////////////

/obj/item/weapon/gun/energy/rifle/gun
	name = "energy rifle"
	desc = "A basic energy-based rifle with two settings: Stun and kill."
	icon = 'icons/obj/erifle.dmi'
	icon_state = "eriflestun100"
	item_state = "laser"	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'

	charge_cost = 50 //How much energy is needed to fire.
	projectile_type = "/obj/item/projectile/energy/electrode"
	origin_tech = "combat=3;magnets=2"
	modifystate = "eriflestun"

	fire_delay_wielded = 4 //6 is normal fire_delay
	fire_delay_unwielded = 24 //4x difference, let's be an arse about this, and push the issue
	force_wielded = 10 //10 is amped force, due to better grip
	force_unwielded = 5 //5 is normal force

	var/mode = 0 //0 = stun, 1 = kill


//	attack_self(mob/living/user as mob)
	verb/toggle()
		set name = "Switch weapon mode"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(mode)
			if(0)
				mode = 1
				charge_cost = 50
				fire_sound = 'sound/weapons/Laser.ogg'
				usr << "\red [src.name] is now set to kill."
				projectile_type = "/obj/item/projectile/beam"
				modifystate = "eriflekill"
			if(1)
				mode = 0
				charge_cost = 50
				fire_sound = 'sound/weapons/Taser.ogg'
				usr << "\red [src.name] is now set to stun."
				projectile_type = "/obj/item/projectile/energy/electrode"
				modifystate = "eriflestun"
		update_icon()

/*
This. Will be a pain. For future refence, shall we? -- Skull132

/obj/item/weapon/gun/energy/rifle/gun/attack_hand(mob/user as mob)
	if(loc == user)
		if(scoped)
			if(user.l_hand != src && user.r_hand != src)
				..()
				return
			user << "<span class='notice'>You detach [scoped] from [src].</span>"
			user.put_in_hands(scoped)
			var/scoped = 0
			update_icon()
			return
	..()

/obj/item/weapon/gun/energy/rifle/gun/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/scope))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		user.drop_item()
		user << "<span class='notice'>You attach [I] onto [src].</span>"
		scoped = I	//dodgy?
		var/scoped = 1
		I.loc = src		//put the silencer into the gun
		update_icon()
		return
	..()

/obj/item/weapon/gun/energy/rifle/gun/update_icon()
	..()
	if(scoped)
		if(mode = 0)
			modifystate = "eriflescopestun"
		else
			modifystate = "eriflescopekill"
	else
		if(mode = 0)
			modifystate = "eriflestun"
		else
			modifystate = "eriflekill"

/obj/item/weapon/scope
	name = "scope"
	desc = "a scope"
	icon = 'icons/obj/erfile.dmi'
	icon_state = "scope"
	w_class = 2

/obj/item/weapon/gun/energy/rifle/gun/verb/zoom()
	set category = "Object"
	set name = "Use Rifle Scope"
	set popup_menu = 0
	if(scoped = 0)
		usr << "You need a scope to look down and focus your aim."
		return
	if(usr.stat || !(istype(usr,/mob/living/carbon/human)))
		usr << "You are unable to focus down the scope of the rifle."
		return
	if(!zoom && global_hud.darkMask[1] in usr.client.screen)
		usr << "Your welding equipment gets in the way of you looking down the scope"
		return
	if(!zoom && usr.get_active_hand() != src)
		usr << "You are too distracted to look down the scope, perhaps if it was in your active hand this might work better"
		return

	if(usr.client.view == world.view)
		if(!usr.hud_used.hud_shown)
			usr.button_pressed_F12(1)	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		usr.button_pressed_F12(1)
		usr.client.view = 12
		zoom = 1
	else
		usr.client.view = world.view
		if(!usr.hud_used.hud_shown)
			usr.button_pressed_F12(1)
		zoom = 0
	usr << "<font color='[zoom?"blue":"red"]'>Zoom mode [zoom?"en":"dis"]abled.</font>"
	return*/


/obj/item/weapon/gun/projectile/laser //butts
	desc = "a basic weapon designed to kill with concentrated energy bolts."
	name = "laser rifle"
	caliber = "laser"
	w_class = 3.0
	recoil = 0
	ammo_type = "/obj/item/ammo_casing/laser"
	max_shells = 100
	load_method = 2 //0 = Single shells or quick loader, 1 = box, 2 = magazine
	fire_delay = 6
	ejectshell = 0
	slot_flags = SLOT_BACK
	var/modded = 0
	var/obj/item/weapon/reloadlasermodkit/mod

	//placeholders//
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	//placeholders//  Well, okay, not the sound.

	New()
		for(var/i = 1, i <= 30, i++)
			loaded += new ammo_type(src)
			update_icon()

		empty_mag = new /obj/item/ammo_magazine/laser/empty(src)
		update_icon()
		return

//////////
//Wielding
//////////
	icon_action_button = "action_blank"
	action_button_name = "Wield the rifle"
	can_wield()
		return 1

/obj/item/weapon/gun/projectile/laser/ui_action_click()
	if( src in usr )
		toggle_wield(usr)
	return

/obj/item/weapon/gun/projectile/laser/verb/wield()
	set name = "Wield"
	set category = "Object"
	set src in usr

	toggle_wield(usr)
//////////////
//End Wielding
//////////////


/obj/item/ammo_magazine/laser/empty
	max_ammo = 0

/obj/item/ammo_magazine/laser
	name = "charge cell (laser)"
	desc = "A standard 30-shot cell."
	icon_state = "12mm"
	origin_tech = "combat=2"
	ammo_type = "/obj/item/ammo_casing/laser"
	max_ammo = 30
//	multiple_sprites = 1

/obj/item/ammo_magazine/laser/pulse
	name = "charge cell (pulse)"
	desc = "A heavy-duty 15-shot pulse cell."
	ammo_type = "/obj/item/ammo_casing/laser/pulse"
	max_ammo = 15

/obj/item/ammo_magazine/laser/heavy
	name = "charge cell (heavy)"
	desc = "A 15-shot cell designed to overload your projectiles with an extremely heavy charge."
	ammo_type = "/obj/item/ammo_casing/laser/heavy"
	max_ammo = 15

/obj/item/ammo_magazine/laser/practice
	name = "charge cell (practice)"
	desc = "A hundred-shot cell keyed in to a harmless wavelength for practice shooting."
	ammo_type = "/obj/item/ammo_casing/laser/practice"
	max_ammo = 100

/obj/item/ammo_magazine/laser/light
	name = "charge cell (light)"
	desc = "A 60-shot cell designed with capacity in mind.  The lasers are weaker, though."
	ammo_type = "/obj/item/ammo_casing/laser/light"
	max_ammo = 60

/obj/item/ammo_magazine/laser/stun
	name = "charge cell (stun)"
	desc = "A 20-shot cell that fires lethal incapacitating bolts.  Not standard issue."
	ammo_type = "/obj/item/ammo_casing/laser/stun"
	max_ammo = 20

////////////////////////////
//Shells for the magazines//
////////////////////////////

//don't spawn these you butts//

/obj/item/ammo_casing/laser
	desc = "A LASER SHELL.  You shouldn't be seeing this."
	caliber = "laser"
	projectile_type = "/obj/item/projectile/beam"

/obj/item/ammo_casing/laser/pulse
	desc = "A PULSE SHELL.  You shouldn't be seeing this."
	caliber = "laser"
	projectile_type = "/obj/item/projectile/beam/pulse"

/obj/item/ammo_casing/laser/heavy
	desc = "A LASER CANNON SHELL.  You shouldn't be seeing this."
	caliber = "laser"
	projectile_type = "/obj/item/projectile/beam/heavylaser"

/obj/item/ammo_casing/laser/practice
	desc = "A PRACTICE BLANK FAKE LASER SHELL.  You shouldn't be seeing this."
	caliber = "laser"
	projectile_type = "/obj/item/projectile/beam/practice"

/obj/item/ammo_casing/laser/light
	desc = "A LIGHT LASER XRAY SHELL.  You shouldn't be seeing this."
	caliber = "laser"
	projectile_type = "/obj/item/projectile/beam/xray/burst"

/obj/item/ammo_casing/laser/stun
	desc = "A STUN LASER SHELL.  You shouldn't be seeing this."
	caliber = "laser"
	projectile_type = "/obj/item/projectile/beam/stun"


////////////////////////////////
//////////////mods//////////////
////////////////////////////////

/obj/item/weapon/reloadlasermodkit
	desc = "A cheap, disposable modkit designed to rapidly and permanently augment NT-standard laser rifles."
	name = "rifle nanokit"
	var/modtype = 0
	var/uses = 1
	var/emagged
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain" //the placeholders are real

/* Not sure about this yet.
/obj/item/device/megaphone/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		user << "\red You sneakily unlock the highly illegal military-grade burstfire augment."
		emagged = 1
		return
	return
*/
/obj/item/weapon/reloadlasermodkit/attack_self(var/mob/user as mob)

	if (!emagged)
		if (modtype == 0)
			user << "<span class='notice'>Size modification selected.</span>"
			modtype = 1
		else if (modtype == 1)
			user << "<span class='notice'>Rapid-fire modification selected.</span>"
			modtype = 2
		else if (modtype == 2)
			user << "<span class='notice'>Silencer modification selected.</span>"
			modtype = 0
	else if (emagged) //We'll see.  Burst is ridiculous, especially on a full-power laser.
		user << "<span class='notice'>Burstfire modification selected.</span>"
		modtype = 3

/obj/item/weapon/gun/projectile/laser/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/reloadlasermodkit))
		if(user.l_hand != src && user.r_hand != src)	//if we're not in his hands
			user << "<span class='notice'>You'll need [src] in your hands to do that.</span>"
			return
		if(src.modded == 1)
			user << "<span class='notice'>The frame can only handle one mod.</span>"
			return
		user.drop_item()
		user << "<span class='notice'>You activate the modkit and watch the nanites swarm over [src].</span>"
		I.loc = src.mod
		src.mod = I
		src.modded = 1
		if (mod.modtype == 0)
			user << "<span class='notice'>[src]'s firerate has been increased.</span>"
			src.fire_delay = 4
		else if (mod.modtype == 1)
			user << "<span class='notice'>[src]'s shape changes rapidly, becoming smaller and more economical.</span>"
			src.w_class = 3
		else if (mod.modtype == 2)
			user << "<span class='notice'>[src] sprouts wave-cancelling emitters.  Its shots are now silenced.</span>"
			src.silenced = 1
		else if (mod.modtype == 3)
			user << "<span class='notice'>[src] rapidly reshapes its firing mechanism.  It now fires in bursts.</span>"
			src.fire_delay = 0
			src.projectiles_per_shot = 3
			src.fire_cooldown = 1
			fire_sound = 'sound/weapons/Gunshot_smg.ogg'
		return
	..()

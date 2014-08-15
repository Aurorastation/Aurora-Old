/obj/item/weapon/gun/energy/automatic/
	name = "you shouldnt have spawned this"
	desc = "this gun only exists to hold variables in the code.  please delete."
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = "combat=5;materials=3;magnets=2"
	projectile_type = "/obj/item/projectile/beam/xray/burst"
	w_class = 3
	fire_delay = 0
	projectiles_per_shot = 3 //more than three and adminlogs will cry
	fire_cooldown = 2

//How burst weapons work.  Firedelay should always, always be 0 if and when burstfire is toggled on.  Its function is replaced by fire_cooldown, which triggers after
//a burst.
/*
/obj/item/weapon/gun/energy/automatic/verb/toggle_burst()
	set name = "Toggle Burst"
	set category = "Object"

	if (projectiles_per_shot == 3)
		loc << "\red [src.name] is now set to single shot.."
		projectiles_per_shot = 1
		fire_cooldown = 0
	else
		loc << "\red [src.name] is now set to fire in bursts."
		projectiles_per_shot = 3
		fire_cooldown = 2
	update_icon()
*/
/obj/item/weapon/gun/energy/automatic/rapidlaser
	name = "rapid laser gun"
	desc = "A high-power laser gun capable of expelling rapid bursts of concentrated xray blasts."
	icon_state = "xray"
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = "combat=5;materials=3;magnets=2"
	projectile_type = "/obj/item/projectile/beam/xray/burst"
	charge_cost = 33
	w_class = 3

/obj/item/weapon/gun/energy/automatic/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon."
	cell_type = "/obj/item/weapon/cell/infinite"
	projectile_type = "/obj/item/projectile/beam/pulse"
	fire_sound = 'sound/weapons/pulse.ogg'
	icon_state = "pulse"
	item_state = null
	w_class = 4
	slot_flags = SLOT_BACK
	force = 666
	charge_cost = 0
	projectiles_per_shot = 10
	fire_cooldown = 0
	fire_delay = 0
	attack_self(mob/living/user as mob)
		user << "\red [src.name] has three settings, and they are all DESTROY."
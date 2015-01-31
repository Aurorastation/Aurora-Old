// Gravity Generator
var/list/gravity_field_generators = list() // We will keep track of this by adding new gravity generators to the list, and keying it with the z level.

#define POWER_IDLE 0
#define POWER_UP 1
#define POWER_DOWN 2

#define GRAV_NEEDS_SCREWDRIVER 0
#define GRAV_NEEDS_WELDING 1
#define GRAV_NEEDS_PLASTEEL 2
#define GRAV_NEEDS_WRENCH 3

#define AREA_ERRNONE 0
#define AREA_STATION 1
#define AREA_SPACE 2
#define AREA_SPECIAL 3
//
// Abstract Generator
//

/client/proc/cmd_dev_reset_gravity()
	set category = "Debug"
	set name = "Restore Default Gravity"
	set desc = "Resets all gravity on the entire server."

	if(!check_rights(R_DEBUG|R_DEV))	return

	if(!holder)
		return //how did they get here?

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "\red The game hasn't started yet!"
		return

	if(alert(usr, "Make people fall on their face?", "Restore gravity", "No", "Yes") == "No")
		return 0

	world << "\red \b Resetting Gravity Simulation."
	gravity_is_on = 1
	spawn(1)
		for(var/area/A in world)
			if(A.name == "Space")
				continue

			A.has_gravity = 1
			for(var/area/SubA in A.related)
				SubA.has_gravity = 1
				for(var/mob/living/carbon/human/M in SubA)
					M:float(0)
		world << "\red Gravity Simulation reset."

	feedback_add_details("admin_verb","RSG")

/client/proc/cmd_dev_reset_floating()
	set category = "Debug"
	set name = "Reset floating mobs"
	set desc = "Stops all mobs floating instantly."

	if(!check_rights(R_DEBUG|R_DEV))	return

	if(!holder)
		return //how did they get here?

	if(!ticker)
		alert("Wait until the game starts")
		return

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "\red The game hasn't started yet!"
		return

	for(var/mob/living/M in world)
		M.float(0)

	feedback_add_details("admin_verb","RSF")

/obj/machinery/gravity_field_generator
	name = "gravitational generator"
	desc = "A device which produces a graviton field when set up."
	icon = 'Scopes Files/gravity_generator.dmi'
	anchored = 1
	density = 1
	use_power = 0
	unacidable = 1
	var/sprite_number = 0

/obj/machinery/gravity_field_generator/ex_act(severity)
	if(severity == 1) // Very sturdy.
		set_broken()

/obj/machinery/gravity_field_generator/update_icon()
	..()
	icon_state = "[get_status()]_[sprite_number]"

/obj/machinery/gravity_field_generator/proc/get_status()
	return "off"

// You aren't allowed to move.
/obj/machinery/gravity_field_generator/Move()
	..()
	del(src)

/obj/machinery/gravity_field_generator/proc/set_broken()
	stat |= BROKEN

/obj/machinery/gravity_field_generator/proc/set_fix()
	stat &= ~BROKEN

/obj/machinery/gravity_field_generator/part/Del()
	set_broken()
	if(main_part)
		del(main_part)
	..()

//
// Part generator which is mostly there for looks
//

/obj/machinery/gravity_field_generator/part
	var/obj/machinery/gravity_field_generator/main/main_part = null

/obj/machinery/gravity_field_generator/part/attackby(obj/item/I as obj, mob/user as mob)
	return main_part.attackby(I, user)

/obj/machinery/gravity_field_generator/part/get_status()
	return main_part.get_status()

/obj/machinery/gravity_field_generator/part/attack_hand(mob/user as mob)
	return main_part.attack_hand(user)

/obj/machinery/gravity_field_generator/part/set_broken()
	..()
	if(main_part && !(main_part.stat & BROKEN))
		main_part.set_broken()

//
// Generator which spawns with the station.
//

/obj/machinery/gravity_field_generator/main/station/initialize()
	setup_parts()
	middle.overlays += "activated"
	log_debug("Gravity Generator spawned: initialize()")
	update_list()

//
// Generator an admin can spawn
//

/obj/machinery/gravity_field_generator/main/station/admin/New()
	..()
	round_start = 1
	initialize()

//
// Main Generator with the main code
//

/obj/machinery/gravity_field_generator/main
	icon_state = "on_8"
	idle_power_usage = 0
	active_power_usage = 12000
	power_channel = ENVIRON
	sprite_number = 8
	use_power = 1
	var/on = 1
	var/breaker = 1
	var/list/parts = list()
	var/obj/middle = null
	var/charging_state = POWER_IDLE
	var/charge_count = 100
	var/current_overlay = null
	var/broken_state = 0
	var/list/localareas = list()
	var/effectiverange = 255  //Currently unused due to errors
	var/round_start = 2 //To help stop a bug with round start
	var/has_been_charged = 0

/obj/machinery/gravity_field_generator/main/Del() // If we somehow get deleted, remove all of our other parts.
	log_debug("Gravity Generator Destroyed")
	investigate_log("was destroyed!", "gravity")
	captain_announce("Gravity generator: location missing!")
	on = 0
	update_list()
	for(var/obj/machinery/gravity_field_generator/part/O in parts)
		O.main_part = null
		del(O)
	..()

/obj/machinery/gravity_field_generator/main/proc/setup_parts()
	var/turf/our_turf = get_turf(src)
	// 9x9 block obtained from the bottom middle of the block
	var/list/spawn_turfs = block(locate(our_turf.x - 1, our_turf.y + 2, our_turf.z), locate(our_turf.x + 1, our_turf.y, our_turf.z))
	var/count = 10
	for(var/turf/T in spawn_turfs)
		count--
		if(T == our_turf) // Skip our turf.
			continue
		var/obj/machinery/gravity_field_generator/part/part = new(T)
		if(count == 5) // Middle
			middle = part
		if(count <= 3) // Their sprite is the top part of the generator
			part.density = 0
			part.layer = MOB_LAYER + 0.1
		part.sprite_number = count
		part.main_part = src
		parts += part
		part.update_icon()

/obj/machinery/gravity_field_generator/main/proc/connected_parts()
	return parts.len == 8

/obj/machinery/gravity_field_generator/main/set_broken()
	..()
	for(var/obj/machinery/gravity_field_generator/M in parts)
		if(!(M.stat & BROKEN))
			M.set_broken()
	middle.overlays.Cut()
	charge_count = 0
	breaker = 0
	set_power()
	set_state(0)
	investigate_log("has broken down.", "gravity")

/obj/machinery/gravity_field_generator/main/set_fix()
	..()
	for(var/obj/machinery/gravity_field_generator/M in parts)
		if(M.stat & BROKEN)
			M.set_fix()
	broken_state = 0
	update_icon()
	set_power()

// Interaction

// Fixing the gravity generator.
/obj/machinery/gravity_field_generator/main/attackby(obj/item/I as obj, mob/user as mob)
	var/old_broken_state = broken_state
	switch(broken_state)
		if(GRAV_NEEDS_SCREWDRIVER)
			if(istype(I, /obj/item/weapon/screwdriver))
				user << "<span class='notice'>You secure the screws of the framework.</span>"
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
				broken_state++
		if(GRAV_NEEDS_WELDING)
			if(istype(I, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = I
				if(WT.remove_fuel(1, user))
					user << "<span class='notice'>You mend the damaged framework.</span>"
					playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
					broken_state++
		if(GRAV_NEEDS_PLASTEEL)
			if(istype(I, /obj/item/stack/sheet/plasteel))
				var/obj/item/stack/sheet/plasteel/PS = I
				if(PS.amount >= 10)
					PS.use(10)
					user << "<span class='notice'>You add the plating to the framework.</span>"
					playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
					broken_state++
				else
					user << "<span class='notice'>You need 10 sheets of plasteel.</span>"
		if(GRAV_NEEDS_WRENCH)
			if(istype(I, /obj/item/weapon/wrench))
				user << "<span class='notice'>You secure the plating to the framework.</span>"
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				set_fix()
		else
			..()
	if(old_broken_state != broken_state)
		update_icon()

/obj/machinery/gravity_field_generator/main/attack_hand(mob/user as mob)
	if(!..())
		return interact(user)

/obj/machinery/gravity_field_generator/main/interact(mob/user as mob)
	if(stat & BROKEN)
		return
	var/dat = "Gravity Generator Breaker: "
	if(breaker)
		dat += "<span class='linkOn'>ON</span> <A href='?src=\ref[src];gentoggle=1'>OFF</A>"
	else
		dat += "<A href='?src=\ref[src];gentoggle=1'>ON</A> <span class='linkOn'>OFF</span> "

	dat += "<br>Generator Status:<br><div class='statusDisplay'>"
	if(charging_state != POWER_IDLE)
		dat += "<font class='bad'>WARNING</font> Radiation Detected. <br>[charging_state == POWER_UP ? "Charging..." : "Discharging..."]"
	else if(on)
		dat += "Powered."
	else
		dat += "Unpowered."

	dat += "<br>Gravity Charge: [charge_count]%</div>"

	var/datum/browser/popup = new(user, "gravgen", name)
	popup.set_content(dat)
	popup.open()


/obj/machinery/gravity_field_generator/main/Topic(href, href_list)

	if(..())
		return

	if(href_list["gentoggle"])
		if(charging_state != POWER_IDLE)
			return 0
		breaker = !breaker
		investigate_log("was toggled [breaker ? "<font color='green'>ON</font>" : "<font color='red'>OFF</font>"] by [usr.key].", "gravity")
		set_power()
		spawn(2)
			src.updateUsrDialog()

// Power and Icon States

/obj/machinery/gravity_field_generator/main/power_change()
	..()
	investigate_log("has [stat & NOPOWER ? "lost" : "regained"] power.", "gravity")
	set_power()

/obj/machinery/gravity_field_generator/main/get_status()
	if(stat & BROKEN)
		return "fix[min(broken_state, 3)]"
	return on || charging_state != POWER_IDLE ? "on" : "off"

/obj/machinery/gravity_field_generator/main/update_icon()
	..()
	for(var/obj/O in parts)
		O.update_icon()

// Set the charging state based on power/breaker.
/obj/machinery/gravity_field_generator/main/proc/set_power()
	var/new_state = 0
	if(stat & (NOPOWER|BROKEN) || !breaker)
		new_state = 0
	else if(breaker)
		new_state = 1

	charging_state = new_state ? POWER_UP : POWER_DOWN // Startup sequence animation.
	investigate_log("is now [charging_state == POWER_UP ? "charging" : "discharging"].", "gravity")
	update_icon()

// Set the state of the gravity.
/obj/machinery/gravity_field_generator/main/proc/set_state(var/new_state)
	charging_state = POWER_IDLE
	on = new_state
	use_power = on ? 2 : 1
	// Sound the alert if gravity was just enabled or disabled.
	var/alert = 0
	var/area/area = get_area(src)
	if(new_state) // If we turned on
		if(has_been_charged)
			return
		if(gravity_in_level() == 0)
			alert = 1
			gravity_is_on = 1
			investigate_log("was brought online and is now producing gravity for this level.", "gravity")
			message_admins("The gravity generator was brought online. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>[area.name]</a>)")
	else
		if(gravity_in_level() == 1)
			alert = 1
			gravity_is_on = 0
			captain_announce("Gravity generator: shutdown successful.")
			investigate_log("was brought offline and there is now no gravity for this level.", "gravity")
			message_admins("The gravity generator was brought offline with no backup generator. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>[area.name]</a>)")
			message_mods("The gravity generator was brought offline with no backup generator. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>[area.name]</a>)")


	update_icon()
	update_list()
	src.updateUsrDialog()
	if(alert)
		shake_everyone()

// Charge/Discharge and turn on/off gravity when you reach 0/100 percent.
// Also emit radiation and handle the overlays.
/obj/machinery/gravity_field_generator/main/process()
	if(stat & BROKEN)
		return
	if(charging_state != POWER_IDLE)
		if(charging_state == POWER_UP && charge_count >= 100)
			set_state(1)
			has_been_charged = 1
		else if(charging_state == POWER_DOWN && charge_count <= 0)
			set_state(0)
			has_been_charged = 0
		else
			if(charging_state == POWER_UP)
				charge_count += 2
			else if(charging_state == POWER_DOWN)
				charge_count -= 2

			if(charge_count % 4 == 0 && prob(75)) // Let them know it is charging/discharging.
				playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)

			updateDialog()
			if(prob(25)) // To help stop "Your clothes feel warm" spam.
				pulse_radiation()

			var/overlay_state = null
			switch(charge_count)
				if(0 to 20)
					overlay_state = null
				if(21 to 40)
					overlay_state = "startup"
				if(41 to 60)
					overlay_state = "idle"
				if(61 to 80)
					overlay_state = "activating"
				if(81 to 100)
					overlay_state = "activated"

			if(overlay_state != current_overlay)
				if(middle)
					middle.overlays.Cut()
					if(overlay_state)
						middle.overlays += overlay_state
					current_overlay = overlay_state


/obj/machinery/gravity_field_generator/main/proc/pulse_radiation()
	for(var/mob/living/L in view(7, src))
		L.apply_effect(20, IRRADIATE)

// Shake everyone on the z level to let them know that gravity was enagaged/disenagaged.
/obj/machinery/gravity_field_generator/main/proc/shake_everyone()
	var/turf/our_turf = get_turf(src)
	for(var/mob/M in mob_list)
		var/turf/their_turf = get_turf(M)
		if(!their_turf) continue
		if(their_turf.z == our_turf.z)
			M.update_gravity(M.mob_has_gravity())
			if(M.client)
				if(!M)	continue
				shake_camera(M, 5, 1)
				M.playsound_local(our_turf, 'sound/effects/alert.ogg', 100, 1, 0.5)

/obj/machinery/gravity_field_generator/main/proc/gravity_in_level()
	var/turf/T = get_turf(src)
	if(!T)
		return 0
	if(gravity_field_generators["[T.z]"])
		return length(gravity_field_generators["[T.z]"])
	return 0

/obj/machinery/gravity_field_generator/main/proc/update_list()
	var/turf/T = get_turf(src.loc)
	if(T)
		if(!gravity_field_generators["[T.z]"])
			gravity_field_generators["[T.z]"] = list()
		if(on)
			msg_scopes("Well here is a list of people on their face")
			for(var/area/A in localareas)
				A.has_gravity = 1
				if(round_start)
					A.gravitychange(A.has_gravity,A,1)
				else
					A.gravitychange(A.has_gravity,A)
			if(round_start >= 1)
				round_start--
			gravity_field_generators["[T.z]"] |= src
		else
			msg_scopes("Here is a lovely list of floaty people")
			for(var/area/A in localareas)
				A.has_gravity = 0
				A.gravitychange(A.has_gravity,A)
			gravity_field_generators["[T.z]"] -= src


//because the whole movement system needs changing, this hack will work for the main station
//Not counting the outposts as part of the station
/obj/machinery/gravity_field_generator/main/proc/get_area_type(var/area/A = get_area())
	if (A.name == "Space")
		return AREA_SPACE
	var/list/SPECIALS = list(
		/area/start,
		/area/shuttle,
		/area/admin,
		/area/arrival,
		/area/centcom,
		/area/asteroid,
		/area/tdome,
		/area/syndicate_station,
		/area/syndicate_mothership,
		/area/wizard_station,
		/area/vox_station,
		/area/prison,
		/area/mine,
		/area/research_outpost,
		/area/derelict,
		/area/djstation,
		/area/tcommsat,
		/area/AIsattele,
		/area/asteroid,
		/area/planet,
		/area/prison,
		/area/awaymission,
		/area/engi,
		/area/solar/derelict_starboard,
		/area/solar/derelict_aft,
		/area/turret_protected/tcomsat,
		/area/turret_protected/tcomfoyer,
		/area/turret_protected/tcomwest,
		/area/turret_protected/tcomeast,
		/area/alien
	)
	for (var/type in SPECIALS)
		if ( istype(A,type) )
			if(A.type == /area/prison/gas_chamber)
				return AREA_STATION
			return AREA_SPECIAL
	return AREA_STATION


// Misc

/obj/item/weapon/paper/gravity_gen
	name = "paper- 'Generate your own gravity!'"
	info = {"<h1>Gravity Generator Instructions For Dummies</h1>
	<p>Surprisingly, gravity isn't that hard to make! All you have to do is inject deadly radioactive minerals into a ball of
	energy and you have yourself gravity! You can turn the machine on or off when required but you must remember that the generator
	will EMIT RADIATION when charging or discharging, you can tell it is charging or discharging by the noise it makes, so please WEAR PROTECTIVE CLOTHING.</p>
	<br>
	<h3>It blew up!</h3>
	<p>Don't panic! The gravity generator was designed to be easily repaired. If, somehow, the sturdy framework did not survive then
	please proceed to panic; otherwise follow these steps.</p><ol>
	<li>Secure the screws of the framework with a screwdriver.</li>
	<li>Mend the damaged framework with a welding tool.</li>
	<li>Add additional plasteel plating.</li>
	<li>Secure the additional plating with a wrench.</li></ol>"}


//Yeah so this is my hack to find all the areas on the station
//Very bad idea but it works.
/obj/machinery/gravity_field_generator/main/New()
	..()
	spawn(5)
//		locatelocalareas()
		log_debug("Gravity Generator loading area list")
		for(var/area/A in world)
			if(!(get_area_type(A) == AREA_STATION) || (A.master in localareas))
				continue
			localareas += A.master
		return
	return

/*
//This thing didn't want to work no matter how I set it up
/obj/machinery/gravity_field_generator/main/proc/locatelocalareas()
	for(var/area/A in range(255,src)
		if(A.name == "Space")
			continue // No (de)gravitizing space.
		if(get_area_type(A) == AREA_SPECIAL)
			continue
		if((istype(A, /area/vox_station)) || (istype(A, /area/syndicate_station)) || (istype(A, /area/shuttle)))
			continue
		if(A.master && !( A.master in localareas) )
			localareas += A.master*/
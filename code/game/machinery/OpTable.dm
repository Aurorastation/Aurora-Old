/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	var/modify_state = "table2"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0
	var/opened = 0

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/optable(src)
	component_parts += new /obj/item/weapon/cable_coil(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(src)
	component_parts += new /obj/item/device/healthanalyzer(src)

	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break

/obj/machinery/optable/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.density = 0
		else
	return

/obj/machinery/optable/blob_act()
	if(prob(75))
		del(src)

/obj/machinery/optable/attack_paw(mob/user as mob)
	if ((HULK in usr.mutations))
		usr << text("\blue You destroy the operating table.")
		visible_message("\red [usr] destroys the operating table!")
		src.density = 0
		del(src)
	if (!( locate(/obj/machinery/optable, user.loc) ))
		step(user, get_dir(user, src))
		if (user.loc == src.loc)
			user.layer = TURF_LAYER
			visible_message("The monkey hides under the table!")
	return

/obj/machinery/optable/attack_hand(mob/user as mob)
	if (HULK in usr.mutations)
		usr << text("\blue You destroy the table.")
		visible_message("\red [usr] destroys the operating table!")
		src.density = 0
		del(src)
	return

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/machinery/optable/MouseDrop_T(obj/O as obj, mob/user as mob)

	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/machinery/optable/update_icon()
	if (opened)
		icon_state = "[modify_state]-open"
	else if (victim)
		icon_state = victim.pulse ? "[modify_state]-active" : "[modify_state]-idle"
	else
		icon_state = "[modify_state]-idle"

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, loc)
		if(M.lying)
			victim = M
			return 1
	victim = null
	return 0

/obj/machinery/optable/process()
	check_victim()
	update_icon()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if (C == user)
		user.visible_message("[user] climbs on the operating table.","You climb on the operating table.")
	else
		visible_message("\red [C] has been laid on the operating table by [user].", 3)
	C.resting = 1
	C.loc = src.loc
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
		icon_state = H.pulse ? "[modify_state]-active" : "[modify_state]-idle"
	else
		icon_state = "[modify_state]-idle"

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return

	if (opened)
		return

	take_victim(usr,usr)

/obj/machinery/optable/attackby(obj/item/weapon/W as obj, mob/living/carbon/user as mob)
	if (opened)
		if (istype(W, /obj/item/weapon/crowbar))
			playsound(loc, 'sound/items/Crowbar.ogg')
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
					reagents.trans_to(I, reagents.total_volume)
				if(I.reliability != 100 && crit_fail)
					I.crit_fail = 1
				I.loc = src.loc
			del(src)
			return 1

	if (istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(iscarbon(G.affecting) && check_table(G.affecting))
			take_victim(G.affecting,usr)
			del(W)
			return 1

	if (!victim)
		if (istype(W, /obj/item/weapon/screwdriver))
			switch (opened)
				if (0)
					opened = 1
					if (computer)
						computer.table = null
						computer = null
					icon_state = "[modify_state]-open"
					user << "You open the maintenance hatch of [src]."
					return 1
				if (1)
					opened = 0
					for(dir in list(NORTH,EAST,SOUTH,WEST))
						computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
						if (computer)
							computer.table = src
							break
					icon_state = "[modify_state]-idle"
					user << "You close the maintenance hatch of [src]."
					return 1

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient as mob)
	if(src.victim)
		usr << "\blue <B>The table is already occupied!</B>"
		return 0

	if(patient.buckled)
		usr << "\blue <B>Unbuckle first!</B>"
		return 0

	return 1

/obj/machinery/optable/proc/onlifesupport()
	return 0

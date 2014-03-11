var/engineering_shuttle_tickstomove = 10
var/engineering_shuttle_moving = 0
var/engineering_shuttle_location = 0 // 0 = station 13, 1 = engineering outpost

proc/move_engineering_shuttle()
	if(engineering_shuttle_moving)	return
	engineering_shuttle_moving = 1
	spawn(engineering_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (engineering_shuttle_location == 1)
			fromArea = locate(/area/shuttle/engineering/outpost)
			toArea = locate(/area/shuttle/engineering/station)

		else
			fromArea = locate(/area/shuttle/engineering/station)
			toArea = locate(/area/shuttle/engineering/outpost)

		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/

			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		for(var/mob/living/simple_animal/pest in toArea) // And for the other kind of bug...
			pest.gib()

		fromArea.move_contents_to(toArea)
		if (engineering_shuttle_location)
			engineering_shuttle_location = 0
		else
			engineering_shuttle_location = 1

		for(var/mob/M in toArea)
			if(M.client)
				spawn(0)
					if(M.buckled)
						shake_camera(M, 3, 1) // buckled, not a lot of shaking
					else
						shake_camera(M, 10, 1) // unbuckled, HOLY SHIT SHAKE THE ROOM
			if(istype(M, /mob/living/carbon))
				if(!M.buckled)
					M.Weaken(3)

		engineering_shuttle_moving = 0
	return

/obj/machinery/computer/engineering_shuttle
	name = "engineering shuttle console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "shuttle"
	req_access = list(access_engine)
	circuit = "/obj/item/weapon/circuitboard/engineering_shuttle"
	var/hacked = 0
	var/location = 0 //0 = station, 1 = engineering base

/obj/machinery/computer/engineering_shuttle/attack_hand(user as mob)
	if(..(user))
		return
	src.add_fingerprint(usr)
	var/dat

	dat = "<center>Engineering Shuttle Control<hr>"

	if(engineering_shuttle_moving)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		dat += "Location: [engineering_shuttle_location ? "Outpost" : "Station"] <br>"

	dat += "<b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>"


	user << browse("[dat]", "window=engineeringshuttle;size=200x150")

/obj/machinery/computer/engineering_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if(href_list["move"])
		//if(ticker.mode.name == "blob")
		//	if(ticker.mode:declared)
		//		usr << "Under directive 7-10, [station_name()] is quarantined until further notice."
		//		return

		if (!engineering_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_engineering_shuttle()
		else
			usr << "\blue Shuttle is already moving."

	updateUsrDialog()

/obj/machinery/computer/engineering_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"

	else if(istype(W, /obj/item/weapon/screwdriver))
		playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
			var/obj/item/weapon/circuitboard/engineering_shuttle/M = new /obj/item/weapon/circuitboard/engineering_shuttle( A )
			for (var/obj/C in src)
				C.loc = src.loc
			A.circuit = M
			A.anchored = 1

			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				new /obj/item/weapon/shard( src.loc )
				A.state = 3
				A.icon_state = "3"
			else
				user << "\blue You disconnect the monitor."
				A.state = 4
				A.icon_state = "4"

			del(src)

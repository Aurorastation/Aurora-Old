/obj/structure/stool/bed/couch	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "couch"
	desc = "You sit in this or lay on it. Either will do."
	icon_state = "couch"
	icon = 'AuroraSoundFiles/Couches.dmi'

/obj/structure/stool/bed/couch/proc/update_adjacent()
	for(var/direction in list(1,2,4,8,5,6,9,10))
		if(locate(/obj/structure/stool/bed/couch,get_step(src,direction)))
			var/obj/structure/table/T = locate(/obj/structure/stool/bed/couch,get_step(src,direction))
			T.update_icon()

/obj/structure/stool/bed/couch/New()
	..()
	for(var/obj/structure/table/T in src.loc)
		if(T != src)
			del(T)
	update_icon()
	update_adjacent()

/obj/structure/stool/bed/couch/Del()
	update_adjacent()
	..()


/obj/structure/stool/bed/couch/MouseDrop(atom/over_object)
	return

/obj/structure/stool/bed/couch/New()
	if(anchored)
		src.verbs -= /atom/movable/verb/pull
	..()
	//spawn(3)	//Not needed ???
	//	handle_rotation()
	return

/obj/structure/stool/bed/couch/update_icon()
	spawn(2) //So it properly updates when deleting

		var/dir_sum = 0
		for(var/direction in list(1,2,4,8))
			var/skip_sum = 0
			for(var/obj/structure/window/W in src.loc)
				if(W.dir == direction) //So smooth tables don't go smooth through windows
					skip_sum = 1
					continue
			var/inv_direction //inverse direction
			switch(direction)
				if(1)
					inv_direction = 2
				if(2)
					inv_direction = 1
				if(4)
					inv_direction = 8
				if(8)
					inv_direction = 4

			for(var/obj/structure/window/W in get_step(src,direction))
				if(W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
					skip_sum = 1
					continue
			if(!skip_sum) //means there is a window between the two tiles in this direction
				var/obj/structure/stool/bed/couch/T = locate(/obj/structure/stool/bed/couch,get_step(src,direction))
				if(T)
					if(direction <5)
						dir_sum += direction

		var/table_type = 0 //stand_alone table
		if(dir_sum%16 in cardinal)
			table_type = 1 //endtable
			dir_sum %= 16
		if(dir_sum%16 in list(3,12))
			table_type = 2 //1 tile thick, streight table
			if(dir_sum%16 == 3) //3 doesn't exist as a dir
				dir_sum = 2
			if(dir_sum%16 == 12) //12 doesn't exist as a dir.
				dir_sum = 4
		if(dir_sum%16 in list(5,6,9,10))
			if(locate(/obj/structure/table,get_step(src.loc,dir_sum%16)))
				table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
			else
				table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
			dir_sum %= 16

		switch(table_type)
			if(0)
				icon_state = "table"
			if(1)
				icon_state = "couchblackleft"
			if(2)
				icon_state = "couchblackright"
			if(3)
				icon_state = "tabledir"
			if(4)
				icon_state = "table_middle"
			if(5)
				icon_state = "tabledir2"
			if(6)
				icon_state = "tabledir3"
		if (dir_sum in list(1,2,4,8))
			dir = dir_sum
		else
			dir = 2


/obj/structure/stool/bed/couch/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	/*
	if(istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			user << "<span class='notice'>[SK] is not ready to be attached!</span>"
			return
		user.drop_item()
		var/obj/structure/stool/bed/couch/e_chair/E = new /obj/structure/stool/bed/couch/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		del(src)
*/

/obj/structure/stool/bed/couch/attack_tk(mob/user as mob)
	return
/*	if(buckled_mob)
		..()
	else
		rotate()
	return
*/

/*
/obj/structure/stool/bed/couch/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		src.dir = turn(src.dir, 90)
		handle_rotation()
		return
	else
		if(istype(usr,/mob/living/simple_animal/mouse))
			return
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return

		src.dir = turn(src.dir, 90)
		handle_rotation()
		return
*/

/obj/structure/stool/bed/couch/MouseDrop_T(mob/M as mob, mob/user as mob)
	return
/*	if(!istype(M)) return
	buckle_mob(M, user)
	return
*/

// couch types
/*
/obj/structure/stool/bed/couch/comfy
	name = "comfy couch"
	desc = "It looks comfy."
*/
/obj/structure/stool/bed/couch/brown
	icon_state = "comfycouch_brown"

/obj/structure/stool/bed/couch/beige
	icon_state = "comfycouch_beige"

/obj/structure/stool/bed/couch/teal
	icon_state = "comfycouch_teal"

/obj/structure/stool/bed/couch/black
	icon_state = "comfycouch_black"
/obj/item/device/isocube
	name = "Isocube"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	desc = "two weeks in the isocubes."
	w_class = 3
	unacidable = 1
	flags = FPRINT | TABLEPASS
	slot_flags = SLOT_BELT
	origin_tech = "bluespace=4;materials=4"



//////////////////////////////Capturing////////////////////////////////////////////////////////

	attack(mob/living/carbon/human/M as mob, mob/user as mob)
		if(!istype(M, /mob/living/carbon/human))//If target is not a human.
			return ..()
		if(istype(M, /mob/living/carbon/human/dummy))
			return..()

		if(M.has_brain_worms()) //Borer stuff - RR
			user << "<span class='warning'>The isocube spits out an error message: multiple lifeforms detected.</span>"
			return..()

		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been imprisoned with [src.name] by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to imprison [M.name] ([M.ckey])</font>")
		msg_admin_attack("[key_name_admin(user)] is attemptin to imprison [key_name_admin(M)] with the [src.name] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		isolate("VICTIM", M, user)
		return

	attack_self(mob/user)
		if (!in_range(src, user))
			return
		user.set_machine(src)
		var/dat = "<TT><B>Isocube</B><BR>"
		for(var/mob/living/carbon/human/A in src)
			dat += "Prisoner: [A.name]<br>"
			dat += {"<A href='byond://?src=\ref[src];choice=Release'>Release Prisoner</A>"}
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Disable'>Disable Prisoner</a>"}
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Enable'>Enable Prisoner</a>"}
			dat += "<br>"
			dat += {"<a href='byond://?src=\ref[src];choice=Close'> Close</a>"}
		user << browse(dat, "window=aicard")
		onclose(user, "aicard")
		return




	Topic(href, href_list)
		var/mob/U = usr
		if (!in_range(src, U)||U.machine!=src)
			U << browse(null, "window=aicard")
			U.unset_machine()
			return

		add_fingerprint(U)
		U.set_machine(src)

		switch(href_list["choice"])//Now we switch based on choice.
			if ("Close")
				U << browse(null, "window=aicard")
				U.unset_machine()
				return

			if ("Release")
				for(var/mob/living/carbon/human/A in src)
					A.status_flags &= ~GODMODE
					A.canmove = 1
					A << "<b>You feel a sickening lurch as the isocube dumps you out, weak and disoriented.</b>"
					for(var/mob/O in viewers(U, null))
						O.show_message(text("<b>[U] fiddles with the isocube, releasing [A]!</b>"), 1)
					A.loc = U.loc
					A.weakened = 10
					A.paralysis = 0
					A.cancel_camera()
					src.icon_state = "soulstone"
				for(var/obj/O in src)
					O.loc = U.loc
			if ("Disable")
				for(var/mob/living/carbon/human/A in src)
					if (A.paralysis < 100)
						A << "<b>You feel a sudden, crippling agony, then darkness creeps over you.</b>"
						for(var/mob/O in viewers(U, null))
							O.show_message(text("You hear an ominous crunch."), 1)
						A.paralysis = 9000000
			if ("Enable")
				for(var/mob/living/carbon/human/A in src)
					if (A.paralysis > 10)
						A << "<b>You feel a jolt of consciousness.</b>"
						for(var/mob/O in viewers(U, null))
							O.show_message(text("Something whirrs."), 1)
						A.paralysis = 0
		attack_self(U)


/obj/item/proc/isolate(var/choice as text, var/target, var/mob/U as mob).
	if("VICTIM")
		var/mob/living/carbon/human/T = target
		var/obj/item/device/isocube/C = src

		if(C.contents.len)
			U << "\red <b>The isocube is full!</b>"
		else if (U == T)
			U << "\red <b>The isocube's safeties prevent you from capturing yourself.</b>"
			return
		else
			for(var/mob/O in viewers(U, null))
				O.show_message("\red <B>[U] is trying to pull [T] into an isocube!</B>", 1)
			var/turf/p_loc = U.loc
			var/turf/p_loc_m = T.loc
			spawn(30)
				if(!T)	return
				if(p_loc == U.loc && p_loc_m == T.loc)
/*					var/atom/movable/overlay/animation = new /atom/movable/overlay( T.loc )
					animation.icon_state = "blank"
					animation.icon = 'icons/mob/mob.dmi'
					animation.master = T
					flick("dust-h", animation)
					del(animation)*/
					T.loc = C //put dummy in isocube
					T.status_flags |= GODMODE //So they won't die inside the stone somehow
					T.canmove = 0//Can't move out of the soul stone
					if (T.client)
						T.cancel_camera()
					C.icon_state = "soulstone2"
					T << "You feel a heavy weightlessness and find yourself barely able to move.  The outside world seems larger."
					U << "\blue <b>[T.real_name] has been successfully captured within the isocube.</b> "
					T.Weaken(9000000)
					msg_admin_attack("[key_name_admin(U)] used the [src.name] to imprison [key_name_admin(T)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[U.x];Y=[U.y];Z=[U.z]'>JMP</a>)")
	return
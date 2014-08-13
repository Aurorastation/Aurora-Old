///////////////////////////////////////
//    Prototype medical alarms
//   They currently break things
///////////////////////////////////////


/obj/machinery/medical_alarm
	name = "Medical Emergency button"
	desc = "Medical Emergency button for when people are hurt"
	icon = 'Scopes Files/Alarms.dmi'
	icon_state = "eng_stand"
	anchored = 1
	var/on = 1
	var/area/area = null
	var/otherarea = null
	//luminosity = 1

/area
	var/obj/machinery/medical_alarm = null

/obj/machinery/medical_alarm/New()
	..()
	spawn(5)
		src.area = src.loc.loc

		if(otherarea)
			log_debug("Other area: [otherarea]")
			src.area = locate(text2path("/area/[otherarea]"))

		if(!name)
			name = "Medical Emergency button ([area.name])"

		src.on = src.area.medical_alarm
		updateicon()

/obj/machinery/medical_alarm/proc/updateicon()
//	if(stat & NOPOWER)
//		icon_state = "eng_stand"
	if(on)
		icon_state = "eng_unlock"
	else
		icon_state = "eng_stand"

/obj/machinery/medical_alarm/examine()
	set src in oview(1)
	if(usr && !usr.stat)
		usr << "A Medical Emergency button. It is [on? "on" : "off"]."

/obj/machinery/medical_alarm/attack_paw(mob/user)
	src.attack_hand(user)

/obj/machinery/medical_alarm/attack_hand(mob/user)
//	var/last_icon = icon_state
	icon_state = "eng_press"
	add_fingerprint(usr)
//	if(!allowed(user))
//		user << "\red Access Denied"
//		icon_state = last_icon

//	else
	on = !on

	for(var/area/A in area.master.related)
		A.medical_alarm = on
		spawn(10)
			A.updateicon()

		for(var/obj/machinery/medical_alarm/L in A)
			L.on = on
			spawn(10)
				L.updateicon()
				L.activate()

	area.master.power_change()

/obj/machinery/medical_alarm/proc/make_noise()
	for (var/mob/O in hearers(6, src.loc))
		O << "Impliment Sound"

/obj/machinery/medical_alarm/proc/activate()
	if(on)
		make_noise()
		spawn(100)
			activate()
	return
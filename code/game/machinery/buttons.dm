/obj/machinery/driver_button
	name = "mass driver button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mass driver."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

	attackby(obj/item/weapon/C as obj, mob/user as mob)
		if(istype(C, /obj/item/device/signaltool))
			var/obj/item/device/signaltool/ST = C
			id = ST.change_ID(id)
			return

/obj/machinery/ignition_switch
	name = "ignition switch"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = "A remote control switch for a mounted igniter."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

	attackby(obj/item/weapon/C as obj, mob/user as mob)
		if(istype(C, /obj/item/device/signaltool))
			var/obj/item/device/signaltool/ST = C
			id = ST.change_ID(id)
			return

/obj/machinery/flasher_button
	name = "flasher button"
	desc = "A remote control switch for a mounted flasher."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

	attackby(obj/item/weapon/C as obj, mob/user as mob)
		if(istype(C, /obj/item/device/signaltool))
			var/obj/item/device/signaltool/ST = C
			id = ST.change_ID(id)
			return

/obj/machinery/crema_switch
	desc = "Burn baby burn!"
	name = "crematorium igniter"
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"
	anchored = 1.0
	req_access = list(access_crematorium)
	var/on = 0
	var/area/area = null
	var/otherarea = null
	var/id = 1

	attackby(obj/item/weapon/C as obj, mob/user as mob)
		if(istype(C, /obj/item/device/signaltool))
			var/obj/item/device/signaltool/ST = C
			id = ST.change_ID(id)
			return
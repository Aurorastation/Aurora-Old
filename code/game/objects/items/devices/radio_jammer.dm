//Global list for housing active radiojammers:
var/list/active_radio_jammers = list()

/obj/item/device/radiojammer
	name = "radio jammer"
	desc = "A small, inconspicious looking item with an 'ON/OFF' toggle."
	icon = 'icons/obj/device.dmi'
	icon_state = "shield0"
	w_class = 2

	var/active = 0
	var/radius = 7

/obj/item/device/radiojammer/New()
	..()

	if (active)
		active_radio_jammers += src
		icon_state = "shield1"

/obj/item/device/radiojammer/attack_self()
	toggle()

/obj/item/device/radiojammer/emp_act()
	toggle()

/obj/item/device/radiojammer/proc/toggle()
	switch (active)
		if (0)
			usr << "<span class='notice'>You activate \the [src].</span>"
			active = 1
			active_radio_jammers += src
			icon_state = "shield1"
		if (1)
			usr << "<span class='notice'>You deactivate \the [src].</span>"
			active = 0
			active_radio_jammers -= src
			icon_state = "shield0"

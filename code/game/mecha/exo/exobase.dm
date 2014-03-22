/obj/mecha/exoskeleton/New()
	..()

	var/turf/T = get_turf(src)
	if(T.z != 2)
		new /obj/item/mecha_parts/mecha_tracking(src)
	return


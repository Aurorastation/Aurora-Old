// Sooooo Yeah.
//
// This is reverse of the heater code.
//
// This does work if you want to use it. Just needs sprites.

/obj/machinery/space_cooler
	anchored = 0
	density = 1
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	name = "space cooler"
	desc = "Made by Space Amish using traditional space techniques, this cooler is guaranteed not to set the station on fire."
//	var/obj/item/weapon/cell/cell
	var/obj/item/weapon/tank/nitrogen/N2tank
	var/on = 0
	var/open = 0
	var/set_temperature = 20		// in celcius, add T0C for kelvin
	var/cooling_power = 10000

	flags = FPRINT


	New()
		..()
		N2tank = new(src)
		N2tank.air_contents.temperature = TCMB
/*
		cell = new(src)
		cell.charge = 1000
		cell.maxcharge = 1000
*/
		update_icon()
		return

	update_icon()
		overlays.Cut()
		icon_state = "sheater[on]"
		if(open)
			overlays  += "sheater-open"
		return

	examine()
		set src in oview(12)
		if (!( usr ))
			return
		usr << "This is \icon[src] \an [src.name]."
		usr << src.desc

		usr << "The cooler is [on ? "on" : "off"] and the hatch is [open ? "open" : "closed"]."
		if(open)
			usr << "The power tank is [N2tank ? "installed" : "missing"]."
		else
			usr << "The charge meter reads [N2tank ? round(N2tank.air_contents.temperature-T0C) : 0]%"
		return

/*
	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		if(cell)
			cell.emp_act(severity)
		..(severity)
*/
	attackby(obj/item/I, mob/user)
		if(istype(I, /obj/item/weapon/tank/nitrogen))
			if(open)
				if(N2tank)
					user << "There is already a tank inside."
					return
				else
					// insert cell
					var/obj/item/weapon/tank/nitrogen/N2 = usr.get_active_hand()
					if(istype(N2))
						user.drop_item()
						N2tank = N2
						N2.loc = src
						N2.add_fingerprint(usr)

						user.visible_message("\blue [user] inserts [N2] into [src].", "\blue You insert [N2] into [src].")
			else
				user << "The hatch must be open to insert a tank."
				return
		else if(istype(I, /obj/item/weapon/screwdriver))
			open = !open
			user.visible_message("\blue [user] [open ? "opens" : "closes"] the hatch on the [src].", "\blue You [open ? "open" : "close"] the hatch on the [src].")
			update_icon()
			if(!open && user.machine == src)
				user << browse(null, "window=spacecooler")
				user.unset_machine()
		else
			..()
		return

	attack_hand(mob/user as mob)
		src.add_fingerprint(user)
		interact(user)

	interact(mob/user as mob)

		if(open)

			var/dat
			dat = "N2 Tank: "
			if(N2tank)
				dat += "<A href='byond://?src=\ref[src];op=tankremove'>Installed</A><BR>"
			else
				dat += "<A href='byond://?src=\ref[src];op=tankinstall'>Removed</A><BR>"

			dat += "Tank Temperature: [N2tank ? round(N2tank.air_contents.temperature-T0C) : 0]&deg;C<BR><BR>"

			dat += "Set Temperature: "

			dat += "<A href='?src=\ref[src];op=temp;val=-5'>-</A>"

			dat += " [set_temperature]&deg;C "
			dat += "<A href='?src=\ref[src];op=temp;val=5'>+</A><BR>"

			user.set_machine(src)
			user << browse("<HEAD><TITLE>Space cooler Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=spacecooler")
			onclose(user, "spacecooler")




		else
			on = !on
			user.visible_message("\blue [user] switches [on ? "on" : "off"] the [src].","\blue You switch [on ? "on" : "off"] the [src].")
			update_icon()
		return


	Topic(href, href_list)
		if (usr.stat)
			return
		if ((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
			usr.set_machine(src)

			switch(href_list["op"])

				if("temp")
					var/value = text2num(href_list["val"])

					// limit to 20-90 degC
					set_temperature = dd_range(-50, 20, set_temperature + value)

				if("tankremove")
					if(open && N2tank && !usr.get_active_hand())
						usr.put_in_hands(N2tank)
						N2tank.add_fingerprint(usr)
						N2tank = null
						usr.visible_message("\blue [usr] removes the tank from \the [src].", "\blue You remove the tank from \the [src].")


				if("tankinstall")
					if(open && !N2tank)
						var/obj/item/weapon/tank/nitrogen/N2 = usr.get_active_hand()
						if(istype(N2))
							usr.drop_item()
							N2tank = N2
							N2.loc = src
							N2.add_fingerprint(usr)

							usr.visible_message("\blue [usr] inserts a tank into \the [src].", "\blue You insert the tank into \the [src].")

			updateDialog()
		else
			usr << browse(null, "window=spacecooler")
			usr.unset_machine()
		return



	process()
		if(on)
			if(N2tank)
				var/datum/gas_mixture/tank_env
				tank_env = N2tank.air_contents
				if(tank_env.temperature >= T20C)
					return

				var/turf/simulated/L = loc
				if(istype(L))
					var/datum/gas_mixture/env = L.return_air()
					if(env.temperature > set_temperature + T0C)
						var/transfer_moles = 0.25 * env.total_moles
						var/datum/gas_mixture/air_removed = env.remove(transfer_moles)
						var/datum/gas_mixture/tank_removed = tank_env.remove(transfer_moles)
						if(air_removed)
							var/heat_capacity = air_removed.heat_capacity()
							if(heat_capacity) // Added check to avoid divide by zero (oshi-) runtime errors -- TLE
								if(air_removed.temperature != set_temperature + T0C)
									air_removed.temperature = min(air_removed.temperature - cooling_power/heat_capacity/3, TCMB)
									tank_removed.temperature = max(tank_removed.temperature + rand(1,15), 50)
						env.merge(air_removed)
						tank_env.merge(tank_removed)
				else
					on = 0
					update_icon()
		return
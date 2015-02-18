/obj/item/clothing/gloves/captain
	desc = "Regal blue gloves, with a nice gold trim. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"
	item_color = "captain"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/cyborg
	desc = "beep boop borp"
	name = "cyborg gloves"
	icon_state = "black"
	item_state = "r_hands"
	siemens_coefficient = 1.0

/obj/item/clothing/gloves/swat
	desc = "These tactical gloves are somewhat fire and impact-resistant."
	name = "\improper SWAT Gloves"
	icon_state = "black"
	item_state = "swat_gl"
	siemens_coefficient = 0.6
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/combat //Combined effect of SWAT gloves and insulated gloves
	desc = "These tactical gloves are somewhat fire and impact resistant."
	name = "combat gloves"
	icon_state = "combat"
	item_state = "swat_gl"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/latex
	name = "latex gloves"
	desc = "Sterile latex gloves."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.30
	permeability_coefficient = 0.01
	item_color="white"

	cmo
		item_color = "medical"		//Exists for washing machines. Is not different from latex gloves in any way.

/obj/item/clothing/gloves/latex/unathi
	name = "unathi latex gloves"
	desc = "Sterile latex gloves. Designed for Unathi use."
	species_restricted = list("Unathi")

/obj/item/clothing/gloves/latex/tajara
	name = "tajara latex gloves"
	desc = "Sterile latex gloves. Designed for Tajara use."
	species_restricted = list("Tajaran")

/obj/item/clothing/gloves/botanic_leather
	desc = "These leather gloves protect against thorns, barbs, prickles, spikes and other harmful objects of floral origin."
	name = "botanist's leather gloves"
	icon_state = "leather"
	item_state = "ggloves"
	permeability_coefficient = 0.9
	siemens_coefficient = 0.9

/obj/item/clothing/gloves/watch
	desc = "A small wristwatch, capable of telling time."
	name = "watch"
	icon_state = "watch"
	item_state = "watchgloves"
	w_class = 1
	wired = 1
	species_restricted = null
//	var/time = 1

	verb/checktime()
		set category = "Object"
		set name = "Check Time"
		set src in usr

		if(wired && !clipped)
			usr << "You check your watch, spotting a digital collection of numbers reading '[worldtime2text()]'"
		else if(wired && clipped)
			usr << "You check your watch realising it's still open"
		else
			usr << "You check your watch as it dawns on you that it's broken"

	verb/pointatwatch()
		set category = "Object"
		set name = "Point at watch"
		set src in usr

		if(wired && !clipped)
			usr.visible_message ("<span class='notice'>[usr] taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes.</span>", "<span class='notice'>You point down at the [src], an arrogant look about your eyes.</span>")
		else if(wired && clipped)
			usr.visible_message ("<span class='notice'>[usr] taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes, not noticing it's open</span>", "<span class='notice'>You point down at the [src], an arrogant look about your eyes.</span>")
		else
			usr.visible_message ("<span class='notice'>[usr] taps their foot on the floor, arrogantly pointing at the [src] on their wrist with a look of derision in their eyes, not noticing it's broken</span>", "<span class='notice'>You point down at the [src], an arrogant look about your eyes.</span>")

	attackby(obj/item/weapon/W, mob/user)
		if(istype(W, /obj/item/weapon/screwdriver))
			if (clipped) //Using clipped because adding a new var for something is dumb
				user.visible_message("\blue [user] screws the cover of the [src] closed.","\blue You screw the cover of the [src] closed..")
				clipped = 0
				return
//			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user.visible_message("\blue [user] unscrew the cover of the [src].","\blue You unscrew the cover of the [src].")
			clipped = 1
			return
		if(wired)
			return
		if(istype(W, /obj/item/weapon/cable_coil))
			var/obj/item/weapon/cable_coil/C = W
			if (!clipped)
				user << "<span class='notice'>The [src] is not open.</span>"
				return

			if(wired)
				user << "<span class='notice'>The [src] are already wired.</span>"
				return

			if(C.amount < 2)
				user << "<span class='notice'>There is not enough wire to cover the [src].</span>"
				return

			C.use(2)
			wired = 1
			user << "<span class='notice'>You repair some wires in the [src].</span>"
			return

	emp_act(severity)
		if(prob(50/severity))
			wired = 0
		..()
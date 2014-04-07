//Needs a shite-tonne more thuoght and dev time than I can put into this right now. So yeah.
//Sorry Chris.

/obj/item/device/radio/bug
	name = "slistening device"
	desc = "A small device with the ability to transmit over custom frequencies."
	icon_state = "bug"
	origin_tech = "magnets=4"

	var/list/item_choices = list()

	New()
		..()
		for(var/U in typesof(/obj/item/device)-(/obj/item/device))
			var/obj/item/clothing/under/V = new U
			src.item_choices += V

		for(var/U in typesof(/obj/item/weapon)-(/obj/item/weapon))
			var/obj/item/clothing/under/V = new U
			src.item_choices += V
		return


	attackby(/obj/item/U as obj)
		..()
		if(istype(U, /obj/item/device/radio/bug))
			user << "\red Nothing happens."
			return
		if(istype(U, /obj/item))
			if(src.item_choices.Find(U))
				user << "\red Shape is already recognised by the device."
				return
			src.item_choices += U
			user << "\red Shape absorbed by the suit."


/*	emp_act(severity)
		name = "psychedelic"
		desc = "Groovy!"
		icon_state = "psyche"
		spawn(200)
			name = "Black Jumpsuit"
			icon_state = "bl_suit"
			desc = null
		..()
*/


	verb/change()
		set name = "Change Shape"
		set category = "Object"
		set src in usr

/*		if(icon_state == "psyche")
			usr << "\red Your device is malfunctioning"
			return
*/

		var/obj/item/clothing/under/A
		A = input("Select Item to change it to", "Shapes", A) in item_choices
		if(!A)
			return

		desc = null
		permeability_coefficient = 0.90

		desc = A.desc
		name = A.name
		icon_state = A.icon_state
		item_state = A.item_state
//		usr.update_inv_w_uniform()	//so our overlays update. Shouldn't be needed, right?
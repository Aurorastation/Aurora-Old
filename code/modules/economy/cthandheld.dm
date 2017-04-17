/*
 * A handheld device for managing transaction on the fly.
 * Must be linked to a credit transfer terminal to function!
 */
/obj/item/device/cthandheld
	name = "handheld credit transfer device"
	desc = "A handheld device for making purchases. Spend your credits with just one swipe!"
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"

	var/deviceid = ""
	var/department = ""
	var/mode = 2
	var/currenttransaction = list("amount" = 0, "reason" = "", "customer" = 0)	//This is easier to store in a list, to be honest
	var/obj/machinery/computer/ctterminal/linkedterminal

/obj/item/device/cthandheld/New()
	..()

	if (department)
		for (var/obj/machinery/computer/ctterminal/A in world)
			if (A.department == department)
				linkterminal(A, A.devicenumber++)
				break

/obj/item/device/cthandheld/proc/linkterminal(var/obj/machinery/computer/ctterminal/newterminal, var/newid)
	if (!newterminal || !newid)
		return

	linkedterminal = newterminal
	deviceid = newid

/obj/item/device/cthandheld/proc/cleartransaction()
	currenttransaction["amount"] = 0
	currenttransaction["reason"] = ""
	currenttransaction["customer"] = 0

/obj/item/device/cthandheld/proc/cancomplete()
	if (linkedterminal && currenttransaction["amount"] && currenttransaction["reason"] && currenttransaction["customer"])
		return 1
	else
		return 0

/obj/item/device/cthandheld/proc/completetransaction()
	if (!cancomplete())
		return 0

	return linkedterminal.handletransaction(currenttransaction["customer"], currenttransaction["amount"], currenttransaction["reason"], deviceid)

/obj/item/device/cthandheld/attack_self(mob/user as mob)

	user.set_machine(src)

	ui_interact(user) //NanoUI requires this proc
	return

/obj/item/device/cthandheld/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if (user.stat)
		return

	var/data[0]
	data["src"] = "\ref[src]"
	data["mode"] = mode

	if (!linkedterminal)
		data["linked"] = 0
	else
		data["linked"] = 1
		data["currenttransaction"] = currenttransaction;
		if (linkedterminal.storedtransactions)
			data["storedtransactions"] = linkedterminal.storedtransactions;

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "ct_handheld.tmpl", "Handheld Credit Transfer", 470, 290)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/item/device/cthandheld/Topic(href, href_list)
	..()
	if (usr.stat)
		return 0

	if (href_list["select_transaction"])
		if (mode == 1)
			for (var/list/A in linkedterminal.storedtransactions)
				if (A["index"] == text2num(href_list["select_transaction"]))
					currenttransaction["reason"] = A["reason"]
					currenttransaction["amount"] = A["amount"]
					break
			return 1

	switch (href_list["choice"])
		if ("transaction_reason")
			if (mode == 1)
				currenttransaction["reason"] = href_list["transaction_reason"]
				return 1
		if ("transaction_amount")
			if (mode == 1)
				currenttransaction["amount"] = href_list["transaction_amount"]
				return 1
		if ("transaction_customer")
			var/obj/item/I = usr.get_active_hand()
			if (istype(I, /obj/item/weapon/card/id))
				var/obj/item/weapon/card/id/B
				var/pin = input(usr, "Please enter your account PIN.", "Authenticate", null) as text|null
				if (attempt_account_access(B.associated_account_number, pin))
					currenttransaction["customer"] = B.associated_account_number
					return 1
		if ("transaction_complete")
			if (currenttransaction["reason"] && currenttransaction["amount"] && currenttransaction["customer"])
				if (completetransaction())
					cleartransaction()
				return 1
		if ("transaction_clear")
			cleartransaction()
			return 1
		if ("transaction_lock")
			if (mode == 1)
				mode = 2
				return 1
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					var/obj/item/weapon/card/id/C = I
					if (C in linkedterminal.authorisedids)
						mode = 1
						return 1

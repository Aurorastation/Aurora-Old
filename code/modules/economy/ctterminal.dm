/*
 * A central control terminal for linking individual Handheld Credit Transfer devices.
 * Stores the linked account and processes transactions initiated by the ct devices.
 */
/obj/machinery/computer/ctterminal
	name = "credit transfer terminal"
	icon_state = "aiupload"
//	circuit = "/obj/item/weapon/circuitboard/ctterminal"

	var/machine_id = ""
	var/department = ""
	var/devicenumber = 0
	var/screen = 1
	var/transactionindex = 0
	var/list/storedtransactions
	var/list/transaction_log = list()
	var/list/authorisedids = list()
	var/list/linkeddevices = list()
	var/obj/item/weapon/disk/transactions/storeddisk
	var/datum/money_account/targetaccount

/obj/machinery/computer/ctterminal/New()
	..()

	machine_id = "[station_name()] CTT #[num_financial_terminals++]"

/obj/machinery/computer/ctterminal/attackby(I as obj, user as mob)
	..()

	if (istype(I, /obj/item/device/cthandheld))
		if (stat & (NOPOWER|BROKEN))
			return
		var/obj/item/device/cthandheld/A = I
		A.linkterminal(src, devicenumber++)
		linkeddevices += A
		user << "<span class='notice'>\icon[I] pings: successfully linked to [src]!</span>"
		return

/obj/machinery/computer/ctterminal/proc/handletransaction(var/customeraccount, var/amount, var/reason, var/deviceid)
	var/datum/money_account/customer = get_account(customeraccount)

	if (!customer || !targetaccount)
		return 0

	var/machine_id_proper = "[machine_id]-[deviceid]"
	if (customer.transferfrom(targetaccount, amount, reason, machine_id_proper))
		var/datum/transaction/A = new("Linked CTH #[deviceid]", reason, amount, customer.owner_name)
		transaction_log += A
		return 1
	else
		return 0

/obj/machinery/computer/ctterminal/proc/linkaccount(var/accountnum)
	var/datum/money_account/newtarget = get_account(accountnum)

	if (!newtarget || newtarget.suspended)
		return 0

	targetaccount = newtarget
	return 1

/obj/machinery/computer/ctterminal/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/ctterminal/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/ctterminal/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	if (user.stat)
		return

	var/data[0]
	data["src"] = "\ref[src]"
	data["machineid"] = machine_id
	data["screen"] = screen

	switch (screen)
		if (1)
			var/linkedaccount[0]
			linkedaccount["number"] = targetaccount ? targetaccount.account_number : ""
			linkedaccount["name"] = targetaccount ? targetaccount.owner_name : ""
			data["linkedaccount"] = linkedaccount;

			var/departmentalaccounts[0]
			for (var/datum/money_account/A in all_money_accounts)
				if (A.isdepartmental)
					departmentalaccounts.Add(list(list("number" = A.account_number, "name" = A.owner_name)))
			data["departmentalaccounts"] = departmentalaccounts;

			var/authorisedidslist[0]
			for (var/obj/item/weapon/card/id/B in authorisedids)
				authorisedidslist.Add(list(list("owner" = B.registered_name, "ref" = "\ref[B]")))
			data["authorisedids"] = authorisedidslist;

		if (2)
			var/linkeddeviceslist[0]
			for (var/obj/item/device/cthandheld/C in linkeddevices)
				linkeddeviceslist.Add(list(list("deviceid" = C.deviceid, "ref" = "\ref[C]")))
			data["linkeddevices"] = linkeddeviceslist;

		if (3)
//			if (storedtransactions && storedtransactions.len)
			data["storedtransactions"] = storedtransactions;

		if (4)
			var/transactionlog[0]
			for (var/datum/transaction/D in transaction_log)
				transactionlog.Add(list(list("deviceid" = D.target_name, "reason" = D.purpose, "amount" = D.amount, "customer" = D.source_terminal)))
			data["transactionlog"] = transactionlog;

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "ct_terminal.tmpl", "Credit Transfer Terminal", 540, 680)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/computer/ctterminal/Topic(href, href_list)
	if(..())
		return

	if (href_list["screen"])
		screen = text2num(href_list["screen"])
		return 1

	switch (href_list["choice"])
		if ("link_account")
			if (!linkaccount(text2num(href_list["account_number"])))
				src.visible_message("<span class='notice'>\icon[src] buzzes rudely.</span>")
			return 1
		if ("authorise_user")
			var/obj/item/weapon/card/A = usr.get_active_hand()
			if (A && istype(A))
				authorisedids += A
			return 1
		if ("unlink_id")
			var/obj/item/weapon/card/B = locate(href_list["ref"])
			if (B && B in authorisedids)
				authorisedids -= B
			return 1
		if ("unlink_device")
			var/obj/item/device/cthandheld/C = locate(href_list["ref"])
			if (C && C in linkeddevices)
				linkeddevices -= C
				C.linkedterminal = null
			return 1
		if ("create_transaction")
			if (href_list["transaction_reason"] && href_list["transaction_amount"])
				storedtransactions.Add(list(list("index" = transactionindex++, "reason" = href_list["transaction_reason"], "amount" = text2num(href_list["transaction_amount"]))))
			return 1
		if ("remove_transaction")
			if (!storedtransactions)
				return
			for (var/list/D in storedtransactions)
				if (D["index"] == text2num(href_list["transaction_id"]))
					storedtransactions -= D
					break
			return 1
	return 1

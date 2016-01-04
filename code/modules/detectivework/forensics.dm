//swabs and code therein

/obj/item/weapon/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	storage_slots=14
	can_hold = list("/obj/item/weapon/forensics/swab")
	max_combined_w_class = 42

	New()
		..()
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )
		new /obj/item/weapon/forensics/swab( src )

/obj/item/weapon/forensics/swab
	name = "swab kit"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "swab"
	flags = FPRINT | TABLEPASS | CONDUCT | NOBLUDGEON
	w_class = 1.0
	var/used = 0
	var/gsr = 0
	var/list/dna = list()

/obj/item/weapon/forensics/swab/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitize(input(user, "Enter a label for [src.name]","Label"))
		if(length(tmp_label) > 20)
			user << "\red The label can be at most 20 characters long."
		else
			user << "\blue You set the label to \"[tmp_label]\"."
			name = "[initial(name)] \"[tmp_label]\"."

/obj/item/weapon/forensics/swab/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if(used == 1)
		user << "\blue This swab has already been used."
		return
	else if(user.zone_sel.selecting == "mouth")
		user.visible_message("[user] swabs [M]'s mouth for a saliva sample.", "You swab [M]'s mouth for a saliva sample.")
		dna += M.dna.unique_enzymes
		used = 1
		name = "swab of [M]'s DNA"
		desc = "[initial(desc)] <br> \blue The label on the vial reads 'Sample of [M]'s DNA'."
		update_icon()
		return
	else if(user.zone_sel.selecting == "r_hand" || user.zone_sel.selecting == "l_hand")
		user.visible_message("[user] swabs [M]'s palm for a sample.", "You swab [M]'s palm for a sample.")
		gsr = M.gsr
		used = 1
		name = "swab of [M] for GSR tests"
		desc = "[initial(desc)] <br> \blue The label on the vial reads 'GSR Sample from [M]'."
		update_icon()
		return
	else
		return

/obj/item/weapon/forensics/swab/afterattack(atom/A as obj, mob/user as mob, proximity)
	if(istype(A, /obj/item/weapon/forensics/slide))
		return
	if(used == 1)
		return
	if(!proximity) return
	if(loc != user)
		return

	add_fingerprint(user)

	if (istype(A, /obj/effect/decal/cleanable/blood) || istype(A, /obj/effect/rune) || istype(A, /obj/effect/decal/cleanable/blood/gibs))
		if(!isnull(A.blood_DNA))
			for(var/blood in A.blood_DNA)
				dna = A.blood_DNA
				user.visible_message("[user] swabs [A] for a sample.", "You swab [A] for a DNA sample.")
				used = 1
				update_icon()
		return

	else if(istype(A, /obj/item/clothing))
		switch(alert(user,"What would you like to swab for?",,"Blood","Gunshot Residue","Cancel"))
			if("Blood")
				dna = A.stored_DNA
				user.visible_message("[user] swabs [A] for a sample.", "You swab [A] for a DNA sample.")
				used = 1
				name = "swab of DNA from [A]"
				desc = "[initial(desc)] <br> \blue The label on the vial reads 'Sample of DNA from [A].'."
				update_icon()
				return
			if("Gunshot Residue")
				var/obj/item/clothing/B = A
				gsr = B.gsr
				user.visible_message("[user] swabs [A] for a sample.", "You swab [A] for a GSR sample.")
				used = 1
				name = "swab of [A] for GSR tests"
				desc = "[initial(desc)] <br> \blue The label on the vial reads 'GSR Sample from [A].'"
				update_icon()
				return
			if("Cancel")
				return

	else if (istype(A, /obj/item/))
		if(!isnull(A.stored_DNA))
			dna = A.stored_DNA
			user.visible_message("[user] swabs [A] for a sample.", "You swab [A] for a DNA sample.")
			used = 1
			desc = "[initial(desc)] <br> \blue The label on the vial reads 'Sample of DNA from [A].'."
			update_icon()
		return



/obj/item/weapon/forensics/swab/update_icon()
	if(used == 0)
		icon_state = "swab"
	if(used == 1)
		icon_state = "swab_used"

//crime scene kit
/obj/item/weapon/storage/briefcase/crimekit
	name = "Crime Scene Kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	storage_slots=14
	max_combined_w_class = 42

//microscope slide code and such
/obj/item/weapon/storage/box/slides
	name = "microscope slide box"
	icon_state = "solution_trays"

	New()
		..()
		new /obj/item/weapon/forensics/slide( src )
		new /obj/item/weapon/forensics/slide( src )
		new /obj/item/weapon/forensics/slide( src )
		new /obj/item/weapon/forensics/slide( src )
		new /obj/item/weapon/forensics/slide( src )
		new /obj/item/weapon/forensics/slide( src )
		new /obj/item/weapon/forensics/slide( src )

/obj/item/weapon/forensics/slide
	name = "microscope slide"
	desc = "A pair of thin glass panes used in the examination of samples beneath a microscope."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "slide"
	flags = FPRINT | TABLEPASS | CONDUCT | NOBLUDGEON
	w_class = 1.0
	var/slidesamp = 0
	var/gsr = 0
	var/list/fibers_complete = list()

/obj/item/weapon/forensics/slide/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(slidesamp == 1)
		user << "\red There is already a sample in the slide."
		return
	if(istype (W, /obj/item/weapon/forensics/swab))
		var/obj/item/weapon/forensics/swab/D = W
		user << "\blue You insert the sample into the slide."
		slidesamp = 1
		user.drop_item()
		D.loc = src
		gsr = D.gsr
		icon_state = "slideswab"
		update_icon()
	else if(istype (W, /obj/item/weapon/fiberbag))
		var/obj/item/weapon/fiberbag/E = W
		user << "\blue You insert the sample into the slide."
		slidesamp = 1
		user.drop_item()
		E.loc = src
		fibers_complete = E.fibers_complete
		icon_state = "slidefiber"
		update_icon()
	else
		user << "\red You don't think this will fit."
		return

/obj/item/weapon/forensics/slide/verb/verb_remove_from_slide()
	set category = "Object"
	set name = "Empty Slide"
	set src in usr
	if(usr.stat || !(istype(usr,/mob/living/carbon/human)))
		usr << "No."
		return

	if(issilicon(usr))
		return

	var/obj/item/weapon/W = locate() in src
	if(W)
		usr << "<span class='notice'>You remove \the [W] from \the [src].</span>"
		src.slidesamp = 0
		src.gsr = 0
		src.fibers_complete = list()
		src.update_icon()
		W.loc = get_turf(src)
		return

/obj/item/weapon/forensics/slide/update_icon()
	if(slidesamp == 0)
		icon_state = "slide"

//microscope code itself
/obj/machinery/microscope
	name = "high powered electron microscope"
	desc = "A highly advanced microscope capable of zooming up to 3000x."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "microscope"
	anchored = 1
	var/obj/item/weapon/forensics/sample = null
	var/report_num = 0
	density = 1

/obj/machinery/microscope/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(sample)
		user << "\red There is already a slide in the microscope."
		return
	else if(istype(W, /obj/item/weapon/forensics/slide))
		user << "\blue You insert the slide into the microscope."
		sample = W
		user.drop_item()
		W.loc = src
		update_icon()
		return
	else if(istype(W, /obj/item/weapon/f_card))
		user << "\blue You insert the fingerprint card into the microscope."
		sample = W
		user.drop_item()
		W.loc = src
		update_icon()
		return

/obj/machinery/microscope/attack_hand(mob/user)
	var/obj/item/weapon/W = locate() in src
	if(sample)
		switch(alert("What would you like to do?",,"Examine for GSR","Examine Fingerprints","Examine Fibers","Cancel"))
			if("Examine for GSR")
				if(istype(W, /obj/item/weapon/forensics/slide))
					user << "\blue The microscope whirrs as you examine the sample."
					spawn(25)
						var/obj/item/weapon/forensics/slide/C = W
						if(C.gsr == 0)
							user << "\red No traces of gunshot residue were found."
						else
							user << "\blue Printing findings now..."
							var/obj/item/weapon/paper/P = new(src)
							P.name = "GSR report #[++report_num]: [C.name]"
							P.stamped = list(/obj/item/weapon/stamp)
							P.overlays = list("paper_stamped")

							var/data = "No information available."
							if(C.gsr != null)
								data = "Molecular analysis on provided sample has determined the presence of chemicals composing gunpowder.<br><br>"
								data += "GSR Analysis: Positive<br>Significant amount of residue detected.<br><br>"
							else
								data += "No residue found.<br>"
							P.info = "<b>GSR analysis report #[report_num]</b><br>"
							P.info += "<b>Scanned item:</b><br>[C.name]<br><br>" + data
							P.loc = src.loc
							P.update_icon()
							return
				else
					user << "\red I don't think that is applicable here..."
					return

			if("Examine Fingerprints")
				if(istype(W, /obj/item/weapon/f_card))
					user << "\blue The microscope whirrs as you examine the sample."
					spawn(25)
						user << "\blue Printing findings now..."
						var/obj/item/weapon/paper/Y = new(src)
						Y.name = "Fingerprint report #[++report_num]: [W.name]"
						Y.stamped = list(/obj/item/weapon/stamp)
						Y.overlays = list("paper_stamped")

						var/data = "No information available."
						var/obj/item/weapon/f_card/B = W
						if(B.complete_prints != null)
							data = "Surface analysis on provided card has determined the presence of uique fingerprint strings.<br><br>"
							for(var/prints in B.complete_prints)
								data += "\blue Fingerprint string: [B.complete_prints[prints]]<br><br>"
						else
							data += "No fingerprints found.<br>"
						Y.info = "<b>Fingerprint analysis report #[report_num]</b><br>"
						Y.info += "<b>Scanned item:</b><br>[B.name]<br><br>" + data
						Y.loc = src.loc
						Y.update_icon()
						return
				else
					user << "\red I don't think that is applicable here..."
					return

			if("Examine Fibers")
				if(istype(W, /obj/item/weapon/forensics/slide))
					user << "\blue The microscope whirrs as you examine the sample."
					spawn(25)
						user << "\blue Printing findings now..."
						var/obj/item/weapon/paper/Z = new(src)
						Z.name = "Fiber report #[++report_num]: [W.name]"
						Z.stamped = list(/obj/item/weapon/stamp)
						Z.overlays = list("paper_stamped")

						var/data = "No information available."
						var/obj/item/weapon/fiberbag/D = W
						if(D.fibers_complete != null)
							data = "Molecular analysis on provided sample has determined the presence of unique fiber strings.<br><br>"
							for(var/j = 1, j <= D.fibers_complete.len, j++)
								data += "\blue Most likely match for fibers: [D.fibers_complete[j]]<br><br>"
						else
							data += "No fibers found.<br>"
						Z.info = "<b>Fiber analysis report #[report_num]</b><br>"
						Z.info += "<b>Scanned item:</b><br>[D.name]<br><br>" + data
						Z.loc = src.loc
						Z.update_icon()
						return
				else
					user << "\red I don't think that is applicable here..."
					return
			if("Cancel")
				return
	else
		user << "\blue The microscope has no sample."

/obj/machinery/microscope/verb/verb_remove_slide()
	set category = "Object"
	set name = "Remove Sample"
	set src in oview(1)
	if(usr.stat || !(istype(usr,/mob/living/carbon/human)))
		usr << "No."
		return

	if(issilicon(usr))
		return

	var/obj/item/weapon/W = locate() in src
	if(W)
		usr << "<span class='notice'>You remove \the [W] from \the [src].</span>"
		src.sample = null
		src.update_icon()
		W.loc = get_turf(src)
		return
	else
		usr << "<span class='notice'>This microscope does not have a sample in it.</span>"

/obj/machinery/microscope/update_icon()
	if(sample)
		icon_state = "microscopeslide"
	else
		icon_state = "microscope"

//fingerprint powder
/obj/item/weapon/forensics/powder
	name = "fingerprint powder"
	desc = "A jar containing aluminum powder and a specialized brush."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dust"
	var/list/complete_prints = list()
	var/stored = list()
	var/data_enty = list()
	w_class = 1.0

/obj/item/weapon/forensics/powder/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	if(loc != user)
		return

	add_fingerprint(user)

	if ((!A.fingerprints || !A.fingerprints.len))
		user.visible_message("\blue [user] carefully begins to print [A] using their [src].","\blue Unable to locate any fingerprints on [A]!")
		return 0

	if(!A.fingerprints || !A.fingerprints.len)
		if(A.fingerprints)
			del(A.fingerprints)
	else
		user << "\blue You managed to isolate [A.fingerprints.len] fingerprints and transfer them to an adhesive sheet."
	/*	for(var/i in A.fingerprints)
			var/print = A.fingerprints[i]
			var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
			F.complete_prints += print
			F.name = "[initial(name)] from ([A])"
			F.icon_state = "fingerprint1" */
			//We keep this, because it's the start of the string.
		var/list/data_entry = stored
		if(islist(data_entry)) //Yay, it was already stored!
			//Merge the fingerprints.
			complete_prints = data_entry//[1] Starting the main part of the hack: I'm removing the number references from the code, hopefully I can use a singular sum_list commabnd as a result.
			for(var/print in A.fingerprints)
				var/merged_print = complete_prints[print]
				if(!merged_print)
					complete_prints[print] = A.fingerprints[print]
				else
					complete_prints[print] = stringmerge(complete_prints[print],A.fingerprints[print])
			//We nix EVERYTHING that that has to do with non-print bullshite. So, yah, shorter code.
		var/list/sum_list//[4]	Pack it back up! || Except not 4 anymore, just one
		sum_list/*[1]*/ = A.fingerprints ? A.fingerprints.Copy() : null
		//nixed all of the sum_list commands that didn't do shit.
		stored = sum_list
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
		F.complete_prints = stored
		stored = list()
		data_enty = list()
		complete_prints = list()
		F.name = "fingerprint card from ([A])"
		F.icon_state = "fingerprint1"
		return 0

//fiber collection
/obj/item/weapon/fiberbag
	name = "fiber bag"
	desc = "Used to hold fiber evidence for the detective."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "fiberbag"
	var/list/fibers_complete = list()

/obj/item/weapon/forensics/fiberkit
	name = "Fiber Collection Kit"
	desc = "A magnifying glass and tweezers. Used to lift suit fibers."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "m_glass"
	var/list/fibers_complete = list()
	var/stored = list()
	var/data_enty = list()

/obj/item/weapon/forensics/fiberkit/afterattack(atom/A as obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	if(loc != user)
		return

	add_fingerprint(user)

	if((!A.suit_fibers))
		user.visible_message("\blue [user] carefully begins to examine [A] using their [src].","\blue Unable to locate any suit fibers on [A]!")
		return 0
	else
		user << "\blue You managed to isolate [A.suit_fibers.len] samples of fiber evidence and transfer it to an evidence bag."
		var/list/data_entry = stored
		if(islist(data_entry)) //Yay, it was already stored!
			//Do the stuff that does the stuff
			fibers_complete = data_entry//[2] Again, not needed because single entry lists and not multiple entry cascades.
			for(var/j = 1, j <= A.suit_fibers.len, j++)	//Fibers~~~
				if(!fibers_complete.Find(A.suit_fibers[j]))	//It isn't!  Add!
					fibers_complete += A.suit_fibers[j]
		var/list/sum_list//[4]	Pack it back up! || Except not 4 anymore, just one
		sum_list/*[1]*/ = A.suit_fibers ? A.suit_fibers.Copy() : null
		//nixed all of the sum_list commands that didn't do shit.
		stored = sum_list
		var/obj/item/weapon/fiberbag/F = new /obj/item/weapon/fiberbag( user.loc )
		F.fibers_complete = stored
		stored = list()
		data_enty = list()
		fibers_complete = list()
		F.name = "fiber bag from ([A])"
		return 0



//Luminol and Goggles

/obj/item/clothing/glasses/UV
	name = "Ultraviolet Goggles"
	desc = "A pair of specialized forensic glasses designed to detect luminol flouresence.."
	icon_state = "thermal"
	item_state = "glasses"
	origin_tech = "magnets=3"

/obj/item/weapon/reagent_containers/spray/luminol
	name = "luminol bottle"
	desc = "A bottle containing an ordorless, colorless liquid."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "luminol"
	item_state = "cleaner"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10)
	volume = 250

/obj/item/weapon/reagent_containers/spray/luminol/New()
	..()
	reagents.add_reagent("luminol", 250)

//DNA machine

/obj/machinery/dnaforensics
	name = "DNA analyzer"
	desc = "A high tech machine that is designed to read DNA samples properly."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnaopen"
	anchored = 1
	var/ui_title = "QuikScan DNA Analyzer"
	var/range = 10
	density = 1


	//vars important for analyzing
	var/obj/item/weapon/forensics/swab/bloodsamp = null
	var/closed = 0
	var/scanning = 0
	var/scanner_progress = 0
	var/scanner_rate = 2.50 //scanning takes 40 seconds
	var/last_process_worldtime = 0
	var/report_num = 0

/obj/machinery/dnaforensics/attackby(obj/item/weapon/forensics/swab/W as obj, mob/user as mob)
	if(src.bloodsamp)
		user << "\red There is already a sample in the machine."
		return
	if(src.closed == 1)
		user << "\red Open the cover before inserting the sample."
		return
	if(!istype(W))
		user << "\red You struggle to put that in the machine."
		return
	if(W.used == 1)
		src.bloodsamp = W
		user.drop_item()
		W.loc = src
		user << "You insert [W] into the machine."

/obj/machinery/dnaforensics/update_icon()
	..()
	if(! (stat & (NOPOWER)) && (scanning) && (closed == 1))
		icon_state = "dnaworking"
	else if(! (stat & (NOPOWER)) && (scanning != 1) && (closed == 1))
		icon_state = "dnaclosed"
	else if(! (stat & (NOPOWER)) && (scanning != 1) && (closed == 0))
		icon_state = "dnaopen"

/obj/machinery/dnaforensics/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null)
	if(stat & (NOPOWER)) return
	if(user.stat || user.restrained()) return

	// this is the data which will be sent to the ui
	var/data[0]
	data = list(
		"scan_progress" = round(scanner_progress),
		"scanning" = scanning,
		"bloodsamp" = (bloodsamp ? bloodsamp.name : ""),
		"bloodsamp_desc" = (bloodsamp ? (bloodsamp.desc ? bloodsamp.desc : "No information on record.") : ""),
		"lidstate" = closed
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "dnaforensics.tmpl", "QuikScan DNA Analyzer", 540, 326)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/dnaforensics/Topic(href, href_list)
	if(stat & (NOPOWER))
		return 0 // don't update UIs attached to this object

	src.add_fingerprint(usr)

	if(href_list["scanItem"])
		if(scanning)
			stop_scanning()
		else
			if(bloodsamp)
				if(closed == 1)
					scanner_progress = 0
					scanning = 1
					usr << "<span class='notice'>Scan initiated.</span>"
					update_icon()
				else
					usr << "<span class='notice'>Please close sample lid before initiating scan.</span>"
			else
				usr << "<span class='warning'>Insert an item to scan.</span>"

	if(href_list["ejectItem"])
		if(bloodsamp)
			bloodsamp.loc = src.loc
			bloodsamp = null

	if(href_list["toggleLid"])
		toggle_lid()

	return 1

/obj/machinery/dnaforensics/process()
	if(scanning)
		if(!bloodsamp || bloodsamp.loc != src)
			bloodsamp = null
			stop_scanning()
		else if(scanner_progress >= 100)
			complete_scan()
			return
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1
			scanner_progress = min(100, scanner_progress + scanner_rate * deltaT)
	last_process_worldtime = world.time

/obj/machinery/dnaforensics/proc/stop_scanning()
	scanning = 0

/obj/machinery/dnaforensics/proc/complete_scan()
	src.visible_message("\blue \icon[src] makes an insistent chime.", 2)
	update_icon()

	if(bloodsamp)
		var/obj/item/weapon/paper/P = new(src)
		P.name = "[src] report #[++report_num]: [bloodsamp.name]"
		P.stamped = list(/obj/item/weapon/stamp)
		P.overlays = list("paper_stamped")

		//dna data itself
		var/data = "No scan information available."
		if(bloodsamp.dna != null)
			data = "Spectometric analysis on provided sample has determined the presence of [bloodsamp.dna.len] strings of DNA.<br><br>"
			for(var/blood in bloodsamp.dna)
				data += "\blue Blood type: [bloodsamp.dna[blood]]<br>\nDNA: [blood]<br><br>"
		else
			data += "No DNA found.<br>"
		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<b>Scanned item:</b><br>[bloodsamp.name]<br>[bloodsamp.desc]<br><br>" + data
		P.loc = src.loc
		P.update_icon()
		stop_scanning()
		update_icon()
	return

/obj/machinery/dnaforensics/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/dnaforensics/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/dnaforensics/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/dnaforensics/verb/toggle_lid()
	set category = "Object"
	set name = "Toggle Lid"
	set src in oview(1)
	if(usr.stat || !isliving(usr))
		usr << "No."
		return

	if(scanning)
		usr << "<span class='warning'>You can't do that while [src] is scanning!</span>"
		return

	if(closed == 1)
		icon_state = "dnaopen"
		closed = 0
		src.update_icon()
	else
		icon_state = "dnaclosed"
		closed = 1
		src.update_icon()

/obj/machinery/printer
	name = "printer"
	desc = "Your standard printer."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "printer"
	var/printing = 0
	density = 1
	anchored = 1

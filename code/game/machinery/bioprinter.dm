//These machines are mostly just here for debugging/spawning. Skeletons of the feature to come.

/obj/machinery/bioprinter
	name = "organ bioprinter"
	desc = "It's a machine that grows replacement organs."
	icon = 'icons/obj/surgery.dmi'

	anchored = 1
	density = 1
	use_power = 1
	idle_power_usage = 40

	icon_state = "bioprinter"

	var/prints_prosthetics
	var/stored_matter = 200
	var/loaded_dna //Blood sample for DNA hashing.
	var/list/products = list(
		"heart" =   list(/obj/item/organ/heart,  50),
		"lungs" =   list(/obj/item/organ/lungs,  40),
		"kidneys" = list(/obj/item/organ/kidneys,20),
		"eyes" =    list(/obj/item/organ/eyes,   30),
		"liver" =   list(/obj/item/organ/liver,  50)
		)

/obj/machinery/bioprinter/prosthetics
	name = "prosthetics fabricator"
	desc = "It's a machine that prints prosthetic organs."
	prints_prosthetics = 1

/obj/machinery/bioprinter/attack_hand(mob/user)

	var/choice = input("What would you like to print?") as null|anything in products
	if(!choice)
		return

	if(stored_matter >= products[choice][2])

		stored_matter -= products[choice][2]
		var/new_organ = products[choice][1]
		var/obj/item/organ/O = new new_organ(get_turf(src))

		if(prints_prosthetics)
			O.robotic = 2
		else if(loaded_dna)
			visible_message("<span class='notice'>The printer injects stored DNA in used biomass.</span>.")
			var/datum/organ/internal/I = new O.organ_type
			I.transplant_data = list()
			var/mob/living/carbon/human/C = loaded_dna["donor"]
			I.transplant_data["species"] =    C.species.name
			I.transplant_data["blood_type"] = loaded_dna["blood_type"]
			I.transplant_data["blood_DNA"] =  loaded_dna["blood_DNA"]
			O.organ_data = I
			I.organ_holder = O


		visible_message("<span class='info'>The bioprinter spits out a new organ.")

	else
		user << "<span class='warning'>There is not enough matter in the printer.</span>"

/obj/machinery/bioprinter/attackby(obj/item/weapon/W, mob/user)

	// DNA sample from syringe.
	if(!prints_prosthetics && istype(W,/obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.data
			user << "<span class='info'>You inject the blood sample into the bioprinter.</span>"
		return
	// Meat for biomass.
	else if(!prints_prosthetics && istype(W, /obj/item/weapon/reagent_containers/food/snacks/meat))
		stored_matter += 50
		user.drop_item()
		user << "<span class='info'>\The [src] processes \the [W]. Levels of stored biomass now: [stored_matter]</span>"
		del(W)
		return
	// Steel for matter.
	else if(prints_prosthetics && istype(W, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = W
		stored_matter += M.amount * 10
		user.drop_item()
		user << "<span class='info'>\The [src] processes \the [W]. Levels of stored matter now: [stored_matter]</span>"
		del(W)
		return
	else
		return..()

/obj/item/weapon/paper/bioprinter
	name = "HP-4001 Prosthetics Fabricator Manual"
	info = {"<h4>Overview</h4>
	<p>The HP 4000 series is a prosthetics fabricator capable of producing mechanical substitutions for organic limbs. It comes with the finest rapid-prototyping
	technology.</p>
	<h4>Operation</h4>
	<p>The machine is relatively easy to operate.<br>
	<b>1st</b> you need to ensure that the machine is in a powered area, and has enough matter stored in it to function.<br>
	As the <b>2nd</b> step, you need to simply activate the machine, and pick which organ you wish to create.<br>
	The <b>final</b> step is simply waiting: the HP 4000 series model prosthetics fabricator will produce a fully functioning, mechanical substitution for the organ selected
	within seconds of receiving input. The substitute organs are ready for transplantation right after the printing is completed!</p>
	<h4>Restocking</h4>
	<p>Each printjob requires a set of materials. Should you ever run out of materials, then the HP 4000 series model prosthetics fabricator can be easily restocked by simply
	feeding metal sheets into its receptor port.</p>
	<font size=1>This technology produced under license from Thinktronic Systems, LTD.<br>
	Thinktronic Systems, LTD. cannot be held liable for the quality of the substitute organs created, or the inherint issues that come from using such mechanical devices.</font>"}
//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_hand()
	return module_active



/*-------TODOOOOOOOOOO--------*/
/mob/living/silicon/robot/proc/uneq_module(obj/item/O)
	if(!O)
		return 0

	if(istype(O,/obj/item/borg/sight))
		var/obj/item/borg/sight/S = O
		sight_mode &= ~S.sight_mode
	else if(istype(O, /obj/item/device/flashlight))
		var/obj/item/device/flashlight/F = O
		if(F.on)
			F.on = 0
			F.update_brightness(src)
	if(client)
		client.screen -= O
	contents -= O
	if(module)
		O.loc = module	//Return item to module so it appears in its contents, so it can be taken out again.

	if(module_active == O)
		module_active = null
	if(module_state_1 == O)
		inv1.icon_state = "inv1"
		module_state_1 = null
	else if(module_state_2 == O)
		inv2.icon_state = "inv2"
		module_state_2 = null
	else if(module_state_3 == O)
		module_state_3 = null
		inv3.icon_state = "inv3"
		
	hud_used.update_robot_modules_display() // update the display
	
	return 1
	
	
/mob/living/silicon/robot/proc/activate_module(var/obj/item/O)
	if(!(locate(O) in src.module.modules) && O != src.module.emag)
		return
	if(activated(O))
		src << "Already activated"
		return
	var/selected=get_selected_module() // this makes you swap your selected module if you've got one selected
	if (selected)
		uneq_active()
	if(!module_state_1)
		module_state_1 = O
		O.layer = 20
		O.screen_loc = inv1.screen_loc
		contents += O
		if(istype(module_state_1,/obj/item/borg/sight))
			sight_mode |= module_state_1:sight_mode
	else if(!module_state_2)
		module_state_2 = O
		O.layer = 20
		O.screen_loc = inv2.screen_loc
		contents += O
		if(istype(module_state_2,/obj/item/borg/sight))
			sight_mode |= module_state_2:sight_mode
	else if(!module_state_3)
		module_state_3 = O
		O.layer = 20
		O.screen_loc = inv3.screen_loc
		contents += O
		if(istype(module_state_3,/obj/item/borg/sight))
			sight_mode |= module_state_3:sight_mode
	else
		src << "You need to disable a module first!"
	if (selected) // replaces your selection if you're swapping
		select_module(selected)

/mob/living/silicon/robot/proc/uneq_active()
	uneq_module(module_active)

/mob/living/silicon/robot/proc/uneq_all()
	uneq_module(module_state_1)
	uneq_module(module_state_2)
	uneq_module(module_state_3)

/mob/living/silicon/robot/proc/activated(obj/item/O)
	if(module_state_1 == O)
		return 1
	else if(module_state_2 == O)
		return 1
	else if(module_state_3 == O)
		return 1
	else
		return 0
	updateicon()

//Helper procs for cyborg modules on the UI.
//These are hackish but they help clean up code elsewhere.

//module_selected(module) - Checks whether the module slot specified by "module" is currently selected.
/mob/living/silicon/robot/proc/module_selected(var/module) //Module is 1-3
	return module == get_selected_module()

//module_active(module) - Checks whether there is a module active in the slot specified by "module".
/mob/living/silicon/robot/proc/module_active(var/module) //Module is 1-3
	if(module < 1 || module > 3) return 0

	switch(module)
		if(1)
			if(module_state_1)
				return 1
		if(2)
			if(module_state_2)
				return 1
		if(3)
			if(module_state_3)
				return 1
	return 0

//get_selected_module() - Returns the slot number of the currently selected module.  Returns 0 if no modules are selected.
/mob/living/silicon/robot/proc/get_selected_module()
	if(module_state_1 && module_active == module_state_1)
		return 1
	else if(module_state_2 && module_active == module_state_2)
		return 2
	else if(module_state_3 && module_active == module_state_3)
		return 3

	return 0

//select_module(module) - Selects the module slot specified by "module"
/mob/living/silicon/robot/proc/select_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(!module_active(module)) return

	switch(module)
		if(1)
			if(module_active != module_state_1)
				inv1.icon_state = "inv1 +a"
				inv2.icon_state = "inv2"
				inv3.icon_state = "inv3"
				module_active = module_state_1
				return
		if(2)
			if(module_active != module_state_2)
				inv1.icon_state = "inv1"
				inv2.icon_state = "inv2 +a"
				inv3.icon_state = "inv3"
				module_active = module_state_2
				return
		if(3)
			if(module_active != module_state_3)
				inv1.icon_state = "inv1"
				inv2.icon_state = "inv2"
				inv3.icon_state = "inv3 +a"
				module_active = module_state_3
				return
	return

//deselect_module(module) - Deselects the module slot specified by "module"
/mob/living/silicon/robot/proc/deselect_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	switch(module)
		if(1)
			if(module_active == module_state_1)
				inv1.icon_state = "inv1"
				module_active = null
				return
		if(2)
			if(module_active == module_state_2)
				inv2.icon_state = "inv2"
				module_active = null
				return
		if(3)
			if(module_active == module_state_3)
				inv3.icon_state = "inv3"
				module_active = null
				return
	return

	
/mob/living/silicon/robot/proc/deselect_current_module() //deselect current module
	deselect_module(get_selected_module())

	
//toggle_module(module) - Toggles the selection of the module slot specified by "module".
/mob/living/silicon/robot/proc/toggle_module(var/module) //Module is 1-3
	if(module < 1 || module > 3) return

	if(module_selected(module))
		deselect_module(module)
	else
		if(module_active(module))
			select_module(module)
		else
			deselect_module(get_selected_module()) //If we can't do select anything, at least deselect the current module.
	return

/mob/living/silicon/robot/proc/first_active_module()
	for (var/slot=0,slot<=3,slot++)
		if (module_active(slot))
			return slot
	return 0

/mob/living/silicon/robot/proc/next_slot(var/slot)
	if (slot >= 3)
		return 1
	return slot+1
	
//cycle_modules() - Cycles through the list of selected modules.
/mob/living/silicon/robot/proc/cycle_modules()
	var/slot_start = get_selected_module()
	if(slot_start)
		deselect_module(slot_start) //Only deselect if we have a selected slot.
	if(!slot_start) // we did not find a module
		select_module(first_active_module()) // try to select the first active module
	else
		var/slot_num = next_slot(slot_start)
		while(slot_start != slot_num) //If we wrap around without finding any free slots, just give up.
			if(module_active(slot_num))
				select_module(slot_num)
				return
			slot_num=next_slot(slot_num)
	return

	
/mob/living/silicon/robot/key_pressed_v()
	uneq_active()
	
/mob/living/silicon/robot/key_pressed_c()
	deselect_current_module()

/mob/living/silicon/robot/key_pressed_q()
	hud_used.toggle_show_robot_modules()
	
/mob/living/silicon/robot/key_pressed_1()
	return select_module(1)
	
/mob/living/silicon/robot/key_pressed_2()
	return select_module(2)	
	
/mob/living/silicon/robot/key_pressed_3()
	return select_module(3)
	
/mob/living/silicon/robot/key_pressed_4()
	return
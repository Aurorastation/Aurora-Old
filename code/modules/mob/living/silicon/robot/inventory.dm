//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting stuff manually
//as they handle all relevant stuff like adding it to the player's screen and such

//Returns the thing in our active hand (whatever is in our active module-slot, in this case)
/mob/living/silicon/robot/get_active_hand()
	return module_active



/*-------TODOOOOOOOOOO--------*/
/mob/living/silicon/robot/proc/uneq_module(obj/item/O,var/display_tool_transfer=TRUE)
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
		
	if (!display_tool_transfer)
		for(var/mob/M in viewers(src, null)) // show when cyborgs change their modules
			if (M == src)
				usr << "<span class='notice'>You retract \icon[O] [O] into your internal tool storage.</span>"
			else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
				M.show_message("<span class='notice'>[src] retracts \icon[O] [O] into their internal tool storage.</span>")
			else //Otherwise they can only see that you've put something back.
				M.show_message("<span class='notice'>[src] retracts a tool into their internal tool storage.</span>")
			
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
		for(var/mob/M in viewers(src, null)) // show when cyborgs change their modules
			if (M == src)
				usr << "<span class='notice'>You swap \icon[module_active] [module_active] for \icon[O] [O].</span>"
			else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
				M.show_message("<span class='notice'>[src] swaps \icon[module_active] [module_active] for \icon[O] [O].</span>")
			else //Otherwise they can only see that you've swapped something.
				M.show_message("<span class='notice'>[src] swaps some of their tools.</span>")
		uneq_active(TRUE)
	
	var/target=(selected) ? selected : first_free_module() // find where we're putting this 
	if (!target) // if there's nowhere to put it just warn them and kick out
		src << "You need to disable a module first!"
		return
	
	switch (target)
		if(1)
			module_state_1=O
			O.screen_loc = inv1.screen_loc
		if(2)
			module_state_2=O
			O.screen_loc = inv2.screen_loc
		if(3)
			module_state_3=O
			O.screen_loc = inv3.screen_loc
	
	O.layer = 20 // this bit moves the target object into the robot, and moves it's location on screen
	contents += O
	if(istype(O,/obj/item/borg/sight))
		var/obj/item/borg/sight/S = O
		sight_mode |= S.sight_mode
	
	if (selected) // replaces your selection if you're swapping
		select_module(selected)
	else // only do this if we activated a module but weren't swapping
		for(var/mob/M in viewers(src, null)) // show when cyborgs change their modules
			if (M == src)
				usr << "<span class='notice'>You retrieve \icon[O] [O] from your internal tool storage.</span>"
			else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
				M.show_message("<span class='notice'>[src] extends \icon[O] [O] from their internal tool storage.</span>")
			else //Otherwise they can only see that you've swapped something.
				M.show_message("<span class='notice'>[src] extends a tool.</span>")

/mob/living/silicon/robot/proc/uneq_active(var/display_tool_transfer=FALSE)
	uneq_module(module_active,display_tool_transfer)

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
	
/mob/living/silicon/robot/proc/first_free_module()
	for (var/slot=1,slot<=3,slot++)
		if (!module_active(slot))
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


/mob/living/silicon/robot/proc/describe_module(var/slot)
	var/list/index_module=list(module_state_1,module_state_2,module_state_3)
	var/result = "   Hardpoint [slot] holds "
	result += (index_module[slot]) ? "\icon[index_module[slot]] [index_module[slot]]." : "nothing."
	result += "\n"
	return result
	
	
/mob/living/silicon/robot/proc/describe_all_modules()
	var/result="It has three tool hardpoints.\n"
	for (var/x = 1; x <=3; x++)
		result+=describe_module(x)
	var/selected=get_selected_module()
	if (selected)
		result+="\nThe activity light on hardpoint [selected] is on.\n"
	return result

/*
	Cyborg ClickOn()

	Cyborgs have no range restriction on attack_robot(), because it is basically an AI click.
	However, they do have a range restriction on item use, so they cannot do without the
	adjacency code.
*/

/mob/living/silicon/robot/ClickOn(var/atom/A, var/params)
	if(!AllowedToMoveAgain())
		return

	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A)
		return
	if(modifiers["shift"] && modifiers["alt"])
		AltShiftClickOn(A)
		return
	if(modifiers["middle"])
		MiddleClickOn(A)
		return
	if(modifiers["shift"])
		ShiftClickOn(A)
		return
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A)
		return
	if(modifiers["ctrl"])
		CtrlClickOn(A)
		return

	if(stat || lockcharge || weakened || stunned || paralysis)
		return

	if(!AllowedToMoveAgain())
		return
	AllowedToClickAgainAfter(1) // prevent very speedy click spam

	face_atom(A) // change direction to face what you clicked on

	if(aiCamera.in_camera_mode)
		aiCamera.camera_mode_off()
		if(is_component_functioning("camera"))
			aiCamera.captureimage(A, usr)
		else
			src << "<span class='userdanger'>Your camera isn't functional.</span>"
		return

	/*
	cyborg restrained() currently does nothing
	if(restrained())
		RestrainedClickOn(A)
		return
	*/
	// handle equipping modules
	if (A.equip_robot(src))
		return 
		
	var/obj/item/W = get_active_hand()

	// Cyborgs have no range-checking unless there is item use
	if(!W)
		A.add_hiddenprint(src)
		A.attack_robot(src)
		return

	// buckled cannot prevent machine interlinking but stops arm movement
	if( buckled )
		return

	if(W == A)
		DelayClick_Weapon(W)
		W.attack_self(src)
		return

	// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc in contents)
	if(A == loc || (A in loc) || (A in contents))
		// No adjacency checks
		DelayClick_Weapon(W)
		var/resolved = A.attackby(W,src)
		if(!resolved && A && W)
			W.afterattack(A,src,1,params)
		return

	if(!isturf(loc))
		return

	// cyborgs are prohibited from using storage items so we can I think safely remove (A.loc && isturf(A.loc.loc))
	if(isturf(A) || isturf(A.loc))
		if(A.Adjacent(src)) // see adjacent.dm
			DelayClick_Weapon(W)
			var/resolved = A.attackby(W, src)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params)
			return
		else
			AllowedToClickAgainAfter(CLICK_CD_POINT)
			W.afterattack(A, src, 0, params)
			return
	return

/*
	As with AI, these are not used in click code,
	because the code for robots is specific, not generic.

	If you would like to add advanced features to robot
	clicks, you can do so here, but you will have to
	change attack_robot() above to the proper function
*/
/mob/living/silicon/robot/UnarmedAttack(atom/A)
	A.attack_robot(src)
	
/mob/living/silicon/robot/RangedAttack(atom/A)
	A.attack_robot(src)

/atom/proc/attack_robot(mob/user as mob)
	attack_ai(user)
	return
	
/atom/proc/equip_robot(mob/user as mob)
	return

/mob/living/silicon/robot/MiddleClickOn(var/atom/A)
	cycle_modules()

/mob/living/silicon/robot/CtrlShiftClickOn(var/atom/A)
	A.AICtrlShiftClick(src)
	
/mob/living/silicon/robot/AltShiftClickOn(var/atom/A)
	A.AIAltShiftClick(src)
	
/mob/living/silicon/robot/ShiftClickOn(var/atom/A)
	var/opened_door=A.AIShiftClick(src)
	if (!opened_door)
		..(A)
		
/mob/living/silicon/robot/CtrlClickOn(var/atom/A)
	var/locked_door=A.AICtrlClick(src)
	if (!locked_door)
		..(A)

/mob/living/silicon/robot/AltClickOn(var/atom/A)
	A.AIAltClick(src)
	
/mob/living/silicon/robot/proc/DelayClick_Weapon(var/obj/item/W)
	AllowedToClickAgainAfter(CLICK_CD_MELEE)
	DelayClickByWeaponFlag(W)

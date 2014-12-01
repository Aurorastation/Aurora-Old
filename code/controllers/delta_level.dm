// This is the timer for the Delta Alert Level
// As a note I really hate making controllers
// Scrap that I hate typos
//
// - SoundScopes

var/global/datum/delta_level/delta_level

datum/delta_level
	var/active = 0
	var/endtime

//Leaving this here just incase we want a way to cancel it.
datum/delta_level/proc/cancel()
	active = 0

	// returns the time (in seconds) before explosion
datum/delta_level/proc/timeleft()
	if(active)
		var/timeleft = round((endtime - world.timeofday)/10 ,1)
		return timeleft

	// sets the time left to a given delay (in seconds)
datum/delta_level/proc/settimeleft(var/delay)
	endtime = world.timeofday + delay * 10

datum/delta_level/proc/activate()
	active = 1
	settimeleft(590)
	ticker.mode:explosion_in_progress = 1
	for(var/mob/M in player_list)
		M << 'sound/machines/Alarm.ogg'

datum/delta_level/proc/dotheboom()
	for(var/i = 9 to 1 step -1)
		world << i+1
		sleep(10)

	enter_allowed = 0
	if(ticker)
		for(var/mob/M in player_list)
			M << 'sound/effects/Explosion2.ogg'
		ticker.station_explosion_cinematic(0,null)

		if(ticker.mode)
			ticker.mode:station_was_nuked = 1
			ticker.mode:explosion_in_progress = 0

datum/delta_level/proc/process()
	if(!active)
		if(ticker.mode:explosion_in_progress == 1)
			ticker.mode:explosion_in_progress = 0
			settimeleft(0)
		return
	var/timeleft = timeleft()
	if(timeleft > 1e5)		// midnight rollover protection
		timeleft = 0

	for (var/obj/machinery/status_display/SD in machines)
		SD.set_picture("redalert")

	if(timeleft>0)
		return
	else
		active = 0
		dotheboom()


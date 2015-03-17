/mob/living/carbon/alien/say(var/message)
	var/verb = "says"
	var/message_range = world.view

	if(client)
		if(client.prefs.muted & MUTE_IC)
			src << "\red You cannot speak in IC (Muted)."
			return

	message =  trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(stat == 2)
		return say_dead(message)

	if(copytext(message,1,2) == "*")
		return emote(copytext(message,2))

	var/datum/language/speaking = parse_language(message)
	if(speaking)
		message = copytext(message,3)
	else
		speaking = all_languages[language]

	var/ending = copytext(message, length(message))
	if (speaking)
		// This is broadcast to all mobs with the language,
		// irrespective of distance or anything else.
		if(speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return
		//If we've gotten this far, keep going!
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending=="!")
			verb=pick("roars","screeches","growls")
		if(ending=="?")
			verb="asks"
/*
	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		if(languages.len)
			for(var/datum/language/L in languages)
				if(lowertext(channel_prefix) == ":[L.key]")
					verb = L.speech_verb
					speaking = L
					break

	if(speaking)
		message = trim(copytext(message,3))
*/
	message = capitalize(trim(message))

	if(!message || stat)
		return

	..(message, speaking, verb, null, null, message_range, null)
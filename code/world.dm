/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session



#define RECOMMENDED_VERSION 501
/world/New()
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diaryofmeanpeople = file("data/logs/[date_string] Attack.log")
	diary << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	diaryofmeanpeople << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND"

	load_configuration()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	if(config && config.log_runtime)
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	callHook("startup")
	//Emergency Fix
	load_mods()
//	if(config.ip_blacklist_enabled)	Should no longer be necessary.
//		loadBlacklist()
	//end-emergency fix

	src.update_status()

	. = ..()

	sleep_offline = 1

	// Set up roundstart seed list. This is here because vendors were bugging out and not
	// populating with the correct packet names due to this list not being instantiated.
	populate_seed_list()

	master_controller = new /datum/controller/game_controller()
	spawn(1)
		master_controller.setup()

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()
		if(config.kick_inactive)
			KickInactiveClients()

#undef RECOMMENDED_VERSION

	return

//world/Topic(href, href_list[])
//		world << "Received a Topic() call!"
//		world << "[href]"
//		for(var/a in href_list)
//			world << "[a]"
//		if(href_list["hello"])
//			world << "Hello world!"
//			return "Hello world!"
//		world << "End of Topic() call."
//		..()

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr, master, key)
	if (config.log_world_topic)
		log_game("world/Topic(): T: \"[T]\"; From: [addr]; Master: [master]; Key: [key].")

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (T == "admins")
		var/n = 0
		for (var/client/client in clients)
			if (client.holder && client.holder.rights & (R_MOD|R_ADMIN))
				n++

		return n

	else if (T == "docount")
		var/n = 0
		for (var/client/client in clients)
			if (client.holder && (client.holder.rights & R_DUTYOFF) && !(client.holder.rights & R_ADMIN))
				n++

		return n

	else if (T == "gamemode")
		return master_mode

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		s["stationtime"] = worldtime2text()
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n

		s["admins"] = admins

		return list2params(s)

	else if (copytext(T,1,9) == "adminmsg")
		/*
			We got an adminmsg from IRC bot lets split the input then validate the input.
			expected output:
				1. adminmsg = ckey of person the message is to
				2. msg = contents of message, parems2list requires
				3. validatationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
				4. sender = the ircnick that send the message.
		*/


		var/input[] = params2list(T)
		if (input["key"] != config.comms_password)
			return do_topic_spam_protection(addr)

		var/client/C

		for (var/client/K in clients)
			if(K.ckey == ckey(input["adminmsg"]))
				C = K
				break
		if (!C)
			return "No client with that name on server"

		var/message =	"<font color='red'>Discord-Admin PM from <b><a href='?irc_msg=1'>[C.holder ? "Discord-" + input["sender"] : "Administrator"]</a></b>: [input["msg"]]</font>"
		var/amessage =  "<font color='blue'>Discord-Admin PM from <a href='?irc_msg=1'>Discord-[input["sender"]]</a> to <b>[key_name(C)]</b> : [input["msg"]]</font>"

		C.received_discord_pm = world.time
		C.discord_admin = input["sender"]

		C << 'sound/effects/adminhelp.ogg'
		C << message


		for (var/client/A in admins)
			if (A != C)
				A << amessage

		return "Message Successful"

	else if (copytext(T, 1, 8) == "restart")
		var/input[] = params2list(T)
		if (input["key"] == config.comms_password)
			world << "<font size=4 color='#ff2222'>Server restarting by remote command.</font>"
			message_admins("World restart initiated by [input["restart"]].")
			feedback_set_details("end_error","remote restart")

			if (blackbox)
				blackbox.save_all_data_to_sql()

			sleep(50)
			log_game("Rebooting due to remote command. Dumping topic call data.")
			log_game("TOPIC: \"[T]\", from: [addr], master: [master], key: [key][log_end].")
			world.Reboot(2)

			return "Server successfully restarted."
		else
			message_admins("Remote restart attempted and stopped. Dumping topic call data.")
			message_admins("TOPIC: \"[T]\", from: [addr], master: [master], key: [key][log_end]")
			log_game("Remote restart attempted and stopped. Dumping topic call data.")
			log_game("TOPIC: \"[T]\", from: [addr], master: [master], key: [key][log_end]")
			if (world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

	else if (copytext(T, 1, 9) == "announce")
		var/input[] = params2list(T)
		if (input["key"] == config.comms_password)
			world << "\blue <b>[input["announce"] ? input["announce"] : "Administrator"] Announces Via Discord:</b>\n \t [input["msg"]]"
			log_admin("Announce Remote: [input["announce"]] : [input["msg"]]")

			return "Announcement successfully sent."
		else
			return do_topic_spam_protection(addr)

	else if (copytext(T, 1, 8) == "faxlist")
		var/input[] = params2list(T)
		if (input["key"] == config.comms_password)
			var/list/output = list()
			if (!ticker || !ticker.fax_repository)
				output += "error"
				output["error"] = "Ticker not found!"
				output = list2params(output)
				return output

			var/list/faxes = list()
			switch (input["faxlist"])
				if ("received")
					faxes = ticker.fax_repository.received_faxes
				if ("sent")
					faxes = ticker.fax_repository.sent_faxes

			if (!faxes || !faxes.len)
				output += "error"
				output["error"] = "No faxes found!"
				output = list2params(output)
				return output

			for (var/i = 1, i <= faxes.len, i++)
				var/list/a = faxes[i]
				output += "ID [i]"
				output["ID [i]"] = a["subject"]

			output = list2params(output)
			return output
		else
			return do_topic_spam_protection(addr, 1)

	else if (copytext(T, 1, 7) == "getfax")
		var/input[] = params2list(T)
		if (input["key"] == config.comms_password)
			if (!ticker || !ticker.fax_repository)
				return "Ticker not found!"

			var/list/fax = list()
			switch (input["received"])
				if ("received")
					fax = ticker.fax_repository.get_fax(text2num(input["getfax"]), 1)
				if ("sent")
					fax = ticker.fax_repository.get_fax(text2num(input["getfax"]), 0)

			if (!fax || !fax.len)
				return "No fax with that ID found!"

			fax["data"] = replacetext(fax["data"], "<br>", "\n")
			return strip_html_properly(fax["data"], 0)
		else
			return do_topic_spam_protection(addr)

/world/Reboot(var/reason)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/
	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")
		else
			C << link("byond://[world.address]:[world.port]")

	..(reason)


#define INACTIVITY_KICK	6000	//10 minutes in ticks (approx.)
/world/proc/KickInactiveClients()
	spawn(-1)
		set background = 1
		while(1)
			sleep(INACTIVITY_KICK)
			for(var/client/C in clients)
				if(C.is_afk(INACTIVITY_KICK))
					if(!istype(C.mob, /mob/dead))
						log_access("AFK: [key_name(C)]")
						C << "\red You have been inactive for more than 10 minutes and have been disconnected."
						del(C)
#undef INACTIVITY_KICK


/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/hook/startup/proc/loadVisibility()
	world.load_visibility()
	testing("Loading visibility.")
	return 1

/world/proc/load_visibility()
	testing("Loading visibility 2.")
	var/list/saved_settings = file2list("data/hubsetting.txt")
	var/list/invisible_days = list("Saturday", "Sunday")
	if (saved_settings.len == 2)
		log_misc("Saved visibility is: [saved_settings[1]]; saved override is: [saved_settings[2]].")
		if (text2num(saved_settings[2]) == 1)
			world.visibility = text2num(saved_settings[1])
		else
			if (time2text(realtime, "Day") in invisible_days)
				world.visibility = 0
			else
				world.visibility = 1
			save_visibility(world.visibility, 0)

/world/proc/save_visibility(var/visibility, var/override = 0)
	var/F = file("data/hubsetting.txt")
	fdel(F)
	F << visibility
	F << override

/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")


/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.loadsql("config/dbconfig.txt")
	config.loadforumsql("config/forumdbconfig.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn

	if (config.use_age_restriction_for_jobs)
		config.load("config/age_restrictions.txt","age_restrictions")

/hook/startup/proc/loadMods()
	world.load_mods()
	return 1

/world/proc/load_mods()
	if(config.admin_legacy_system)
		var/text = file2text("config/moderators.txt")
		if (!text)
			error("Failed to load config/mods.txt")
		else
			var/list/lines = text2list(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
//				if(config.mods_are_mentors) title = "Mentor"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(directory[ckey])

/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()] - Heavy Roleplay</b>";
	s += " ("
	s += "<a href=\"[forum_link()]\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Forums"
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(ticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>STARTING</b>"

	if (!enter_allowed)
		features += "closed"

	features += abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	/*
	is there a reason for this? the byond site shows 'hosted by X' when there is a proper host already.
	if (host)
		features += "hosted by <b>[host]</b>"
	*/

	if (!host && config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [list2text(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the main database."
	else
		world.log << "Main database connection established."
	return 1

proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the main database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1

//This proc disconnects the database forcefully, and then establishes connection again.
proc/cycle_db_connection()
	if (!dbcon)
		return 0

	log_debug("Cycling database connection.")
	dbcon.Disconnect()

	sleep(5)
	setup_database_connection()

#undef FAILED_DB_CONNECTION_CUTOFF

// stores world.timeofday when the world starts for use in worldtime2text()

var/world_timeofday_at_start

hook/startup/proc/store_timeofday_at_start()
	world_timeofday_at_start = world.timeofday
	return 1

/world/proc/do_topic_spam_protection(var/addr, var/return_params = 0)
	if (!return_params)
		if (world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

			spawn(50)
				world_topic_spam_protect_time = world.time
				return "Bad Key (Throttled)"

		world_topic_spam_protect_time = world.time
		world_topic_spam_protect_ip = addr

		return "Bad Key"
	else
		var/list/output = list()
		if (world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

			spawn(50)
				world_topic_spam_protect_time = world.time
				output += "error"
				output["error"] = "Bad key (Throttled)"
				output = list2params(output)
				return output

		world_topic_spam_protect_time = world.time
		world_topic_spam_protect_ip = addr

		output += "error"
		output["error"] = "Bad key"
		output = list2params(output)
		return output

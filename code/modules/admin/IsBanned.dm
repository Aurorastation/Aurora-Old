#define IPBAN		1
#define IPBANPASS	2
#define IDBAN		4
#define IDBANPASS	8
#define KEYBAN		16
#define KEYBANPASS	32

var/global/list/blacklist = list()

//Blocks an attempt to connect before even creating our client datum thing.
world/IsBanned(key,address,computer_id)
	if(!computer_id)
		message_admins("\blue Failed Login: [key] ([address]) Null computerID")
		return list("reason"="Bad computerID", "desc"="\nReason: Blank computerID returned from client.")

	if(ckey(key) in admin_datums)
		return ..()

	//Making the adminbot for automated bans.
	var/datum/admins/Adminbot = new /datum/admins("Friendly Robot", 8196, "Adminbot")

	//Guest Checking
	if(!guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [key] - Guests not allowed")
		message_admins("\blue Failed Login: [key] - Guests not allowed")
		del Adminbot
		return list("reason"="guest", "desc"="\nReason: Guests not allowed. Please sign in with a byond account.")

	//check if the IP address is a known TOR node
	if(config && config.ToRban && ToRban_isbanned(address))
		log_access("Failed Login: [src] - Banned: ToR")
		message_admins("\blue Failed Login: [src] - Banned: ToR")
		//ban their computer_id and ckey for posterity
		AddBan(ckey(key), computer_id, "Use of ToR", "Automated Ban", 0, 0)
		del Adminbot
		return list("reason"="Using ToR", "desc"="\nReason: The network you are using to connect has been banned.\nIf you believe this is a mistake, please request help at [config.banappeals]")

	if(config && config.ip_blacklist_enabled)
		var/banhe = 0
		msg_scopes("Checking [key]'s IP for blacklist.")
		if(!establish_db_connection())
			//No database. Make do!
			error("Database connection failed while checking blacklist. Reverted to old system.")

			msg_scopes("Executing old blacklisting.")
			if(!blacklist)
				loadBlacklist()
			if(blacklist)
				if(address in blacklist)
					banhe = 1
			else
				msg_scopes("Where is the blacklist!")
		else
			//Have data, will base.
			var/DBQuery/query = dbcon.NewQuery("SELECT ip FROM ss13_ipblacklist WHERE ip = '[address]'")
			query.Execute()

			if(query.NextRow())
				banhe = 1

		if(banhe)
			log_access("Failed Login: [key] - Blacklisted IP. User banned.")
			message_admins("\blue Failed Login: [key] - Blacklisted IP. User banned.")
			message_mods("\blue Failed Login: [key] - Blacklisted IP. User banned.")

			var/reason = "This IP has been blacklisted from the server."
			Adminbot.DB_ban_record(1, null, null, reason, null, null, ckey(key), 1, address, computer_id)
			notes_add_sql(key, reason, null, address, computer_id)

			del Adminbot
			return list("reason"="IP Blacklisted", "desc"="\nReason: [reason]\nIf you believe this is a mistake, please request help at [config.banappeals]")

		msg_scopes("[key]'s blacklist check completed.")

	if(config.ban_legacy_system)

		//Ban Checking
		. = CheckBan( ckey(key), computer_id, address )
		if(.)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [.["reason"]]")
			message_admins("\blue Failed Login: [key] id:[computer_id] ip:[address] - Banned [.["reason"]]")
			del Adminbot
			return .

		del Adminbot
		return ..()	//default pager ban stuff

	else

		var/ckeytext = ckey(key)

		if(!establish_db_connection())
			error("Ban database connection failure. Key [ckeytext] not checked")
			log_misc("Ban database connection failure. Key [ckeytext] not checked")
			del Adminbot
			return

		var/failedcid = 1
		var/failedip = 1
		var/toban = 0
		var/banFlag = 0
		var/desc = null
		var/tobantype = null

		var/multireason = null
		var/newreason = null

		var/ipquery = ""
		var/cidquery = ""
		if(address)
			failedip = 0
			ipquery = " OR ip = '[address]' "

		if(computer_id)
			failedcid = 0
			cidquery = " OR computerid = '[computer_id]' "

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, ip, computerid, a_ckey, reason, expiration_time, duration, bantime, bantype FROM ss13_ban WHERE (ckey = '[ckeytext]' [ipquery] [cidquery]) AND (bantype = 'PERMABAN'  OR (bantype = 'TEMPBAN' AND expiration_time > Now())) AND isnull(unbanned)")

		query.Execute()

		while(query.NextRow())
			var/pckey = query.item[1]
			var/pip = query.item[2]
			var/pcid = query.item[3]
			var/ackey = query.item[4]
			var/reason = query.item[5]
			var/expiration = query.item[6]
			var/duration = query.item[7]
			var/bantime = query.item[8]
			var/bantype = query.item[9]

			var/expires = ""
			if(text2num(duration) > 0)
				expires = " The ban is for [duration] minutes and expires on [expiration] (server time)."

			if(!desc) //No desc then none of the others are set
				desc = "\nReason: You, or another user of this computer or connection ([pckey]) is banned from playing here. The ban reason is:\n[reason]\nThis ban was applied by [ackey] on [bantime], [expires]"
				multireason = reason
				tobantype = bantype

			if(bantype == "PERMABAN")
				if(!(banFlag & KEYBANPASS) && ckey(key) != ckey(pckey))
					banFlag |= KEYBAN

				if(!(banFlag & IDBANPASS) && computer_id != pcid)
					banFlag |= IDBAN

				if(!(banFlag & IPBANPASS) && address != pip)
					banFlag |= IPBAN

				if(banFlag & (KEYBAN|IDBAN|IPBAN))
					if(banFlag & KEYBAN && ckey(key) == ckey(pckey))
						banFlag &= ~KEYBAN
						banFlag |= KEYBANPASS

					if(banFlag & IDBAN && computer_id == pcid)
						banFlag &= ~IDBAN
						banFlag |= IDBANPASS

					if(banFlag & IPBAN && address == pip)
						banFlag &= ~IPBAN
						banFlag |= IPBANPASS

					if(banFlag && !newreason)
						newreason = "This is an automatic ban for attempted bandodging. The original ban reason: [multireason]."

			if(!toban)
				toban = 1

		if(banFlag & (KEYBAN|IDBAN|IPBAN))
			Adminbot.DB_ban_record(1, null, null, multireason, null, null, ckey(key), 1, address, computer_id)
			notes_add_sql(key, newreason, null, address, computer_id)

		if(toban)
			log_access("Failed Login: [key] [computer_id] [address] - Banned [multireason]")
			message_admins("\blue Failed Login: [key] id:[computer_id] ip:[address] - Banned [multireason]")
			del Adminbot
			return list("reason"="[tobantype]", "desc"="[desc]")

		if (failedcid)
			message_admins("[key] has logged in with a blank computer id in the ban check.")
		if (failedip)
			message_admins("[key] has logged in with a blank ip in the ban check.")
		del Adminbot
		return ..()	//default pager ban stuff

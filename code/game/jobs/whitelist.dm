#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if (config.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	if (config.whitelists_on_sql)
		establish_db_connection()

		if (!dbcon.IsConnected())
			//Continue with the old code if it fails. Stop and return if it succeeds.
			log_misc("Database connection failed. Reverting to legacy system.")
			config.whitelists_on_sql = 0
		else
			return

	whitelist = file2list(WHITELISTFILE)
	if (!whitelist.len)
		whitelist = null

/proc/check_whitelist(mob/M)
	if (config.whitelists_on_sql)
		var/head_of_staff_whitelist = 1
		if (M.client && M.client.whitelist_status)
			return (M.client.whitelist_status & head_of_staff_whitelist)

		return 0
	else
		if (!whitelist)
			return 0
		return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	if (config.whitelists_on_sql)
		establish_db_connection()

		if (!dbcon.IsConnected())
			log_misc("Database connection failed. Reverting to legacy system.")
			config.whitelists_on_sql = 0
		else
			var/DBQuery/query = dbcon.NewQuery("SELECT status_name, flag FROM ss13_whitelist_statuses")
			query.Execute()

			while (query.NextRow())
				if (query.item[1] in whitelisted_species)
					whitelisted_species[query.item[1]] = text2num(query.item[2])

			return

	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
	else
		alien_whitelist = text2list(text, "\n")

//todo: admin aliens
/proc/is_alien_whitelisted(mob/M, var/species)
	if (!config.usealienwhitelist)
		return 1

	if (!M || !species)
		return 0

	if (species == "human" || species == "Human")
		return 1

	if (config.whitelists_on_sql)
		if (M.client && M.client.whitelist_status)
			return (M.client.whitelist_status & whitelisted_species[species])

	else
		if (!alien_whitelist)
			return 0
		for (var/s in alien_whitelist)
			if (findtext(s, "[M.ckey] - [species]"))
				return 1
			if (findtext(s, "[M.ckey] - All"))
				return 1

	return 0

#undef WHITELISTFILE

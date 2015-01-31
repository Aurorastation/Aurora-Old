/*
 * All warning related code will now go here
 *
 * Warning, legacy version
 *
 */

#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn_legacy(warned_ckey, var/datum/preferences/D, C)
//
//	Due to the way this legacy proc now gets called, having this row of checks executed again is useless.
//
//	if(!check_rights(R_ADMIN|R_MOD))	return
//
//	if(!warned_ckey || !istext(warned_ckey))	return
//	if(warned_ckey in admin_datums)
//		usr << "<font color='red'>Error: warn(): You can't warn admins.</font>"
//		return
//
//	var/datum/preferences/D
//	var/client/C = directory[warned_ckey]
//	if(C)	D = C.prefs
//	else	D = preferences_datums[warned_ckey]
//
//	if(!D)
//		src << "<font color='red'>Error: warn(): No such ckey found.</font>"
//		return
//
	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			message_mods("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			C << "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes."
			del(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
			message_mods("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)
		feedback_inc("ban_warn",1)
	else
		if(C)
			C << "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>"
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
			message_mods("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-D.warns] strikes remaining.")
			message_mods("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-D.warns] strikes remaining.")

	feedback_add_details("admin_verb","WARN-LEG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#undef MAX_WARNS
#undef AUTOBANTIME

/*
 * Newer, database version
 *
 * Warn proc itself
 *
 */

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN|R_MOD))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		usr << "<font color='red'>Error: warn(): You can't warn admins.</font>"
		return

	var/datum/preferences/D
	var/client/C = directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = preferences_datums[warned_ckey]

	if(!D)
		src << "<font color='red'>Error: warn(): No such ckey found.</font>"
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
	//No DB, reverting to legacy
		error("Connection to SQL database failed while attempting to warn a player. Reverting to legacy warning.")
		usr.client.warn_legacy(warned_ckey, D, C)
		return

	//	Let's begin data gathering and conversion!

	var/reason = input("Add Warning Reason") as null|text
	if(!reason)
		return

	var/notes = input("Add Additional Information") as null|text

	var/severity
	switch(alert("Set Warning Severity",,"Standard","Severe"))
		if("Standard")
			severity = 0
		if("Severe")
			severity = 1

	var/sqlkey = sanitizeSQL(warned_ckey)
	var/computerid
	var/ip
	if(C)
		computerid = C.computer_id
		ip = C.address
	var/a_ckey = key_name_admin(src)

	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO aurora_warnings (id, time, severity, reason, notes, ckey, computerid, ip, a_ckey) VALUES (null, Now(), '[severity]', '[reason]', '[notes]', '[sqlkey]', '[computerid]', '[ip]', '[a_ckey]')")
	query_insert.Execute()
	notes_add(warned_ckey, "Warning added by [a_ckey], for: [reason]. || Notes regarding the warning: [notes].")
	feedback_add_details("admin_verb","WARN-DB")
	message_admins("[key_name_admin(src)] has warned [warned_ckey].")
	message_mods("[key_name_admin(src)] has warned [warned_ckey].")

/*
 * A proc for a player to check their own warnings
 */

/client/verb/check_warns
	set name = "My warnings"
	set category = "OOC"

	var/lcolor = "#ffeeee"	//light colour, severity = 1
	var/dcolor = "#ffdddd"	//dark colour, severity = 2
	var/looksimilar = 0
	var/dat = ""

	establish_db_connection()
	if(!dbcon.IsConnected())
//		error("Connection to SQL database failed while attempting to fetch a player's warnings. Verb cancelled.")
//		dat += "<div align='center'><font color='#ffffff'><h3>Database connection error. Warnings were not fetched. Please contact an Administrator.</h3></font></div>"
		return

	dat += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
	dat += "<tr>"
	dat += "<th width='20%'>ADMIN</th>"
	dat += "<th width='20%'>TIME ISSUED</th>"
	dat += "<th width='60%'>REASON</th>"
	dat += "</tr>"

	var/sqlkey = sanitizeSQL(ckey)

	var/DBQuery/search_query = dbcon.NewQuery("SELECT time, severity, reason, a_ckey FROM aurora_warnings WHERE ckey='[sqlkey]' ORDER BY time DESC")
	search_query.Execute()

	while(search_query.NextRow())
		var/time = search_query.item[1]
		var/seveiry = search_query.item[2]
		var/reason = search_query.item[3]
		var/a_ckey = search_query.item[4]

		if(severity)
			dat += "<tr bgcolor='[dcolor]' align='center'>"
		else
			dat += "<tr bgcolor='[lcolor]' align='center'>"

		dat += "<td>[a_ckey]</td>"
		dat += "<td>[time]</td>"
		dat += "<td>[reason]</td>"
		dat += "</tr>"

	dat += "</table>"
	dat += "<br><br>"
	if(!looksimilar)
		dat += "<div align='center'><h3><a href='?src=\ref[src];warning_similar=[ckey]'>Search for warnings issued to similar clients</a></h3></div>"

/client/proc/check_similar_warns(ip, cid)
	dat += "<div align='center'><h3>Warnings issued to players with similar credentials</h3></div>"
	dat += "<br>"

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("Connection to SQL database failed while attempting to fetch a player's warnings. Proc cancelled.")
		dat +="<div align='center'><font color='#ffffff'><h3>Database connection error. Warnings were not fetched. Please contact an Administrator.</h3></font></div>"
		return

	dat += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
	dat += "<tr>"
	dat += "<th width='10%'>ADMIN</th>"
	dat += "<th width='10%'>CKEY ISSUED TO</th>"
	dat += "<th width='10%'>TIME ISSUED</th>"
	dat += "<th width='60%'>REASON</th>"
	dat += "</tr>"

	var/DBQuery/similar_query = dbcon.NewQuery("SELECT time, severity, reason, ckey, a_ckey FROM aurora_warnings WHERE computerid='[cid]' OR ip='[ip]' ORDER BY time DESC")
	similar_query.Execute()

	while(similar_query.NextRow())
		var/time = similar_query.item[1]
		var/severity = similar_query.item[2]
		var/reason = similar_query.item[3]
		var/ckey = similar_query.item[4]
		var/a_ckey = similar_query.item[5]

		if(severity)
			dat += "<tr bgcolor='[dcolor]' align='center'>"
		else
			dat += "<tr bgcolor='[lcolor]' align='center'>"

		dat += "<td>[a_ckey]</td>"
		dat += "<td>[ckey]</td>"
		dat += "<td>[time]</td>"
		dat += "<td>[a_ckey]</td>"
		dat += "</tr>"

	dat += "</table>"
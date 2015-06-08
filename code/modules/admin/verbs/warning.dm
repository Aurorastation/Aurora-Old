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
//	if(warned_ckey in admin_datums)
//		usr << "<font color='red'>Error: warn(): You can't warn admins.</font>"
//		return

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
	var/computerid = null
	var/ip = null
	if(C)
		computerid = C.computer_id
		ip = C.address
	var/a_ckey = sanitizeSQL(ckey)

	var/DBQuery/query_insert = dbcon.NewQuery("INSERT INTO aurora_warnings (id, time, severity, reason, notes, ckey, computerid, ip, a_ckey) VALUES (null, Now(), '[severity]', '[reason]', '[notes]', '[sqlkey]', '[computerid]', '[ip]', '[a_ckey]')")
	query_insert.Execute()

	if(config.ban_legacy_system)
		notes_add(warned_ckey, "Warning added by [a_ckey], for: [reason]. || Notes regarding the warning: [notes].")
	else
		notes_add_sql(warned_ckey, "Warning added by [a_ckey], for: [reason]. || Notes regarding the warning: [notes].", src, ip, computerid)

	feedback_add_details("admin_verb","WARN-DB")
	if(C)
		C << "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>You can look up your warnings through the OOC panel, with the 'My Warnings' button.</font>"
	message_admins("[key_name_admin(src)] has warned [warned_ckey] for: [reason].")
	message_mods("[key_name_admin(src)] has warned [warned_ckey].")

/*
 * A proc for a player to check their own warnings
 */

/client/verb/check_warns()
	set name = "My warnings"
	set category = "OOC"
	set desc = "Display warnings issued to you."

	var/lcolor = "#ffeeee"	//light colour, severity = 1
	var/dcolor = "#ffaaaa"	//dark colour, severity = 2

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("Connection to SQL database failed while attempting to fetch a player's warnings. Verb cancelled.")
		alert("Connection to the SQL database lost. Aborting. Please alert an Administrator or a member of staff.")
		return

	var/dat = "<div align='center'><h3>Warnings received</h3></div><br>"

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
		var/severity = search_query.item[2]
		var/reason = search_query.item[3]
		var/a_ckey = search_query.item[4]

		var/bgcolor = lcolor

		if(severity == "1")
			bgcolor = dcolor

		dat += "<tr bgcolor='[bgcolor]' align='center'>"
		dat += "<td>[a_ckey]</td>"
		dat += "<td>[time]</td>"
		dat += "<td>[reason]</td>"
		dat += "</tr>"

		dat += "<tr>"
		dat += "<td colspan='5' bgcolor='white'>&nbsp</td>"
		dat += "</tr>"

	dat += "</table>"
	usr << browse(dat, "window=mywarnings;size=900x500")

/*
 * A proc for an admin/moderator to look up a member's warnings.
 */

/client/proc/warning_panel()
	set category = "Admin"
	set name = "Warnings Panel"
	set desc = "Look-up warnings assigned to players."

	if(!holder)
		return

	holder.warning_panel()

/datum/admins/proc/warning_panel(var/adminckey = null, var/playerckey = null)
	if(!check_rights(R_ADMIN|R_MOD))	return

	var/lcolor = "#ffeeee"	//light colour, severity = 1
	var/dcolor = "#ffdddd"	//dark colour, severity = 2

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("Connection to SQL database failed while attempting to fetch a player's warnings. Verb cancelled.")
		alert("Connection to the SQL database lost. Aborting. Please alert an Administrator or a member of staff.")
		return

	var/dat = "<div align='center'><h3>Warning Look-up Panel</h3><br>"

	//Totally not stealing code from the DB_ban_panel

	dat += "<form method='GET' action='?src=\ref[src]'><b>Search:</b> "
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += "<b>Ckey:</b> <input type='text' name='warnsearchckey' value='[playerckey]'>"
	dat += "<b>Admin ckey:</b> <input type='text' name='warnsearchadmin' value='[adminckey]'>"
	dat += "<input type='submit' value='search'>"
	dat += "</form></div>"

	if(adminckey || playerckey)

		dat += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
		dat += "<tr>"
		dat += "<th width='10%'>ISSUED TO</th>"
		dat += "<th width='10%'>ISSUED BY</th>"
		dat += "<th width='10%'>TIME ISSUED</th>"
		dat += "<th width='60%'>REASON</th>"
		dat += "</tr>"

		adminckey = ckey(adminckey)
		playerckey = ckey(playerckey)
		var/paramone = ""
		var/paramtwo = ""
		if(adminckey)
			paramone = "AND a_ckey = '[adminckey]' "
		if(playerckey)
			paramtwo = "AND ckey = '[playerckey]' "

		var/DBQuery/search_query = dbcon.NewQuery("SELECT time, severity, reason, notes, ckey, a_ckey FROM aurora_warnings WHERE 1 [paramone] [paramtwo] ORDER BY time DESC")
		search_query.Execute()

		while(search_query.NextRow())
			var/time = search_query.item[1]
			var/severity = search_query.item[2]
			var/reason = search_query.item[3]
			var/notes = search_query.item[4]
			var/ckey = search_query.item[5]
			var/a_ckey = search_query.item[6]

			var/bgcolor = lcolor

			if(severity == "1")
				bgcolor = dcolor

			dat += "<tr bgcolor='[bgcolor]' align='center'>"
			dat += "<td>[ckey]</td>"
			dat += "<td>[a_ckey]</td>"
			dat += "<td>[time]</td>"
			dat += "<td>[reason]</td>"
			dat += "</tr>"
			dat += "<tr>"
			dat += "<td align='center' colspan='5'><b>Staff Notes:</b> <cite>\"[notes]\"</cite></td>"
			dat += "</tr>"

			dat += "<tr>"
			dat += "<td colspan='5' bgcolor='white'>&nbsp</td>"
			dat += "</tr>"

		dat +="</table>"

	usr << browse(dat, "window=lookupwarns;size=900x500")
	feedback_add_details("admin_verb","WARN-LKUP")

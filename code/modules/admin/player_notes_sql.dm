//System will now support SQL pulls for fetching player notes.
//Yay!

/proc/notes_add_sql(var/key, var/note, var/mob/usr, var/IP, var/CID)
	if(!key || !note)
		return

	var/ckey = sanitizeSQL(key)
	var/content = sanitizeSQL(note)

	note = sql_sanitize_text(note)

	var/a_ckey
	if(usr)
		a_ckey = sanitizeSQL(usr.key)
	else
		a_ckey = "Adminbot"

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("SQL connection failed while trying to add a note!")
		return

	if(!IP || !CID)
		var/DBQuery/initquery = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = '[ckey]'")
		initquery.Execute()
		if(initquery.NextRow())
			IP = initquery.item[1]
			CID = initquery.item[2]

	var/querycontents
	if(IP && CID)
		querycontents = "INSERT INTO ss13_notes (id, adddate, ckey, ip, computerid, a_ckey, content) VALUES (null, Now(), '[ckey]', '[IP]', '[CID]', '[a_ckey]', '[content]')"
	else
		querycontents = "INSERT INTO ss13_notes (id, adddate, ckey, ip, computerid, a_ckey, content) VALUES (null, Now(), '[ckey]', null, null, '[a_ckey]', '[content]')"

	//We aren't suppose to end up here, but just in case.
	if(!querycontents)
		return

	var/DBQuery/insertquery = dbcon.NewQuery(querycontents)
	insertquery.Execute()
	if(insertquery.ErrorMsg())
		error("Inserting notes into SQL failed. Reason: [insertquery.ErrorMsg()].")
	else
		message_admins("\blue [key_name_admin(usr)] has edited [key]'s notes.")
		log_admin("[key_name(usr)] has edited [key]'s notes.")

/proc/notes_edit_sql(var/noteid, var/noteedit)
	if(!noteid || !noteedit)
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("SQL connection failed while attempting to delete a note!")
		return

	var/count = 0 //failsafe from unban procs
	var/ackey = usr.ckey
	var/ckey
	var/content

	var/DBQuery/initquery = dbcon.NewQuery("SELECT ckey, content FROM ss13_notes WHERE id = '[noteid]'")
	initquery.Execute()
	while(initquery.NextRow())
		ckey = initquery.item[1]
		content = initquery.item[2]
		count++

	if(count == 0)
		usr << "\red Database update failed due to a note id not being present in the database."
		error("Database update failed due to a note id not being present in the database.")
		return

	if(count > 1)
		usr << "\red Database update failed due to multiple notes having the same ID. Contact the database admin."
		error("Database update failed due to multiple notes having the same ID. Contact the database admin.")
		return

	switch(noteedit)
		if("delete")
			if(alert("Delete this note?", "Delete?", "Yes", "No") == "Yes")
				var/DBQuery/deletequery = dbcon.NewQuery("UPDATE ss13_notes SET visible = 0 WHERE id = '[noteid]'")
				deletequery.Execute()

				message_admins("\blue [key_name_admin(usr)] deleted one of [ckey]'s notes.")
				log_admin("[key_name(usr)] deleted one of [ckey]'s notes.")
			else
				usr << "Cancelled"
				return
		if("content")
			var/newcontent = input("Edit this note's contents.", "New Contents", "[content]", null) as null|text
			newcontent = sql_sanitize_text(newcontent)
			if(!newcontent)
				usr << "Cancelled"
				return
			var/DBQuery/editquery = dbcon.NewQuery("UPDATE ss13_notes SET content = '[newcontent]', lasteditor = '[ackey]', lasteditdate = Now(), edited = 1 WHERE id = [noteid]")
			editquery.Execute()

/datum/admins/proc/show_notes_sql(var/playerckey = null, var/adminckey = null)
	if(!check_rights(R_ADMIN|R_MOD))
		return

	if(adminckey == "Adminbot")
		usr << "Adminbot is not an actual admin. You were lied to."
		//The fucking size of this request would be astronomical. Please do not!
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("SQL connection failed while attempting to view a player's notes!")
		return

	var/dat = "<div align='center'><h3>Notes Look-up Panel</h3><br>"

	//Totally not stealing code from the DB_ban_panel

	dat += "<form method='GET' action='?src=\ref[src]'><b>Search:</b> "
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += "<b>Ckey:</b> <input type='text' name='notessearchckey' value='[playerckey]'>"
	dat += "<b>Admin ckey:</b> <input type='text' name='notessearchadmin' value='[adminckey]'>"
	dat += "<input type='submit' value='search'>"
	dat += "</form></div>"

	dat += "<table width='90%' bgcolor='#e3e3e3' cellpadding='5' cellspacing='0' align='center'>"
	dat += "<tr>"
	dat += "<th width='10%'>ISSUED TO</th>"
	dat += "<th width='10%'>ISSUED BY</th>"
	dat += "<th width='20%'>TIME ISSUED</th>"
	dat += "<th width='50%'>CONTENT</th>"
	dat += "</tr>"

	if(playerckey)

		dat += "<tr><td align='center' colspan='4' bgcolor='white'><b><a href='?src=\ref[src];add_player_info=[playerckey]'>Add Note</a></b></td></tr>"

		var/ckey = sanitizeSQL(playerckey)
		var/IP
		var/CID
		var/DBQuery/initquery = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = '[ckey]'")
		initquery.Execute()
		if(initquery.NextRow())
			IP = initquery.item[1]
			CID = initquery.item[2]

		var/querycontent = "SELECT id, adddate, ckey, a_ckey, content, edited, lasteditor, lasteditdate FROM ss13_notes WHERE ckey = '[ckey]' AND visible = '1'"

		if(IP)
			querycontent += " OR ip = '[IP]' AND visible = '1'"
		if(CID)
			querycontent += " OR computerid = '[CID]' AND visible = '1'"

		querycontent += " ORDER BY adddate ASC"
		var/DBQuery/query = dbcon.NewQuery(querycontent)
		query.Execute()

		while(query.NextRow())
			var/id = text2num(query.item[1])
			var/date = query.item[2]
			var/p_ckey = query.item[3]
			var/a_ckey = query.item[4]
			var/content = query.item[5]
			var/edited = text2num(query.item[6])

			if(adminckey && ckey(a_ckey) != ckey(adminckey))
				continue
			else
				dat += "<tr bgcolor='#ffeeee'><td align='center'><b>[p_ckey]</b></td><td align='center'><b>[a_ckey]</b></td><td align='center'>[date]</td><td align='center'>[content]</td></tr>"
				if(edited)
					var/lasteditor = query.item[7]
					var/editdate = query.item[8]
					dat += "<tr><td align='center' colspan='4'><b>Note last edited: [editdate], by: [lasteditor].</b></td></tr>"
				dat += "<tr><td align='center' colspan='4'><b>(<a href=\"byond://?src=\ref[src];dbnoteedit=delete;dbnoteid=[id]\">Delete</a>) (<a href=\"byond://?src=\ref[src];dbnoteedit=content;dbnoteid=[id]\">Edit</a>)</b></td></tr>"
				dat += "<tr><td colspan='4' bgcolor='white'>&nbsp</td></tr>"

	else if(adminckey && !playerckey)
		var/adminkey = sanitizeSQL(adminckey)

		var/aquerycontent = "SELECT id, adddate, ckey, content, edited, lasteditor, lasteditdate FROM ss13_notes WHERE a_ckey = '[ckey(adminkey)]' AND visible = '1' ORDER BY adddate ASC"
		var/DBQuery/adminquery = dbcon.NewQuery(aquerycontent)
		adminquery.Execute()

		while(adminquery.NextRow())
			var/id = text2num(adminquery.item[1])
			var/date = adminquery.item[2]
			var/p_ckey = adminquery.item[3]
			var/content = adminquery.item[4]
			var/edited = text2num(adminquery.item[5])

			dat += "<tr bgcolor='#ffeeee'><td align='center'><b>[p_ckey]</b></td><td align='center'><b>[adminckey]</b></td><td align='center'>[date]</td><td align='center'>[content]</td></tr>"
			if(edited)
				var/lasteditor = adminquery.item[6]
				var/editdate = adminquery.item[7]
				dat += "<tr><td align='center' colspan='4'><b>Note last edited: [editdate], by: [lasteditor].</b></td></tr>"
			dat += "<tr><td align='center' colspan='4'><b>(<a href=\"byond://?src=\ref[src];dbnoteedit=delete;dbnoteid=[id]\">Delete</a>) (<a href=\"byond://?src=\ref[src];dbnoteedit=content;dbnoteid=[id]\">Edit</a>)</b></td></tr>"
			dat += "<tr><td colspan='4' bgcolor='white'>&nbsp</td></tr>"

	dat += "</table>"
	usr << browse(dat,"window=lookupnotes;size=900x500")

/*/proc/notes_transfer()
	msg_scopes("Locating master list.")
	var/savefile/note_list = new("data/player_notes.sav")
	var/list/note_keys
	note_list >> note_keys

	msg_scopes("Establishing DB connection!")
	establish_db_connection()
	if(!dbcon.IsConnected())
		msg_scopes("No DB connection!")
		return

	for(var/t in note_keys)
		var/IP = null
		var/CID = null
		var/DBQuery/query = dbcon.NewQuery("SELECT ip, computerid FROM ss13_player WHERE ckey = '[t]'")
		query.Execute()
		if(query.NextRow())
			IP = query.item[1]
			CID = query.item[2]

		var/savefile/info = new("data/player_saves/[copytext(t, 1, 2)]/[t]/info.sav")
		var/list/infos
		info >> infos

		for(var/datum/player_info/I in infos)
			var/a_ckey = sanitizeSQL(I.author)
			var/timeY = copytext(I.timestamp, findtext(I.timestamp, "of") + 3)
			var/timeM
			var/timeD = copytext(I.timestamp, findtext(I.timestamp, " ", 6) + 1, findtext(I.timestamp, " ", 6) + 3)
			if(findtext(timeD, "s") || findtext(timeD, "n") || findtext(timeD, "r") || findtext(timeD, "t"))
				timeD = "0[copytext(timeD, 1, 2)]"

//			msg_scopes("Timestamp: [I.timestamp].")
			var/temp = copytext(I.timestamp, 6, findtext(I.timestamp, " ", 6))
//			msg_scopes("The day? [timeD].")
//			msg_scopes("The month? [temp].")
//			msg_scopes("The year? [timeY].")
			switch(temp)
				if("January")
					timeM = "01"
				if("February")
					timeM = "02"
				if("March")
					timeM = "03"
				if("April")
					timeM = "04"
				if("May")
					timeM = "05"
				if("June")
					timeM = "06"
				if("July")
					timeM = "07"
				if("August")
					timeM = "08"
				if("September")
					timeM = "09"
				if("October")
					timeM = "10"
				if("November")
					timeM = "11"
				if("December")
					timeM = "12"

			var/DTG = "[timeY]-[timeM]-[timeD] 00:00:00"
//			msg_scopes("Full DTG: [DTG]")
			var/insertionstuff
			if(IP && CID)
				insertionstuff = "INSERT INTO ss13_notes (id, adddate, ckey, ip, computerid, a_ckey, content) VALUES (null, '[DTG]', '[t]', '[IP]', '[CID]', '[a_ckey]', '[I.content]')"
			else
				insertionstuff = "INSERT INTO ss13_notes (id, adddate, ckey, ip, computerid, a_ckey, content) VALUES (null, '[DTG]', '[t]', null, null, '[a_ckey]', '[I.content]')"
			var/DBQuery/insertquery = dbcon.NewQuery(insertionstuff)
			insertquery.Execute()
			if(insertquery.ErrorMsg())
				msg_scopes(insertquery.ErrorMsg())
			else
				msg_scopes("Transfer successful.")*/

/******************** Requests Console ********************/
/** Originally written by errorage, updated by: Carn, needs more work though. I just added some security fixes */

var/req_console_assistance = list()
var/req_console_supplies = list()
var/req_console_information = list()
var/list/obj/machinery/requests_console/allConsoles = list()

/obj/machinery/requests_console
	name = "Requests Console"
	desc = "A console intended to send requests to different departments on the station."
	anchored = 1
	icon = 'icons/obj/terminals.dmi'
	icon_state = "req_comp0"
	var/department = "Unknown" //The list of all departments on the station (Determined from this variable on each unit) Set this to the same thing if you want several consoles in one department
	var/list/messages = list() //List of all messages
	var/departmentType = 0
		// 0 = none (not listed, can only repeplied to)
		// 1 = assistance
		// 2 = supplies
		// 3 = info
		// 4 = ass + sup //Erro goddamn you just HAD to shorten "assistance" down to "ass"
		// 5 = ass + info
		// 6 = sup + info
		// 7 = ass + sup + info
	var/newmessagepriority = 0
		// 0 = no new message
		// 1 = normal priority
		// 2 = high priority
		// 3 = extreme priority - not implemented, will probably require some hacking... everything needs to have a hidden feature in this game.
	var/screen = 0
		// 0 = main menu,
		// 1 = req. assistance,
		// 2 = req. supplies
		// 3 = relay information
		// 4 = write msg - not used
		// 5 = choose priority - not used
		// 6 = sent successfully
		// 7 = sent unsuccessfully
		// 8 = view messages
		// 9 = authentication before sending
		// 10 = send announcement
		// 11 = form database
		// 12 = directive index
		// 13 = directive view
		// 14 = directive description
	var/silent = 0 // set to 1 for it not to beep all the time
//	var/hackState = 0
		// 0 = not hacked
		// 1 = hacked
	var/announcementConsole = 0
		// 0 = This console cannot be used to send department announcements
		// 1 = This console can send department announcementsf
	var/open = 0 // 1 if open
	var/announceAuth = 0 //Will be set to 1 when you authenticate yourself for announcements
	var/msgVerified = "" //Will contain the name of the person who varified it
	var/msgStamped = "" //If a message is stamped, this will contain the stamp name
	var/message = "";
	var/dpt = ""; //the department which will be receiving the message
	var/priority = -1 ; //Priority of the message being sent
	var/SQLquery
	var/queryid
	var/paperstock = 10
	var/lid = 0
	luminosity = 0

/obj/machinery/requests_console/power_change()
	..()
	update_icon()

/obj/machinery/requests_console/update_icon()
	if(stat & NOPOWER)
		if(icon_state != "req_comp_off")
			icon_state = "req_comp_off"
	else
		if(icon_state == "req_comp_off")
			icon_state = "req_comp0"

/obj/machinery/requests_console/New()
	..()
	name = "[department] Requests Console"
	allConsoles += src
	//req_console_departments += department
	switch(departmentType)
		if(1)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
		if(2)
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
		if(3)
			if(!("[department]" in req_console_information))
				req_console_information += department
		if(4)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
		if(5)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
			if(!("[department]" in req_console_information))
				req_console_information += department
		if(6)
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
			if(!("[department]" in req_console_information))
				req_console_information += department
		if(7)
			if(!("[department]" in req_console_assistance))
				req_console_assistance += department
			if(!("[department]" in req_console_supplies))
				req_console_supplies += department
			if(!("[department]" in req_console_information))
				req_console_information += department


/obj/machinery/requests_console/attack_hand(user as mob)
	if(..(user))
		return
	var/dat
	dat = text("<HEAD><TITLE>Requests Console</TITLE></HEAD><H3>[department] Requests Console</H3>")
	if(!open)
		switch(screen)
			if(1)	//req. assistance
				dat += text("Which department do you need assistance from?<BR><BR>")
				for(var/dpt in req_console_assistance)
					if (dpt != department)
						dat += text("[dpt] (<A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> or ")
						dat += text("<A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
						dat += text(")<BR>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'>Back</A><BR>")

			if(2)	//req. supplies
				dat += text("Which department do you need supplies from?<BR><BR>")
				for(var/dpt in req_console_supplies)
					if (dpt != department)
						dat += text("[dpt] (<A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> or ")
						dat += text("<A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
						dat += text(")<BR>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'>Back</A><BR>")

			if(3)	//relay information
				dat += text("Which department would you like to send information to?<BR><BR>")
				for(var/dpt in req_console_information)
					if (dpt != department)
						dat += text("[dpt] (<A href='?src=\ref[src];write=[ckey(dpt)]'>Message</A> or ")
						dat += text("<A href='?src=\ref[src];write=[ckey(dpt)];priority=2'>High Priority</A>")
//						if (hackState == 1)
//							dat += text(" or <A href='?src=\ref[src];write=[ckey(dpt)];priority=3'>EXTREME</A>)")
						dat += text(")<BR>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'>Back</A><BR>")

			if(6)	//sent successfully
				dat += text("<FONT COLOR='GREEN'>Message sent</FONT><BR><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=0'>Continue</A><BR>")

			if(7)	//unsuccessful; not sent
				dat += text("<FONT COLOR='RED'>An error occurred. </FONT><BR><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=0'>Continue</A><BR>")

			if(8)	//view messages
				for (var/obj/machinery/requests_console/Console in allConsoles)
					if (Console.department == department)
						Console.newmessagepriority = 0
						Console.icon_state = "req_comp0"
						Console.luminosity = 1
				newmessagepriority = 0
				icon_state = "req_comp0"
				for(var/msg in messages)
					dat += text("[msg]<BR>")
				dat += text("<A href='?src=\ref[src];setScreen=0'>Back to main menu</A><BR>")

			if(9)	//authentication before sending
				dat += text("<B>Message Authentication</B><BR><BR>")
				dat += text("<b>Message for [dpt]: </b>[message]<BR><BR>")
				dat += text("You may authenticate your message now by scanning your ID or your stamp<BR><BR>")
				dat += text("Validated by: [msgVerified]<br>");
				dat += text("Stamped by: [msgStamped]<br>");
				dat += text("<A href='?src=\ref[src];department=[dpt]'>Send</A><BR>");
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'>Back</A><BR>")

			if(10)	//send announcement
				dat += text("<B>Station wide announcement</B><BR><BR>")
				if(announceAuth)
					dat += text("<b>Authentication accepted</b><BR><BR>")
				else
					dat += text("Swipe your card to authenticate yourself.<BR><BR>")
				dat += text("<b>Message: </b>[message] <A href='?src=\ref[src];writeAnnouncement=1'>Write</A><BR><BR>")
				if (announceAuth && message)
					dat += text("<A href='?src=\ref[src];sendAnnouncement=1'>Announce</A><BR>");
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'>Back</A><BR>")

			if(11)	//form database
				dat += text("<B>NanoTrasen Corporate Forms</B><br><br>")

				establish_db_connection()

				if(!dbcon.IsConnected())
					dat += text("<font color=red><b>ERROR</b>: Unable to contact external database. Please contact your system administrator for assistance.</font>")
					log_game("SQL database connection failed. Attempted to fetch form information.")
				else
					dat += {"<table border='1'>
					<tr><th>NCF ID</th><th>Form Name</th><td></td><td></td><td></td></tr>"}

					//For reference:
					//Command forms, 	01xx series
					//Security forms,	02xx series
					//Medical forms,	03xx series
					//Engineer forms,	04xx series
					//Science forms,	05xx series
					//Supply forms,		06xx series
					//General forms,	10xx series

					var/DBQuery/query = dbcon.NewQuery(SQLquery)
					query.Execute()

					while(query.NextRow())
						var/id = query.item[1]
						var/name = query.item[2]
						var/department = query.item[3]
						dat += "<tr><td>NCF-[id]</td><td>[name]</td><td><a href='?src=\ref[src];sort=[department]'>[department]</a></td><td><a href='?src=\ref[src];print=[id]'>Print</a></td><td><a href='?src=\ref[src];whatis=[id]'>?</a></td></tr>"
					dat += "</table>"
					dat += text("<br><A href='?src=\ref[src];setScreen=11'>Reset Search</a>")
				dat += text("<BR><A href='?src=\ref[src];setScreen=0'>Back</A><BR>")

			if(12) //directive index
				dat += "<div align='center'><b>Station Directives<br>NanoTrasen<br>NSS Aurora</b></div><br>"

				establish_db_connection()
				if(!dbcon.IsConnected())
					dat += text("<div align='center'><font color=red><b>ERROR</b>: Unable to contact external database.</div></font>")
					error("SQL database connection failed. Attempted to fetch form information.")

				var/DBQuery/query = dbcon.NewQuery("SELECT id, name FROM ss13_directives")
				query.Execute()
				dat += "<div align='center'><table width='90%' cellpadding='2' cellspacing='0'>"
				dat += "<tr><td colspan='3' bgcolor='white' align='center'><a href='?src=\ref[src];setScreen=14'>Regarding Station Directives</a><br></td></tr>"

				while(query.NextRow())
					var/id = text2num(query.item[1])
					var/name = query.item[2]

					var/bgcolor = "#e3e3e3"
					if(id%2 == 0)
						bgcolor = "white"
					dat += "<tr bgcolor='[bgcolor]'><td>Directive #[id]</td><td>[name]</td><td><a href='?src=\ref[src];directivesview=[id]'>Review</a></td></tr>"
				dat += "</table></div>"
				dat += "<br><div align='center'><a href='?src=\ref[src];setScreen=0'>Return to Main Menu</a></div>"

			if(13)	//directive view
				if(!queryid)
					return //this should never happen

				var/DBQuery/searchquery = dbcon.NewQuery("SELECT id, name, data FROM ss13_directives WHERE id=[queryid]")
				searchquery.Execute()

				while(searchquery.NextRow())
					var/id = searchquery.item[1]
					var/name = searchquery.item[2]
					var/data = searchquery.item[3]

					dat += "<div align='center'><b>Directive #[id]<br>'[name]'</b></div><hr>"
					dat += "<div align='justify'>[data]</div>"

				dat += "<br><div align='center'><a href='?src=\ref[src];setScreen=12'>Return to Index</a></div>"
				dat += "<div align='center'><a href='?src=\ref[src];setScreen=0'>Return to Main Menu</a></div>"

			if(14)	//directive description
				dat += "<div align='center'><b>Regarding Station Directives</b></div><hr>"
				dat += "<div align='justify'>The Station Directives are a set of specific orders and directives issued and enforced aboard a specific NanoTrasen Corporation installation. This terminal provides access to orders and directives enforced aboard the <i>NSS Aurora.</i> Note that these are only enforced upon NanoTrasen Employees, and not civilians or visitors, unless ruled otherwise by sector specific Central Command.<br><br>"
				dat += "Overwriting power of general NanoTrasen Corporate Regulation is given to the Station Directives. Should a conflict emerge, the Station Directives active aboard the specific installation are to be adhered to, over Corporate Regulation.<br><br>"
				dat += "Punishment for a violation of Station Directives should be escalated in the following fashion:<br><ul><li>Verbal warning, and citation. Ensure that the Employee is familiar with the Station Directives.</li><li>Charge of violating article i111 - Failure to Execute an Order - of NanoTrasen Corporate Regulation</li><li>Subsequent charge of violating article i206 - Neglect of Duty - of NanoTrasen Corporate Regulation, and review of Employee by the Employee's Head of Staff.</li><li>Subsequent failure to follow Station Directives should result in suspension of contract, if not imprisonment until transfer to Central Command station.</li></ul>"
				dat += "Dependant on the violation and actual crimes concerned, punishment may be escalated faster, with intent to ensure in the safety of station, equipment and crew.<br>"
				dat += "During non-standard operation, and highly abnormal circumstances, Station Directives may be overlooked, for the sake of a less costly solution to the given emergency. Note that should a follow-on review find this solution to have been more detrimental, and the breach of Directives and Regulation be unwarranted, then such an act will be punished.</div>"
				dat += "<br><div align='center'><a href='?src=\ref[src];setScreen=12'>Return to Index</a></div>"
				dat += "<div align='center'><a href='?src=\ref[src];setScreen=0'>Return to Main Menu</a></div>"

			else	//main menu
				screen = 0
				announceAuth = 0
				if (newmessagepriority == 1)
					dat += text("<FONT COLOR='RED'>There are new messages</FONT><BR>")
				if (newmessagepriority == 2)
					dat += text("<FONT COLOR='RED'><B>NEW PRIORITY MESSAGES</B></FONT><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=8'>View Messages</A><BR><BR>")

				dat += text("<A href='?src=\ref[src];setScreen=1'>Request Assistance</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=2'>Request Supplies</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=3'>Relay Anonymous Information</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=12'>NanoTrasen Station Directives</A><BR>")
				dat += text("<A href='?src=\ref[src];setScreen=11'>NanoTrasen Corporate Form Database</A><BR><BR>")
				if(announcementConsole)
					dat += text("<A href='?src=\ref[src];setScreen=10'>Send station-wide announcement</A><BR><BR>")
				if (silent)
					dat += text("Speaker <A href='?src=\ref[src];setSilent=0'>OFF</A>")
				else
					dat += text("Speaker <A href='?src=\ref[src];setSilent=1'>ON</A>")
				if(paperstock)
					dat += text("<br>[paperstock] papers in stock.")
				else
					dat += text("<br><font color = red>No paper in stock.</font>")
				if(lid)
					dat += text("<br>Paper container lid <A href='?src=\ref[src];setLid=0'>OPEN</A>.")
				else
					dat += text("<br>Paper container lid <A href='?src=\ref[src];setLid=1'>CLOSE</A>.")

		user << browse("[dat]", "window=request_console")
		onclose(user, "req_console")
	return

/obj/machinery/requests_console/Topic(href, href_list)
	if(..())	return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(reject_bad_text(href_list["write"]))
		dpt = ckey(href_list["write"]) //write contains the string of the receiving department's name

		var/new_message = copytext(reject_bad_text(input(usr, "Write your message:", "Awaiting Input", "")),1,MAX_MESSAGE_LEN)
		if(new_message)
			message = new_message
			screen = 9
			switch(href_list["priority"])
				if("2")	priority = 2
				else	priority = -1
		else
			dpt = "";
			msgVerified = ""
			msgStamped = ""
			screen = 0
			priority = -1

	if(href_list["writeAnnouncement"])
		var/new_message = copytext(reject_bad_text(input(usr, "Write your message:", "Awaiting Input", "")),1,MAX_MESSAGE_LEN)
		if(new_message)
			message = new_message
			switch(href_list["priority"])
				if("2")	priority = 2
				else	priority = -1
		else
			message = ""
			announceAuth = 0
			screen = 0

	if(href_list["sendAnnouncement"])
		if(!announcementConsole)	return
		for(var/mob/M in player_list)
			if(!istype(M,/mob/new_player))
				M << "<b><font size = 3><font color = red>[department] announcement:</font color> [message]</font size></b>"
		announceAuth = 0
		message = ""
		screen = 0

	if( href_list["department"] && message )
		var/log_msg = message
		var/sending = message
		sending += "<br>"
		if (msgVerified)
			sending += msgVerified
			sending += "<br>"
		if (msgStamped)
			sending += msgStamped
			sending += "<br>"
		screen = 7 //if it's successful, this will get overrwritten (7 = unsufccessfull, 6 = successfull)
		if (sending)
			var/pass = 0
			for (var/obj/machinery/message_server/MS in world)
				if(!MS.active) continue
				MS.send_rc_message(href_list["department"],department,log_msg,msgStamped,msgVerified,priority)
				pass = 1

			if(pass)

				for (var/obj/machinery/requests_console/Console in allConsoles)
					if (ckey(Console.department) == ckey(href_list["department"]))

						switch(priority)
							if("2")		//High priority
								if(Console.newmessagepriority < 2)
									Console.newmessagepriority = 2
									Console.icon_state = "req_comp2"
								if(!Console.silent)
									playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
									for (var/mob/O in hearers(5, Console.loc))
										O.show_message(text("\icon[Console] *The Requests Console beeps: 'PRIORITY Alert in [department]'"))
								Console.messages += "<B><FONT color='red'>High Priority message from <A href='?src=\ref[Console];write=[ckey(department)]'>[department]</A></FONT></B><BR>[sending]"

		//					if("3")		//Not implemanted, but will be 		//Removed as it doesn't look like anybody intends on implimenting it ~Carn
		//						if(Console.newmessagepriority < 3)
		//							Console.newmessagepriority = 3
		//							Console.icon_state = "req_comp3"
		//						if(!Console.silent)
		//							playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
		//							for (var/mob/O in hearers(7, Console.loc))
		//								O.show_message(text("\icon[Console] *The Requests Console yells: 'EXTREME PRIORITY alert in [department]'"))
		//						Console.messages += "<B><FONT color='red'>Extreme Priority message from [ckey(department)]</FONT></B><BR>[message]"

							else		// Normal priority
								if(Console.newmessagepriority < 1)
									Console.newmessagepriority = 1
									Console.icon_state = "req_comp1"
								if(!Console.silent)
									playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
									for (var/mob/O in hearers(4, Console.loc))
										O.show_message(text("\icon[Console] *The Requests Console beeps: 'Message from [department]'"))
								Console.messages += "<B>Message from <A href='?src=\ref[Console];write=[ckey(department)]'>[department]</A></FONT></B><BR>[message]"

						screen = 6
						Console.luminosity = 2
				messages += "<B>Message sent to [dpt]</B><BR>[message]"
			else
				for (var/mob/O in hearers(4, src.loc))
					O.show_message(text("\icon[src] *The Requests Console beeps: 'NOTICE: No server detected!'"))

	if(href_list["sort"])
		var/sortdep = sanitizeSQL(href_list["sort"])
		SQLquery += " WHERE department LIKE '%[sortdep]%'"
		screen = 11

	if(href_list["print"])
		if(paperstock == 0)
			alert("Error! No paper to print on! Aborting!")
			return
		var/printid = sanitizeSQL(href_list["print"])
		establish_db_connection()

		if(!dbcon.IsConnected())
			alert("Connection to the database lost. Aborting.")
		if(!printid)
			alert("Invalid query. Try again.")
		var/DBQuery/query = dbcon.NewQuery("SELECT id, name, data FROM ss13_forms WHERE id=[printid]")
		query.Execute()

		while(query.NextRow())
			var/id = query.item[1]
			var/name = query.item[2]
			var/data = query.item[3]
			var/obj/item/weapon/paper/C = new(src.loc)

			//Let's start the BB >> HTML conversion!

			data = html_encode(data)
			data = replacetext(data, "\n", "<BR>")

			C.info += data
			C.info = C.parsepencode(C.info)
			C.updateinfolinks()
			C.name = "NFC-[id] - [name]"
			paperstock--

	if(href_list["whatis"])
		var/whatisid = sanitizeSQL(href_list["whatis"])
		establish_db_connection()

		if(!dbcon.IsConnected())
			alert("Connection to the database lost. Aborting.")
		if(!whatisid)
			alert("Invalid query. Try again.")
		var/DBQuery/query = dbcon.NewQuery("SELECT id, name, department, info FROM ss13_forms WHERE id=[whatisid]")
		query.Execute()

		var/dat = "<center><b>NanoTrasen Corporate Form</b><br>"

		while(query.NextRow())
			var/id = query.item[1]
			var/name = query.item[2]
			var/department = query.item[3]
			var/info = query.item[4]

			dat += "<b>NCF-[id]</b><br><br>"
			dat += "<b>[name]</b><br>"
			dat += "<b>[department] Department</b><hr>"
			dat += "[info]"
		dat += "</center>"
		usr << browse(dat, "window=Information;size=560x240")

	switch( href_list["setLid"] )
		if(null)	//skip
		if("1")	lid = 1
		else	lid = 0

	//Handle screen switching
	switch(text2num(href_list["setScreen"]))
		if(null)	//skip
		if(1)		//req. assistance
			screen = 1
		if(2)		//req. supplies
			screen = 2
		if(3)		//relay information
			screen = 3
//		if(4)		//write message
//			screen = 4
		if(5)		//choose priority
			screen = 5
		if(6)		//sent successfully
			screen = 6
		if(7)		//unsuccessfull; not sent
			screen = 7
		if(8)		//view messages
			screen = 8
		if(9)		//authentication
			screen = 9
		if(10)		//send announcement
			if(!announcementConsole)	return
			screen = 10
		if(11)		//form database
			SQLquery = "SELECT id, name, department FROM ss13_forms"
			screen = 11
		if(12)		//directive index
			screen = 12
		if(13)		//directive view
			screen = 13
		if(14)		//directive description
			screen = 14
		else		//main menu
			dpt = ""
			msgVerified = ""
			msgStamped = ""
			message = ""
			priority = -1
			screen = 0

	//Handle silencing the console
	switch( href_list["setSilent"] )
		if(null)	//skip
		if("1")	silent = 1
		else	silent = 0

	if(href_list["directivesview"])
		queryid = sanitizeSQL(href_list["directivesview"])
		screen = 13


	updateUsrDialog()
	return

					//err... hacking code, which has no reason for existing... but anyway... it's supposed to unlock priority 3 messanging on that console (EXTREME priority...) the code for that actually exists.
/obj/machinery/requests_console/attackby(var/obj/item/weapon/O as obj, var/mob/user as mob)
	/*
	if (istype(O, /obj/item/weapon/crowbar))
		if(open)
			open = 0
			icon_state="req_comp0"
		else
			open = 1
			if(hackState == 0)
				icon_state="req_comp_open"
			else if(hackState == 1)
				icon_state="req_comp_rewired"
	if (istype(O, /obj/item/weapon/screwdriver))
		if(open)
			if(hackState == 0)
				hackState = 1
				icon_state="req_comp_rewired"
			else if(hackState == 1)
				hackState = 0
				icon_state="req_comp_open"
		else
			user << "You can't do much with that."*/

	if (istype(O, /obj/item/weapon/card/id))
		if(screen == 9)
			var/obj/item/weapon/card/id/T = O
			msgVerified = text("<font color='green'><b>Verified by [T.registered_name] ([T.assignment])</b></font>")
			updateUsrDialog()
		if(screen == 10)
			var/obj/item/weapon/card/id/ID = O
			if (access_RC_announce in ID.GetAccess())
				announceAuth = 1
			else
				announceAuth = 0
				user << "\red You are not authorized to send announcements."
			updateUsrDialog()
	if (istype(O, /obj/item/weapon/stamp))
		if(screen == 9)
			var/obj/item/weapon/stamp/T = O
			msgStamped = text("<font color='blue'><b>Stamped with the [T.name]</b></font>")
			updateUsrDialog()
	if (istype(O, /obj/item/weapon/paper_bundle))
		if(lid)					//More of that restocking business
			var/obj/item/weapon/paper_bundle/C = O
			paperstock += C.amount
			user.drop_item(C)
			del(C)
			for (var/mob/U in hearers(4, src.loc))
				U.show_message(text("\icon[src] *The Requests Console beeps: 'Paper added.'"))
		else
			user << "\blue I should open the lid to add more paper, or try faxing one paper at a time."
	if (istype(O, /obj/item/weapon/paper))
		if(lid)					//Stocking them papers
			var/obj/item/weapon/paper/C = O
			user.drop_item(C)
			del(C)
			paperstock++
			for (var/mob/U in hearers(4, src.loc))
				U.show_message(text("\icon[src] *The Requests Console beeps: 'Paper added.'"))
		else if(screen == 0)	//Faxing them papers
			var/pass = 0
			var/sendto = input("Select department.", "Send Fax", null, null) in allConsoles

			for (var/obj/machinery/message_server/MS in world)
				if(!MS.active) continue
				pass = 1

			if(pass)
				var/sent = 0
				for (var/obj/machinery/requests_console/Console in world)
					if (Console == sendto)
						if(Console.paperstock == 0)
							alert("Error! Receiving console out of paper! Aborting!")
							return
						if(!sent)
							sent = 1

						var/obj/item/weapon/paper/C = O
						var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(Console.loc)
						P.info = "<font color = #101010>"
						var/copied = html_decode(C.info)
						copied = replacetext(copied, "<font face=\"[P.deffont]\" color=", "<font face=\"[P.deffont]\" nocolor=")	//state of the art techniques in action
						copied = replacetext(copied, "<font face=\"[P.crayonfont]\" color=", "<font face=\"[P.crayonfont]\" nocolor=")	//This basically just breaks the existing color tag, which we need to do because the innermost tag takes priority.
						P.info += copied
						P.info += "</font>"
						P.name = C.name
						P.fields = C.fields
						P.stamps = C.stamps
						P.stamped = C.stamped
						P.ico = C.ico
						P.offset_x = C.offset_x
						P.offset_y = C.offset_y
						var/list/temp_overlays = C.overlays
						var/image/img
						for (var/j = 1, j <= temp_overlays.len, j++)
							if (findtext(C.ico[j], "cap") || findtext(C.ico[j], "cent"))
								img = image('icons/obj/bureaucracy.dmi', "paper_stamp-circle")
							else if (findtext(C.ico[j], "deny"))
								img = image('icons/obj/bureaucracy.dmi', "paper_stamp-x")
							else
								img = image('icons/obj/bureaucracy.dmi', "paper_stamp-dots")
							img.pixel_x = C.offset_x[j]
							img.pixel_y = C.offset_y[j]
							P.overlays += img

						P.updateinfolinks()
						playsound(Console.loc, 'sound/machines/twobeep.ogg', 50, 1)
						for (var/mob/player in hearers(4, Console.loc))
							player.show_message(text("\icon[Console] *The Requests Console beeps: 'Fax received'"))
						Console.paperstock--

				if(sent == 1)
					user.show_message(text("\icon[src] *The Requests Console beeps: 'Message Sent.'"))

			else
				user.show_message(text("\icon[src] *The Requests Console beeps: 'NOTICE: No server detected!'"))

	return

/*
 *
 *For housing procs and things related to the viewing of General Orders.
 *Later iterations may get bound through other DMs
 *
 */

/*
 *Proc for fetching and displaying the General Orders
 */

/client/proc/orderslookup()
	var/dat = "<div align='center'><u>Crew General Orders<br>NanoTrasen<br>NSS Aurora</u></div><br><br>"
	var/SQLquery

	establish_db_connection()
	if(!dbcon.IsConnected())
		dat += text("<font color=red><b>ERROR</b>: Unable to contact external database. Please contact your system administrator for assistance.</font>")
		log_game("SQL database connection failed. Attempted to fetch form information.")

	dat += {"<table border='1'><tr><th>Order #</th><th>Order Name</th><td></td></tr>"}
	var/DBQuery/query = dbcon.NewQuery(SQLquery)
	query.Execute()

	while(query.NextRow())
		var/id = query.item[1]
		var/name = query.item[2]
		var/data = query.item[3]

		dat += "<tr><td>[id]</td><td>[name]</td><td><a href='?src=\ref[src];goreview=[id]'>Review</a></td></tr>"

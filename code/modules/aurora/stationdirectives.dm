/*
 *
 *For housing procs and things related to the viewing of Station Directives.
 *Later iterations may get bound through other DMs
 *
 */

/*
 *Proc for fetching and displaying the Station Directives
 */

/client/proc/directiveslookup(var/screen = 1, var/queryid="", var/machine)
	var/dat = "<div align='center'><b>Station Directives<br>NanoTrasen<br>NSS Aurora</b></div><br>"

	establish_db_connection()
	if(!dbcon.IsConnected())
		dat += text("<div align='center'><font color=red><b>ERROR</b>: Unable to contact external database.</div></font>")
		log_game("SQL database connection failed. Attempted to fetch form information.")

	switch(screen)
		if(1)
			var/DBQuery/query = dbcon.NewQuery("SELECT id, name FROM aurora_directives")
			query.Execute()
			dat += "<div align='center'><table width='90%' cellpadding='2' cellspacing='0'>"
			dat += "<tr><td colspan='3' bgcolor='white' align='center'><a href='?src=\ref[src];directivescreen=3'>Regarding Station Directives</a><br></td></tr>"
			var/bgcolor = "white"
			var/even = 1	//Hacky-hacky-hacky!

			while(query.NextRow())
				var/id = query.item[1]
				var/name = query.item[2]

				switch(even)
					if(0)
						bgcolor = "white"
						even = 1
					if(1)
						bgcolor = "#e3e3e3"
						even = 0
				dat += "<tr bgcolor='[bgcolor]'><td>Directive #[id]</td><td>[name]</td><td><a href='?src=\ref[src];directiveview=[id]'>Review</a></td></tr>"
			dat += "</table></div>"
		if(2)
			if(!queryid)
				return //this should never happen

			var/DBQuery/searchquery = dbcon.NewQuery("SELECT id, name, data FROM aurora_directives WHERE id=[queryid]")
			searchquery.Execute()

			while(searchquery.NextRow())
				var/id = searchquery.item[1]
				var/name = searchquery.item[2]
				var/data = searchquery.item[3]

				dat += "<div align='center'><b>Directive #[id]<br>'[name]'</b></div><hr>"
				dat += "<div align='center'>[data]</div>"

			dat += "<div align='center'><a href='?src=\ref[src];directivescreen=1'>Return to Index</a></div>"
		if(3)
			dat += "<div align='center'><b>Regarding Station Directives</b></div><hr>"
			dat += "<div align='justify'>The Station Directives are a set of specific orders and directives issued and enforced aboard a specific NanoTrasen Corporation installation. This terminal provides access to orders and directives enforced aboard the <i>NSS Aurora.</i> Note that these are only enforced upon NanoTrasen Employees, and not civilian orotherwise visitors, unless ruled otherwise by sector specific Central Command.<br><br>"
			dat += "Overwriting power of general NanoTrasen Corporate Regulation is given to the Station Directives. Should a conflict emerge, the Station Directives active aboard the specific installation are to be adhered to, over Corporate Regulation.<br><br>"
			dat += "Punishment for a violation of Station Directives should be escalated in the following fashion:<br><ul><li>Verbal warning, and citation. Ensure that the Employee is familiar with the Station Directives.</li><li>Charge of violating article i111 - Failure to Execute an Order - of NanoTrasen Corporate Regulation</li><li>Subsequent charge of violating article i206 - Neglect of Duty - of NanoTrasen Corporate Regulation, and review of Employee by the Employee's Head of Staff.</li><li>Subsequent failure to follow Station Directives should result in suspension of contract, if not imprisonment until transfer to Central Command station.</li></ul>"
			dat += "Obviously, dependant on the violation and actual crimes concerned, punishment may be escalated faster, with intent to ensure in the safety of station, equipment and crew.</div>"
			dat += "<br><div align='center'><a href='?src=\ref[src];directivescreen=1'>Return to Index</a></div>"
	usr << browse("[dat]", "window=station_directives;size=400x380")


/*
 *
 *For housing code that's related to bringing news over at preset times from an SQL database into the game and publish them
 *
 *The basic premise is:
 *This gets created in the master controller.
 *It then starts checking and crawling down an organized SQL list.
 *Releases news articles one after another, based on when they're meant to be released.
 *It's recursive and kills itself once it runs to the end of it's list.
 *
 *TO DO:
 *Make it create a new feed channel if specified.
 *
 */

var/global/datum/sqlnews/sqlnews_controller

datum/sqlnews
	var/count = 0	//arbitrary count variable, increased every time an article is pulled, for sorting SQL data.
	var/time		//publishtime, time in gametime
	var/id			//id, primary-key, of the news article that's destined for pulling.
	var/running = 1	//whenever no results are found, this ticks over to a 0, and thus, no more updates.
	var/fails = 0

datum/sqlnews/proc/process()
	if(!running == 1)	//No more news, immediate kill and return.
		return

	if(fails >= 5)		//If it sucks at running, we'll off it.
		kill()
		return

	if(!id && !time)	//No entry loaded, update and load one.
		update()
		return

	else if(time < world.time)	//Running late! Time to publish the stored article!
		publish()
		return

datum/sqlnews/proc/update()		//Updates the stored variables and preppes it for a new run of publish()
	establish_db_connection()
	if(!dbcon.IsConnected())
		error("SQL database connection failed. Attempted to fetch news information.")
		fails++
		return

	var/DBQuery/query = dbcon.NewQuery("SELECT id, publishtime FROM ss13_news WHERE status = '2' ORDER BY publishtime ASC LIMIT [count],1")
	query.Execute()

	if(!query.RowCount())
		running = 0
		return

	while(query.NextRow())
		id = query.item[1]
		time = text2num(query.item[2]) * 600

	count++

datum/sqlnews/proc/publish()	//Uses data stored from the update() proc and: pulls further information required to publish an article, publishes it.
	if(!id)
		return

	establish_db_connection()
	if(!dbcon.IsConnected())
		error("SQL database connection failed. Attempted to fetch news information.")
		fails++
		return

	var/DBQuery/fetchquery = dbcon.NewQuery("SELECT channel, author, body FROM ss13_news WHERE id=[id]")
	fetchquery.Execute()

	while(fetchquery.NextRow())
		var/channel = fetchquery.item[1]
		var/author = fetchquery.item[2]
		var/body = fetchquery.item[3]

		var/datum/feed_message/newMsg = new /datum/feed_message
		newMsg.author = author
		newMsg.body = body

		var/found	//Do we need a new channel or not?
		for(var/datum/feed_channel/FC in news_network.network_channels)
			if(FC.channel_name == channel)
				FC.messages += newMsg
				found = 1

		if(!found)
			var/datum/feed_channel/NC = new /datum/feed_channel
			NC.channel_name = channel
			NC.author = author
			NC.locked = 1
			NC.is_admin_channel = 1
			news_network.network_channels += NC

			NC.messages += newMsg

		for(var/obj/machinery/newscaster/NEWSCASTER in allCasters)
			NEWSCASTER.newsAlert("[channel]")

	id = null
	time = null

datum/sqlnews/proc/kill()
	running = 0
	return
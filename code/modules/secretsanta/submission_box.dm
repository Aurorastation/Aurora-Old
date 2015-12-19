/*
*	Contains the secret santa structures and procs.
*	Requires database modification to work.
*/

#define CUTOFF_DATE 19
#define STATUS_CLOSED 0
#define STATUS_SIGNUP 1
#define STATUS_GIFTS 2

/obj/structure/santa_signup_box
	name = "Secret Santa Sign-up Box"
	desc = "Sign up to participate in NSS Aurora secret santa extravaganza here!"
	anchored = 1
	density = 1

	icon = 'icons/obj/secret_santa.dmi'
	icon_state = "sign_up_box"

	var/daysLeft
	var/signupStatus

/obj/structure/santa_signup_box/New()
	..()

	daysLeft = CUTOFF_DATE - text2num(time2text(world.realtime, "DD"))

	if (time2text(world.realtime, "MM") != "12")
		signupStatus = STATUS_CLOSED
		return

	if (daysLeft > 0)
		signupStatus = STATUS_SIGNUP
	else
		signupStatus = STATUS_GIFTS

/obj/structure/santa_signup_box/examine()
	..()

	switch (signupStatus)
		if (STATUS_SIGNUP)
			usr << "\blue Sign-ups to participate are still being accepted for the next [daysLeft] days!"
		if (STATUS_GIFTS)
			usr << "\blue Currently accepting gift submissions from assigned santas!"
		else
			usr << "\red Christmas is over! Go home, scrub!"

/obj/structure/santa_signup_box/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/structure/santa_signup_box/ui_interact(mob/user)
	if (user.stat)
		return

	if (!ishuman(user))
		user << "\red You must be human to use this machine!"
		return

	var/mob/living/carbon/human/M = user

	if (!M.client || M.client.player_age < 14)
		user << "\red You haven't been around for long enough to participate! Sorry, but this is kind of an anti-spam measure..."
		return

	var/explanation = "<br><br><center><b>Explanation:</b></center><br>"
	explanation += "<center>Everyone has until the 18th of December to sign up to participate. On the 19th of December, everyone who's signed up will be assigned a mark. You can return to this box on that day, or afterwards, to check up who you were assigned!<br>After that, until the 26th of December, you can submit a gift idea to this box. The gifts will be delivered by a NanoTrasen approved Santa Claus after the 24th!</center><br><br>"
	explanation += "<center><b>OOC remarks:</b> Be creative, any item that is ingame is a go! Also, feel free to seek out your mark and try to figure out what would suit them best! The gifted items will spawn on the marked characters until mid-to-late-January.<br><b>No weapons or godmodded items<b> -- the only rule.<br>If you were assigned a mark you don't know anything about, and cannot reasonably interact with due to timezone constraints, please contact Skull132 ASAP!</center>"

	var/dat

	establish_db_connection()

	if (dbcon.IsConnected())
		switch (signupStatus)
			if (STATUS_CLOSED)
				dat += "<br><br><br><center><b><font color='red'>Christmas is over! Go home, scrub!</font></b></center>"
			if (STATUS_SIGNUP)
				if (isSignedUp(M))
					dat += "<center><b>You are currently signed up to participate in the NSS Aurora secret santa extravaganza!</b></center><br><br>"
					dat += "<center>You have [daysLeft] days left to change your mind, should you want to!</center><br>"
					dat += "<center><font color='red'><a href='?src=\ref[src];choice=withdraw;user=\ref[user]'>Withdraw Participation</a></font></center>"
				else
					dat += "<center><b>You are currently not signed up to participate in the NSS Aurora secret santa extravaganza!</b></center><br><br>"
					dat += "<center>You have [daysLeft] days left to sign up!</center><br>"
					dat += "<center><font color='green'><a href='?src=\ref[src];choice=signup;user=\ref[user]'>Sign up to participate!</a></font></center>"

				dat += explanation

			if (STATUS_GIFTS)
				if (isSignedUp(M))
					if (hasMark(M) && getMarkInfo(hasMark(M)))
						var/datum/santaMark/D = getMarkInfo(hasMark(M))

						dat += "<center>Your mark is: <b>[D.name]</b>!</center><br>"
						dat += "<center>Figure out what they may like for Christmas, and submit the idea for NanoTrasen approval!</center><br>"
						dat += "<center>Your mark is a [D.gender] [D.species] working aboard the NSS Aurora as a [D.job]. They like [D.like].</center><br><br>"

						if (D.gift)
							dat += "<center>You are giving them a [D.gift]. <a href='?src=\ref[src];choice=reviseGift;user=\ref[user]'>Revise</a></center>"
						else
							dat += "<center><a href='?src=\ref[src];choice=submitGift;user=\ref[user]'>Submit Gift Idea</a></center>"

					else
						dat += "<center>You have no mark! This is <font color='red'><b>bad</b></font>! Contact an admin, pronto!</center>"

					dat += explanation
				else
					dat += "<br><br><br><center>You didn't sign up in time! Sorry!</center><br>"
					dat += "<center>Better luck next time!</center>"

				if (user.client.holder && (user.client.holder.rights & R_ADMIN))
					dat += "<br><br><br><center><b><font color='red'>Admin Area</font></b></center><br><br>"
					dat += "<center><a href='?src=\ref[src];choice=assignMarks;user=\ref[user]'>Assign everyone a mark</a></center>"

	else
		dat += "<center>No database connection! System unable to operate!</center>"

	M << browse(dat, "window=secret_santa")
	return

/obj/structure/santa_signup_box/Topic(href, href_list)
	..()

	var/mob/living/carbon/user = locate(href_list["user"])

	switch (href_list["choice"])
		if ("withdraw")
			withdrawSignUp(user)
		if ("signup")
			signUp(user)
		if ("reviseGift")
			assignGift(user)
		if ("submitGift")
			assignGift(user)
		if ("assignMarks")
			assignMarks(user)

	ui_interact(user)
	return

/obj/structure/santa_signup_box/proc/signUp(var/mob/living/carbon/human/user)
	if (!user.client || user.stat || !user.real_name)
		user << "\red No. Die."
		return

	establish_db_connection()

	if (!dbcon.IsConnected())
		user << "\red No database connection! Bad!"
		return

	var/queryText

	var/DBQuery/lookupQuery = dbcon.NewQuery("SELECT * FROM ss13_santa WHERE character_name = '[user.real_name]'")
	lookupQuery.Execute()
	if (lookupQuery.NextRow())
		if (alert(user, "Your data already exists here. Do you just want to be added to the roster again?", "Choices, choices...", "Yes", "No") == "Yes")
			queryText = "UPDATE ss13_santa SET participation_status = '1' WHERE character_name = '[user.real_name]'"
		else
			return

	else
		var/list/storeArray = list("character_name", "character_gender", "character_species", "character_job", "character_like")

		storeArray["character_name"] = sanitizeSQL(user.real_name)
		storeArray["character_gender"] = sanitizeSQL(user.gender)
		storeArray["character_species"] = sanitizeSQL(user.species.name)
		storeArray["character_job"] = input(user, "Please type in your character's normal job", "Character Job") as text
		storeArray["character_like"] = input(user, "Please specific 1 of your character's likes", "Character Like") as message

		storeArray["character_job"] = sanitizeSQL(storeArray["character_job"])
		storeArray["character_like"] = sanitizeSQL(storeArray["character_like"])

		queryText = "INSERT INTO ss13_santa (character_name, character_gender, character_species, character_job, character_like) VALUES ('[storeArray["character_name"]]', '[storeArray["character_gender"]]', '[storeArray["character_species"]]', '[storeArray["character_job"]]', '[storeArray["character_like"]]')"

	var/DBQuery/query = dbcon.NewQuery(queryText)
	if (!query.Execute())
		user << "\red Something went wrong! Give this error to the coders: [query.ErrorMsg()]."
	else
		user << "\blue You are now signed up for the NSS Aurora secret santa extravaganza! Return here after the 18th of December to find out who your mark is!"

	return

/obj/structure/santa_signup_box/proc/isSignedUp(var/mob/living/carbon/human/user)
	establish_db_connection()

	if (!dbcon.IsConnected())
		return 0

	var/isSignedUp = 0

	var/DBQuery/query = dbcon.NewQuery("SELECT participation_status FROM ss13_santa WHERE character_name = '[user.real_name]'")
	query.Execute()
	if (query.NextRow())
		isSignedUp = text2num(query.item[1])

	return isSignedUp

/obj/structure/santa_signup_box/proc/withdrawSignUp(var/mob/living/carbon/human/user)
	establish_db_connection()

	if (!dbcon.IsConnected())
		return

	var/DBQuery/query = dbcon.NewQuery("UPDATE ss13_santa SET participation_status = '0' WHERE character_name = '[user.real_name]'")
	query.Execute()
	return

/obj/structure/santa_signup_box/proc/hasMark(var/mob/living/carbon/human/user)
	establish_db_connection()

	if (!dbcon.IsConnected())
		return 0

	var/DBQuery/query = dbcon.NewQuery("SELECT mark_name FROM ss13_santa WHERE character_name = '[user.real_name]'")
	query.Execute()
	if (query.NextRow())
		return query.item[1]

	return 0

/datum/santaMark
	var/name
	var/gender
	var/species
	var/job
	var/like
	var/gift

/obj/structure/santa_signup_box/proc/getMarkInfo(var/markName)
	if (!markName)
		return 0

	establish_db_connection()

	if (!dbcon.IsConnected())
		return 0

	markName = sanitizeSQL(markName)

	var/DBQuery/query = dbcon.NewQuery("SELECT character_gender, character_species, character_job, character_like, gift_assigned FROM ss13_santa WHERE character_name = '[markName]'")
	query.Execute()

	if (query.ErrorMsg())
		msg_scopes(query.ErrorMsg())

	if (query.NextRow())
		var/datum/santaMark/A = new /datum/santaMark()

		A.name = markName
		A.gender = query.item[1]
		A.species = query.item[2]
		A.job = query.item[3]
		A.like = query.item[4]
		A.gift = query.item[5]

		return A

	return 0

/obj/structure/santa_signup_box/proc/assignGift(var/mob/living/carbon/user)
	establish_db_connection()

	if (!dbcon.IsConnected())
		return

	var/gift = input(user, "What would you like to gift your mark?", "Pick a Gift!") as text
	gift = sanitizeSQL(gift)

	var/DBQuery/query = dbcon.NewQuery("UPDATE ss13_santa SET gift_assigned = '[gift]' WHERE character_name = '[sanitizeSQL(hasMark(user))]'")
	query.Execute()

/obj/structure/santa_signup_box/proc/assignMarks(var/mob/user)
	if (!user.client.holder || !(user.client.holder.rights & R_ADMIN))
		user << "\red You are not an admin! How did you even get here...?"
		return

	if (signupStatus != STATUS_GIFTS)
		user << "\red Sign-ups are still open! They should close first!"
		return

	establish_db_connection()

	if (!dbcon.IsConnected())
		user << "\red No database connection! Aborting!"
		return

	var/list/people = list()

	var/DBQuery/query = dbcon.NewQuery("SELECT character_name FROM ss13_santa WHERE participation_status = '1' AND mark_name IS NULL")
	query.Execute()

	if (query.ErrorMsg())
		user << "\red [query.ErrorMsg()]"
		user << "\red Stopping."
		return

	while (query.NextRow())
		people += sanitizeSQL(query.item[1])

	var/DBQuery/initQuery = dbcon.NewQuery("SELECT character_name FROM ss13_santa WHERE participation_status = '1' AND is_assigned = '0' ORDER BY RAND()")
	initQuery.Execute()

	if (initQuery.ErrorMsg())
		user << "\red [initQuery.ErrorMsg()]"
		user << "\red Stopping."
		return

	var/list/marks = list()

	while (initQuery.NextRow())
		marks += sanitizeSQL(initQuery.item[1])

	var/i = 0

	user << "\blue Marks: [marks.len]"
	user << "\blue People: [people.len]"

	for (var/A in people)
		i++
		var/mark = marks[rand(1, marks.len)]

		var/DBQuery/assignQuery = dbcon.NewQuery("UPDATE ss13_santa SET mark_name = '[mark]' WHERE character_name = '[A]'")
		assignQuery.Execute()

		if (assignQuery.ErrorMsg())
			user << "\red [assignQuery.ErrorMsg()]"
			user << "\red Stopping at mark [i]."
			return

		var/DBQuery/updateMark = dbcon.NewQuery("UPDATE ss13_santa SET is_assigned = '1' WHERE character_name = '[mark]'")
		updateMark.Execute()

		if (updateMark.ErrorMsg())
			user << "\red [updateMark.ErrorMsg()]"
			user << "\red Stopping at mark [i]."
			return

		marks -= mark

	user << "\blue Assignment completed! Have a merry Christmas!"
	return

#undef CUTOFF_DATE
#undef STATUS_CLOSED
#undef STATUS_SIGNUP
#undef STATUS_GIFTS

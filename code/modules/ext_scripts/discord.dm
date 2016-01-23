/proc/send_to_discord(var/channel, var/message)
	if (!config.use_discord_bot)
		return

	if (channel == "admin_channel")
		channel = config.discord_admin_url
	else if (channel == "cciaa_channel")
		channel = config.discord_cciaa_url

	if (!config.discord_mention_everyone && findtext(message, "@everyone"))
		replacetextEx(message, "@everyone", "")

	ext_python("discordbot_message.py", "[config.discord_login] [config.discord_password] [channel] [message]")
	return

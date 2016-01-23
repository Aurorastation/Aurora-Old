import discord
import sys

client = discord.Client()

def run_bot():
	global invite
	global message
	global client

	login = sys.argv[1]
	password = sys.argv[2]
	invite_url = sys.argv[3]

	message = sys.argv[4]
	if len(sys.argv) > 5:
		for in_data in sys.argv[5:]:
			message += " " + in_data

	client.login(login, password)
	invite = client.get_invite(invite_url)

	client.run()

@client.event
def on_ready():
	client.accept_invite(invite)
	client.send_message(invite.channel, message)

	client.logout()
	sys.exit()

if __name__ == "__main__" and len(sys.argv) > 3:
	run_bot()

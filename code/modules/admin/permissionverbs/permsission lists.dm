//admin verb groups - They can overlap if you so wish. Only one of each verb will exist in the verbs list regardless
var/list/admin_verbs_default = list(
	/client/proc/deadmin_self,			/*destroys our own admin datum so we can play as a regular player*/
	/client/proc/hide_verbs,			/*hides all our adminverbs*/
	)

var/list/admin_verbs_admin = list(
//	/datum/admins/proc/show_traitor_panel,	/*interface which shows a mob's mind*/ -Removed due to rare practical use. Moved to debug verbs ~Errorage
//	/client/proc/sendmob,				/*sends a mob somewhere*/ -Removed due to it needing two sorting procs to work, which were executed every time an admin right-clicked. ~Errorage
//	/client/proc/toggle_hear_deadcast,	/*toggles whether we hear deadchat*/
//	/client/proc/deadchat				/*toggles deadchat on/off*/
	/datum/admins/proc/announce,		/*priority announce something to all clients.*/
	/datum/admins/proc/access_news_network,	/*allows access of newscasters*/
	/datum/admins/proc/PlayerNotes,
	/datum/admins/proc/show_player_info,
	/datum/admins/proc/show_player_panel,	/*shows an interface for individual players, with various links (links require additional flags*/
	/datum/admins/proc/show_skills,
	/datum/admins/proc/toggleenter,		/*toggles whether people can join the current game*/
	/datum/admins/proc/toggleguests,	/*toggles whether guests can join the current game*/
	/datum/admins/proc/toggleooc,		/*toggles ooc on/off for everyone*/
	/datum/admins/proc/toggledevooc,
	/datum/admins/proc/togglemodooc,
	/datum/admins/proc/togglelooc,
	/datum/admins/proc/togglemodlooc,
	/datum/admins/proc/toggledevlooc,
	/datum/admins/proc/toggleoocdead,	/*toggles ooc on/off for everyone who is dead*/
	/datum/admins/proc/toggledsay,		/*toggles dsay on/off for everyone*/
	/datum/admins/proc/view_atk_log,	/*shows the server combat-log, doesn't do anything presently*/
	/datum/admins/proc/view_txt_log,	/*shows the server log (diary) for today*/
	/client/proc/admin_call_shuttle,	/*allows us to call the emergency shuttle*/
	/client/proc/admin_cancel_shuttle,	/*allows us to cancel the emergency shuttle, sending it back to centcomm*/
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/admin_memo,			/*admin memo system. show/delete/write. +SERVER needed to delete admin memos of others*/
	/client/proc/admin_memo_player,
	/client/proc/alertlevels,
	/client/proc/allow_character_respawn,   /* Allows a ghost to respawn */
	/client/proc/check_ai_laws,			/*shows AI and borg laws*/
	/client/proc/check_antagonists,
	/client/proc/check_customitem_activity,
	/client/proc/check_words,			/*displays cult-words*/
	/client/proc/cleartox,
	/client/proc/cmd_admin_check_contents,	/*displays the contents of an instance*/
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_admin_direct_narrate,	/*send text directly to a player with no padding. Useful for narratives and fluff-text*/
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/cmd_admin_subtle_message,	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_admin_say,			/*admin-only ooc chat*/
	/client/proc/cmd_admin_rejuvenate,
	/client/proc/cmd_admin_unwind,
	/client/proc/cmd_admin_wind,
	/client/proc/cmd_admin_world_narrate,	/*sends text to all players with no padding*/
	/client/proc/cmd_duty_say,
	/client/proc/cmd_mentor_check_new_players,
	/client/proc/cmd_mod_say,
	/client/proc/colorooc,				/*allows us to set a custom colour for everythign we say in ooc*/
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game. +VAREDIT needed to modify*/
	/client/proc/dsay,					/*talk in deadchat using our ckey/fakekey*/
	/client/proc/free_slot,			/*frees slot for chosen job*/
	/client/proc/game_panel,			/*game panel, allows to change game-mode etc*/
	/client/proc/Getmob,				/*teleports a mob to our location*/
	/client/proc/Getkey,				/*teleports a mob with a certain ckey to our location*/
	/client/proc/getserverlog,			/*allows us to fetch server logs (diary) for other days*/
	/client/proc/giveruntimelog,		/*allows us to give access to runtime logs to somebody*/
	/client/proc/global_man_up,
	/client/proc/hide_most_verbs,		/*hides all our hideable adminverbs*/
	/client/proc/investigate_show,		/*various admintools for investigation. Such as a singulo grief-log*/
	/client/proc/invisimin,				/*allows our mob to go invisible/visible*/
	/client/proc/Jump,
	/client/proc/jumptocoord,			/*we ghost and jump to a coordinate*/
	/client/proc/jumptokey,				/*allows us to jump to the location of a mob with a certain ckey*/
	/client/proc/jumptomob,				/*allows us to jump to a specific mob*/
	/client/proc/jumptoturf,			/*allows us to jump to a specific turf*/
	/client/proc/man_up,
	/client/proc/player_panel,			/*shows an interface for all players, with links to various panels (old style)*/
	/client/proc/player_panel_new,		/*shows an interface for all players, with links to various panels*/
	/client/proc/response_team, // Response Teams admin verb
	/client/proc/toggleadminhelpsound,	/*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/toggle_antagHUD_use,
	/client/proc/toggle_antagHUD_restrictions,
	/client/proc/toggleattacklogs,
	/client/proc/toggledebuglogs,
	/client/proc/toggleghostwriters,
	/client/proc/toggle_hear_radio,		/*toggles whether we hear the radio*/
	/client/proc/toggledrones,
	/client/proc/toggleprayers,
	/client/proc/toggle_view_range,		/*changes how far we can see*/
	/client/proc/toggle_visibily,
	/client/proc/secrets,
	/client/proc/set_ooc
)

var/list/admin_verbs_ban = list(
	/client/proc/unban_panel,
	/client/proc/jobbans,
	/client/proc/warning_panel
	)

var/list/admin_verbs_sounds = list(
	/client/proc/play_local_sound,
	/client/proc/play_sound
	)

var/list/admin_verbs_fun = list(
//Hey look it's in order of letters ^_^
	/datum/admins/proc/access_news_network,
	/datum/admins/proc/toggle_aliens,
	/datum/admins/proc/toggle_space_ninja,
	/client/proc/admin_ghost,
	/client/proc/alertlevels,
	/client/proc/check_ai_laws,
	/client/proc/cinematic,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_change_custom_event,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/cmd_admin_pm_context,
	/client/proc/cmd_admin_pm_panel,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/cmd_mod_say,
	/client/proc/debug_variables,
	/client/proc/drop_bomb,
	/client/proc/dsay,
	/client/proc/editappear,
	/client/proc/everyone_random,
	/client/proc/game_panel,
	/client/proc/Getmob,
	/client/proc/Getkey,
	/client/proc/hide_most_verbs,
	/client/proc/Jump,
	/client/proc/jumptokey,
	/client/proc/jumptomob,
	/client/proc/make_area_sound,
	/client/proc/make_sound,
	/client/proc/object_talk,
	/client/proc/one_click_antag,
	/client/proc/player_panel,
	/client/proc/secrets,
	/client/proc/send_space_ninja,
	/client/proc/toggle_view_range
	)

var/list/admin_verbs_dev = list(
	/datum/admins/proc/restart,
	/client/proc/admin_ghost,
	/client/proc/air_report,
	/client/proc/enable_debug_verbs,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_dev_bst,
	/client/proc/cmd_dev_say,
	/client/proc/cmd_dev_reset_gravity,
	/client/proc/cmd_dev_reset_floating,
	/client/proc/Debug2,
	/client/proc/debug_controller,
	/client/proc/debug_variables,
	/client/proc/dsay,
	/client/proc/getruntimelog,
	/client/proc/giveruntimelog,
	/client/proc/hide_most_verbs,
	/client/proc/kill_air,
	/client/proc/kill_airgroup,
	/client/proc/player_panel,
	/client/proc/reload_admins,
	/client/proc/restart_controller,
	/client/proc/togglebuildmodeself,
	/client/proc/toggledebuglogs,
	/client/proc/togglescopeslogs,
	/client/proc/ZASSettings
)
var/list/admin_verbs_spawn = list(
	/datum/admins/proc/spawn_atom,		/*allows us to spawn instances*/
	/client/proc/respawn_character
	)
var/list/admin_verbs_server = list(
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/adjump,
	/datum/admins/proc/delay,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/toggleAI,
	/datum/admins/proc/toggle_aliens,
	/datum/admins/proc/toggle_space_ninja,
	/datum/admins/proc/immreboot,
	/datum/admins/proc/startnow,
	/datum/admins/proc/restart,
	/client/proc/check_customitem_activity,
	/client/proc/cmd_admin_delete,		/*delete an instance/object/mob/etc*/
	/client/proc/cmd_debug_del_all,
//	/client/proc/eventHost_grant,
//	/client/proc/eventHost_revoke,
	/client/proc/everyone_random,
	/client/proc/nanomapgen_DumpImage,
	/client/proc/SDQL_query,
	/client/proc/SDQL2_query,
	/client/proc/Set_Holiday,
	/client/proc/ToRban,
	/client/proc/toggle_log_hrefs,
	/client/proc/toggle_random_events,
	/client/proc/toggle_visibily
	)

var/list/admin_verbs_debug = list(
	/datum/admins/proc/delay,
	/datum/admins/proc/restart,
	/client/proc/air_report,
	/client/proc/callproc,
	/client/proc/cmd_admin_delete,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/cmd_dev_reset_gravity,
	/client/proc/cmd_dev_reset_floating,
	/client/proc/Debug2,
	/client/proc/debug_controller,
	/client/proc/debug_variables,
	/client/proc/enable_debug_verbs,
//	/client/proc/eventHost_grant,
//	/client/proc/eventHost_revoke,
	/client/proc/fillspace,
	/client/proc/getruntimelog,
	/client/proc/hide_activity,
	/client/proc/kill_air,
	/client/proc/kill_airgroup,
	/client/proc/show_distribution_map,
	/client/proc/toggledebuglogs,
	/client/proc/reload_admins,
	/client/proc/restart_controller,
	/client/proc/remake_distribution_map,
	/client/proc/ZASSettings,
	)

var/list/admin_verbs_possess = list(
	/proc/possess,
	/proc/release
	)

var/list/admin_verbs_permissions = list(
	/client/proc/edit_admin_permissions
	)

var/list/admin_verbs_rejuv = list(
	/client/proc/respawn_character
	)

var/list/admin_verbs_mod = list(
	/datum/admins/proc/PlayerNotes,
	/datum/admins/proc/show_player_info,
	/datum/admins/proc/show_skills,
	/datum/admins/proc/show_player_panel,
	/client/proc/admin_ghost,			/*allows us to ghost/reenter body at will*/
	/client/proc/check_antagonists,		/*shows all antags*/
	/client/proc/check_ai_laws,
	/client/proc/cmd_admin_check_contents,
	/client/proc/cmd_admin_wind,
	/client/proc/cmd_admin_unwind,
	/client/proc/cmd_admin_pm_context,	/*right-click adminPM interface*/
	/client/proc/cmd_admin_pm_panel,	/*admin-pm list*/
	/client/proc/cmd_admin_subtle_message, 	/*send an message to somebody as a 'voice in their head'*/
	/client/proc/cmd_mentor_check_new_players,
	/client/proc/cmd_mod_say,
	/client/proc/debug_variables,		/*allows us to -see- the variables of any instance in the game.*/
	/client/proc/dsay,
	/client/proc/hide_most_verbs,
	/client/proc/jobbans,
	/client/proc/player_panel,
	/client/proc/player_panel_new,
	/client/proc/toggleadminhelpsound,	/*toggles whether we hear a sound when adminhelps/PMs are used*/
	/client/proc/toggleattacklogs,
	/client/proc/toggledebuglogs,
	/client/proc/toggleprayers
)

//verbs which can be hidden - needs work
var/list/admin_verbs_hideable = list(
	/datum/admins/proc/access_news_network,
	/datum/admins/proc/adjump,
	/datum/admins/proc/adrev,
	/datum/admins/proc/adspawn,
	/datum/admins/proc/announce,
	/datum/admins/proc/delay,
	/datum/admins/proc/immreboot,
	/datum/admins/proc/restart,
	/datum/admins/proc/show_traitor_panel,
	/datum/admins/proc/startnow,
	/datum/admins/proc/toggleaban,
	/datum/admins/proc/toggleAI,
	/datum/admins/proc/toggle_aliens,
	/datum/admins/proc/toggleenter,
	/datum/admins/proc/toggleguests,
	/datum/admins/proc/toggle_space_ninja,
	/datum/admins/proc/view_txt_log,
	/datum/admins/proc/view_atk_log,
	/client/proc/admin_call_shuttle,
	/client/proc/admin_cancel_shuttle,
	/client/proc/admin_ghost,
	/client/proc/air_report,
	/client/proc/callproc,
	/client/proc/check_words,
	/client/proc/cinematic,
	/client/proc/cmd_admin_add_freeform_ai_law,
	/client/proc/cmd_admin_add_random_ai_law,
	/client/proc/cmd_admin_check_contents,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_admin_direct_narrate,
	/client/proc/cmd_admin_dress,
	/client/proc/cmd_admin_gib_self,
	/client/proc/cmd_admin_subtle_message,
	/client/proc/cmd_admin_world_narrate,
	/client/proc/cmd_debug_make_powernets,
	/client/proc/cmd_debug_mob_lists,
	/client/proc/cmd_admin_list_open_jobs,
	/client/proc/cmd_debug_del_all,
	/client/proc/cmd_debug_tog_aliens,
	/client/proc/colorooc,
//	/client/proc/deadchat,
	/client/proc/deadmin_self,
	/client/proc/Debug2,
	/client/proc/debug_controller,
	/client/proc/drop_bomb,
	/client/proc/enable_debug_verbs,
	/client/proc/everyone_random,
	/client/proc/kill_air,
	/client/proc/kill_airgroup,
	/client/proc/make_area_sound,
	/client/proc/make_sound,
	/client/proc/object_talk,
	/client/proc/play_local_sound,
	/client/proc/play_sound,
	/client/proc/reload_admins,
	/client/proc/restart_controller,
	/client/proc/send_space_ninja,
	/client/proc/Set_Holiday,
	/client/proc/set_ooc,
	/client/proc/startSinglo,
	/client/proc/toggle_hear_radio,
	/client/proc/toggle_log_hrefs,
	/client/proc/toggleprayers,
	/client/proc/toggle_random_events,
	/client/proc/toggle_view_range,
	/client/proc/ToRban,
	/proc/possess,
	/proc/release
	)

/client/proc/remove_admin_verbs()
	verbs.Remove(
		admin_verbs_default,
		/client/proc/togglebuildmodeself,
		/client/proc/stealth,
		admin_verbs_admin,
		admin_verbs_ban,
		admin_verbs_fun,
		admin_verbs_server,
		admin_verbs_debug,
		admin_verbs_possess,
		admin_verbs_permissions,
		admin_verbs_rejuv,
		admin_verbs_sounds,
		admin_verbs_spawn,
		admin_verbs_dev,
		admin_verbs_duty,
		/*Debug verbs added by "show debug verbs"*/
		/client/proc/Cell,
		/client/proc/do_not_use_these,
		/client/proc/camera_view,
		/client/proc/sec_camera_report,
		/client/proc/intercom_view,
		/client/proc/air_status,
		/client/proc/atmosscan,
		/client/proc/powerdebug,
		/client/proc/count_objects_on_z_level,
		/client/proc/count_objects_all,
		/client/proc/cmd_assume_direct_control,
		/client/proc/jump_to_dead_group,
		/client/proc/startSinglo,
		/client/proc/ticklag,
		/client/proc/cmd_admin_grantfullaccess,
		/client/proc/kaboom,
		/client/proc/splash,
		/client/proc/cmd_admin_areatest,
		/client/proc/view_power_update_stats_area,
		/client/proc/view_power_update_stats_machines,
		/client/proc/toggle_power_update_profiling,
		/client/proc/atmos_toggle_debug
		)

var/list/admin_verbs_duty = list(
	/client/proc/spawn_duty_officer,
	/client/proc/cmd_admin_create_centcom_report,
	/client/proc/cmd_duty_say,
	/client/proc/returntobody,
	/client/proc/view_duty_log
)

/client/proc/add_admin_verbs()
	if(holder)
		verbs += admin_verbs_default
		if(holder.rights & R_BUILDMODE)		verbs += /client/proc/togglebuildmodeself
		if(holder.rights & R_ADMIN)			verbs += admin_verbs_admin
		if(holder.rights & R_BAN)			verbs += admin_verbs_ban
		if(holder.rights & R_FUN)			verbs += admin_verbs_fun
		if(holder.rights & R_SERVER)		verbs += admin_verbs_server
		if(holder.rights & R_DEBUG)			verbs += admin_verbs_debug
		if(holder.rights & R_POSSESS)		verbs += admin_verbs_possess
		if(holder.rights & R_PERMISSIONS)	verbs += admin_verbs_permissions
		if(holder.rights & R_STEALTH)		verbs += /client/proc/stealth
		if(holder.rights & R_REJUVINATE)	verbs += admin_verbs_rejuv
		if(holder.rights & R_SOUNDS)		verbs += admin_verbs_sounds
		if(holder.rights & R_SPAWN)			verbs += admin_verbs_spawn
		if(holder.rights & R_MOD)			verbs += admin_verbs_mod
		if(holder.rights & R_DEV)			verbs += admin_verbs_dev
		if(holder.rights & R_DUTYOFF)		verbs += admin_verbs_duty //hehe duty

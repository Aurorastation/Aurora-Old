//Desks - BLANK
/obj/structure/desk
	name = "reinforced desk"
	desc = "A solid desk, made of reinforced metal."
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "desk_corner"
	density = 1
	anchored = 1.0
	layer = 2.8
	throwpass = 1	//You can throw objects over this, despite it's density.")
	var/health = 200

/obj/structure/desk/corner
	name = "reinforced desk"
	desc = "A solid desk, made of reinforced metal."
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "desk_corner2"

//Computers

	//Security
			//Security Records
/obj/machinery/computer/secure_data/military
	name = "Security Records"
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "sec_record"

			//Prisoner Management
/obj/machinery/computer/prisoner/military
	name = "Prisoner Management Console"
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "prisoner_new"


			//Sec Cams
/obj/machinery/computer/security/military
	name = "Security Camera Monitoring Console"
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "seccams"

	//CENTRAL
		//Communications
/obj/machinery/computer/communications/military
	name = "Communications Console"
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "communications"

	//MEDICAL
		//Medical Records
/obj/machinery/computer/med_data/military
	name = "Crew Medical Records Console"
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "medrec"

		//CMC
/obj/machinery/computer/crew/military
	name = "Crew Monitoring Console"
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "medtrack"

	//ENGINEERING
		//Drone Control
/obj/machinery/computer/drone_control/military
	name = "Maintenance Drone Control"
	desc = "Used to monitor the station's drone population and the assembler that services them."
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "dronecontrol"

		//Power Monitor
/obj/machinery/power/monitor/military
	name = "power monitoring computer"
	desc = "It monitors power levels across the station."
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "powermonitor"

		//Alerts
/obj/machinery/computer/station_alert/military
	name = "Station Alert Computer"
	desc = "Used to access the station's automated alert system."
	icon = 'icons/obj/militarycomputers.dmi'
	icon_state = "alert:0"

/*

We need to mix blending into limb object code, this will slow shit down a lot.

*/

#define SYNTHETIC_COVERING_WORKING 1
#define SYNTHETIC_COVERING_DAMAGED 0

datum/synthetic_limb_cover
	var/coverage //
	var/colour_r = 128 // the colour of the limb
	var/colour_g = 128// the colour of the limb
	var/colour_b = 128// the colour of the limb
	var/datum/organ/external/limb_datum // the limb in question
	var/obj/item/robot_parts/limb_item // also the limb in question (if dismembered)
	var/main_icon = 'icons/mob/human_races/robotic.dmi'
	var/damage_icon = 'icons/mob/human_races/robotic.dmi'
	var/icon_key_type="BAD"
	var/hair_species=null
	var/eyes_state = "blank_eyes"
	var/tail = null


datum/synthetic_limb_cover/New(	var/datum/organ/external/datum_target=null,var/input_colour_r=null,var/input_colour_g=null,var/input_colour_b=null)
	world << "Making cover : [src]"
	limb_datum=datum_target
	coverage=SYNTHETIC_COVERING_WORKING // start working
	if(input_colour_r)
		colour_r=input_colour_r
	if(input_colour_g)
		colour_g=input_colour_g
	if(input_colour_b)
		colour_b=input_colour_b
		
	world << "COLOUR is [colour_r]-[colour_g]-[colour_b]"


datum/synthetic_limb_cover/proc/get_icon() // default mechanical limbs return robo versions
	var/icon/temp = new /icon((coverage ? main_icon : damage_icon), "[limb_datum.icon_name][limb_datum.get_gender_string()]") // only add a gender if it's necessary
	var/icon/result = icon(temp)
	result.GrayScale()
	result.Blend(rgb(colour_r,colour_g,colour_b), ICON_ADD)
	return result


datum/synthetic_limb_cover/proc/repair()
	coverage = SYNTHETIC_COVERING_WORKING


datum/synthetic_limb_cover/proc/damage()
	coverage = SYNTHETIC_COVERING_DAMAGED


datum/synthetic_limb_cover/proc/recolour(var/paint_colour_r, var/paint_colour_g, var/paint_colour_b, var/update=FALSE)
	colour_r=paint_colour_r
	colour_g=paint_colour_g
	colour_b=paint_colour_b
	if (update)
		if (limb_datum)
			if (limb_datum.owner)
				limb_datum.owner.update_body()


datum/synthetic_limb_cover/proc/get_icon_key() // this is going to wreck the icon cache but to do custom colour per limb this is necessary
	return "SYNTH:[icon_key_type]:[colour_r][colour_g][colour_b]"


datum/synthetic_limb_cover/paint
	main_icon = 'icons/mob/human_races/r_machine.dmi'
	icon_key_type = "Paint"
	hair_species = "Machine"


datum/synthetic_limb_cover/skin
	main_icon = 'icons/mob/human_races/r_human_grey.dmi'
	icon_key_type = "Skin"
	hair_species = "Human"
	eyes_state="eyes_s"


datum/synthetic_limb_cover/fur
	main_icon = 'icons/mob/human_races/r_tajaran.dmi'
	icon_key_type = "Fur"
	hair_species = "Tajaran"
	eyes_state="eyes_s"
	tail = "tajtail"


datum/synthetic_limb_cover/scales
	main_icon = 'icons/mob/human_races/r_lizard.dmi'
	icon_key_type = "Scales"
	hair_species = "Unathi"
	eyes_state="eyes_s"
	tail = "sogtail"


var/list/limb_covering_references
/proc/get_limb_covering_references()
	if (isnull(limb_covering_references))
		limb_covering_references = list()
		for(var/skin_type in typesof(/datum/synthetic_limb_cover)-/datum/synthetic_limb_cover)
			var/datum/synthetic_limb_cover/temp_cover = new skin_type()
			limb_covering_references[skin_type]=temp_cover
	return limb_covering_references
	
	
var/list/limb_covering_names
/proc/get_limb_covering_names()
	if (isnull(limb_covering_names))
		limb_covering_names=list("None")
		var/list/refs=get_limb_covering_references()
		for(var/skin_type in refs)
			var/datum/synthetic_limb_cover/temp=refs[skin_type]
			limb_covering_names.Add(temp.icon_key_type)
	return limb_covering_names
	

var/list/limb_covering_list
/proc/get_limb_covering_list()
	if(isnull(limb_covering_list))
		limb_covering_list=list("None"=null)
		var/list/refs=get_limb_covering_references()
		for(var/skin_type in refs)
			var/datum/synthetic_limb_cover/temp=refs[skin_type]
			limb_covering_list[temp.icon_key_type]=skin_type
	return limb_covering_list
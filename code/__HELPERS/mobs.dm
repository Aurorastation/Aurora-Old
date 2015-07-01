proc/valid_sprite_accessories(gender,species,test_list)
	var/list/valid = list()
	for(var/style in test_list)
		var/datum/sprite_accessory/S = test_list[style]
		if( !(species in S.species_allowed))
			continue
		if (S.gender!=NEUTER)
			if (S.gender!=gender)
				continue
		valid[style] = S
	return valid
	

proc/get_valid_hairstyles(gender, species)
	return valid_sprite_accessories(gender,species,hair_styles_list)
	
	
proc/get_valid_facialhairstyles(gender, species)
	return valid_sprite_accessories(gender,species,facial_hair_styles_list)


proc/random_hair_style(gender, species)
	var/h_style = "Bald"
	if (species)
		var/list/valid_hairstyles = get_valid_hairstyles(gender,species)
		if(valid_hairstyles.len)
			h_style = pick(valid_hairstyles)
	return h_style
	

proc/random_facial_hair_style(gender, species)
	var/f_style = "Shaved"
	if (species)
		var/list/valid_facialhairstyles = get_valid_facialhairstyles(gender,species)
		if(valid_facialhairstyles.len)
			f_style = pick(valid_facialhairstyles)
	return f_style
	

proc/random_name(gender, species = "Human")
	if(gender==FEMALE)	return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
	else				return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185,34)
	return min(max( .+rand(-25, 25), -185),34)

proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(18 to 30)
			return "health25"
		if(5 to 18)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"
	return "0"

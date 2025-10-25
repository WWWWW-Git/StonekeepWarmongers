/mob/living/carbon/human/species/human/northern
	race = /datum/species/human/northern

/datum/species/human/northern
	name = "Subhumin"
	id = "human"
	desc = "<b>Subhumin</b><br>\
	The great root below us all has changed us, both from within and without. \
	We are found everywhere on The Clump, as common as the root is, and we find ourselves \
	destined for greatness, whether by the grace of the root, or by our own ingenuity. \
	Ours is such a simple life, but when the horns of war sound out we feel compelled to obey His call. \
	There is no finer calling in life than to die for a cause, and to die happy knowing the root may yet consume you."

	skin_tone_wording = "Ancestry"

	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	default_features = list("mcolor" = "FFF", "wings" = "None")
	use_skintones = 1
	possible_ages = ALL_AGES_LIST
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = NONE
	liked_food = NONE
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	hairyness = "t1"
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
	OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
	OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
	OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
	OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
	OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
	OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
	OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
	OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
	OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,0))
	specstats = list("strength" = 0, "perception" = 0, "intelligence" = 0, "constitution" = 1, "endurance" = 1, "speed" = 0, "fortune" = 0)
	specstats_f = list("strength" = 0, "perception" = 0, "intelligence" = 1, "constitution" = 0, "endurance" = 0, "speed" = 1, "fortune" = 0)
	enflamed_icon = "widefire"

/datum/species/human/northern/check_roundstart_eligible()
	return TRUE

/datum/species/human/northern/get_skin_list()
	return sortList(list(
		"Ice Cap" = SKIN_COLOR_ICECAP,
		"Arctic" = SKIN_COLOR_ARCTIC,
		"Tundra" = SKIN_COLOR_TUNDRA,
		"Continental" = SKIN_COLOR_CONTINENTAL,
		"Temperate" = SKIN_COLOR_TEMPERATE,
		"Coastal" = SKIN_COLOR_COASTAL,
		"Subtropical" = SKIN_COLOR_SUBTROPICAL,
		"Tropical Dry" = SKIN_COLOR_TROPICALDRY,
		"Tropical Wet" = SKIN_COLOR_TROPICALWET,
		"Desert" = SKIN_COLOR_DESERT,
		"Crimson Lands" = SKIN_COLOR_CRIMSONLANDS,
	))

/datum/species/human/northern/get_hairc_list()
	return sortList(list(
	"blond - pale" = "9d8d6e",
	"blond - dirty" = "88754f",
	"blond - drywheat" = "d5ba7b",
	"blond - strawberry" = "c69b71",

	"brown - mud" = "362e25",
	"brown - oats" = "584a3b",
	"brown - grain" = "58433b",
	"brown - soil" = "48322a",

	"black - oil" = "181a1d",
	"black - cave" = "201616",
	"black - rogue" = "2b201b",
	"black - midnight" = "1d1b2b",

	"red - berry" = "48322a",
	"red - wine" = "82534c",
	"red - sunset" = "82462b",
	"red - blood" = "822b2b"

	))

/datum/species/human/northern/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("string/rt/names/human/humnorm.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("string/rt/names/human/humnorm.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("string/rt/names/human/humnorm.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("string/rt/names/human/humnorm.txt") )
	return randname

/datum/species/human/northern/random_surname()
	return " [pick(world.file2list("string/rt/names/human/humnorlast.txt"))]"

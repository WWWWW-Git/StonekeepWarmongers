/obj/item/storage/belt/rogue
	name = ""
	desc = ""
	icon = 'icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = ""
	item_state = ""
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whips", "lashes")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	var/heldz_items = 3

/obj/item/storage/belt/rogue/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		STR.max_combined_w_class = 6
		STR.max_w_class = WEIGHT_CLASS_SMALL
		STR.max_items = heldz_items

/obj/item/storage/belt/rogue/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE
	..()

/obj/item/storage/belt/rogue/leather
	name = "belt"
	desc = ""
	icon_state = "leather"
	item_state = "leather"
	equip_sound = 'sound/blank.ogg'
	heldz_items = 3

/obj/item/storage/belt/rogue/leather/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

// Until ninja stars are fixed (able to be removed from embedding), replacing them with poison berries for arrow crafting.
/obj/item/storage/belt/rogue/leather/assassin/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison(src)
	new /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison(src)
	new /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison(src)

/obj/item/storage/belt/rogue/leather/medic/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/rogue(src)
	new /obj/item/reagent_containers/glass/bottle/rogue(src)
	new /obj/item/reagent_containers/glass/bottle/rogue(src)

/obj/item/storage/belt/rogue/leather/bullet/PopulateContents()
	new /obj/item/ammo_casing/caseless/rogue/bullet/wood(src)
	new /obj/item/ammo_casing/caseless/rogue/bullet/wood(src)
	new /obj/item/ammo_casing/caseless/rogue/bullet/wood(src)

/obj/item/storage/belt/rogue/leather/plaquegold
	name = "plaque belt"
	icon_state = "goldplaque"
	sellprice = 50

/obj/item/storage/belt/rogue/leather/shalal
	name = "shalal belt"
	icon_state = "shalal"
	sellprice = 5

/obj/item/storage/belt/rogue/leather/black
	name = "black belt"
	icon_state = "blackbelt"
	sellprice = 10

/obj/item/storage/belt/rogue/leather/plaquesilver
	name = "plaque belt"
	icon_state = "silverplaque"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/hand
	name = "steel belt"
	icon_state = "steelplaque"
	sellprice = 30

/obj/item/storage/belt/rogue/leather/rope
	name = "rope belt"
	desc = ""
	icon_state = "rope"
	item_state = "rope"
	color = "#b9a286"
	heldz_items = 1

/obj/item/storage/belt/rogue/leather/cloth
	name = "cloth sash"
	desc = ""
	icon_state = "cloth"
	heldz_items = 1

/obj/item/storage/belt/rogue/leather/cloth/lady
	color = "#575160"

/obj/item/storage/belt/rogue/leather/cloth/bandit
	color = "#ff0000"

/obj/item/storage/belt/rogue/pouch
	name = "pouch"
	desc = ""
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = null
	icon_state = "pouch"
	item_state = "pouch"
	lefthand_file = 'icons/mob/inhands/equipment/belt_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/belt_righthand.dmi'
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whips", "lashes")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"

/obj/item/storage/belt/rogue/pouch/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		STR.max_combined_w_class = 3
		STR.max_w_class = WEIGHT_CLASS_NORMAL
		STR.max_items = 3
		STR.not_while_equipped = FALSE

/obj/item/storage/belt/rogue/pouch/coins/mid/Initialize()
	. = ..()
	var/obj/item/roguecoin/silver/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/roguecoin/copper/pile/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/rogue/pouch/coins/poor/Initialize()
	. = ..()
	var/obj/item/roguecoin/copper/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/rogue/pouch/coins/rich/Initialize()
	. = ..()
	var/obj/item/roguecoin/silver/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/rogue/pouch/coins/veryrich/Initialize()
	. = ..()
	var/obj/item/roguecoin/gold/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/backpack/rogue/satchel
	name = "satchel"
	desc = ""
	icon_state = "satchel"
	item_state = "satchel"
	icon = 'icons/roguetown/clothing/storage.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = NONE
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER

/obj/item/storage/backpack/rogue/satchel/heartfelt/PopulateContents()
	new /obj/item/natural/feather(src)
	new /obj/item/paper/heartfelt/random(src)


/obj/item/storage/backpack/rogue/satchel/black
	color = CLOTHING_BLACK

/obj/item/storage/backpack/rogue/satchel/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		STR.max_combined_w_class = 21
		STR.max_w_class = WEIGHT_CLASS_NORMAL
		STR.max_items = 3

/obj/item/storage/backpack/rogue/attack_right(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		CP.rmb_show(user)
		return TRUE

/obj/item/rogue/musicpack
	name = "musicpack device"
	desc = "It goes on your back. Use your middle finger to reach into the hole to turn it on."
	icon = 'icons/roguetown/clothing/storage.dmi'
	icon_state = "musicbackpack"
	item_state = "musicbackpack"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = NONE
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	var/datum/looping_sound/musloop/war/soundloop
	var/faction = BLUE_WARTEAM
	var/curfile
	var/playing = FALSE
	var/curvol = 70
	var/list/songs = list("The Knight's Song" = 'sound/music/jukeboxes/grenz_music1.ogg',
	"Landsknecht und Würfel" = 'sound/music/jukeboxes/grenz_music2.ogg',
	"Musketier Marsch" = 'sound/music/jukeboxes/grenz_music3.ogg')

/obj/item/rogue/musicpack/heartfelt
	songs = list("Faiāransā e no ōdo" = 'sound/music/jukeboxes/heart_music1.ogg',
	"Shōri e no kōshin" = 'sound/music/jukeboxes/heart_music2.ogg',
	"Shi ka haji ka" = 'sound/music/jukeboxes/heart_music3.ogg')
	faction = RED_WARTEAM

/obj/item/rogue/musicpack/Initialize()
	soundloop = new(list(src), FALSE)
	soundloop.musicpack = src
	. = ..()

/obj/item/rogue/musicpack/attack_right(mob/user)
	if(!user.ckey)
		return
	if(playing)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/selection = input(user, "Select a song.", "Music Device") as null|anything in songs
	if(!selection)
		return
	if(!Adjacent(user))
		return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	playing = FALSE
	soundloop.stop()
	curfile = songs[selection]
	update_icon()

/obj/item/rogue/musicpack/MiddleClick(mob/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(!playing)
		if(curfile)
			playing = TRUE
			soundloop.mid_sounds = list(curfile)
			soundloop.cursound = null
			soundloop.volume = curvol
			soundloop.start()
	else
		playing = FALSE
		soundloop.stop()
	update_icon()

/obj/item/storage/backpack/rogue/backpack
	name = "backpack"
	desc = ""
	icon_state = "backpack"
	item_state = "backpack"
	icon = 'icons/roguetown/clothing/storage.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK_L
	resistance_flags = NONE
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"

/obj/item/storage/backpack/rogue/backpack/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		STR.max_combined_w_class = 42
		STR.max_w_class = WEIGHT_CLASS_NORMAL
		STR.max_items = 14
		STR.not_while_equipped = TRUE

/obj/item/storage/backpack/rogue/satchel/surgbag
	name = "surgery bag"
	desc = "Contains all the phreakish devices one needs to cut a person up."
	slot_flags = ITEM_SLOT_BACK
	item_state = "doctorbag"
	icon_state = "doctorbag"
	attack_verb = list("beats", "bludgeons")

/obj/item/storage/backpack/rogue/satchel/surgbag/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		STR.max_combined_w_class = 42
		STR.max_w_class = WEIGHT_CLASS_NORMAL
		STR.max_items = 14

/obj/item/storage/backpack/rogue/satchel/surgbag/PopulateContents()
	new /obj/item/needle/blessed(src)
	new /obj/item/rogueweapon/surgery/scalpel(src)
	new /obj/item/rogueweapon/surgery/saw(src)
	new /obj/item/rogueweapon/surgery/hemostat(src)
	new /obj/item/rogueweapon/surgery/hemostat(src)
	new /obj/item/rogueweapon/surgery/retractor(src)
	new /obj/item/rogueweapon/surgery/bonesetter(src)
	new /obj/item/rogueweapon/surgery/cautery(src)
	new /obj/item/rogueweapon/surgery/hammer(src)

//...............Kaizoku Update..............
/obj/item/storage/belt/rogue/kaizoku/leather/daisho
	name = "daisho belt"
	desc = "A oil-boiled reinforced silk or leather belt used by Abyssariads for practicing Daisho."
	icon_state = "daisho"
	sellprice = 5
	icon = 'icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'

/obj/item/storage/belt/rogue/kaizoku/leather/daisho/heartfelt
	color = COLOR_ALMOST_BLACK	
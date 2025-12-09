/datum/job/roguetown/warmongers/after_spawn(mob/living/H, mob/M, latejoin)
	. = ..()
	if(H)
		var/mob/living/carbon/human/HU = H

		if(istype(HU.client.equippedPerk))
			spawn()
				HU.client.equippedPerk.apply(H)

		if(aspect_chosen(/datum/round_aspect/squishyhumans))
			HU.STACON = 3
			ADD_TRAIT(HU, TRAIT_BRITTLE, TRAIT_GENERIC)

		if(aspect_chosen(/datum/round_aspect/kicking))
			ADD_TRAIT(HU, TRAIT_NUTCRACKER, TRAIT_GENERIC)
		
		if(aspect_chosen(/datum/round_aspect/nomood))
			ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)

		if(aspect_chosen(/datum/round_aspect/monkwarfare))
			H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
			
		/*
		if(aspect_chosen(/datum/round_aspect/cripplefight))
			var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
			var/obj/vehicle/ridden/wheelchair/wheels = new(HU.loc)

			HU.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)
			wheels.buckle_mob(HU)

		
		if(aspect_chosen(/datum/round_aspect/goblino))
			HU.set_species(/datum/species/goblin)
		*/

		//HU.add_client_colour(/datum/client_colour/sepia)
		switch(HU.warfare_faction)
			if(RED_WARTEAM)
				if(HU.cmode_music == 'sound/music/root.ogg')
					HU.cmode_music = 'sound/music/drunkandlovingit.ogg'
				HU.speech_sound = list('sound/vo/wc/speech_ppr1.ogg', 'sound/vo/wc/speech_ppr2.ogg', 'sound/vo/wc/speech_ppr3.ogg')
			if(BLUE_WARTEAM)
				if(HU.cmode_music == 'sound/music/root.ogg')
					HU.cmode_music = 'sound/music/prayformoreammo.ogg'
				HU.speech_sound = list('sound/vo/wc/speech_regimer1.ogg', 'sound/vo/wc/speech_regimer2.ogg', 'sound/vo/wc/speech_regimer3.ogg')
		// root.ogg is the default combat music for every mob. it basically checks if combat music was set already, and if not, it sets it. Possibly dumb, but it works and nobody is a coder for this codebase except me :)
		if(HAS_TRAIT(HU, TRAIT_NOBLE))
			HU.speech_sound = 'sound/vo/speech_lord.ogg'
		HU.client.preload_sounds()

// Lord Procs

/proc/getlordtitle()
	return pick("of Wolvs", "the Tyrant", "the Idiot", "the Foolish", "the Bloody", "the Impaler", "the Discombobulater", "the Risktaker", "the Golden", "of Gold", "the Warmonger", "the Warmongrel", "the Thief", "the Waterborn", "the Bloodborn", "the Barker", "the Wolv", "the Predator", "of Predators", "the Stealthy", "the Sneaky", "the Destroyer", "the Ambusher", "the Bomber", "the Strategist", "of Strategy", "of Bombing", "of Ambushing", "the Racist", "the Hater of Stringbeans", "the Suicidal", "the Buffoon", "the Baboon", "the Bear", "the Bringer of Death", "of Death", "the Ordinary", "the Boring", "the Peaceful", "the Negotiator", "the Actor", "the Funny", "the Jestful", "of Jesters", "of Peasantry", "of Zealotry", "of Life")

/mob/living/carbon/human/proc/warfare_announce()
	set name = "ANNOUNCE!"
	set category = "LORD"
	if(stat != CONSCIOUS)
		to_chat(src, "<span class='warning'>You're incapable.</span>")
		return
	var/ann = browser_input_text(src, "ANNOUNCE TO YOUR FLOCK!","BRASS HORN",max_length=MAX_BROADCAST_LEN, multiline=TRUE)

	if(ann)
		shoutbubble()
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.warfare_faction != src.warfare_faction)
				continue
			if(M.can_hear())
				to_chat(M, "<br><span class='alert'>THE WORTHY LORD SAYS: \"[ann]\"</span>")
				M.playsound_local(M.loc, 'sound/foley/trumpt.ogg', 75)

/mob/living/carbon/human/proc/warfare_command()
	set name = "COMMAND!"
	set category = "LORD"
	if(stat != CONSCIOUS)
		to_chat(src, "<span class='warning'>You're incapable.</span>")
		return
	var/ann = browser_input_text(src, "COMMAND YOUR FLOCK!","BRASS HORN",max_length=MAX_BROADCAST_LEN, multiline=TRUE)

	if(ann)
		shoutbubble()
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.warfare_faction != src.warfare_faction)
				continue
			if(M.can_hear())
				to_chat(M, "<br><span class='alert'>THE WORTHY LORD COMMANDS: \"[ann]\"</span>")
				M.playsound_local(M.loc, 'sound/foley/trumpt.ogg', 75)

/mob/living/carbon/human/proc/warfare_inspire()
	set name = "MASS INSPIRE (3 TRI)"
	set category = "LORD"
	var/ann = alert(usr, "ARE YOU SURE?", "WARMONGERS", "Yes", "No")
	var/mob/living/carbon/human/H = usr

	if(ann == "Yes")
		if(H.get_triumphs() < 3)
			to_chat(H, "<span class='warning'>I haven't TRIUMPHED enough.</span>")
			return
		H.adjust_triumphs(-3)
		H.shoutbubble()
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			if(M.warfare_faction != src.warfare_faction)
				continue
			M.apply_status_effect(/datum/status_effect/buff/inspired)
			M.shoutbubble()
			M.emote_warcry()
			if(!M.cmode)
				M.toggle_cmode()
			if(aspect_chosen(/datum/round_aspect/halo))
				M.playsound_local(M.loc, 'sound/vo/halo/hail2theking.mp3', 75)
			else
				M.playsound_local(M.loc, 'sound/foley/trumpt.ogg', 75)
			to_chat(M, "<span class='alert'>I WILL DIE FOR THE LORD!</span>")

/mob/living/carbon/human/proc/warfare_shop()
	set name = "REDEEM SUPPORT POINTS"
	set category = "LORD"
	var/datum/game_mode/warmongers/C = SSticker.mode
	var/list/shippables = list()

	for(var/s in subtypesof(/datum/warshippable))
		var/datum/warshippable/WS = new s()
		var/faction_check = TRUE
		if(WS.faction && WS.faction != warfare_faction)
			faction_check = FALSE
		if(C.reinforcementwave >= WS.reinforcement && faction_check)
			shippables[WS.name] = WS

	var/choice = input(src, "URGENT AIRSHIP SHIPPING!", "BUY NOW!!!") as null|anything in shippables
	var/datum/warshippable/shoppin = shippables[choice]
	if(!shoppin)
		return
	if(!do_after(src, 5 SECONDS, TRUE, loc))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	switch(warfare_faction)
		if(RED_WARTEAM)
			if(C.red_bonus >= 1)
				C.red_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				to_chat(src, "<span class='info'>Insufficient points.</span>")
				return
		if(BLUE_WARTEAM)
			if(C.blu_bonus >= 1)
				C.blu_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
				to_chat(src, "<span class='info'>Insufficient points.</span>")
				return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

	for(var/i in shoppin.items)
		new i(get_turf(src))

/mob/living/carbon/human/proc/warfare_points()
	set name = "GAIN SUPPORT POINTS"
	set category = "LORD"
	var/datum/game_mode/warmongers/C = SSticker.mode
	to_chat(src, "<span class='info'>You call forward an airship and you begin donating your blood plasme.</span>")
	flash_fullscreen("redflash1")
	emote("embed")
	playsound(loc, 'sound/misc/sucking.ogg', 100, FALSE, -1)
	if(do_after(src, 15 SECONDS, TRUE))
		if(blood_volume <= BLOOD_VOLUME_BAD)
			to_chat(src, "<span class='userdanger'>The airship sucks out all your blood plasme, AND YOU FUCKING DIE!!! HOLY SHIT!!!</span>")
			death()
		else
			to_chat(src, "<span class='info'>The airship sucks out all your blood plasme, it leaves you weak... but hey, one point!</span>")
	blood_volume = BLOOD_VOLUME_SURVIVE
	flash_fullscreen("redflash3")
	switch(warfare_faction)
		if(RED_WARTEAM)
			C.red_bonus++
		if(BLUE_WARTEAM)
			C.blu_bonus++
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

///////////////////////////// RED ///////////////////////////////////////

/datum/job/roguetown/warmongers/red
	warfare_faction = RED_WARTEAM
	selection_color = CLOTHING_RED

/datum/job/roguetown/warmongers/red/lord
	title = "Fat Official"
	tutorial = "The loonies want this land, gather the lads and send the bastards packing before supper."
	department_flag = REDSS
	flag = REDKING
	min_pq = 0
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	outfit = /datum/outfit/job/roguetown/redking

/datum/job/roguetown/warmongers/red/lord/after_spawn(mob/living/carbon/human/H, mob/M, latejoin)
	. = ..()
	H.verbs += list(
		/mob/living/carbon/human/proc/warfare_announce,
		/mob/living/carbon/human/proc/warfare_command,
		/mob/living/carbon/human/proc/warfare_inspire,
		/mob/living/carbon/human/proc/warfare_shop,
		/mob/living/carbon/human/proc/warfare_points
	)
	if(istype(SSticker.mode, /datum/game_mode/warmongers))
		var/datum/game_mode/warmongers/C = SSticker.mode
		C.redlord = H

	if(aspect_chosen(/datum/round_aspect/stronglords))
		H.STASTR = 20
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
		ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

	if(aspect_chosen(/datum/round_aspect/veteranlords))
		H.change_stat("strength", 3)
		H.STACON = 25
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.charflaw = new /datum/charflaw/noeyer()
		if(!istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch, SLOT_WEAR_MASK)
		ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // Desensitized through thousand campaigns

/datum/outfit/job/roguetown/redking
	name = "Fat Official"
	jobtype = /datum/job/roguetown/warmongers/red/lord

/datum/outfit/job/roguetown/redking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	var/datum/game_mode/warmongers/W = SSticker.mode

	H.set_species(/datum/species/human/northern/fat)

	neck = /obj/item/clothing/neck/roguetown/gorget/flasked
	head = /obj/item/clothing/head/roguetown/helmet/war/ppr/toffhelm
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/quiver/bullets
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers
	pants = /obj/item/clothing/under/roguetown/trou/war/panties
	belt = /obj/item/storage/belt/rogue/leather/rope/war/fat
	beltr = GetSidearmForWarfarePPU()
	beltl = /obj/item/rogueweapon/sword/sabre/warcrime
	armor = /obj/item/clothing/suit/roguetown/armor/armordress/ppr/jammies
	if(istype(W.warmode, /datum/warmode/lords))
		head = /obj/item/clothing/head/roguetown/warmongers/crownred
	if(!(findtext(H.real_name, " of ") || findtext(H.real_name, " the ")))
		H.change_name("[H.real_name] [getlordtitle()]")
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 5, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("intelligence", 3)
		H.change_stat("endurance", 3)
		H.change_stat("constitution", 3)
		H.change_stat("speed", 1)
		H.change_stat("perception", 4)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
		H.cmode_music = 'sound/music/soberandhatingit.ogg'
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	//ADD_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)

////////////// RED SOLDIERS AND CLASSES /////////////////

/datum/job/roguetown/warmongers/red/soldier
	title = "Peasantry Militian"
	tutorial = "Peasant work takes the life out of you, luckily for you the bier you're paid in tends to make it easier to stomach. And you will admit, outright killing people can be fun."
	department_flag = REDSS
	flag = SOLDIER
	total_positions = 99
	spawn_positions = 10
	faction = "Station"
	outfit = null
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	advclass_cat_rolls = list(CTAG_REDSOLDIER = 99)

/datum/job/roguetown/warmongers/red/soldier/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.advsetup = TRUE
		H.status_flags |= GODMODE
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		H.apply_status_effect(/datum/status_effect/incapacitating/immobilized)

//// MUSKETEER ////

/datum/advclass/red/musketeer
	name = "Muckraker"
	tutorial = "Unwashed land workers armed with muskets. The bulk of any PPR army."
	outfit = /datum/outfit/job/roguetown/redsoldier
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/redsoldier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/alternate
	if(H.dna.species.id == "fat")
		pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/fat/alternate
	if(H.dna.species.id == "bulky")
		pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/bulky/alternate
	cloak = /obj/item/clothing/cloak/war/ppr/scarf
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt
	if(H.dna.species.id == "fat")
		shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt/fat
	if(H.dna.species.id == "bulky")
		shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt/bulky
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers
	if(H.dna.species.id == "bulky")
		shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers/bulky
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	if(H.dna.species.id == "fat")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/fat
	if(H.dna.species.id == "bulky")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/bulky
	beltl = /obj/item/rogueweapon/huntingknife/bayonet
	if(H.dna.species.id == "bulky")
		beltl = null
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/ppr
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/ppr/alternate
	beltr = /obj/item/quiver/bullets
	if(H.dna.species.id == "bulky")
		beltr = /obj/item/rogueweapon/woodcut/war
	backr = GetMainGunForWarfarePPU()
	if(H.dna.species.id == "bulky")
		backr = /obj/item/rogueweapon/shield/woodbuckler
	backl = /obj/item/storage/backpack/rogue/backpack/war/ppr
	if(H.dna.species.id == "bulky")
		backl = null
	neck = /obj/item/rogue/barkenpowderflask
	if(H.dna.species.id == "bulky")
		neck = null
	head = /obj/item/clothing/head/roguetown/helmet/war/ppr/pointhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/ppr/pointhelm/alternate
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)


//// OUTRIDER ////

/datum/advclass/red/outrider
	name = "Outrider"
	tutorial = "Fast moving, heavy cavalry capable of breaking lines of infantry like they were twigs."
	outfit = /datum/outfit/job/roguetown/redoutrider
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/horse/tame/saddled
	maximum_possible_slots = -1
	reinforcements_wave = 2
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/redoutrider/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/standard)

	pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	beltl = GetSidearmForWarfarePPU()
	beltr = /obj/item/quiver/bullets
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt
	head = /obj/item/clothing/head/roguetown/helmet/war/ppr/outriderhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/ppr/outriderhelm/alternate
	neck = /obj/item/rogue/barkenpowderflask
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/ppr/outrider
	backr = /obj/item/rogueweapon/woodcut/steel/war
	cloak = /obj/item/clothing/cloak/war/ppr/scarf
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", -1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
		H.cmode_music = 'sound/music/soberandhatingit.ogg'
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

//// SNIPER ////

/datum/advclass/red/sniper
	name = "Nimrod"
	tutorial = "Marksmen in service to the Union, hired on for their skill with longbarks."
	outfit = /datum/outfit/job/roguetown/redsniper
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/redsniper/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/standard)

	pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/alternate
	cloak = /obj/item/clothing/cloak/war/ppr/scarf
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	beltl = null
	beltr = /obj/item/quiver/bullets
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	backl = null
	neck = /obj/item/rogue/barkenpowderflask
	head = /obj/item/clothing/head/roguetown/helmet/war/ppr/nimrodhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/ppr/nimrodhelm/alternate
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 3)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
	ADD_TRAIT(H, TRAIT_SNIPER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_OFFICER, TRAIT_GENERIC)

//// OFFICER ////

/datum/advclass/red/officer
	name = "Redtop"
	tutorial = "A Muckraker who has earned prestige and experience will eventually rise to become a Redtop, leading his fellows both in raking muck as well as in battle."
	outfit = /datum/outfit/job/roguetown/redofficer
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	min_pq = -5
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/redofficer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons
	if(H.dna.species.id == "fat")
		pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/fat
	if(H.dna.species.id == "bulky")
		pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/bulky
	cloak = /obj/item/clothing/cloak/war/ppr/cloak
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt/alternate
	if(H.dna.species.id == "fat")
		shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt/fat/alternate
	if(H.dna.species.id == "bulky")
		shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt/bulky/alternate
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers
	if(H.dna.species.id == "bulky")
		shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers/bulky
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	if(H.dna.species.id == "fat")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/fat
	if(H.dna.species.id == "bulky")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/bulky
	beltl = /obj/item/rogueweapon/sword/sabre/shofficer
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/ppr
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/ppr/alternate
	beltr = GetSidearmForWarfarePPU()
	if(H.dna.species.id == "bulky")
		beltr = null
	backr = /obj/item/quiver/bullets
	if(H.dna.species.id == "bulky")
		backr = /obj/item/rogueweapon/woodcut/steel/war
	neck = /obj/item/rogue/barkenpowderflask
	if(H.dna.species.id == "bulky")
		neck = null
	head = /obj/item/clothing/head/roguetown/helmet/war/ppr/redhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/ppr/redhelm/alternate
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
		H.change_stat("intelligence", 3)
	ADD_TRAIT(H, TRAIT_OFFICER, TRAIT_GENERIC)

//// FIRESTARTER ////

/datum/advclass/red/firestarter
	name = "Firestarter"
	tutorial = "Firewater-cocktail slinging skirmishers who can deny large areas to the enemy."
	outfit = /datum/outfit/job/roguetown/redfirestarter
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = 3
	reinforcements_wave = 3
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/redfirestarter/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/fat)

	pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/alternate
	cloak = /obj/item/clothing/cloak/war/ppr/scarf
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	beltl = /obj/item/flint
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/ppr
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/ppr/alternate
	beltr = /obj/item/rogueweapon/woodcut/war
	backl = /obj/item/storage/backpack/rogue/satchel/booze
	backr = /obj/item/storage/backpack/rogue/satchel/booze
	head = /obj/item/clothing/head/roguetown/helmet/war/ppr/redhoodmask
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/ppr/redhoodmask/alternate
	backpack_contents = list(/obj/item/bomb/mollie=6)
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
		H.cmode_music = 'sound/music/soberandhatingit.ogg'

//// MEDIC ////

/datum/advclass/red/medic
	name = "Quack"
	tutorial = "With dubious credentials you were welcomed with open arms into the PPU, never expecting to actually have to try keep these fat bastards alive. Now here you are, having to do just that."
	outfit = /datum/outfit/job/roguetown/redmedic
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_REDSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/redmedic/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/standard)

	pants = /obj/item/clothing/under/roguetown/trou/war/pantaloons/alternate
	cloak = /obj/item/clothing/cloak/quackcloak
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/ppr/basicshirt
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/stompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	head = /obj/item/clothing/head/roguetown/war/tallhat
	backl = /obj/item/storage/backpack/rogue/satchel/surgbag
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	beltl = /obj/item/rogue/cranker
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/healthpot
	mask = /obj/item/clothing/mask/rogue/beakmask
	if(prob(50))
		mask = /obj/item/clothing/mask/rogue/war/mask/red
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("speed", 4)
		H.change_stat("intelligence", 3)
		H.change_stat("strength", -2)
	H.slowed_by_drag = FALSE
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

/////////////////////////////////////// BLU //////////////////////////////////////////////

/datum/job/roguetown/warmongers/blu
	warfare_faction = BLUE_WARTEAM
	selection_color = CLOTHING_BLUE

/datum/job/roguetown/warmongers/blu/lord
	title = "Regimian Low-Lord"
	tutorial = "A full-lifer through and through, you know which fork is which, and the best way to curtsy, and now you're in charge of the lives of hundreds if not thousands of men. The KAITZAR expects greatness, and you should sooner kill yourself than disappoint HIM."
	department_flag = BLUES
	flag = BLUKING
	min_pq = 0
	total_positions = 1
	spawn_positions = 1
	faction = "Station"
	allowed_races = ALL_RACES_LIST_NAMES
	outfit = /datum/outfit/job/roguetown/bluking

/datum/job/roguetown/warmongers/blu/lord/after_spawn(mob/living/carbon/human/H, mob/M, latejoin)
	. = ..()
	H.verbs += list(
		/mob/living/carbon/human/proc/warfare_announce,
		/mob/living/carbon/human/proc/warfare_command,
		/mob/living/carbon/human/proc/warfare_inspire,
		/mob/living/carbon/human/proc/warfare_shop,
		/mob/living/carbon/human/proc/warfare_points
	)
	if(istype(SSticker.mode, /datum/game_mode/warmongers))
		var/datum/game_mode/warmongers/C = SSticker.mode
		C.blulord = H

	if(aspect_chosen(/datum/round_aspect/stronglords))
		H.STASTR = 20
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE)
		ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

	if(aspect_chosen(/datum/round_aspect/veteranlords))
		H.change_stat("strength", 3)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.charflaw = new /datum/charflaw/noeyer()
		if(!istype(H.wear_mask, /obj/item/clothing/mask/rogue/eyepatch))
			qdel(H.wear_mask)
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch, SLOT_WEAR_MASK)
		ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // Desensitized through thousand campaigns

/datum/outfit/job/roguetown/bluking
	name = "Regimian Low-Lord"
	jobtype = /datum/job/roguetown/warmongers/blu/lord

/datum/outfit/job/roguetown/bluking/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	var/datum/game_mode/warmongers/W = SSticker.mode

	H.set_species(/datum/species/human/northern/standard)

	pants = pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons
	cloak = /obj/item/clothing/cloak/war/regime/scarf
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/wornshirt/alternate
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/trompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	beltl = /obj/item/rogueweapon/sword/sabre/dec/alt
	beltr = GetSidearmForWarfareRegime()
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/regime
	backl = /obj/item/quiver/bullets
	cloak = /obj/item/clothing/cloak/war/regime/cloak
	neck = /obj/item/clothing/neck/roguetown/gorget/flasked
	if(istype(W.warmode, /datum/warmode/lords))
		head = /obj/item/clothing/head/roguetown/warmongers/crownblu
	else
		head = /obj/item/clothing/head/roguetown/helmet/war/regime/groghelm
	if(!(findtext(H.real_name, " of ") || findtext(H.real_name, " the ")))
		H.change_name("[H.real_name] [getlordtitle()]")
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 5, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("intelligence", 3)
		H.change_stat("endurance", 3)
		H.change_stat("constitution", 3)
		H.change_stat("speed", 1)
		H.change_stat("perception", 4)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
		H.cmode_music = 'sound/music/makeamartyrofme.ogg'
	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	//ADD_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)

/////// BLU SOLDIERS AND CLASSES /////////////////

/datum/job/roguetown/warmongers/blu/soldier
	title = "Regimian Regiman"
	tutorial = "No-lifers and Some-lifers, pressed into service, given weaponry, and pointed at foe. The No-Lifers fight wanting to be Some-lifers, the Some-lifers fight wanting to be Full-Lifers, and the Full-Lifers are back at home relaxing while the former two do the dying. For the KAITZAR!"
	department_flag = BLUES
	flag = SOLDIER
	total_positions = 99
	spawn_positions = 10
	faction = "Station"
	outfit = null
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	advclass_cat_rolls = list(CTAG_BLUSOLDIER = 99)

/datum/job/roguetown/warmongers/blu/soldier/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.patron = GLOB.patronlist[/datum/patron/divine/kaitzar] // Grenzelhoft worships Psydon in lore. Why wouldn't they here? Thats right because they worship KAITZAR now.
		H.advsetup = TRUE
		H.status_flags |= GODMODE
		H.invisibility = INVISIBILITY_MAXIMUM
		H.become_blind("advsetup")
		H.apply_status_effect(/datum/status_effect/incapacitating/immobilized)

//// MUSKETEER ////

/datum/advclass/blu/musketeer
	name = "Sycophant"
	tutorial = "Poor zealots armed with whatever was deemed as inexpensive as possible."
	outfit = /datum/outfit/job/roguetown/blusoldier
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/blusoldier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/alternate
	if(H.dna.species.id == "fat")
		pants = pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/fat/alternate
	if(H.dna.species.id == "bulky")
		pants = pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/bulky/alternate
	cloak = /obj/item/clothing/cloak/war/regime/scarf
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/wornshirt
	if(H.dna.species.id == "fat")
		shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/wornshirt/fat
	if(H.dna.species.id == "bulky")
		shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/wornshirt/bulky
	shoes = 	shoes = /obj/item/clothing/shoes/roguetown/boots/war/trompers
	if(H.dna.species.id == "bulky")
		shoes = 	shoes = /obj/item/clothing/shoes/roguetown/boots/war/trompers/bulky
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	if(H.dna.species.id == "fat")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/fat
	if(H.dna.species.id == "bulky")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/bulky
	beltl = /obj/item/rogueweapon/huntingknife/bayonet
	if(H.dna.species.id == "bulky")
		beltl = null
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/regime
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/regime/alternate
	beltr = /obj/item/quiver/bullets
	if(H.dna.species.id == "bulky")
		beltr = /obj/item/rogueweapon/mace/cudgel/war
	backr = GetMainGunForWarfareRegime()
	if(H.dna.species.id == "bulky")
		backr = /obj/item/rogueweapon/shield/pavise
	backl = /obj/item/storage/backpack/rogue/backpack/war/regime
	if(H.dna.species.id == "bulky")
		backl = null
	neck = /obj/item/rogue/barkenpowderflask
	if(H.dna.species.id == "bulky")
		neck = null
	head = /obj/item/clothing/head/roguetown/helmet/war/regime/morion
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/regime/morion/alternate
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)

//// ZEALOT ////

/datum/advclass/blu/zealot //High stamina, speed, and damage. However, no gun skills, and really not that well armored.
	name = "Zealot"
	tutorial = "Elite shocktroops which excel with dicing apart enemies with ferocity, but they are poorly armored, and unable to use firearms due to lack of training."
	outfit = /datum/outfit/job/roguetown/bluzealot
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = 3
	reinforcements_wave = 3
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/bluzealot/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/bulky)

	pants = pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/alternate
	if(H.dna.species.id == "bulky")
		pants = pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/bulky/alternate
	cloak = /obj/item/clothing/cloak/war/regime/parchment
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	if(H.dna.species.id == "bulky")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/bulky
	backr = /obj/item/rogueweapon/flail/bigflail
	head = /obj/item/clothing/head/roguetown/war/stitchhood
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/war/stitchhood/alternate
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("strength", 2)
		H.change_stat("perception", -1)
		H.change_stat("endurance", 4)
		H.change_stat("constitution", 1)
		H.cmode_music = 'sound/music/makeamartyrofme.ogg'
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

//// HUSSAR ////

/datum/advclass/blu/hussar
	name = "Hussar"
	tutorial = "Light, fast moving cavalry armed with pistols and sabres capable of outflanking the foe."
	outfit = /datum/outfit/job/roguetown/bluhussar
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/horse/tame/saddled
	maximum_possible_slots = -1
	reinforcements_wave = 2
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/bluhussar/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/standard)

	pants = /obj/item/clothing/under/roguetown/trou/war/regime/fancypants
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/trompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	beltl = GetSidearmForWarfareRegime()
	beltr = /obj/item/quiver/bullets
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/hussarshirt
	head = /obj/item/clothing/head/roguetown/helmet/war/hussarhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/hussarhelm/alternate
	cloak = /obj/item/clothing/cloak/hussarcloak
	neck = /obj/item/rogue/barkenpowderflask
	backr = /obj/item/rogueweapon/spear/pike
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", -1)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
		H.cmode_music = 'sound/music/makeamartyrofme.ogg'
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

//// SNIPER ////

/datum/advclass/blu/sniper
	name = "Smonk Whisperer"
	tutorial = "Long ranged marksmen, said to be able to forsee their target dying in the billowing of the smonk."
	outfit = /datum/outfit/job/roguetown/blusniper
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/blusniper/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/standard)

	pants = pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/alternate
	cloak = /obj/item/clothing/cloak/war/regime/scarf
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/wornshirt
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/trompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	beltl = null
	beltr = /obj/item/quiver/bullets
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/sniper/alternate
	backl = null
	neck = /obj/item/rogue/barkenpowderflask
	head = /obj/item/clothing/head/roguetown/helmet/war/regime/tallhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/regime/tallhelm/alternate
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("strength", 1)
		H.change_stat("perception", 3)
		H.change_stat("endurance", 1)
		H.change_stat("constitution", 1)
	ADD_TRAIT(H, TRAIT_SNIPER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_OFFICER, TRAIT_GENERIC)

//// OFFICER ////

/datum/advclass/blu/officer
	name = "Rabble-Rouser"
	tutorial = "Drawn from the Some-lifers, Rabble-Rousers are the officer class of the Regimer army, tasked with whipping the soldiers into a chaotic frenzy before battle."
	outfit = /datum/outfit/job/roguetown/bluofficer
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	min_pq = -5
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/bluofficer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons
	if(H.dna.species.id == "fat")
		pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/fat
	cloak = /obj/item/clothing/cloak/war/regime/scarf
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/wornshirt/alternate
	if(H.dna.species.id == "fat")
		shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/wornshirt/fat/alternate
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/trompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	if(H.dna.species.id == "fat")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/fat
	if(H.dna.species.id == "bulky")
		belt = /obj/item/storage/belt/rogue/leather/rope/war/bulky
	beltl = /obj/item/rogueweapon/sword/sabre/officer
	if(H.dna.species.id == "bulky")
		beltl = /obj/item/rogueweapon/whip/pulverizer
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/regime
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/war/regime/alternate
	beltr = GetSidearmForWarfareRegime()
	if(H.dna.species.id == "bulky")
		beltr = /obj/item/rogueweapon/mace/cudgel/war
	backr = /obj/item/quiver/bullets
	if(H.dna.species.id == "bulky")
		backr = null
	neck = /obj/item/rogue/barkenpowderflask
	if(H.dna.species.id == "bulky")
		neck = null
	head = /obj/item/clothing/head/roguetown/helmet/war/regime/kalpakhelm
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/war/regime/kalpakhelm/alternate
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/combat/flintlocks, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/leadership, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/inspire)
		H.change_stat("intelligence", 3)
	ADD_TRAIT(H, TRAIT_OFFICER, TRAIT_GENERIC)

//// MEDIC ////

/datum/advclass/blu/medic
	name = "Medic"
	tutorial = "Sanitaters feel like gravediggers, considering they deal with more corpses than wounded soldiers. Still, they do their part however they can."
	outfit = /datum/outfit/job/roguetown/blumedic
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL_RACES_LIST_NAMES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	category_tags = list(CTAG_BLUSOLDIER)
	maximum_possible_slots = -1
	reinforcements_wave = 0
	allowed_races = ALL_RACES_LIST_NAMES

/datum/outfit/job/roguetown/blumedic/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	H.set_species(/datum/species/human/northern/standard)

	pants = /obj/item/clothing/under/roguetown/trou/war/regime/darkpantaloons/alternate
	shirt = /obj/item/clothing/suit/roguetown/shirt/war/regime/butchershirt
	shoes = /obj/item/clothing/shoes/roguetown/boots/war/trompers
	belt = /obj/item/storage/belt/rogue/leather/rope/war
	backl = /obj/item/storage/backpack/rogue/satchel/surgbag
	neck = /obj/item/reagent_containers/glass/bottle/waterskin
	beltl = /obj/item/rogue/cranker
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/healthpot
	mask = /obj/item/clothing/mask/rogue/butcher
	if(H.mind)
		H.mind.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/medicine, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/misc/sewing, 6, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
		H.mind.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
		H.change_stat("speed", 4)
		H.change_stat("intelligence", 3)
		H.change_stat("strength", -2)
	H.slowed_by_drag = FALSE
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_RIVERSWIMMER, TRAIT_GENERIC)

/obj/item/rogue/caltrop
	name = "caltrop"
	desc = "."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "tetsubishi"
	var/obj/item/bomb/loaded_bomb = null
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP
	embedding = list("embedded_unsafe_removal_time" = 40, "embedded_pain_chance" = 40, "embedded_pain_multiplier" = 1, "embed_chance" = 100, "embedded_fall_chance" = 0)

/obj/item/rogue/caltrop/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/bomb))
		I.forceMove(src)
		loaded_bomb = I
		to_chat(user, "<span class='notice'>You attach \the [I] on \the [src].</span>")
		icon_state = "mine"
		playsound(src, 'sound/foley/trap_arm.ogg', 65)

/obj/item/rogue/caltrop/bombed/Initialize()
	. = ..()
	var/obj/item/bomb/B = new(src)
	loaded_bomb = B
	icon_state = "mine"

/obj/item/rogue/caltrop/Crossed(AM as mob|obj)
	if(isturf(loc))
		if(isliving(AM))
			var/mob/living/L = AM
			var/snap = TRUE
			if(istype(L.buckled, /obj/vehicle))
				var/obj/vehicle/ridden_vehicle = L.buckled
				if(!ridden_vehicle.are_legs_exposed)
					return ..()

			if(L.throwing)
				return ..()

			if(L.movement_type & (FLYING|FLOATING))
				return ..()

			var/def_zone = BODY_ZONE_CHEST
			if(ishuman(L))
				var/mob/living/carbon/human/C = L
				if(C.mobility_flags & MOBILITY_STAND)
					def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
					var/obj/item/bodypart/BP = C.get_bodypart(def_zone)
					if(BP)
						add_mob_blood(C)
						if(!BP.is_object_embedded(src))
							BP.add_embedded_object(src)
						C.emote("agony")
						if(icon_state != "[icon_state]-bloody")
							icon_state = "[icon_state]-bloody"
						if(loaded_bomb)
							loaded_bomb.forceMove(get_turf(C))
							loaded_bomb.light()
							loaded_bomb.explode()
							QDEL_NULL(loaded_bomb)
							loaded_bomb = null
			else if(isanimal(L))
				var/mob/living/simple_animal/SA = L
				if(SA.mob_size <= MOB_SIZE_TINY) //don't close the trap if they're as small as a mouse.
					snap = FALSE
			if(snap)
				L.apply_damage(50, BRUTE, def_zone)
				L.Stun(20)
	..()

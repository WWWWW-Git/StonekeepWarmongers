/datum/advclass
	var/name
	var/outfit
	var/tutorial = "Choose me!"
	var/list/allowed_sexes
	var/list/allowed_races = list("Humen",
	"Humen",
	"Elf",
	"Elf",
	"Dark Elf",
	"Dwarf",
	"Dwarf"
	)
	var/list/allowed_patrons
	var/list/allowed_ages
	var/pickprob = 100
	var/maximum_possible_slots = 999
	var/total_slots_occupied = 0
	var/min_pq = -100
	var/max_pq = -100

	var/reinforcements_wave = 9 // a way to unlock classes by time, or something. if 0 it means playable at all times

	var/horse = FALSE
	var/vampcompat = TRUE

	/// This class is immune to species-based swapped gender locks
	var/immune_to_genderswap = FALSE

	//What categories we are going to sort it in
	var/list/category_tags = list(CTAG_DISABLED)

/datum/advclass/proc/equipme(mob/living/carbon/human/H)
	// input sleeps....
	set waitfor = FALSE
	if(!H)
		return FALSE

	if(outfit)
		H.equipOutfit(outfit)

	post_equip(H)

	H.advjob = name

	//sleep(1)
	//testing("[H] spawn troch")

	var/turf/TU = get_turf(H)
	if(TU)
		if(horse)
			var/mob/living/simple_animal/hostile/retaliate/rogue/saiga/S = new horse(TU)
			S.user_buckle_mob(H, H)

/*	for(var/trait in traits_applied)
		ADD_TRAIT(H, trait, ADVENTURER_TRAIT) */

	if(CTAG_TOWNER in category_tags)
		for(var/mob/M in GLOB.billagerspawns)
			to_chat(M, "<span class='info'>[H.real_name] is the [name].</span>")
		GLOB.billagerspawns -= H

/datum/advclass/proc/post_equip(mob/living/carbon/human/H)
	addtimer(CALLBACK(H,TYPE_PROC_REF(/mob/living/carbon/human, add_credit)), 20)
	return

/*
	Whoa! we are checking requirements here!
	On the datum! Wow!
*/
/datum/advclass/proc/check_requirements(mob/living/carbon/human/H)

	var/list/local_allowed_sexes = list()
	var/datum/game_mode/warfare/W = SSticker.mode
	if(length(allowed_sexes))
		local_allowed_sexes |= allowed_sexes

	if(length(local_allowed_sexes) && !(H.gender in local_allowed_sexes))
		return FALSE

	if(length(allowed_races) && !(H.dna.species.name in allowed_races))
		return FALSE

	if(length(allowed_ages) && !(H.age in allowed_ages))
		return FALSE

	if(min_pq != -100) // If someone sets this we actually do the check.
		if(!(get_playerquality(H.client.ckey) >= min_pq))
			return FALSE
	
	if(max_pq != -100) // If someone sets this we actually do the check.
		if(!(get_playerquality(H.client.ckey) <= max_pq))
			return FALSE

	if(W.reinforcementwave >= reinforcements_wave)
		testing("Reinforcement wave bigger or equal to required ([W.reinforcementwave] >= [reinforcements_wave])")
		return TRUE

// Basically the handler has a chance to plus up a class, heres a generic proc you can override to handle behavior related to it.
// For now you just get an extra stat in everything depending on how many plusses you managed to get.
/datum/advclass/proc/boost_by_plus_power(plus_factor, mob/living/carbon/human/H)
	for(var/S in MOBSTATS)
		H.change_stat(S, plus_factor)


//Final proc in the set for really retarded shit
///datum/advclass/proc/extra_slop_proc_ending(mob/living/carbon/human/H)

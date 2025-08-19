/datum/game_mode/warmongers
	name = "warmongers"
	config_tag = "warmongers"
	report_type = "warmongers"
	false_report_weight = 0
	required_players = 0
	required_enemies = 0
	recommended_enemies = 0
	enemy_minimum_age = 0

	var/whowon = null // use RED_WARTEAM and BLUE_WARTEAM
	var/reinforcementwave = 1 // max 5

	var/mob/redlord
	var/obj/item/clothing/head/roguetown/warmongers/crownred/redcrown
	var/red_bonus = 2 // reinforcement points

	var/mob/blulord
	var/obj/item/clothing/head/roguetown/warmongers/crownblu/blucrown
	var/blu_bonus = 2 // reinforcement points

	var/list/heartfelts = list() // clients
	var/list/grenzels = list()

	var/warfare_start_time = 5 // in minutes
	var/warfare_reinforcement_time = 5 // in minutes
	
	var/stalematecooldown // a cooldown before another stalemate can be held
	var/datum/warmode/warmode = null

	announce_span = "danger"
	announce_text = "The"

/datum/game_mode/warmongers/post_setup(report)
	begin_countDown()
	SSticker.fuckthisshit.setup()
	return ..()

/datum/game_mode/warmongers/proc/award_triumphs()
	if(whowon == BLUE_WARTEAM)
		for(var/client/C in grenzels)
			if(ishuman(C.mob))
				var/mob/living/carbon/human/H = C.mob
				if(H.client?.equippedPerk.type == /datum/warperk)
					H.adjust_triumphs(1)
				H << sound(null) // Stop all sounds
				SEND_SOUND(H, 'sound/vo/wc/gren/grenzvictorysong.ogg')
		for(var/client/C in heartfelts)
			if(ishuman(C.mob))
				var/mob/living/carbon/human/H = C.mob
				H << sound(null) // Stop all sounds
				SEND_SOUND(H, 'sound/vo/wc/felt/heartdefeatsong.ogg')
	if(whowon == RED_WARTEAM)
		for(var/client/C in heartfelts)
			if(ishuman(C.mob))
				var/mob/living/carbon/human/H = C.mob
				if(H.client?.equippedPerk.type == /datum/warperk)
					H.adjust_triumphs(1)
				H << sound(null) // Stop all sounds
				SEND_SOUND(H, 'sound/vo/wc/felt/heartvictorysong.ogg')
		for(var/client/C in grenzels)
			if(ishuman(C.mob))
				var/mob/living/carbon/human/H = C.mob
				H << sound(null) // Stop all sounds
				SEND_SOUND(H, 'sound/vo/wc/gren/grenzdefeatsong.ogg')

/datum/game_mode/warmongers/proc/do_war_end(var/mob/living/carbon/human/crownguy = null, var/team = null) // if you call this with zero arguments, its a stalemate.
	whowon = team
	SSticker.force_ending = TRUE
	if(crownguy)
		warmode.winner = crownguy
		warmode.winner.adjust_triumphs(5)

/datum/game_mode/warmongers/proc/begin_autobalance_loop()
	set waitfor = 0
	while(1)
		CHECK_TICK
		if(SSticker.oneteammode)
			break
		CHECK_TICK
		for(var/mob/dead/new_player/P in GLOB.player_list)
			CHECK_TICK
			P.autobalance()

/datum/game_mode/warmongers/proc/reinforcements()
	set waitfor = 0
	while(1)
		CHECK_TICK
		if((reinforcementwave >= 5))
			break
		sleep(warfare_reinforcement_time MINUTES)
		testing("Sending reinforcement loop works")
		SSticker.SendReinforcements()

/datum/game_mode/warmongers/proc/begin_countDown()
	set waitfor = 0
	while(1)
		sleep(1 MINUTES)
		CHECK_TICK
		if(SSticker.warfare_ready_to_die)
			break
		if(!redlord)
			continue
		CHECK_TICK
		if(!blulord)
			continue
		CHECK_TICK
		to_chat(world, "Both sides are present. We will begin in [warfare_start_time] minutes.")
		sleep(warfare_start_time MINUTES)
		SSticker.ReadyToDie()
		CHECK_TICK

/datum/game_mode/warmongers/proc/HandleNoLords()
	if(!istype(warmode, /datum/warmode/lords)) // Not required.
		return

	var/obj/effect/landmark/blureinforcement/blu = locate(/obj/effect/landmark/blureinforcement) in GLOB.landmarks_list
	var/obj/effect/landmark/redreinforcement/red = locate(/obj/effect/landmark/redreinforcement) in GLOB.landmarks_list

	if(isnull(redlord) || isnull(redcrown)) // You brought this upon yourself, nobody plays lord, no fancy shop and no fancy buffs! DIE!
		var/datum/job/J = SSjob.GetJobType(/datum/job/roguetown/warmongers/red/lord)
		J.total_positions = 0
		J.spawn_positions = 0

		new /obj/effect/telefog(red.loc)
		new /obj/item/clothing/head/roguetown/warmongers/crownred(red.loc)

	if(isnull(blulord) || isnull(blucrown))
		var/datum/job/J = SSjob.GetJobType(/datum/job/roguetown/warmongers/blu/lord)
		J.total_positions = 0
		J.spawn_positions = 0

		new /obj/effect/telefog(blu.loc)
		new /obj/item/clothing/head/roguetown/warmongers/crownblu(blu.loc)
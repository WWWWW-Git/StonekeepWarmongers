/datum/warmode
	var/name = "WARMONGERS Gamemode"
	var/shorthand = "WRMNGS"
	var/blurb = "Uh oh."

	var/obj/structure/warobjective/objective

	var/mob/living/carbon/human/winner
	var/winner_name = null

	var/alertsound = 'sound/misc/alert.ogg'
	var/haloalertsound = 'sound/misc/alert.ogg'

/datum/warmode/proc/beginround()
	if(istype(SSticker.mode, /datum/game_mode/warmongers))
		to_chat(world, "<span class='danger'>[blurb]</span>")
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, haloalertsound)
		else
			for(var/mob/living/carbon/human/M in GLOB.player_list)
				if(hasvar(M, "warfare_faction") && M.warfare_faction == BLUE_WARTEAM)
					SEND_SOUND(M, 'sound/vo/wc/gren/grenzroundstart.ogg')
				if(hasvar(M, "warfare_faction") && M.warfare_faction == RED_WARTEAM)
					SEND_SOUND(M, 'sound/vo/wc/felt/heartroundstart.ogg')

/datum/warmode/Destroy()
	. = QDEL_HINT_IWILLGC
	STOP_PROCESSING(SSprocessing, src)
	..()

/datum/warmode/lords
	name = "Lord Destruction"
	shorthand = "LD"
	blurb = "Take the enemy Lord's crown and sit on the Throne of Heartfelt!"
	winner_name = "crownbearer"
	haloalertsound = 'sound/vo/halo/hail2theking.mp3'

/datum/warmode/noreturn
	name = "Point of No Return"
	shorthand = "PONR"
	haloalertsound = 'sound/vo/halo/ctf.mp3'
	blurb = "Capture the enemy flag and take it to your PONR!"

	winner_name = "capturer"

	var/wealreadywon = FALSE

	var/mob/living/carbon/human/blu_flag
	var/mob/living/carbon/human/red_flag

/datum/warmode/noreturn/beginround()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/datum/warmode/noreturn/process()
	for(var/turf/closed/wall/W in RANGE_TURFS(2, objective)) //no cheating by just boxing in the statue, that is super lame.
		W.dismantle_wall()

/datum/warmode/tdm
	name = "Last Stand"
	shorthand = "TDM"
	
	var/stalemate_kills = 98
	var/win_kills = 50
	var/base_player_count = 16

	var/min_win_kills = 10
	var/max_win_kills = 200
	var/min_stalemate_kills = 20
	var/max_stalemate_kills = 400

/datum/warmode/tdm/beginround()
	var/player_count = length(GLOB.clients)
	win_kills = clamp(round(50 * (player_count / base_player_count)), min_win_kills, max_win_kills)
	stalemate_kills = clamp(round(98 * (player_count / base_player_count)), min_stalemate_kills, max_stalemate_kills)

	START_PROCESSING(SSprocessing, src)
	blurb = "Secure [win_kills] kills for your team to win!"

	..()

/datum/warmode/tdm/process()
	if(istype(SSticker.mode, /datum/game_mode/warmongers))
		var/datum/game_mode/warmongers/C = SSticker.mode
		if(SSticker.grenzelhoft_deaths >= win_kills)
			C.do_war_end(null, RED_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)
		if(SSticker.heartfelt_deaths >= win_kills)
			C.do_war_end(null, BLUE_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)
		if(SSticker.deaths >= stalemate_kills)
			C.do_war_end()
			STOP_PROCESSING(SSprocessing, src)

/datum/warmode/assault
	name = "Assault"
	shorthand = "ASLT"
	objective = /obj/structure/warobjective/assaultthrone

	var/attack_progress = 0
	var/current_capture_point = 1
	var/base_player_count = 16

	var/blu_spawns = 100
	var/min_blu_spawns = 40
	var/max_blu_spawns = 200

	var/list/capture_points = list()
	var/total_capture_points = 0

/datum/warmode/assault/beginround()
	var/player_count = length(GLOB.clients)
	blu_spawns = clamp(round(50 * (player_count / base_player_count)), min_blu_spawns, max_blu_spawns)

	START_PROCESSING(SSprocessing, src)
	blurb = "Grenzelhoft must capture both points! Heartfelt must defend! GRENZELHOFT GETS ONLY [blu_spawns] AVAILABLE SOLDIERS, DEATH IS BAD!!!"

	for(var/area/rogue/assault/cp in world)
		if(istype(cp))
			capture_points += cp
			total_capture_points++
	..()

/datum/warmode/assault/process()
	if(istype(SSticker.mode, /datum/game_mode/warmongers))
		var/datum/game_mode/warmongers/C = SSticker.mode
		if(SSticker.grenzelhoft_deaths >= blu_spawns)
			C.do_war_end(null, RED_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)
		if(current_capture_point > total_capture_points)
			C.do_war_end(null, BLUE_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)

/area/rogue/assault
	name = "Capture Point"
	var/list/grenz = list()
	var/list/heart = list()
	var/capture_sound = 'sound/misc/stolen.ogg'
	var/capture_rate = 1 // 1 means normal speed, 2 means two times speed.
	var/tocapture_points = 100 // How much points to capture?
	var/holder = RED_WARTEAM
	var/capture_order = 0
	var/capturable = FALSE

/area/rogue/assault/throneroom
	name = "Thronesroom"
	capture_rate = 1.5
	capture_order = 2

/area/rogue/assault/gates
	name = "Gateshouse"
	capture_rate = 0.5
	tocapture_points = 150
	capture_order = 1

/area/rogue/assault/proc/on_capture(var/team = BLUE_WARTEAM)
	return

/area/rogue/assault/New()
	. = ..()
	START_PROCESSING(SSprocessing, src)

	// Set the first point as capturable
	if(capture_order == 1)
		capturable = TRUE

/area/rogue/assault/process()
	var/datum/game_mode/warmongers/C = SSticker.mode
	if(C?.warmode)
		if(!istype(C?.warmode, /datum/warmode/assault))
			STOP_PROCESSING(SSprocessing, src)
			return
	else
		return
	var/datum/warmode/assault/ASS = C.warmode // hehe

	// Check if this point can be captured based on order
	if(capture_order != ASS.current_capture_point)
		capturable = FALSE
	else
		capturable = TRUE

	for(var/mob/living/carbon/human/H in src)
		if(!istype(H))
			continue

		if(H.warfare_faction == BLUE_WARTEAM)
			if(H.stat == CONSCIOUS)
				grenz |= H
			else if(H.stat > 0)
				grenz -= H
			else if(!H.client)
				grenz -= H
		else if(H.warfare_faction == RED_WARTEAM)
			if(H.stat == CONSCIOUS)
				heart |= H
			else if(H.stat > 0)
				heart -= H
			else if(!H.client)
				heart -= H

	if(capturable)
		if(grenz.len > heart.len)
			if(ASS.attack_progress < tocapture_points)
				ASS.attack_progress += 1 * capture_rate
		else if(grenz.len < heart.len)
			if(ASS.attack_progress > 0)
				ASS.attack_progress -= capture_rate

		if(ASS.attack_progress >= tocapture_points && (holder != BLUE_WARTEAM))
			to_chat(world, "<span class='userdanger'>[uppertext("[BLUE_WARTEAM] HAVE CAPTURED THE [src]")]!</span>")
			holder = BLUE_WARTEAM
			ASS.attack_progress = 0
			on_capture(holder)
			SEND_SOUND(world, capture_sound)
			ASS.current_capture_point++

/area/rogue/assault/Entered(atom/movable/M)
	. = ..()
	var/datum/game_mode/warmongers/C = SSticker.mode
	if(!istype(C?.warmode, /datum/warmode/assault))
		return
	var/datum/warmode/assault/ASS = C.warmode // hehe
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!capturable && H.warfare_faction != holder)
			if(capture_order < ASS.current_capture_point)
				to_chat(H, "<span class='warning'>[src] has been already captured!</span>")
			else
				to_chat(H, "<span class='warning'>[src] can't be captured yet!</span>")
		else if(H.warfare_faction != holder)
			to_chat(H, "<span class='tutorial'>Capturing [src]!</span>")
		else
			to_chat(H, "<span class='tutorial'>Defending [src]!</span>")

/area/rogue/assault/Exit(mob/living/M)
	. = ..()
	if(ishuman(M))
		if(M in grenz)
			grenz -= M
		else if(M in heart)
			heart -= M

/area/rogue/indoors/airship
	name = "reinforcement airship"
	ambientrain = RAIN_IN
	ambientsounds = 'sound/ambience/airship_ambience.ogg'
	ambientnight = 'sound/ambience/airship_ambience.ogg'
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/ambience/airship_ambience.ogg'
	droning_sound_dusk = 'sound/ambience/airship_ambience.ogg'
	droning_sound_night = 'sound/ambience/airship_ambience.ogg'

/area/rogue/indoors/airship/Entered(mob/living/M, atom/OldLoc)
	. = ..()
	to_chat(M, "<span class='info'>Be patient and await arrival to the battlefield. Chat with your fellow comrades.</span>")

/area/rogue/indoors/airship/red
	icon_state = "red"

/area/rogue/indoors/airship/blue
	icon_state = "blue"
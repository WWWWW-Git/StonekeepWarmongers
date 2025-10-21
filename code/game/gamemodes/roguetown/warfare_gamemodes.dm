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

	var/list/control_point_handlers = list()
	var/list/control_point_areas = list()
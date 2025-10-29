#define round_duration_in_ticks (SSticker.round_start_time ? world.time - SSticker.round_start_time : 0)

SUBSYSTEM_DEF(warmongers)
	name = "Warmongers"

	priority = FIRE_PRIORITY_TICKER
	flags = SS_KEEP_TIMING | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME

	var/warfare_ready_to_die = FALSE		// If the barriers for fair play have been removed yet.
	var/warfare_techlevel = WARMONGERS_TECHLEVEL_FLINTLOCKS
	var/obj/structure/warobjective/fuckthisshit
	var/list/warfare_barriers = list()

	var/area/red_airship
	var/area/blue_airship

	var/list/red_airship_landmarks = list()
	var/list/blue_airship_landmarks = list()

	var/respawn_cycle = 0
	var/next_respawn
	var/last_respawn = 0
	var/time_between_respawns = 45 SECONDS // in seconds

	var/respawning = FALSE

	var/oneteammode = FALSE // players only allowed to choose grenzelhoft

/datum/controller/subsystem/warmongers/Initialize(start_timeofday)
	red_airship = locate(/area/rogue/indoors/airship/red)
	blue_airship = locate(/area/rogue/indoors/airship/blue)

/datum/controller/subsystem/warmongers/proc/respawn(var/area/airship)
	var/obj/effect/landmark/blureinforcement/blu = locate(/obj/effect/landmark/blureinforcement) in GLOB.landmarks_list
	var/obj/effect/landmark/redreinforcement/red = locate(/obj/effect/landmark/redreinforcement) in GLOB.landmarks_list
	
	for(var/mob/living/carbon/human/H in airship)
		sleep(rand(1,3))
		H.blind_eyes(1)
		H.emote("scream")
		if(H.warfare_faction)
			if(H.warfare_faction == RED_WARTEAM)
				H.forceMove(red.loc)
			else
				H.forceMove(blu.loc)
			H.lay_down()
			H.pixel_y = 200
			animate(H, 1 SECONDS, easing = BOUNCE_EASING, pixel_y = 0)
			spawn(0.35 SECONDS)
				playsound(H.loc, 'sound/misc/fall.ogg', 100, FALSE, -1)

/datum/controller/subsystem/warmongers/fire(resumed)
	if(!warfare_ready_to_die)
		return

	var/obj/effect/landmark/blureinforcement/blu = locate(/obj/effect/landmark/blureinforcement) in GLOB.landmarks_list
	var/obj/effect/landmark/redreinforcement/red = locate(/obj/effect/landmark/redreinforcement) in GLOB.landmarks_list

	if(round_duration_in_ticks >= next_respawn || !next_respawn)
		if(!respawn_cycle)
			respawn_cycle++
		respawning = TRUE

		playsound(blu.loc, 'sound/misc/airship_horn.ogg', 75, FALSE, -4)
		playsound(red.loc, 'sound/misc/airship_horn.ogg', 75, FALSE, -4)

		playsound_area(red_airship, 'sound/misc/airship_horn_inside.ogg')
		playsound_area(blue_airship, 'sound/misc/airship_horn_inside.ogg')

		for(var/mob/living/M in red_airship)
			to_chat(M, "<span class='info'>WE'RE AT POSITION!!! GET THE FUCK OUT!!!</span>")
		for(var/mob/living/M in blue_airship)
			to_chat(M, "<span class='info'>WE'RE AT POSITION!!! GET THE FUCK OUT!!!</span>")

		sleep(7 SECONDS)
		respawn(red_airship)
		respawn(blue_airship)

		respawn_cycle++
		next_respawn = round_duration_in_ticks + time_between_respawns
		last_respawn = round_duration_in_ticks
		respawning = FALSE

		message_admins("respawn cycle: [respawn_cycle]")

/datum/controller/subsystem/warmongers/proc/ReadyToDie()
	var/datum/game_mode/warmongers/W = SSticker.mode
	if(!warfare_ready_to_die)
		to_chat(world, "<span class='userdanger'>[pick("FOR THE CROWN! FOR THE EMPIRE!","CHILDREN OF THE NATION, TO YOUR STATIONS!","I'M NOT AFRAID TO DIE!")]</span>")
		if(!(oneteammode))
			W.supplies()
		warfare_ready_to_die = TRUE

		// https://imgur.com/a/mzWBurl

		for(var/mob/M in GLOB.player_list)
			SEND_SOUND(M, 'sound/music/wolfintro.ogg')
			M.overlay_fullscreen("graghorror", /atom/movable/screen/fullscreen/graghorror)
			M.clear_fullscreen("graghorror", 5 SECONDS)
			M.client.verbs -= /client/verb/forcestartvote
			SSdroning.area_entered(get_area(M), M.client)

		for(var/obj/O in warfare_barriers)
			qdel(O)
		
		W.HandleNoLords()
		W.warmode.beginround()

/datum/controller/subsystem/warmongers/proc/SendSupplies() // supply drops
	var/datum/game_mode/warmongers/W = SSticker.mode

	var/obj/effect/landmark/blureinforcement/blu = locate(/obj/effect/landmark/blureinforcement) in GLOB.landmarks_list
	var/obj/effect/landmark/redreinforcement/red = locate(/obj/effect/landmark/redreinforcement) in GLOB.landmarks_list

	var/list/reinforcementinas = list()
	switch(W.reinforcementwave)
		if(1)
			reinforcementinas += "/obj/item/bomb"
			reinforcementinas += "/obj/item/bomb/fire/weak"
		if(2)
			reinforcementinas += "/obj/item/bomb"
			reinforcementinas += "/obj/item/bomb"
			reinforcementinas += "/obj/item/bomb/fire/weak"
			reinforcementinas += "/obj/item/bomb/smoke"
			reinforcementinas += "/obj/item/flint"
			SSwarmongers.warfare_techlevel = WARMONGERS_TECHLEVEL_FLINTLOCKS
			to_chat(world, "<span class='notice'>This battle will soon get too heated for these shopkeepers!</span>")
		if(3)
			reinforcementinas += "/obj/item/bomb/smoke"
			reinforcementinas += "/obj/item/bomb/fire"
			reinforcementinas += "/obj/item/bomb/poison"
			reinforcementinas += "/obj/item/bomb"
			reinforcementinas += "/obj/item/bomb"
			for(var/obj/structure/shopkeep/SHP in world)
				to_chat(world, "<span class='notice'>This battle is getting too heated for these shopkeepers! They're leaving!</span>")
				SHP.leave()
		if(4)
			reinforcementinas += "/obj/item/bomb/fire"
			reinforcementinas += "/obj/item/bomb/fire"
			reinforcementinas += "/obj/item/bomb/poison"
			reinforcementinas += "/obj/item/bomb/poison"
			SSwarmongers.warfare_techlevel = WARMONGERS_TECHLEVEL_COWBOY
		if(5)
			reinforcementinas += "/obj/item/bomb"
			reinforcementinas += "/obj/item/bomb"
			reinforcementinas += "/obj/item/bomb/fire"
			reinforcementinas += "/obj/item/bomb/smoke"
			reinforcementinas += "/obj/item/bomb/poison"
			reinforcementinas += "/obj/item/bomb/poison"
	W.reinforcementwave++
	to_chat(world, "<span class='info'><span class='typewrite'>Supplies have arrived.</span></span>")
	for(var/mob/M in GLOB.player_list)
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(M, 'sound/vo/halo/reinforcements.mp3')
		else
			SEND_SOUND(M, 'sound/music/traitor.ogg')
	new /obj/effect/telefog(red.loc)
	new /obj/effect/telefog(blu.loc)
	for(var/i in reinforcementinas)
		var/typepath = text2path(i)
		new typepath(red.loc)
		new typepath(blu.loc)

/proc/GetMainGunForWarfareHeartfelt()
	switch(SSwarmongers.warfare_techlevel)
		if(WARMONGERS_TECHLEVEL_FLINTLOCKS)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo
		if(WARMONGERS_TECHLEVEL_COWBOY)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/repeater
		if(WARMONGERS_TECHLEVEL_AUTO)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/supermachine
		if(WARMONGERS_TECHLEVEL_NONE)
			return null

/proc/GetMainGunForWarfareGrenzelhoft()
	switch(SSwarmongers.warfare_techlevel)
		if(WARMONGERS_TECHLEVEL_FLINTLOCKS)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo
		if(WARMONGERS_TECHLEVEL_COWBOY)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/repeater
		if(WARMONGERS_TECHLEVEL_AUTO)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/supermachine
		if(WARMONGERS_TECHLEVEL_NONE)
			return null

/proc/GetSidearmForWarfare()
	switch(SSwarmongers.warfare_techlevel)
		if(WARMONGERS_TECHLEVEL_FLINTLOCKS)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol
		if(WARMONGERS_TECHLEVEL_COWBOY)
			return /obj/item/gun/ballistic/revolver/grenadelauncher/revolvashot
		if(WARMONGERS_TECHLEVEL_NONE)
			return null
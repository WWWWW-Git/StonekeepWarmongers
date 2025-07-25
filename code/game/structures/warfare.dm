/obj/structure/warobjective
	name = "objective"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/blurb = "Fuck the opposing team to win!"
	var/alertsound = 'sound/misc/alert.ogg'
	var/haloalertsound = 'sound/misc/alert.ogg'

/obj/structure/warobjective/proc/beginround()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		to_chat(world, "<span class='danger'>[blurb]</span>")
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, haloalertsound)
		else
			for(var/mob/living/carbon/human/M in GLOB.player_list)
				if(hasvar(M, "warfare_faction") && M.warfare_faction == BLUE_WARTEAM)
					SEND_SOUND(M, 'sound/vo/wc/gren/grenzroundstart.ogg')
				if(hasvar(M, "warfare_faction") && M.warfare_faction == RED_WARTEAM)
					SEND_SOUND(M, 'sound/vo/wc/felt/heartroundstart.ogg')

// TDM

/obj/structure/warobjective/bloodstatue // new LAST STAND
	name = "Sanctified Statue"
	desc = "A derelict of a former age. It demands blood."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "psy" //ironic...
	pixel_x = -32
	resistance_flags = INDESTRUCTIBLE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	haloalertsound = 'sound/vo/halo/exterminatus.mp3'
	var/stalemate_kills = 98
	var/win_kills = 50
	var/base_player_count = 16

	var/min_win_kills = 10
	var/max_win_kills = 200
	var/min_stalemate_kills = 20
	var/max_stalemate_kills = 400

/obj/structure/warobjective/bloodstatue/Initialize()
	. = ..()
	var/player_count = get_active_player_count()
	win_kills = clamp(round(50 * (player_count / base_player_count)), min_win_kills, max_win_kills)
	stalemate_kills = clamp(round(98 * (player_count / base_player_count)), min_stalemate_kills, max_stalemate_kills)

	START_PROCESSING(SSprocessing, src)
	blurb = "Secure [win_kills] kills for your team to win!"

/obj/structure/warobjective/bloodstatue/process()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		if(SSticker.grenzelhoft_deaths >= win_kills)
			C.do_war_end(null, RED_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)
		if(SSticker.heartfelt_deaths >= win_kills)
			C.do_war_end(null, BLUE_WARTEAM)
			STOP_PROCESSING(SSprocessing, src)
		if(SSticker.deaths >= stalemate_kills)
			C.do_war_end()
			STOP_PROCESSING(SSprocessing, src)

/*
/obj/structure/laststandstatue // relic of old LAST STAND
	name = "Sanctified Statue"
	desc = "A massive, holy statue. Heartfeltians feel compelled to protect it, and Grenzelhoftians to destroy it."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "psy" //ironic...
	max_integrity = 800
	pixel_x = -32
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	var/active = FALSE
	var/progress_in_seconds = 0
	var/purpose_fulfilled = FALSE
	var/last_scream = 0
	var/ascend_time = 10 MINUTES
	var/half_way = FALSE

/obj/structure/laststandstatue/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/structure/laststandstatue/proc/begincountdown()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		C.warmode = GAMEMODE_STAND
		active = TRUE
		for(var/X in C.heartfelts)
			var/mob/living/carbon/human/H = X
			to_chat(H, "<span class='danger'>Protect the [src] at any cost!</span>")
			to_chat(H, "You must protect the [src] for [ascend_time] seconds.")
			SEND_SOUND(H, 'sound/misc/alert.ogg')
		for(var/X in C.grenzels)
			var/mob/living/carbon/human/H = X
			to_chat(H, "<span class='danger'>Destroy the [src] at any cost!</span>")
			to_chat(H, "You have [ascend_time] seconds to destroy the [src].")
			SEND_SOUND(H, 'sound/misc/notice.ogg')

/obj/structure/laststandstatue/process()
	if(active == FALSE)
		return
	for(var/turf/closed/wall/W in RANGE_TURFS(2, src)) //no cheating by just boxing in the statue, that is super lame.
		W.dismantle_wall()
	progress_in_seconds += 1
	if(progress_in_seconds > ascend_time/2 && half_way == FALSE)
		to_chat(world, "<span class='danger'>The [src] is halfway to ascension!</span>")
		half_way = TRUE
		for(var/mob/M in GLOB.player_list)
			SEND_SOUND(M, 'sound/misc/alert.ogg')
	if(progress_in_seconds > ascend_time && purpose_fulfilled == FALSE)
		to_chat(world, "<span class='danger'>The [src] has ascended!</span>")
		if(istype(SSticker.mode, /datum/game_mode/warfare))
			var/datum/game_mode/warfare/C = SSticker.mode
			purpose_fulfilled = TRUE
			C.do_war_end(team=RED_WARTEAM)

/obj/structure/laststandstatue/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(!purpose_fulfilled)
		to_chat(world, "<span class='danger'>The [src] was destroyed!</span>")
		if(istype(SSticker.mode, /datum/game_mode/warfare))
			var/datum/game_mode/warfare/C = SSticker.mode
			C.do_war_end(team=BLUE_WARTEAM)
	. = ..()

/obj/structure/laststandstatue/examine(mob/user)
	..()
	if(!active)
		to_chat(user,"The [src] is not ready yet.")
	else
		to_chat(user, "<b>The [src] must be protected for another [(ascend_time - progress_in_seconds)] seconds.</b>!")
		to_chat(user, "<b>The [src] has [obj_integrity] health</b>!")

/obj/structure/laststandstatue/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE, attack_dir, armour_penetration = 0)
	. = ..()
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		if(last_scream < world.time)
			for(var/X in C.heartfelts)
				var/mob/living/carbon/human/H = X
				SEND_SOUND(H, 'sound/misc/astratascream.ogg')
				to_chat(H, "<span class='danger'>The [src] is taking damage!</span>")
			last_scream = world.time + 600
*/

// CTF

/obj/structure/warobjective/ponr
	name = "Grenzelhofts Point of No Return"
	desc = "You feel like this was shamelessly stolen from some sort of different place. Oh well, DON'T LET THE HEARTFELTS TOUCH THIS! But if you're a Heartfelt... Eh, sure. Why not."
	icon = 'icons/shamelessly_stolen.dmi'
	icon_state = "destruct"
	anchored = TRUE
	climbable = FALSE
	density = TRUE
	opacity = FALSE
	haloalertsound = 'sound/vo/halo/ctf.mp3'
	blurb = "Capture the enemy flag and take it to your PONR!"
	var/team = BLUE_WARTEAM
	var/wealreadywon = FALSE

/obj/structure/warobjective/ponr/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/warobjective/ponr/process()
	for(var/turf/closed/wall/W in RANGE_TURFS(2, src)) //no cheating by just boxing in the statue, that is super lame.
		W.dismantle_wall()

/obj/structure/warobjective/ponr/attack_hand(mob/user) // Dumb fucking oversight here, only one person from each team can be carrying a flag at the same time.
	. = ..()
	var/mob/living/carbon/human/H
	var/datum/game_mode/warfare/C = SSticker.mode
	if(ishuman(user))
		H = user
	if(H.warfare_faction == team)
		if(C.crownbearer == H && !wealreadywon)
			C.do_war_end(H, team)
			wealreadywon = TRUE
			if(aspect_chosen(/datum/round_aspect/halo))
				SEND_SOUND(world, 'sound/vo/halo/flag_cap.mp3')
		else if(C.crownbearer != H)
			to_chat(H, "<span class='info'>Someone else is carrying the flag.</span>")
			return
		else
			to_chat(H, "<span class='info'>This belongs to us.</span>")
		return
	if(C.crownbearer == H)
		return

	C.crownbearer = H
	to_chat(world, "<span class='userdanger'>[uppertext(team)] FLAG TAKEN.</span>")
	if(aspect_chosen(/datum/round_aspect/halo))
		SEND_SOUND(world, 'sound/vo/halo/flag_take.mp3')

/obj/structure/warobjective/ponr/red
	name = "Heartfelts Point of No Return"
	desc = "You feel like this was shamelessly stolen from some sort of different place. Oh well, DON'T LET THE GRENZELHOFTS TOUCH THIS! But if you're a Grenzelhoft... Eh, sure. Why not."
	team = RED_WARTEAM

// LD

/obj/structure/warobjective/warthrone
	name = "throne of Heartfelt"
	desc = "Do not let the enemy sit on this with your crown."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	pixel_x = -32
	buckle_lying = FALSE
	blurb = "Take the enemy Lord's crown and sit on the Throne of Heartfelt!"
	haloalertsound = 'sound/vo/halo/hail2theking.mp3'

/obj/structure/warobjective/warthrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(istype(SSticker.mode, /datum/game_mode/warfare))
		var/datum/game_mode/warfare/C = SSticker.mode
		if(C.crownbearer == H)
			return // Gets rid of people farming triumphs
		switch(H.warfare_faction)
			if(RED_WARTEAM)
				if(istype(H.head, /obj/item/clothing/head/roguetown/warmongers/crownblu))
					C.do_war_end(H, RED_WARTEAM)
			if(BLUE_WARTEAM)
				if(istype(H.head, /obj/item/clothing/head/roguetown/warmongers/crownred))
					C.do_war_end(H, BLUE_WARTEAM)

/obj/structure/warobjective/warthrone/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")

/obj/structure/warobjective/warthrone/Initialize()
	..()
	lordcolor(CLOTHING_RED,CLOTHING_YELLOW)

/obj/structure/warobjective/warthrone/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/structure/warobjective/warthrone/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "throne_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "throne_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)
	GLOB.lordcolor -= src

// Shopkeepers

/obj/structure/shopkeep
	name = "\improper Shopkeeper"
	desc = "A merchant from the isle of Enigma, he has some things to sell. He is hanging from an airship by chain... he won't stick around for long."
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "shop"
	layer = 4.26
	plane = GAME_PLANE_UPPER
	pixel_x = 6
	pixel_y = 9
	anchored = TRUE
	density = FALSE
	var/leaving = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/shopkeep/proc/leave()
	if(leaving)
		return
	leaving = TRUE
	flick("shop_leave", src)
	playsound(src, 'sound/misc/gate.ogg', 50, FALSE)
	QDEL_IN(src, 35)

/obj/structure/shopkeep/Initialize()
	. = ..()
	SSticker.warfare_barriers += src

/obj/structure/shopkeep/examine(mob/user)
	. = ..()
	if(istype(get_area(src), /area/rogue/indoors))
		. += "<span class='info'>There is a hole in the roof to allow the chains to get inside.</span>"

/obj/structure/shopkeep/attack_hand(mob/user)
	. = ..()
	if(!ishuman(user))
		say("FUCK YOU! YOU'RE JUST AN ANIMAL, FIEND!")
		playsound(src, 'sound/misc/machineno.ogg', 50, FALSE)
		return
	if(leaving)
		to_chat(user, "<span class='warning'>NO! NO! I FORGOT TO GET MY CHANGE! NOOOOOOOOO!</span>")
		user.playsound_local(src, 'sound/misc/zizo.ogg', 50, FALSE)
		return
	if(user.client.equippedPerk.type != /datum/warperk)
		say("SORRY! YOU ARE ALREADY EMPOWERED!")
		playsound(src, 'sound/misc/machinetalk.ogg', 50, FALSE)
		return
	playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/list/buyables = list()
	for(var/thing in subtypesof(/datum/warperk))//Populate possible aspects list.
		var/datum/warperk/A = new thing
		buyables[A.name] = A
	var/chosen = input(user, "ENIGMATIC EXPENSIVITIES TO PROTECT YOUR EXTREMITIES! BUY NOW!", "WARMONGERS") as null|anything in buyables
	var/datum/warperk/WP = buyables[chosen]
	if(WP)
		var/full_desc = "[WP.desc] ([WP.cost] TRI)"
		var/alerto = alert(user, full_desc, WP.name, "Confirm", "Cancel")
		if(alerto == "Confirm")
			if(user.get_triumphs() < WP.cost)
				to_chat(user, "<span class='warning'>I haven't TRIUMPHED enough.</span>")
				return
			user.adjust_triumphs(-WP.cost)
			user.client.equippedPerk = WP
			user.client.equippedPerk.apply(user)
			say("THANK YOU FOR SHOPPING WITH US TODAE!")
			playsound(src, 'sound/misc/machinetalk.ogg', 50, FALSE)

/obj/structure/warobjective/cfour
	name = "\improper grand orb"
	desc = "A relic of a former age. It hums with unstable magick."
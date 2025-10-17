/obj/structure/warobjective
	name = "objective"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/gametype = /datum/warmode
	var/qdel_on_init = FALSE

/obj/structure/warobjective/Initialize()
	. = ..()
	SSticker.fuckthisshit = src

/obj/structure/warobjective/proc/setup()
	var/datum/game_mode/warmongers/C = SSticker.mode
	var/datum/warmode/WM = new gametype
	
	C.warmode = WM
	WM.objective = src

	if(qdel_on_init)
		WM.objective = null
		qdel(src)

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
	gametype = /datum/warmode/tdm

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
	gametype = /datum/warmode/noreturn

/obj/structure/warobjective/ponr/attack_hand(mob/user)
	. = ..()
	var/mob/living/carbon/human/H
	var/datum/game_mode/warmongers/C = SSticker.mode
	var/datum/warmode/noreturn/NR = C.warmode
	if(ishuman(user))
		H = user

	if(NR.wealreadywon)
		return
	if(NR.blu_flag)
		to_chat(H, "<span class='info'>Someone else is carrying the flag.</span>")
		return

	if(NR.red_flag == H)
		NR.wealreadywon = TRUE
		C.do_war_end(H, BLUE_WARTEAM)
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, 'sound/vo/halo/flag_cap.mp3')
		return
	
	if(H.warfare_faction == BLUE_WARTEAM)
		to_chat(H, "<span class='info'>This belongs to us.</span>")
		return

	NR.blu_flag = H
	to_chat(world, "<span class='userdanger'>GRENZELHOFTS FLAG TAKEN.</span>")
	if(aspect_chosen(/datum/round_aspect/halo))
		SEND_SOUND(world, 'sound/vo/halo/flag_take.mp3')

/obj/structure/warobjective/ponr/red
	name = "Heartfelts Point of No Return"
	desc = "You feel like this was shamelessly stolen from some sort of different place. Oh well, DON'T LET THE GRENZELHOFTS TOUCH THIS! But if you're a Grenzelhoft... Eh, sure. Why not."

/obj/structure/warobjective/ponr/red/attack_hand(mob/user)
	. = ..()
	var/mob/living/carbon/human/H
	var/datum/game_mode/warmongers/C = SSticker.mode
	var/datum/warmode/noreturn/NR = C.warmode
	if(ishuman(user))
		H = user

	if(NR.wealreadywon)
		return
	if(NR.red_flag)
		to_chat(H, "<span class='info'>Someone else is carrying the flag.</span>")
		return

	if(NR.blu_flag == H)
		NR.wealreadywon = TRUE
		C.do_war_end(H, RED_WARTEAM)
		if(aspect_chosen(/datum/round_aspect/halo))
			SEND_SOUND(world, 'sound/vo/halo/flag_cap.mp3')
		return
	
	if(H.warfare_faction == RED_WARTEAM)
		to_chat(H, "<span class='info'>This belongs to us.</span>")
		return

	NR.red_flag = H
	to_chat(world, "<span class='userdanger'>HEARTFELTS FLAG TAKEN.</span>")
	if(aspect_chosen(/datum/round_aspect/halo))
		SEND_SOUND(world, 'sound/vo/halo/flag_take.mp3')

// ASLT

/obj/structure/warobjective/assaultthrone
	name = "throne of Heartfelt"
	desc = "Do not let the enemy sit on this with your crown."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	pixel_x = -32
	buckle_lying = FALSE
	gametype = /datum/warmode/assault

/obj/structure/warobjective/assaultthrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)

/obj/structure/warobjective/assaultthrone/post_unbuckle_mob(mob/living/M)
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
	gametype = /datum/warmode/lords

/obj/structure/warobjective/warthrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(istype(SSticker.mode, /datum/game_mode/warmongers))
		var/datum/game_mode/warmongers/C = SSticker.mode
		var/datum/warmode/lords/L = C.warmode
		if(L.winner == H)
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

// Shopkeepers, back now with improvements!

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
	var/faction = BLUE_WARTEAM
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/shopkeep/red
	name = "Lé Shopekeep"
	faction = RED_WARTEAM

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
	var/datum/game_mode/warmongers/C = SSticker.mode
	var/mob/living/carbon/human/H
	if(ishuman(user))
		H = user
		if(H.warfare_faction != faction)
			say("OK! LETS GET TO BUSINE- wait a second... HEY YOU'RE NOT MEANT TO BE HERE!!!")
			playsound(loc, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return
	if(leaving)
		to_chat(user, "<span class='warning'>NO! NO! I FORGOT TO GET MY CHANGE! NOOOOOOOOO!</span>")
		user.playsound_local(src, 'sound/misc/zizo.ogg', 50, FALSE)
		return
	playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

	var/list/shippables = list()
	for(var/s in subtypesof(/datum/warshippable))
		var/datum/warshippable/WS = new s()
		if(C.reinforcementwave >= WS.reinforcement)
			shippables[WS.name] = WS

	var/choice = input(user, "AIRSHIP ENIGMATIVITIES STRAIGHT FROM ENIGMA!", "BUY NOW!!!") as null|anything in shippables
	var/datum/warshippable/shoppin = shippables[choice]
	if(!shoppin)
		return
	if(!do_after(user, 5 SECONDS, TRUE, loc))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return

	switch(faction)
		if(RED_WARTEAM)
			if(C.red_bonus >= 1)
				C.red_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				say("INSUFFICIENT POINTS!!!")
				return
		if(BLUE_WARTEAM)
			if(C.blu_bonus >= 1)
				C.blu_bonus--
				playsound(loc, 'sound/misc/machinevomit.ogg', 100, FALSE, -1)
			else
				playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				say("INSUFFICIENT POINTS!!!")
				return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)

	for(var/i in shoppin.items)
		if(shoppin.items.len > 1)
			sleep(rand(1,3))
		var/fuck = new i(get_turf(src))
		if(istype(fuck, /obj))
			var/obj/O = fuck
			O.pixel_y = 200
			animate(O, 1 SECONDS, easing = BOUNCE_EASING, pixel_y = 0)
			spawn(0.35 SECONDS)
				playsound(loc, 'sound/misc/fall.ogg', 100, FALSE, -1)

/obj/structure/cfour
	name = "\improper grand orb"
	desc = "A relic of a former age. It hums with unstable magick."
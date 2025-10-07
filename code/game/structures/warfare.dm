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
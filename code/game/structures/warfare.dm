/obj/structure/warobjective
	name = "objective"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/gametype = /datum/warmode

/obj/structure/warobjective/Initialize()
	. = ..() // I don't know at this point. I guess if you don't want it to show up on the map you can hide it or make a special object that deletes itself on init.
	var/datum/game_mode/warmongers/C = SSticker.mode
	var/datum/warmode/WM = new gametype
	
	C.warmode = WM
	WM.objective = src

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
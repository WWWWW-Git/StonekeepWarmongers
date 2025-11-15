//rootchilde
/mob/living/simple_animal/pet/rootchilde
	name = "Rootchilde"
	desc = "Child of the Root, some consider such things to be demigods unto themselves. Most people just find them annoying, but they still have their uses, as messengers, heralds and even personal jesters."
	icon = 'icons/roguetown/mob/bodies/m/thecreature.dmi'
	icon_state = "creatureppu"
	icon_living = "creatureppu"
	icon_dead = "creatureppu_dead"
	gender = MALE
	speak = list("Skre!", "Tuflu!", "Vargoe!", "EARENFU")
	speak_emote = list("says", "mutters")
	emote_hear = list("sputters.", "splutters.")
	emote_see = list("shakes its head.", "does a jig.")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 6
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE
	mob_size = MOB_SIZE_SMALL
	density = FALSE
	pass_flags = PASSMOB
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = 200
	maxbodytemp = 400
	unsuitable_atmos_damage = 1
	animal_species = /mob/living/simple_animal/pet/rootchilde
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 1)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	STASTR = 3
	STAEND = 4
	STASPD = 3
	STACON = 3
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	gold_core_spawnable = FRIENDLY_SPAWN

	footstep_type = FOOTSTEP_MOB_BAREFOOT

/mob/living/simple_animal/pet/rootchilde/Initialize()
	. = ..()
	verbs += /mob/living/proc/lay_down

/mob/living/simple_animal/pet/rootchilde/update_mobility()
	..()
	if(client && stat != DEAD)
		if (resting)
			icon_state = "[icon_living]_rest"
		else
			icon_state = "[icon_living]"
	regenerate_icons()

/mob/living/simple_animal/pet/rootchilde/Proc
	name = "Proc"
	gender = MALE
	gold_core_spawnable = NO_SPAWN
	unique_pet = TRUE

/mob/living/simple_animal/pet/rootchilde/Life()
	if(!stat && !buckled && !client)
		if(prob(1))
			emote("me", 1, pick("rolls on the ground.", "falls over.", "lies down."))
			icon_state = "[icon_living]_rest"
			set_resting(TRUE)
		else if (prob(1))
			emote("me", 1, pick("sits down.", "looks around.", "looks alert."))
			icon_state = "[icon_living]_sit"
			set_resting(TRUE)
		else if (prob(2))
			if (resting)
				emote("me", 1, pick("gets up.", "walks around.", "stops resting."))
				icon_state = "[icon_living]"
				set_resting(FALSE)
			else
				emote("me", 1, pick("does a little jig.", "taps its foot impatiently.", "fixes its helmet."))

	..()

/mob/living/simple_animal/pet/rootchilde/proc/wuv(change, mob/M)
	if(change)
		if(change > 0)
			if(M && stat != DEAD)
				new /obj/effect/temp_visual/heart(loc)
				emote("me", 1, "splutters!")
				if(flags_1 & HOLOGRAM_1)
					return
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, src, /datum/mood_event/pet_animal, src)
		else
			if(M && stat != DEAD)
				emote("me", 1, "slurs!")
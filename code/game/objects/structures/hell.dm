GLOBAL_LIST_EMPTY(hellexits)
GLOBAL_LIST_EMPTY(hellspawns)
/*
/proc/setup_hell()
	create_hellexit()
	create_jailers()

/proc/create_hellexit()
	var/obj/effect/landmark/L = pick(GLOB.hellexits)
	if(L)
		new /obj/structure/fluff/psyexit(L.loc)

/proc/create_jailers()
	for(var/i in 1 to 6)
		var/obj/effect/landmark/L = pick(GLOB.hellexits)
		if(L)
			new /obj/structure/fluff/helljailer(L.loc)
*/
/obj/effect/landmark/hellspawn
	name = ""
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	density = FALSE
	anchored = TRUE
	layer = MOB_LAYER

/obj/effect/landmark/hellspawn/New()
	GLOB.hellspawns += src
	icon_state = null
	..()

/obj/effect/landmark/hellspawn/Destroy()
	GLOB.hellspawns -= src
	return ..()

/obj/effect/landmark/hellexit
	name = ""
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x2"
	density = FALSE
	anchored = TRUE
	layer = MOB_LAYER

/obj/effect/landmark/hellexit/New()
	GLOB.hellexits += src
	icon_state = null
	..()

/obj/effect/landmark/hellexit/Destroy()
	GLOB.hellexits -= src
	return ..()

/mob/dead/observer
	var/isinhell
	var/last_helld = 0

/mob/dead/observer/proc/go2hell()
	var/obj/effect/landmark/L = pick(GLOB.hellspawns)
	if(L)
		src.forceMove(L)
		if(!isinhell)
			playsound_local(src, 'sound/misc/hel.ogg', 100)
			isinhell = TRUE

/obj/structure/fluff/psyexit
	name = "escape"
	icon = 'icons/roguetown/misc/hell.dmi'
	icon_state = "hellexit"
	alpha = 150
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	max_integrity = 0
	var/spawn_time
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF

/obj/structure/fluff/psyexit/Initialize()
	spawn_time = world.time
	START_PROCESSING(SSobj, src)
	..()

/obj/structure/fluff/psyexit/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/fluff/psyexit/process()
	if(world.time > spawn_time + 10 MINUTES)
//		create_hellexit()
		qdel(src)
		return

/obj/structure/fluff/psyexit/attack_ghost(mob/dead/observer/user)
	if(user.Adjacent(src))
		user.isinhell = FALSE
		user.returntolobby()

/obj/structure/fluff/helljailer
	name = "JAILER"
	desc = "A biological weapon from the depths of all that is unholy. It is said to be created by the Evil Himself as his Destroyer of Man"
	icon = 'icons/roguetown/mob/monster/hellkeeper.dmi'
	icon_state = "hellkeeper"
	density = FALSE
	anchored = FALSE
	layer = MOB_LAYER
	max_integrity = 0
	var/last_dir
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF

/obj/structure/fluff/helljailer/Entered(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.playsound_local(src, pick('sound/misc/HL (1).ogg','sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (4).ogg','sound/misc/HL (5).ogg','sound/misc/HL (6).ogg'), 100)
		playsound(src.loc, list('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 100, FALSE, -1)
		H.flash_fullscreen("redflash3")
		H.emote("agony")
		H.apply_damage(65, BRUTE)
		new /obj/effect/gibspawner/human(get_turf(src))

		var/obj/item/bodypart/limb
		var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
		for(var/zone in limb_list)
			limb = H.get_bodypart(zone)
			if(limb)
				playsound(src,'sound/misc/eat.ogg', rand(30,60), TRUE)
				limb.dismember()
				qdel(limb)
				return

/obj/structure/fluff/helljailer/Initialize()
	START_PROCESSING(SSfastprocess, src)
	..()

/obj/structure/fluff/helljailer/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	. = ..()

/obj/structure/fluff/helljailer/process()
	playsound(src, pick('sound/foley/footsteps/bigwalk (1).ogg','sound/foley/footsteps/bigwalk (2).ogg','sound/foley/footsteps/bigwalk (3).ogg','sound/foley/footsteps/bigwalk (4).ogg'), 100, FALSE, 40)
	if(!last_dir)
		last_dir = dir
	if(prob(23)) //change dir randomly
		var/temp_dir = pick(turn(last_dir, 90),turn(last_dir, -90))
		var/turf/T = get_step(src, temp_dir)
		playsound(src, pick('sound/misc/HL (1).ogg','sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (4).ogg','sound/misc/HL (5).ogg','sound/misc/HL (6).ogg'), 100, FALSE, 3)
		if(isopenturf(T))
			dir = temp_dir
			last_dir = temp_dir
			forceMove(T)
			return
	var/turf/T = get_step(src, last_dir)//go the same dir if we can
	if(isopenturf(T))
		dir = last_dir
		forceMove(T)
		return
	var/list/dirs2go = list(turn(last_dir, 90),turn(last_dir, -90)) //try to change dirs
	var/temp_dir = pick_n_take(dirs2go)
	T = get_step(src, temp_dir)
	if(isopenturf(T))
		dir = temp_dir
		last_dir = temp_dir
		forceMove(T)
		return
	else
		temp_dir = pick_n_take(dirs2go)
		T = get_step(src, temp_dir)
		if(isopenturf(T))
			dir = temp_dir
			last_dir = temp_dir
			forceMove(T)
			return
	//only go 180 if theres nowhere else to go
	temp_dir = turn(last_dir, 180)
	T = get_step(src, temp_dir)
	if(isopenturf(T))
		last_dir = temp_dir
		dir = temp_dir
		forceMove(T)
		return

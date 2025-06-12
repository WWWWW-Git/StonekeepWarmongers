// immovable cannons. no hand cannons, sorry. (jk)

/obj/structure/cannon // cannon
	name = "barkstone"
	desc = "A large weapon mainly hoisted on warships."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "cannona"
	anchored = FALSE
	density = TRUE
	max_integrity = 9999
	drag_slowdown = 1 // If it took so long it would be not really fun.
	w_class = WEIGHT_CLASS_GIGANTIC // INSTANTLY crushed
	var/shootingdown = FALSE // if we are shooting one tile infront of us below (if its an open space)
	var/obj/item/ammo_casing/caseless/rogue/cball/loaded

/obj/structure/cannon/examine(mob/user)
	. = ..()
	if(loaded)
		. += "<span class='info'>It is loaded.</span>"
	if(shootingdown)
		. += "<span class='info'>It will shoot the things below.</span>"

/obj/structure/cannon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/cball))
		if(loaded)
			return
		user.visible_message("<span class='notice'>\The [user] begins loading \the [I] into \the [src].</span>")
		playsound(src, 'sound/combat/cannon_loading.ogg', 35)
		if(!do_after(user, 5 SECONDS, TRUE, src))
			return
		I.forceMove(src)
		loaded = I
		user.visible_message("<span class='notice'>\The [user] loads \the [I] into \the [src].</span>")
		playsound(src, 'sound/foley/trap_arm.ogg', 65)
	if(istype(I, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = I
		if(!loaded)
			return
		if(LR.on)
			playsound(src.loc, 'sound/items/firelight.ogg', 100)
			user.visible_message("<span class='danger'>\The [user] lights \the [src]!</span>")
			fire()
	else
		return ..()

/obj/structure/cannon/attack_right(mob/user)
	. = ..()
	if(!SSticker.warfare_ready_to_die)
		to_chat(user, "<span class='danger'>Why in the world would I ever do that? Why would I waste time pointing it down if I can't even use it to kill the enemy right now?</span>")
		return
	if(!shootingdown)
		visible_message("<span class='info'>[user] begins tilting \the [src] to point down.</span>", "<span class='info'>I begin tilting \the [src] to point down a little...</span>")
	else
		visible_message("<span class='info'>[user] begins tilting \the [src] to point up.</span>", "<span class='info'>I begin tilting \the [src] to point up a little...</span>")
	if(do_after(user, 3  SECONDS, TRUE, src))
		shootingdown = !shootingdown
		playsound(src.loc, 'sound/foley/winch.ogg', 100, extrarange = 3)

/obj/structure/cannon/fire_act(added, maxstacks)
	if(!loaded)
		return
	playsound(src.loc, 'sound/items/firelight.ogg', 100)
	fire()

/obj/structure/cannon/spark_act()
	if(!loaded)
		return
	playsound(src.loc, 'sound/items/firelight.ogg', 100)
	fire()

/obj/structure/cannon/proc/fire()
	if(!loaded)
		return
	for(var/mob/living/carbon/H in hearers(7, src))
		shake_camera(H, 6, 5)
		H.blur_eyes(4)
		if(prob(30))
			H.playsound_local(get_turf(H), 'sound/foley/tinnitus.ogg', 45, FALSE)
	for(var/mob/living/carbon/human/H in get_step(src, turn(dir, 180)))
		var/turf/turfa = get_ranged_target_turf(src, turn(dir, 180), 2)
		H.throw_at(turfa, 4, 1, null, FALSE)
		H.take_overall_damage(45)
		visible_message("<span class='danger'>\The [H] is thrown back from \the [src]'s recoil!</span>")
	flick("cannona_firea", src)

	var/turfina = get_turf(src)
	if(shootingdown)
		var/step = get_step(src, dir)
		if(istype(step, /turf/open/transparent/openspace))
			turfina = get_step_multiz(step, DOWN)
		else
			explosion(get_turf(src), heavy_impact_range = 4, light_impact_range = 6, flame_range = 0, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	var/obj/projectile/fired_projectile = new loaded.projectile_type(turfina)
	fired_projectile.firer = src
	fired_projectile.fired_from = src
	fired_projectile.fire(dir2angle(dir))
	QDEL_NULL(loaded)
	playsound(src.loc, 'sound/misc/explode/explosion.ogg', 100, FALSE)
	sleep(4)
	new /obj/effect/particle_effect/smoke(get_turf(src))

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/handcannon // for the memes
	name = "hand barkstone"
	desc = "HOLY FUCK!"
	fire_sound = 'sound/misc/explode/explosion.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/musk/cannona
	dropshrink = 0.5

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/handcannon/update_icon()
	icon_state = "cannona"

/obj/item/ammo_box/magazine/internal/shot/musk/cannona
	ammo_type = /obj/item/ammo_casing/caseless/rogue/cball
	caliber = "cannoball"
	max_ammo = 1
	start_empty = TRUE

// artillery (fucking OP)

/obj/structure/bombard
	name = "bombardier"
	desc = "Artiljerija! Load in a bomb and set the azirath, then light."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "bombardier"
	anchored = FALSE
	density = TRUE
	max_integrity = 9999
	drag_slowdown = 1 // If it took so long it would be not really fun.
	w_class = WEIGHT_CLASS_GIGANTIC // INSTANTLY crushed
	var/plusy = 0 // no pussy jokes.
	var/obj/item/bomb/loaded
	
/obj/structure/bombard/Moved(atom/OldLoc, Dir)
	. = ..()
	switch(Dir)
		if(NORTH)
			plusy = abs(plusy)
		if(SOUTH)
			plusy = -abs(plusy)

/obj/structure/bombard/MiddleClick(mob/user, params)
	if(ishuman(user))
		var/oldy = y
		var/newy = oldy + plusy
		var/turf/epicenter = locate(x,newy,z)
		if(istype(epicenter, /turf/open/transparent/openspace))
			epicenter = get_step_multiz(epicenter, DOWN)

		to_chat(user, "<span class='notice'>I try to look through the magnifying glass on \the [src].</span>")
		if(do_after(user, 2 SECONDS, TRUE, src))
			// these vars are reset automatically when a person tries to move
			user.client.eye = epicenter
			user.client.perspective = EYE_PERSPECTIVE

/obj/structure/bombard/examine(mob/user)
	. = ..()
	if(plusy)
		. += "<span class='info'>The azirath is set to [plusy]. Which means it will shoot [plusy] urists the direction it is facing.</span>"
	if(loaded)
		. += "<span class='info'>It is loaded.</span>"

/obj/structure/bombard/attack_right(mob/user)
	. = ..()
	var/agka = input(user, "Insert azirath for target (pyrimuth equals location of bombardier)", "WARMONGERS") as null|num
	agka = abs(agka)
	if(agka)
		switch(dir)
			if(NORTH)
				plusy = agka
			if(SOUTH)
				plusy = -agka
		to_chat(user, "<span class='info'>New Target: [y + plusy] azirath</span>")
		playsound(src, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)

/obj/structure/bombard/fire_act(added, maxstacks)
	if(!loaded || !SSticker.warfare_ready_to_die)
		return
	playsound(src.loc, 'sound/items/firelight.ogg', 100)
	fire()

/obj/structure/bombard/spark_act()
	if(!loaded || !SSticker.warfare_ready_to_die)
		return
	playsound(src.loc, 'sound/items/firelight.ogg', 100)
	fire()

/obj/structure/bombard/attackby(obj/item/I, mob/user, params)
	if(dir == WEST || dir == EAST)
		to_chat(user, "<span class='warning'>Shooting that direction would be a waste of resources.</span>")
		return
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/cball))
		to_chat(user, "<span class='warning'>It won't work, I need a bomb.</span>")
		return
	if(istype(I, /obj/item/bomb))
		if(loaded)
			return
		user.visible_message("<span class='notice'>\The [user] begins loading \the [I] into \the [src].</span>")
		playsound(src, 'sound/combat/cannon_loading.ogg', 35)
		if(!do_after(user, 5 SECONDS, TRUE, src))
			return
		I.forceMove(src)
		loaded = I
		user.visible_message("<span class='notice'>\The [user] loads \the [I] into \the [src].</span>")
		playsound(src, 'sound/foley/trap_arm.ogg', 65)
	if(istype(I, /obj/item/flashlight/flare/torch))
		var/obj/item/flashlight/flare/torch/LR = I
		if(!loaded || !SSticker.warfare_ready_to_die)
			to_chat(user, "<span class='danger'>No, that would be stupid.</span>")
			return
		if(LR.on)
			playsound(src.loc, 'sound/items/firelight.ogg', 100)
			user.visible_message("<span class='danger'>\The [user] lights \the [src]!</span>")
			fire()
	else
		return ..()

/obj/structure/bombard/proc/fire()
	for(var/mob/living/carbon/H in hearers(7, src))
		shake_camera(H, 6, 5)
		H.blur_eyes(4)
		if(prob(30))
			H.playsound_local(get_turf(H), 'sound/foley/tinnitus.ogg', 45, FALSE)
	for(var/mob/living/carbon/human/H in get_step(src, turn(dir, 180)))
		var/turf/turfa = get_ranged_target_turf(src, turn(dir, 180), 2)
		H.throw_at(turfa, 3, 1, null, FALSE)
		H.take_overall_damage(45)
		visible_message("<span class='danger'>\The [H] is thrown back from \the [src]'s recoil!</span>")
	flick("bombardier_firea", src)
	playsound(src.loc, 'sound/misc/explode/explosion.ogg', 100, FALSE)
	
	var/oldy = y
	var/newy = oldy + plusy

	var/turf/epicenter = locate(x,newy,z)
	if(istype(epicenter, /turf/open/transparent/openspace))
		epicenter = get_step_multiz(epicenter, DOWN)

	var/obj/effect/warning/G = new(epicenter)

	spawn(5 SECONDS)
		qdel(G)
		loaded.forceMove(epicenter)
		loaded.light()
		loaded.explode(TRUE)
		QDEL_NULL(loaded)

	sleep(8)
	new /obj/effect/particle_effect/smoke(get_turf(src))
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
	if(istype(I, /obj/item/flint))
		var/obj/item/flint/F = I
		if(!loaded || !SSticker.warfare_ready_to_die)
			to_chat(user, "<span class='danger'>No, that would be stupid.</span>")
			return
		F.afterattack(src, user, TRUE)
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

/obj/structure/cannon/proc/fire()
	if(!loaded)
		return
	for(var/mob/living/carbon/H in hearers(7, src))
		shake_camera(H, 6, 5)
		H.blur_eyes(4)
		firearm_recoil_camera(H, 2, 5, dir)
		if(prob(30))
			H.playsound_local(get_turf(H), 'sound/foley/tinnitus.ogg', 45, FALSE)
	for(var/mob/living/carbon/human/H in get_step(src, turn(dir, 180)))
		var/turf/turfa = get_ranged_target_turf(src, turn(dir, 180), 4)
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
	desc = "Artiljerija! Load in a bomb and set the azirath, then light. Use your middle eye to check through the magnifying glass."
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
	if(istype(I, /obj/item/flint))
		var/obj/item/flint/F = I
		if(!loaded || !SSticker.warfare_ready_to_die)
			to_chat(user, "<span class='danger'>No, that would be stupid.</span>")
			return
		F.afterattack(src, user, TRUE)
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
		epicenter = epicenter.below()

	var/obj/effect/warning/G = new(epicenter)

	spawn(5 SECONDS)
		qdel(G)
		loaded.forceMove(epicenter)
		loaded.light()
		loaded.explode(TRUE)
		QDEL_NULL(loaded)

	var/angle
	switch(dir)
		if(NORTH) angle = 90
		if(SOUTH) angle = 270
		if(EAST)  angle = 0
		if(WEST)  angle = 180
	angle += rand(-15, 15)

	var/px = round(64 * cos(angle))
	var/py = round(64 * sin(angle))

	var/obj/effect/temp_visual/small_smoke/S = new(get_turf(src))
	var/matrix/ARE = matrix()
	ARE.Scale(4, 4)
	ARE.Turn(rand(50,350))
	animate(S, time = 50, alpha = 0, pixel_x = px, pixel_y = py, transform = ARE, easing = SINE_EASING)

	new /obj/effect/particle_effect/smoke(get_turf(src))

// maxim bb gun

/obj/structure/maxim
	name = "\improper Maxwell's Barkenweapon"
	desc = "Oh boy, this'll be complicated to operate, won't it? There is a scroll wheel on it."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "machina"
	anchored = FALSE
	density = TRUE
	max_integrity = 9999
	drag_slowdown = 2 // If it took so long it would be not really fun.
	w_class = WEIGHT_CLASS_GIGANTIC // INSTANTLY crushed
	var/list/firesounds = list('sound/combat/Ranged/firebow-shot-01.ogg', 'sound/combat/Ranged/firebow-shot-02.ogg', 'sound/combat/Ranged/firebow-shot-03.ogg')
	var/bullets = 0 // starts with zero
	var/fireangle = 0 // straight forward

	var/obj/effect/point/indicator
	var/last_scroll_time = 0

/obj/structure/maxim/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/bullet))
		to_chat(user, "<span class='notice'>You begin crushing up the ball...</span>")
		if(do_after(user, 5 SECONDS, TRUE, src))
			to_chat(user, "<span class='info'>You break the ball into five small pellets and load them into the machine.</span>")
			playsound(src, 'sound/foley/trap_arm.ogg', 65)
			bullets += 5
			qdel(I)
	if(istype(I, /obj/item/ammo_casing/caseless/rogue/cball))
		to_chat(user, "<span class='notice'>Too big to fit... you'll need to smash that.</span>") // Nobody is gonna get this, but this is a reference to There is No Game: Wrong Dimension in the credits level!
	if(istype(I, /obj/item/rogue/maxim_ammo))
		playsound(src, 'sound/foley/trap_arm.ogg', 65)
		bullets += 25
		qdel(I)

/obj/structure/maxim/examine(mob/user)
	. = ..()
	if(bullets)
		. += "<span class='info'>It is loaded. ([bullets])</span>"

/obj/structure/maxim/proc/fire(mob/user)
	if(!bullets)
		playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
		return
	var/turf/T = get_turf(src)
	//var/turf/target = get_ranged_target_turf(src, dir, 7) // seven7
	var/turf/target = get_step(src, dir)
	var/obj/projectile/bullet/reusable/bullet/maxim/A = new(T)
	A.muzzle_type = null // Fuck you.
	
	var/true_angle = fireangle + dir2angle(dir)
	flick("machina_firea", src)
	playsound(src.loc, pick(firesounds), 100, FALSE)

	firearm_recoil_camera(user, 1, 1, user.dir)

	A.preparePixelProjectile(target, T)
	A.firer = user
	A.fired_from = src
	A.fire(true_angle)
	bullets--

	//new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(src))

	var/angle
	switch(dir)
		if(NORTH) angle = 90
		if(SOUTH) angle = 270
		if(EAST)  angle = 0
		if(WEST)  angle = 180
	angle += rand(-15, 15)

	var/px = round(64 * cos(angle))
	var/py = round(64 * sin(angle))

	var/obj/effect/temp_visual/small_smoke/S = new(get_turf(src))
	var/matrix/ARE = matrix()
	ARE.Scale(0.8, 0.8)
	ARE.Turn(rand(50,350))
	animate(S, time = 10, alpha = 0, pixel_x = px, pixel_y = py, transform = ARE, easing = SINE_EASING)

/obj/structure/maxim/attack_hand(mob/user)
	if(prob(1))
		to_chat(user, "<span class='info'>The trigger got stuck... try again!</span>")
		playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
		return
	fire(user)

/obj/structure/maxim/proc/update_indicator()
	if(!indicator || QDELETED(indicator))
		indicator = new(src)
	indicator.forceMove(get_turf(src))
	indicator.alpha = 255
	indicator.pixel_y = 10

	var/matrix/M = matrix()
	var/true_angle = fireangle + dir2angle(dir)

	M.Turn(true_angle)
	indicator.transform = M

/obj/structure/maxim/proc/start_indicator_timeout()
	var/current_scroll_time = last_scroll_time

	spawn(3 SECONDS)
		if(last_scroll_time == current_scroll_time)
			animate(indicator, 10, alpha = 0)
			sleep(10)
			qdel(indicator)

/obj/structure/maxim/MouseWheel(delta_x, delta_y, location, control, params)
	. = ..()
	var/mob/M = usr
	if(!M)
		return

	if(delta_y > 0)
		fireangle += 5
	else
		fireangle -= 5
	fireangle = clamp(fireangle, -45, 45)
	last_scroll_time = world.time

	update_indicator()
	start_indicator_timeout()

	to_chat(M, "<span class='info'>...[fireangle]...</span>")
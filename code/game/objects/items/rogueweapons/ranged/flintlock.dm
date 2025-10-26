/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock
	name = "barksteel"
	desc = "A firearm without a bayonet, typically used by marksmen."
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "longgun"
	item_state = "longgun"
	possible_item_intents = list(INTENT_GENERIC)
	gripped_intents = list(/datum/intent/shoot/musket/rifle, /datum/intent/shoot/musket/arc, /datum/intent/mace/smash/wood)
	wieldsound = 'sound/combat/musket_wield.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/shot/musk
	slot_flags = ITEM_SLOT_BACK
	experimental_onback = TRUE
	w_class = WEIGHT_CLASS_BULKY
	spread = 5
	max_integrity = 600 // having your gun broken while parrying sucks
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	walking_stick = TRUE
	var/cocked = FALSE
	var/rammed = FALSE
	var/bayonetable = FALSE
	var/has_bayonet = FALSE
	var/has_barkpowder = FALSE
	var/click_delay = 2
	var/obj/item/rogue/ramrod/rod
	bigboy = TRUE
	can_parry = TRUE
	droprot = TRUE
	pin = /obj/item/firing_pin
	force = 10
	cartridge_wording = "ball"
	recoil = 3
	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = list('sound/combat/Ranged/muskshot1.ogg','sound/combat/Ranged/muskshot2.ogg','sound/combat/Ranged/muskshot3.ogg', 'sound/combat/Ranged/muskshot4.ogg', 'sound/combat/Ranged/muskshot5.ogg', 'sound/combat/Ranged/muskshot6.ogg')
	fire_sound_volume = 500
	vary_fire_sound = TRUE
	drop_sound = 'sound/foley/gun_drop.ogg'
	dropshrink = 0.7
	associated_skill = /datum/skill/combat/flintlocks
	var/ramtime = 5.5

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = 0,"nx" = 8,"ny" = 0,"wx" = -5,"wy" = 1,"ex" = 0,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -90,"sturn" = 90,"wturn" = 90,"eturn" = -90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = 0,"wx" = -7,"wy" = -3,"ex" = 7,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 3,"sturn" = -3,"wturn" = 3,"eturn" = -3,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -5,"sy" = 2,"nx" = 5,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = -3,"ey" = 3,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 90,"eturn" = -90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/examine(mob/user)
	. = ..()
	. += "<span class='tutorial'>Use shift+middleclick to cock the weapon.</span>"
	. += "<span class='tutorial'>Use middleclick to remove or put back the ramrod.</span>"
	if(has_bayonet)
		. += "<span class='tutorial'>Use rightclick to remove the bayonet.</span>"

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/heart
	icon_state = "barotrauma1"
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, /datum/intent/mace/heavy/strike)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/grenz
	icon_state = "ironbarkmarksman"
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, /datum/intent/mace/heavy/strike)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/equipped(mob/living/user, slot)
	. = ..()
	playsound(loc, 'sound/foley/gun_equip.ogg', 100, TRUE)

/obj/item/rogue/ramrod
	name = "rod of ramming"
	desc = "Used to force ammunition down a barrel."
	drop_sound = 'sound/combat/ramrod_pickup.ogg' // lol
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "ramrod"
	force = 15
	possible_item_intents = list(/datum/intent/use,/datum/intent/mace/strike,/datum/intent/mace/smash)

/obj/item/rogue/barkpowderflask
	name = "powderflask"
	desc = "A leather pouch containing barkpowder."
	icon_state = "powderflask"
	slot_flags = ITEM_SLOT_NECK
	icon = 'icons/roguetown/items/misc.dmi'

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/Initialize()
	. = ..()
	var/obj/item/rogue/ramrod/rrod = new(src)
	rod = rrod

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/attackby(obj/item/A, mob/user, params)
	var/rt = ramtime
	var/tt
	tt = rt - (user.mind.get_skill_level(/datum/skill/combat/flintlocks) / 2.5)
	if(aspect_chosen(/datum/round_aspect/linefocus))
		tt += 3

	var/mob/living/carbon/human/U
	if(ishuman(user))
		U = user
		if(U.formation_check())
			tt -= 0.6

	if(tt < 0)
		tt = 0.1

	if(aspect_chosen(/datum/round_aspect/noreloading))
		tt = 0.1

	if(istype(A, /obj/item/rogue/ramrod))
		if(!user.is_holding(src))
			to_chat(user, "<span class='warning'>I need to hold \the [src] to ram it!</span>")
			return
		if(chambered)
			if(!rammed)
				playsound(src.loc, 'sound/combat/ramrod_working.ogg', 100, FALSE, -3)
				if(do_after(user, tt SECONDS, TRUE, src))
					to_chat(user, "<span class='info'>I ram \the [src].</span>")
					rammed = TRUE
	if(istype(A, /obj/item/rogue/barkpowderflask))
		if(!user.is_holding(src))
			to_chat(user, "<span class='warning'>I need to hold \the [src] to add barkpowder!</span>")
			return
		if(has_barkpowder == FALSE)
			playsound(src.loc, 'sound/foley/equip/rummaging-01.ogg', 100, FALSE, -3)
			if(do_after(user, tt SECONDS, TRUE, src))
				to_chat(user, "<span class='info'>I add barkpowder to \the [src].</span>")
				has_barkpowder = TRUE
	else if(istype(A, /obj/item/rogueweapon/huntingknife/bayonet))
		if(bayonetable == FALSE)
			to_chat(user, "<span class='warning'>I can't attach a bayonet to this weapon!</span>")
			return
		if(!user.is_holding(src))
			to_chat(user, "<span class='warning'>I need to hold \the [src] to attach a bayonet!</span>")
			return
		if(has_bayonet)
			to_chat(user, "<span class='warning'>A bayonet is already attached!</span>")
			return
		if(!do_after(user, 3 SECONDS, TRUE, src))
			return
		has_bayonet = TRUE
		gripped_intents += list(/datum/intent/dagger/thrust)
		icon_state = "[initial(icon_state)]_b"
		update_icon()
		qdel(A)
		to_chat(user, "<span class='info'>I attach a bayonet to \the [src].</span>")
		playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		return ..()
	else
		return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/MiddleClick(mob/user, params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(rod)
			H.put_in_hands(rod)
			rod = null
			to_chat(H, "<span class='info'>I remove the ramrod from \the [src].</span>")
			playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		else
			if(istype(H.get_active_held_item(), /obj/item/rogue/ramrod))
				var/obj/item/rogue/ramrod/rrod = H.get_active_held_item()
				rrod.forceMove(src)
				rod = rrod
				H.update_a_intents()
				to_chat(H, "<span class='info'>I put \the [rrod] into \the [src].</span>")
				playsound(src.loc, 'sound/combat/ramrod_pickup.ogg', 100, FALSE, -1)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo
	icon_state = "barotrauma"
	desc = "A firearm of Fogland design, provided to Heartfelt to fight the Grenzelhofts."
	bayonetable = TRUE
	spread = 0.5
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, /datum/intent/mace/smash/wood)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/bayo/grenz
	desc = "A weapon that is common in the ranks of the armies of Grenzelhoft, it gets the job done."
	icon_state = "ironbarker"
	bayonetable = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/dropped(mob/user)
	. = ..()
	if(wielded)
		ungrip(user)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/attack_right(mob/user)
	if(!user.is_holding(src))
		to_chat(user, "<span class='warning'>I need to hold \the [src] to do that!</span>")
		return
	if(has_bayonet)
		// wait 3 seconds to detach; abort if interrupted
		if(!do_after(user, 3 SECONDS, TRUE, src))
			return
		has_bayonet = FALSE
		gripped_intents -= list(/datum/intent/dagger/thrust)
		icon_state = initial(icon_state)
		update_icon()
		var/obj/item/rogueweapon/huntingknife/bayonet/B = new /obj/item/rogueweapon/huntingknife/bayonet()
		if(user.put_in_hands(B))
			to_chat(user, "<span class='info'>I detach the bayonet from \the [src] and hold it in my hand.</span>")
		else
			B.forceMove(get_turf(user))
			to_chat(user, "<span class='info'>I detach the bayonet from \the [src] but have no free hand, so it drops to the ground.</span>")
		playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		return

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/ShiftMiddleClick(mob/user)
	if(cocked == FALSE)
		playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
		to_chat(user, "<span class='info'>I cock \the [src].</span>")
		cocked = TRUE
		return

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol
	name = "barkiron"
	desc = "A type of barksteel made with cheaper materials, usually used by civilian militias or supplied to policing forces. It is rarely used by infrantrymen, but officer's regard it as more noble than a barksteel."
	icon = 'icons/roguetown/weapons/32.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "pistol"
	item_state = "pistol"
	bigboy = FALSE
	walking_stick = FALSE
	recoil = 2
	spread = 3
	click_delay = 2.4
	experimental_onback = TRUE
	gripsprite = FALSE
	possible_item_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, /datum/intent/mace/strike/wood)
	gripped_intents = null
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	ramtime = 3.4

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.3,"sx" = -7,"sy" = -6,"nx" = 7,"ny" = -6,"wx" = -3,"wy" = -6,"ex" = 3,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/axed // i axed you a question
	name = "barkaxe"
	desc = "An abomination devised by the bearded menace themselves. The name is being workshopped currently."
	icon = 'icons/roguetown/weapons/32.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "pistolaxe"
	item_state = "pistolaxe"
	walking_stick = FALSE
	possible_item_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, /datum/intent/axe/chop, /datum/intent/axe/cut)

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/attack_self(mob/living/user)
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/pistol/update_icon()
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/update_icon()
	//icon_state = "[initial(icon_state)][wielded]"
	item_state = "[initial(item_state)][wielded]"

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/attack_self(mob/living/user)
	if(!wielded)
		wield(user)
		update_icon()
	else
		ungrip(user)
		update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/shoot_with_empty_chamber(mob/living/user)
	if(!cocked)
		return
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	cocked = FALSE
	rammed = FALSE // just in case

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(user.client)
		if(has_barkpowder == FALSE)
			playsound(src.loc, 'sound/items/match_fail.ogg', 100, FALSE)
			to_chat(user, "<span class='info'>I dry fire \the [src]!</span>")
			cocked = FALSE
			return
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		if(user.client)
			if(user.client.chargedprog >= 100)
				BB.accuracy += 20 //better accuracy for fully aiming
				BB.bonus_accuracy += 2
			if(user.STAPER > 8)
				BB.accuracy += (user.STAPER - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
				BB.bonus_accuracy += (user.STAPER - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.
			if(user.lying)
				BB.bonus_accuracy += 5
			if(user.rogue_sneaking && !user.lying)
				BB.bonus_accuracy += 2
			if(has_bayonet == TRUE)
				BB.bonus_accuracy -=3
		BB.bonus_accuracy += (user.mind.get_skill_level(/datum/skill/combat/flintlocks) * 2)
	if(!cocked)
		return
	if(!rammed)
		return
	playsound(src.loc, 'sound/combat/Ranged/muskclick.ogg', 100, FALSE)
	cocked = FALSE
	rammed = FALSE
	has_barkpowder = FALSE
	sleep(click_delay)
	..()

/obj/item/gun/ballistic/revolver/grenadelauncher/flintlock/shoot_live_shot(mob/living/user, pointblank, mob/pbtarget, message)
	if(user.mind.get_skill_level(/datum/skill/combat/flintlocks) <= 0)
		to_chat(user, "<span class='danger'>I do not know how to use this.</span>")
		return
	..()
	var/angle
	switch(user.dir)
		if(NORTH) angle = 90
		if(SOUTH) angle = 270
		if(EAST)  angle = 0
		if(WEST)  angle = 180
	angle += rand(-25, 25)

	var/px = round(128 * cos(angle))
	var/py = round(128 * sin(angle))

	var/obj/effect/temp_visual/small_smoke/S = new(get_step(user.loc, user.dir))
	var/matrix/ARE = matrix()
	ARE.Scale(5, 5)
	ARE.Turn(rand(-350,350))
	animate(S, time = 50, alpha = 0, pixel_x = px, pixel_y = py, transform = ARE, easing = SINE_EASING)
	QDEL_IN(S, 50)
	SSticker.muskshots++

/obj/item/ammo_box/magazine/internal/shot/musk
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	caliber = "musketball"
	max_ammo = 1
	start_empty = TRUE
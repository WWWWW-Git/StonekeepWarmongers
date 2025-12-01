/mob/proc/add_stress(event)
	return TRUE

/mob/proc/remove_stress(event)
	return TRUE

/mob/proc/update_stress()
	return TRUE

/mob/proc/add_stress_list(list/event_list)
	return

/mob/proc/get_positive_stressors()
	return

/mob/proc/get_neutral_stressors()
	return

/mob/proc/get_negative_stressors()
	return

/mob/proc/get_stress_amount()
	return 0

/mob/proc/adjust_stress(amt)
	return TRUE

/mob/proc/has_stress_type(event)
	return

/mob/living/carbon
	var/stress = 0
	var/oldstress = 0
	var/stressbuffer = 0
	/// List of stressor instances
	var/list/stressors = list()
	COOLDOWN_DECLARE(stress_indicator)

/mob/living/carbon/adjust_stress(amt)
	stressbuffer = stressbuffer + amt
	stress = stress + stressbuffer
	stressbuffer = 0

	if(stress < STRESS_VGOOD)
		stressbuffer = stress - STRESS_VGOOD
		stress = STRESS_VGOOD

/mob/living/carbon/update_stress()
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		stress = 0
	for(var/datum/stressevent/event as anything in stressors)
		if(event.timer)
			if(world.time >= event.timer)
				remove_stress(event)

	if(stress != oldstress)
		switch(stress)
			if(STRESS_VGOOD)
				apply_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_VGOOD+1 to STRESS_BAD-1)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_BAD to STRESS_VBAD-1)
				apply_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_VBAD to STRESS_INSANE-1)
				apply_status_effect(/datum/status_effect/stress/stressvbad)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressinsane)
			if(STRESS_INSANE to INFINITY)
				apply_status_effect(/datum/status_effect/stress/stressinsane)
				remove_status_effect(/datum/status_effect/stress/stressvgood)
				remove_status_effect(/datum/status_effect/stress/stressbad)
				remove_status_effect(/datum/status_effect/stress/stressvbad)
		if(stress > oldstress)
			to_chat(src, "<span class='red'>⏃ Life sucks. ⏃</span>")
		else
			to_chat(src, "<span class='green'>⏀ A moment of peace. ⏀</span>") // in a war that never ends tonight today were all brothers we drink and unite now christmas has arrived and the snow turns the ground white

		if(hud_used?.stressies)
			hud_used.stressies.update_icon()

	oldstress = stress

	if(stress >= STRESS_INSANE)
		var/align = pick("center","left","right")
		var/vert = pick("bottom","middle","top")
		var/text_to_show = pick_list("stress_messages.json", "insanity")

		var/atom/movable/screen/area_text/T = new()
		client.screen += T
		T.maptext = {"<span style='vertical-align:[vert]; text-align:[align];
					color: "#ff0000"; font-size: 125%;
					font-family: "GenericTypewriter", Pterra;'>[text_to_show]</span>"}
		T.maptext_width = rand(200,250)
		T.maptext_height = rand(190,200)
		T.maptext_x = rand(12,40)
		T.maptext_y = rand(-120,-200)
		animate(T, alpha = 255, time = 2, easing = EASE_IN)
		addtimer(CALLBACK(src, PROC_REF(clear_area_text), T), rand(10,15))

/mob/living/carbon/get_stress_amount()
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return 0
	return stress

/mob/living/carbon/has_stress_type(event_type)
	return locate(event_type) in stressors

/mob/living/carbon/get_positive_stressors()
	. = list()
	for(var/datum/stressevent/event as anything in stressors)
		if(event.get_stress(src) < 0)
			. += event

/mob/living/carbon/get_neutral_stressors()
	. = list()
	for(var/datum/stressevent/event as anything in stressors)
		if(event.get_stress(src) == 0)
			. += event

/mob/living/carbon/get_negative_stressors()
	. = list()
	for(var/datum/stressevent/event as anything in stressors)
		if(event.get_stress(src) < 0)
			. += event

/mob/living/carbon/add_stress(event_type)
	if(HAS_TRAIT(src, TRAIT_NOMOOD))
		return FALSE
	var/datum/stressevent/new_event = new event_type()
	if(!new_event.can_apply(src))
		return FALSE

	. = TRUE
	var/datum/stressevent/existing_event = has_stress_type(event_type)
	if(existing_event)
		existing_event.timer = initial(existing_event.timer) + world.time // RESET THE TIMER
		if(existing_event.stacks >= existing_event.max_stacks)
			return
		var/pre_stack = existing_event.get_stress()
		existing_event.stacks++
		var/post_stack = existing_event.get_stress()
		adjust_stress(post_stack-pre_stack)
		existing_event.on_apply(src)
	else
		new_event.timer += world.time
		stressors += new_event
		adjust_stress(new_event.get_stress())
		new_event.on_apply(src)
	SEND_SIGNAL(src, COMSIG_MOB_ADD_STRESS, new_event)

/// Accepts stress typepaths or a list of stress typepaths to remove.
/mob/living/carbon/remove_stress(event_to_remove)
	// if(HAS_TRAIT(src, TRAIT_NOMOOD))
	// 	return FALSE
	var/list/events_to_remove = islist(event_to_remove) ? event_to_remove : list(event_to_remove)
	for(var/stress_type in events_to_remove)
		var/datum/stressevent/stressevent = has_stress_type(stress_type)
		if(stressevent)
			adjust_stress(-1 * stressevent.get_stress())
			stressors -= stressevent
			qdel(stressevent)

/mob/living/carbon/add_stress_list(list/event_list)
	for(var/event_type in event_list)
		add_stress(event_type)
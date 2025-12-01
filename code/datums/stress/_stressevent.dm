/datum/stressevent
	/// Description shown to the player
	var/desc
	/// Integer value for stress change
	var/stressadd = 0
	/// How long should this last
	var/timer = 0
	/// Stacks of this event
	var/stacks = 0
	/// Max stacks of this event
	var/max_stacks = 1
	/// Amount of stress each extra stack adds
	var/stress_change_per_extra_stack = 0
	/// If this event is always hidden from checks
	var/hidden = FALSE
	///this is how much we affect quality in the end
	var/quality_modifier = 0

/datum/stressevent/proc/can_apply(mob/living/user)
	return TRUE

/datum/stressevent/proc/on_apply(mob/living/user)
	return TRUE

/datum/stressevent/proc/on_remove(mob/living/user)
	return TRUE

/datum/stressevent/proc/can_show(mob/living/user)
	return !hidden

/datum/stressevent/proc/get_desc(mob/living/user)
	return desc

/datum/stressevent/proc/get_stress(mob/living/user)
	return stressadd + ((stacks - 1) * stress_change_per_extra_stack)

/datum/stressevent/test
	timer = 5 SECONDS
	stressadd = 3
	desc = "<span class='red'>This is a positive test event.</span>"

/datum/stressevent/testr
	timer = 5 SECONDS
	stressadd = -3
	desc = "<span class='green'>This is a negative test event.</span>"
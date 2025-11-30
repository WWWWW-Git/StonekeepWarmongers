/datum/wound/tendon
	name = "severed tendon"
	check_name = "<span class='artery'><B>TENDON</B></span>"
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = "A tendon is slit in %VICTIM's %BODYPART!"
	sound_effect = 'sound/combat/crit.ogg'
	whp = 25
	sewn_whp = 10
	bleed_rate = 3
	sewn_bleed_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 65
	sewn_woundpain = 20
	mob_overlay = "s1"
	sewn_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	disabling = TRUE

/datum/wound/tendon/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/tendon) && (type == other.type))
		return FALSE
	return TRUE
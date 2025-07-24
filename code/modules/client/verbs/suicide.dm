/mob/var/suiciding = 0

/mob/proc/set_suicide(suicide_state)
	suiciding = suicide_state
	if(suicide_state)
		GLOB.suicided_mob_list += src
	else
		GLOB.suicided_mob_list -= src

/mob/living/carbon/set_suicide(suicide_state) //you thought that box trick was pretty clever, didn't you? well now hardmode is on, boyo.
	. = ..()
	var/obj/item/organ/brain/B = getorganslot(ORGAN_SLOT_BRAIN)
	if(B)
		B.suicided = suicide_state

/mob/living/silicon/robot/set_suicide(suicide_state)
	. = ..()
	if(mmi)
		if(mmi.brain)
			mmi.brain.suicided = suicide_state
		if(mmi.brainmob)
			mmi.brainmob.suiciding = suicide_state

/mob/living/carbon/human/verb/suicide()
	set name = "Suicide"
	set category = "Emotes"
	var/usure = alert(src, "You sure?", "WARMONGERS", "Yes", "No")
	if(usure == "Yes")
		var/areusure = alert(src, "Are you sure?", "STUPID REFERENCE MONGERS", "Pretty sure", "Threw a trashbag", "Into space")
		if(areusure == "Pretty sure")
			say("IT JUST AINT WORTH IT!")
			spawn(20)
				gib(TRUE)

/mob/living/brain/verb/suicide()
	set hidden = 1
	if(!usr.client.holder)
		return
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message("<span class='danger'>[src]'s brain is growing dull and lifeless. [p_they(TRUE)] look[p_s()] like [p_theyve()] lost the will to live.</span>", \
						"<span class='danger'>[src]'s brain is growing dull and lifeless. [p_they(TRUE)] look[p_s()] like [p_theyve()] lost the will to live.</span>")

		suicide_log()

		death(FALSE)

/mob/living/carbon/monkey/verb/suicide()
	set hidden = 1
	if(!usr.client.holder)
		return
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message("<span class='danger'>[src] is attempting to bite [p_their()] tongue. It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='danger'>[src] is attempting to bite [p_their()] tongue. It looks like [p_theyre()] trying to commit suicide.</span>")

		suicide_log()

		adjustOxyLoss(max(200- getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)

/mob/living/silicon/ai/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message("<span class='danger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='danger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>")

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)

/mob/living/silicon/robot/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message("<span class='danger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='danger'>[src] is powering down. It looks like [p_theyre()] trying to commit suicide.</span>")

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(maxHealth * 2 - getToxLoss() - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)

/mob/living/silicon/pai/verb/suicide()
	set hidden = 1
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(confirm == "Yes")
		var/turf/T = get_turf(src.loc)
		T.visible_message("<span class='notice'>[src] flashes a message across its screen, \"Wiping core files. Please acquire a new personality to continue using pAI device functions.\"</span>", null, \
		 "<span class='notice'>[src] bleeps electronically.</span>")

		suicide_log()

		death(FALSE)
	else
		to_chat(src, "Aborting suicide attempt.")

/mob/living/carbon/alien/humanoid/verb/suicide()
	set hidden = 1
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message("<span class='danger'>[src] is thrashing wildly! It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='danger'>[src] is thrashing wildly! It looks like [p_theyre()] trying to commit suicide.</span>", \
				"<span class='hear'>I hear thrashing.</span>")

		suicide_log()

		//put em at -175
		adjustOxyLoss(max(200 - getFireLoss() - getBruteLoss() - getOxyLoss(), 0))
		death(FALSE)

/mob/living/simple_animal/verb/suicide()
	set hidden = 1
	if(!usr.client.holder)
		return
	if(!canSuicide())
		return
	var/confirm = alert("Are you sure you want to commit suicide?", "Confirm Suicide", "Yes", "No")
	if(!canSuicide())
		return
	if(confirm == "Yes")
		set_suicide(TRUE)
		visible_message("<span class='danger'>[src] begins to fall down. It looks like [p_theyve()] lost the will to live.</span>", \
						"<span class='danger'>[src] begins to fall down. It looks like [p_theyve()] lost the will to live.</span>")

		suicide_log()

		death(FALSE)

/mob/living/proc/suicide_log()
	log_message("committed suicide as [src.type]", LOG_ATTACK)

/mob/living/carbon/human/suicide_log()
	log_message("(job: [src.job ? "[src.job]" : "None"]) committed suicide", LOG_ATTACK)

/mob/living/proc/canSuicide()
	switch(stat)
		if(CONSCIOUS)
			return TRUE
		if(SOFT_CRIT)
			to_chat(src, "<span class='warning'>I can't commit suicide while in a critical condition!</span>")
		if(UNCONSCIOUS)
			to_chat(src, "<span class='warning'>I need to be conscious to commit suicide!</span>")
		if(DEAD)
			to_chat(src, "<span class='warning'>You're already dead!</span>")
	return

/mob/living/carbon/canSuicide()
	if(!..())
		return
	if(!(mobility_flags & MOBILITY_USE))	//just while I finish up the new 'fun' suiciding verb. This is to prevent metagaming via suicide
		to_chat(src, "<span class='warning'>I can't commit suicide whilst immobile! ((You can type Ghost instead however.))</span>")
		return
	return TRUE

/obj/effect/proc_holder/spell/targeted/inspire
	name = "Inspire"
	overlay_state = "bcry"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/inspire_02.ogg'
	invocation = "FIGHT WITH ALL YOU GOT!"
	invocation_type = "shout"
	associated_skill = /datum/skill/misc/leadership
	antimagic_allowed = TRUE
	charge_max = 25 SECONDS
	max_targets = 0
	cast_without_targets = TRUE

/obj/effect/proc_holder/spell/targeted/inspire/cast(list/targets, mob/living/user)
	for(var/mob/living/carbon/human/H in targets)
		var/isenemy = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/U = user
			if(U.warfare_faction != H.warfare_faction || H.stat == DEAD)
				isenemy = TRUE
			if(!isenemy)
				if( 4 < user.mind.get_skill_level(/datum/skill/misc/leadership))
					invocation = "FIGHT WITH ALL YOU GOT!"
					H.apply_status_effect(/datum/status_effect/buff/inspired/great) //yes, you can stack inspirations from different levels of leadership
					if(aspect_chosen(/datum/round_aspect/halo))
						sound = 'sound/vo/halo/hail2theking.mp3'
				else
					invocation = "CHARGE!"
					H.apply_status_effect(/datum/status_effect/buff/inspired)
				H.visible_message("<span class='info'>[H] looks more eager to fight!</span>", "<span class='notice'>I feel inspired to fight!</span>")
	..()
	return TRUE

/obj/effect/proc_holder/spell/targeted/blind
	name = "Charge with The Light"
	overlay_state = "blindness"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/whiteflame.ogg'
	invocation = "I INVOKE THE LIGHT BRIGADE!"
	invocation_type = "shout"
	antimagic_allowed = TRUE
	charge_max = 25 SECONDS
	max_targets = 0
	cast_without_targets = TRUE

/obj/effect/proc_holder/spell/targeted/blind/cast(list/targets, mob/living/user)
	user.overlay_fullscreen("graghorror", /atom/movable/screen/fullscreen/graghorror)
	user.clear_fullscreen("graghorror", 5 SECONDS)
	user.playsound_local(user, 'sound/misc/XSCREAM.ogg', 75, FALSE)
	for(var/mob/living/carbon/human/H in targets)
		var/isenemy = TRUE
		if(ishuman(user))
			var/mob/living/carbon/human/U = user
			if(U.warfare_faction == H.warfare_faction || H.stat == DEAD)
				isenemy = FALSE
			if(isenemy)
				H.overlay_fullscreen("graghorror", /atom/movable/screen/fullscreen/graghorror)
				H.clear_fullscreen("graghorror", 5 SECONDS)
				H.playsound_local(H, 'sound/misc/XSCREAM.ogg', 75, FALSE)
	..()
	return TRUE
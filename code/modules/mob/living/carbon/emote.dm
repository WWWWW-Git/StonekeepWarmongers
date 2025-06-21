/datum/emote/living/carbon
	mob_type_allowed_typecache = list(/mob/living/carbon)

/datum/emote/living/carbon/deathgurgle
	key = "deathgurgle"
	key_third_person = ""
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	vary = TRUE
	message = "gasps out their last breath."
	message_simple =  "falls limp."
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/airguitar
	key = "airguitar"
	message = "strums an invisible lute."
	restraint_check = TRUE

/datum/emote/living/carbon/blink
	key = "blink"
	key_third_person = "blinks"
	message = "blinks."

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	message = "blinks rapidly."

/datum/emote/living/carbon/clap
	key = "clap"
	key_third_person = "claps"
	message = "claps."
	muzzle_ignore = TRUE
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE
	vary = TRUE

/datum/emote/living/carbon/clap/get_sound(mob/living/user)
	if(ishuman(user))
		if(!user.get_bodypart(BODY_ZONE_L_ARM) || !user.get_bodypart(BODY_ZONE_R_ARM))
			return
		else
			return "clap"

/datum/emote/living/carbon/warcry
	key = "warcry"
	key_third_person = ""
	message = "shouts a war cry!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/warcry/run_emote(mob/user, params, type_override, intentional, targetted)
    . = ..()
    var/warcry = "WAR!!!"
    var/sound2play
    if(ishuman(user))
        var/mob/living/carbon/human/H = user
        switch(H.warfare_faction)
            if(RED_WARTEAM)
                warcry = "For honor! For Heartfelt!"
                if(HAS_TRAIT(user, TRAIT_NOBLE))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_lord1.ogg','sound/vo/wc/felt/female/f_heart_lord2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_lord1.ogg','sound/vo/wc/felt/heart_lord2.ogg'))
                else if(HAS_TRAIT(user, TRAIT_RANK_AND_FILE))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_musk1.ogg','sound/vo/wc/felt/female/f_heart_musk2.ogg','sound/vo/wc/felt/female/f_heart_musk3.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_musk1.ogg','sound/vo/wc/felt/heart_musk2.ogg','sound/vo/wc/felt/heart_musk3.ogg','sound/vo/wc/felt/heart_musk_rare.ogg'))
                else if(HAS_TRAIT(user, TRAIT_BUSHIDO_CODE))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_zam1.ogg','sound/vo/wc/felt/female/f_heart_zam2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_zam1.ogg','sound/vo/wc/felt/heart_zam2.ogg'))
                else if(HAS_TRAIT(user, TRAIT_SAPPER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_sapper1.ogg','sound/vo/wc/felt/female/f_heart_sapper2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_sapper1.ogg','sound/vo/wc/felt/heart_sapper2.ogg','sound/vo/wc/felt/heart_sapper3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_FIRELANCER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_firelance1.ogg','sound/vo/wc/felt/female/f_heart_firelance2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_firelance1.ogg','sound/vo/wc/felt/heart_firelance2.ogg','sound/vo/wc/felt/heart_firelance3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_NINJA))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_ninja1.ogg','sound/vo/wc/felt/female/f_heart_ninja2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_ninja1.ogg','sound/vo/wc/felt/heart_ninja2.ogg','sound/vo/wc/felt/heart_ninja3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_SNIPER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_sharpbarker1.ogg','sound/vo/wc/felt/female/f_heart_sharpbarker2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_sharpbarker1.ogg','sound/vo/wc/felt/heart_sharpbarker2.ogg','sound/vo/wc/felt/heart_sharpbarker3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_OFFICER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_officer1.ogg','sound/vo/wc/felt/female/f_heart_officer2.ogg','sound/vo/wc/felt/female/f_heart_officer3.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_officer1.ogg','sound/vo/wc/felt/heart_officer2.ogg','sound/vo/wc/felt/heart_officer3.ogg','sound/vo/wc/felt/heart_officer_rare.ogg'))
                else if(HAS_TRAIT(user, TRAIT_MEDIC))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_medic1.ogg','sound/vo/wc/felt/female/f_heart_medic2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_medic1.ogg','sound/vo/wc/felt/heart_medic2.ogg','sound/vo/wc/felt/heart_medic3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_SLAVE))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/felt/female/f_heart_slave1.ogg','sound/vo/wc/felt/female/f_heart_slave2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/felt/heart_slave1.ogg','sound/vo/wc/felt/heart_slave2.ogg','sound/vo/wc/felt/heart_slave3.ogg'))
            if(BLUE_WARTEAM)
                warcry = "Glory in the stars!"
                if(HAS_TRAIT(user, TRAIT_NOBLE))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_lord1.ogg','sound/vo/wc/gren/female/f_grenz_lord2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_lord1.ogg','sound/vo/wc/gren/grenz_lord2.ogg'))
                else if(HAS_TRAIT(user, TRAIT_RANK_AND_FILE))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_musk1.ogg','sound/vo/wc/gren/female/f_grenz_musk2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_musk1.ogg','sound/vo/wc/gren/grenz_musk2.ogg','sound/vo/wc/gren/grenz_musk3.ogg','sound/vo/wc/gren/grenz_musk_rare.ogg'))
                else if(HAS_TRAIT(user, TRAIT_ZWEIHANDER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_zwei1.ogg','sound/vo/wc/gren/female/f_grenz_zwei2.ogg','sound/vo/wc/gren/female/f_grenz_zwei3.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/zwei1.ogg','sound/vo/wc/gren/zwei2.ogg','sound/vo/wc/gren/zwei3.ogg','sound/vo/wc/gren/zwei4.ogg','sound/vo/wc/gren/zwei_rare.ogg'))
                else if(HAS_TRAIT(user, TRAIT_HUSSAR))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_hussar1.ogg','sound/vo/wc/gren/female/f_grenz_hussar2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_hussar1.ogg','sound/vo/wc/gren/grenz_hussar2.ogg','sound/vo/wc/gren/grenz_hussar3.ogg','sound/vo/wc/gren/grenz_hussar_rare.ogg'))
                else if(HAS_TRAIT(user, TRAIT_GRENADIER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_grenadier1.ogg','sound/vo/wc/gren/female/f_grenz_grenadier2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_grenadier1.ogg','sound/vo/wc/gren/grenz_grenadier2.ogg','sound/vo/wc/gren/grenz_grenadier3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_JESTER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_jester1.ogg','sound/vo/wc/gren/female/f_grenz_jester2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_jester1.ogg','sound/vo/wc/gren/grenz_jester2.ogg','sound/vo/wc/gren/grenz_jester3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_SNIPER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_sharpbarker1.ogg','sound/vo/wc/gren/female/f_grenz_sharpbarker2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_sharpbarker1.ogg','sound/vo/wc/gren/grenz_sharpbarker2.ogg','sound/vo/wc/gren/grenz_sharpbarker3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_OFFICER))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_officer1.ogg','sound/vo/wc/gren/female/f_grenz_officer2.ogg','sound/vo/wc/gren/female/f_grenz_officer3.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_officer1.ogg','sound/vo/wc/gren/grenz_officer2.ogg','sound/vo/wc/gren/grenz_officer3.ogg','sound/vo/wc/gren/grenz_officer_rare.ogg'))
                else if(HAS_TRAIT(user, TRAIT_MEDIC))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_medic1.ogg','sound/vo/wc/gren/female/f_grenz_medic2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_medic1.ogg','sound/vo/wc/gren/grenz_medic2.ogg','sound/vo/wc/gren/grenz_medic3.ogg'))
                else if(HAS_TRAIT(user, TRAIT_SLAVE))
                    if(H.gender == FEMALE)
                        sound2play = sound(pick('sound/vo/wc/gren/female/f_grenz_slave1.ogg','sound/vo/wc/gren/female/f_grenz_slave2.ogg'))
                    else
                        sound2play = sound(pick('sound/vo/wc/gren/grenz_slave1.ogg','sound/vo/wc/gren/grenz_slave2.ogg','sound/vo/wc/gren/grenz_slave3.ogg'))
        if(aspect_chosen(/datum/round_aspect/explodeatwill))
            user.say(warcry)
            spawn(2 SECONDS)
                var/obj/item/bomb/B = new(get_turf(user))
                B.light()
                B.explode(TRUE)
                user.gib()
        if(sound2play)
            playsound(user, sound2play, 60, TRUE, -2, ignore_walls = FALSE)
        else
            to_chat(user, "<span class='warning'>Nothing to warcry about yet!</span>")
        user.shoutbubble()
        ping_sound(user)
    
/mob/proc/shoutbubble()
    var/image/I = image('icons/mob/talk.dmi', src, "default2", FLY_LAYER)
    I.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

    var/list/listening = view(6,src)
    var/list/speech_bubble_recipients = list()
    for(var/mob/M in listening)
        speech_bubble_recipients.Add(M.client)

    INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay), I, speech_bubble_recipients, 30)

/mob/living/carbon/human/verb/emote_warcry()
	set name = "WARCRY"
	set category = "Noises"
	emote("warcry", intentional = TRUE)

/mob/living/carbon/human/verb/emote_warcry_f1()
	set name = ".warcry"
	emote_warcry()

/datum/emote/living/carbon/gnarl
	key = "gnarl"
	key_third_person = "gnarls"
	message = "gnarls and shows its teeth..."
	mob_type_allowed_typecache = list(/mob/living/carbon/monkey)

/datum/emote/living/carbon/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."
	mob_type_allowed_typecache = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)
	restraint_check = TRUE

/datum/emote/living/carbon/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."
	mob_type_allowed_typecache = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)
	restraint_check = TRUE

/datum/emote/living/carbon/screech
	key = "screech"
	key_third_person = "screeches"
	message = "screeches."
	mob_type_allowed_typecache = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)

/datum/emote/living/carbon/sign
	key = "sign"
	key_third_person = "signs"
	message_param = "signs the number %t."
	mob_type_allowed_typecache = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)
	restraint_check = TRUE

/datum/emote/living/carbon/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/sign/signal
	key = "signal"
	key_third_person = "signals"
	message_param = "raises %t fingers."
	mob_type_allowed_typecache = list(/mob/living/carbon/human)
	restraint_check = TRUE

/datum/emote/living/carbon/tail
	key = "tail"
	message = "waves their tail."
	mob_type_allowed_typecache = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)

/datum/emote/living/carbon/wink
	key = "wink"
	key_third_person = "winks"
	message = "winks."

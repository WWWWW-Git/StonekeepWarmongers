#define MAX_VOICE_CHARACTERS 40
#define VOICE_DURATION 0.8

/mob/living/carbon/human/proc/send_voice(message, skip_thingy)
	if(!message || !length(message))
		return
	if(dna.species)
		dna.species.send_voice(src, message)

/datum/species/var/last_voice_time = 0

/datum/species/proc/send_voice(mob/living/carbon/human/H, message)
	if(!message || !length(message))
		return

	var/base_sound
	if(istype(H.wear_mask, /obj/item/clothing/mask/gas)) //i have plans that i cannot share with you right now because john will try to sabotage me
		base_sound = list('sound/blank.ogg', 'sound/blank.ogg', 'sound/blank.ogg')
	else
		switch(H.job)
			if("Fat Official")
				if(H.gender == MALE)
					base_sound = list('sound/vo/wc/ppulordspeech1.ogg', 'sound/vo/wc/ppulordspeech2.ogg')
				else if(H.gender == FEMALE)
					base_sound = list('sound/vo/wc/ppulordspeech1f.ogg', 'sound/vo/wc/ppulordspeech2f.ogg')
			if("Peasantry Militian")
				if(H.gender == MALE)
					base_sound = list('sound/vo/wc/ppuspeech1.ogg', 'sound/vo/wc/ppuspeech2.ogg', 'sound/vo/wc/ppuspeech3.ogg')
				else if(H.gender == FEMALE)
					base_sound = list('sound/vo/wc/ppuspeech1f.ogg', 'sound/vo/wc/ppuspeech2f.ogg', 'sound/vo/wc/ppuspeech3f.ogg')
			if("Regimian Low-Lord")
				if(H.gender == MALE)
					base_sound = list('sound/vo/wc/regimelordspeech1.ogg', 'sound/vo/wc/regimelordspeech2.ogg')
				else if(H.gender == FEMALE)
					base_sound = list('sound/vo/wc/regimelordspeech1f.ogg', 'sound/vo/wc/regimelordspeech2f.ogg')
			if("Regimian Regiman")
				if(H.gender == MALE)
					base_sound = list('sound/vo/wc/regimespeech1.ogg', 'sound/vo/wc/regimespeech2.ogg', 'sound/vo/wc/regimespeech3.ogg')
				else if(H.gender == FEMALE)
					base_sound = list('sound/vo/wc/regimespeech1f.ogg', 'sound/vo/wc/regimespeech2f.ogg', 'sound/vo/wc/regimespeech3f.ogg')

	var/initial_voice_time = world.time
	last_voice_time = initial_voice_time
	var/base_pitch_rand = rand(-3, 3)

	var/cumulative_delay = 0
	for(var/i in 1 to min(length(message), MAX_VOICE_CHARACTERS))
		var/char = lowertext(message[i])
		var/pitch = base_pitch_rand
		var/volume = 100
		var/current_delay = VOICE_DURATION

		switch(char)
			// Punctuation
			if("!")
				pitch += 16
			if("?")
				pitch += 20
			if(",", ";", "-")
				pitch -= 2
				current_delay *= 1.5
			if(".", "…")
				pitch -= 4
				current_delay *= 2
			if(" ")
				volume = 0
			// Latin letters
			if("a")
				pitch += 12
			if("b")
				pitch += 11
			if("c")
				pitch += 10
			if("d")
				pitch += 9
			if("e")
				pitch += 8
			if("f")
				pitch += 7
			if("g")
				pitch += 6
			if("h")
				pitch += 5
			if("i")
				pitch += 4
			if("j")
				pitch += 3
			if("k")
				pitch += 2
			if("l")
				pitch += 1
			if("m")
				pitch += 0
			if("n")
				pitch -= 1
			if("o")
				pitch -= 2
			if("p")
				pitch -= 3
			if("q")
				pitch -= 4
			if("r")
				pitch -= 5
			if("s")
				pitch -= 6
			if("t")
				pitch -= 7
			if("u")
				pitch -= 8
			if("v")
				pitch -= 9
			if("w")
				pitch -= 10
			if("x")
				pitch -= 11
			if("y")
				pitch -= 12
			if("z")
				pitch -= 13
			// Cyrillic letters
			if("а")
				pitch += 12
			if("б")
				pitch += 11
			if("в")
				pitch -= 9
			if("г")
				pitch += 6
			if("д")
				pitch += 9
			if("е", "ё")
				pitch += 8
			if("ж")
				pitch += 3
			if("з")
				pitch -= 13
			if("и", "і")
				pitch += 4
			if("й")
				pitch += 3
			if("к")
				pitch += 2
			if("л")
				pitch += 1
			if("м")
				pitch += 0
			if("н")
				pitch -= 1
			if("о")
				pitch -= 2
			if("п")
				pitch -= 3
			if("р")
				pitch -= 5
			if("с")
				pitch -= 6
			if("т")
				pitch -= 7
			if("у")
				pitch -= 8
			if("ф")
				pitch += 7
			if("х")
				pitch += 5
			if("ц")
				pitch += 10
			if("ч")
				pitch += 6
			if("ш", "щ")
				pitch -= 4
			if("ъ", "ь")
				pitch += 1
				volume = 50
			if("ы")
				pitch -= 12
			if("э")
				pitch += 7
			if("ю")
				pitch -= 6
			if("я")
				pitch += 10
			if("ї")
				pitch += 5
			if("є")
				pitch += 9
			else
				pitch += rand(-2, 2)

		// Add slight random variation to each character
		pitch += rand(-2, 2)
		// Clamp pitch to reasonable values
		pitch = clamp(pitch, -15, 20)

		// Convert pitch to frequency (1.0 = normal, range ~0.75-1.4)
		var/frequency = 1.0 + (pitch * 0.02)

		addtimer(CALLBACK(src, PROC_REF(play_voice_sound), H, base_sound, volume, frequency, initial_voice_time), cumulative_delay)
		cumulative_delay += current_delay

/datum/species/proc/play_voice_sound(mob/living/carbon/human/H, list/sounds, volume, frequency, initial_voice_time)
	if(!volume || (last_voice_time != initial_voice_time) || QDELETED(H))
		return
	playsound(get_turf(H), pick(sounds), volume, FALSE, -1, frequency = frequency)

#undef MAX_VOICE_CHARACTERS
#undef VOICE_DURATION

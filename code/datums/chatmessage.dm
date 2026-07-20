#define CHAT_MESSAGE_SPAWN_TIME		1
#define CHAT_MESSAGE_LIFESPAN		5 SECONDS
#define CHAT_MESSAGE_EOL_FADE		0.3 SECONDS
#define CHAT_MESSAGE_EXP_DECAY		0.7
#define CHAT_MESSAGE_HEIGHT_DECAY	0.9
#define CHAT_MESSAGE_APPROX_LHEIGHT	11
#define CHAT_MESSAGE_WIDTH			96
#define CHAT_MESSAGE_MAX_LENGTH		110

// Emote animation settings
#define CHAT_EMOTE_FADE_IN_TIME		0.8 SECONDS
#define CHAT_EMOTE_FLOAT_DISTANCE	8
#define CHAT_EMOTE_FADEOUT_FLOAT	4

#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext_char(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);

#define LAZYREMOVEASSOC(L, K, V) if(L) { if(L[K]) { L[K] -= V; if(!length(L[K])) L -= K; } if(!length(L)) L = null; }
#define LAZYADDASSOC(L, K, V) if(!L) { L = list(); } L[K] += list(V);

/**
 * # Chat Message Overlay
 *
 * Datum for generating a message overlay on the map
 */
/datum/chatmessage
	/// The visual element of the chat messsage
	var/image/message
	/// The location in which the message is appearing
	var/atom/message_loc
	/// The client who heard this message
	var/client/owned_by
	/// Contains the scheduled destruction time
	var/scheduled_destruction
	/// Contains the approximate amount of lines for height decay
	var/approx_lines
	/// Whether this is an emote message
	var/is_emote = FALSE

/datum/chatmessage/New(text, atom/target, mob/owner, list/extra_classes = null, lifespan = CHAT_MESSAGE_LIFESPAN)
	. = ..()
	if (!istype(target))
		CRASH("Invalid target given for chatmessage")
	if(QDELETED(owner) || !istype(owner) || !owner.client)
		stack_trace("/datum/chatmessage created with [isnull(owner) ? "null" : "invalid"] mob owner")
		qdel(src)
		return
	INVOKE_ASYNC(src, PROC_REF(generate_image), text, target, owner, extra_classes, lifespan)

/datum/chatmessage/Destroy()
	if (owned_by)
		if (owned_by.seen_messages)
			LAZYREMOVEASSOC(owned_by.seen_messages, message_loc, src)
		owned_by.images.Remove(message)
	owned_by = null
	message_loc = null
	message = null
	return ..()

/datum/chatmessage/proc/generate_image(text, atom/target, mob/owner, list/extra_classes, lifespan)
	// Register client who owns this message
	owned_by = owner.client
	RegisterSignal(owned_by, COMSIG_PARENT_QDELETING, PROC_REF(qdel), src)

	// Clip message
	var/maxlen = owned_by.prefs.max_chat_length
	if (length_char(text) > maxlen)
		text = copytext_char(text, 1, maxlen + 1) + "..."

	// Calculate target color if not already present
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.voice_color && (target.chat_color != H.voice_color))
			target.chat_color = "#[H.voice_color]"
			target.chat_color_darkened = target.chat_color
			target.chat_color_name = target.name
	if(!target.chat_color)
		target.chat_color = colorize_string(target.name)
		target.chat_color_darkened = colorize_string(target.name, 0.85, 0.85)
		target.chat_color_name = target.name
	if(target.voicecolor_override)
		target.chat_color = "#[target.voicecolor_override]"
		target.chat_color_darkened = target.chat_color

	// Get rid of any URL schemes
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	text = replacetext(text, url_scheme, "")

	// Reject whitespace
	var/static/regex/whitespace = new(@"^\s*$")
	if (whitespace.Find(text))
		qdel(src)
		return

	// Non mobs speakers can be small
	if (!ismob(target))
		extra_classes |= "small"

	var/emote = extra_classes?.Find("emote")
	var/virtual_speaker = extra_classes?.Find("virtual-speaker")
	var/italics = extra_classes?.Find("italics")

	// Append radio icon if from a virtual speaker
	if (virtual_speaker)
		var/image/r_icon = image('icons/UI_Icons/chat/chat_icons.dmi', icon_state = "radio")
		text = "\icon[r_icon]&nbsp;" + text
	else if (emote)
		var/image/r_icon = image('icons/ui_icons/chat/chat_icons.dmi', icon_state = "emote")
		text = "\icon[r_icon]&nbsp;" + text

	// We dim italicized text
	var/tgt_color = italics ? target.chat_color_darkened : target.chat_color

	var/font_size = emote ? 9 : 10
	if(emote)
		tgt_color = "#c8d148"

	// Construct text
	var/class_list = extra_classes ? extra_classes.Join(" ") : ""
	var/complete_text = {"<span style='font-size:[font_size]pt;font-family:"Pterra";color:[tgt_color];text-shadow:0 0 5px #000,0 0 5px #000,0 0 5px #000,0 0 5px #000;' class='center maptext [class_list]'>[text]</span>"}

	var/mheight
	WXH_TO_HEIGHT(owned_by.MeasureText(complete_text, null, CHAT_MESSAGE_WIDTH), mheight)
	if(!VERB_SHOULD_YIELD)
		return finish_image_generation(mheight, target, owner, complete_text, lifespan, text, extra_classes, emote)
	var/datum/callback/our_callback = CALLBACK(src, PROC_REF(finish_image_generation), mheight, target, owner, complete_text, lifespan, text, extra_classes, emote)
	SSrunechat.message_queue += our_callback

/datum/chatmessage/proc/finish_image_generation(mheight, atom/target, mob/owner, complete_text, lifespan, text_inner, list/extra_classes, emote = FALSE)
	if(!owned_by || QDELETED(owned_by))
		return qdel(src)
	if(!target || QDELETED(target))
		return qdel(src)
	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)
	message_loc = target

	// Remove existing messages on this target
	if (owned_by.seen_messages)
		for(var/msg in owned_by.seen_messages[message_loc])
			var/datum/chatmessage/m = msg
			qdel(m)

	// Check if this is an emote
	is_emote = emote ? TRUE : FALSE

	// Build message image
	message = image(loc = message_loc, layer = ABOVE_HUD_LAYER)
	message.plane = ABOVE_HUD_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.pixel_y = owner.bound_height * 0.95
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight
	message.maptext_x = (CHAT_MESSAGE_WIDTH - owner.bound_width) * -0.5

	// Extract prefix and suffix for maptext manipulation
	var/open_idx = findtextEx(complete_text, ">")
	var/close_idx = findtextEx(complete_text, "</span>", open_idx + 1)
	var/prefix = (open_idx ? copytext(complete_text, 1, open_idx + 1) : "")
	var/suffix = (close_idx ? copytext(complete_text, close_idx) : "")

	if(is_emote)
		// For emotes: show full text immediately
		message.maptext = complete_text
	else
		// For speech: start with empty content for typewriter effect
		message.maptext = prefix + suffix

	// View the message
	LAZYADDASSOC(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message

	if(is_emote)
		// For emotes: floating fade animation - start IMMEDIATELY after adding to images
		var/start_y = message.pixel_y
		var/total_display_time = lifespan - CHAT_MESSAGE_EOL_FADE

		// Start animation immediately (synchronously) to prevent flicker
		animate(message, alpha = 150, pixel_y = start_y + CHAT_EMOTE_FLOAT_DISTANCE, time = total_display_time, easing = SINE_EASING | EASE_OUT)

		// Schedule fade out
		scheduled_destruction = world.time + total_display_time
		addtimer(CALLBACK(src, PROC_REF(end_of_life_emote)), total_display_time, TIMER_UNIQUE|TIMER_OVERRIDE)
	else
		// For speech: typewriter effect
		animate(message, alpha = 150, time = CHAT_MESSAGE_SPAWN_TIME)
		INVOKE_ASYNC(src, PROC_REF(reveal_text), prefix, suffix, text_inner, lifespan)

/**
 * End of life for emote messages - fade out while continuing to float up
 */
/datum/chatmessage/proc/end_of_life_emote()
	if(QDELETED(src) || !message)
		return

	var/fadetime = CHAT_MESSAGE_EOL_FADE

	// Fade out while continuing to float upward slightly
	animate(message, alpha = 0, pixel_y = message.pixel_y + CHAT_EMOTE_FADEOUT_FLOAT, time = fadetime, easing = SINE_EASING | EASE_IN)
	sleep(fadetime)

	if(QDELETED(src))
		return
	qdel(src)

/datum/chatmessage/proc/end_of_life(fadetime = CHAT_MESSAGE_EOL_FADE)
	if(QDELETED(src))
		return
	animate(message, alpha = 0, time = fadetime, flags = ANIMATION_PARALLEL)
	sleep(fadetime)
	if(QDELETED(src))
		return
	qdel(src)

/**
 * Tokenize inner maptext - for Unicode support
 */
/datum/chatmessage/proc/tokenize_maptext(content)
	var/list/tokens = list()
	if(!istext(content) || !length_char(content))
		return tokens

	var/len = length_char(content)
	if(findtextEx(content, "&") == 0 && findtextEx(content, "<") == 0 && findtextEx(content, "\\") == 0)
		for(var/i = 1, i <= len, i++)
			tokens += copytext_char(content, i, i + 1)
		return tokens

	var/i = 1

	while(i <= len)
		var/ch = copytext_char(content, i, i + 1)

		// Handle HTML entity like &nbsp;
		if(ch == "&")
			var/found_entity = FALSE
			var/j = i + 1
			while(j <= len && j < i + 12)
				var/next_ch = copytext_char(content, j, j + 1)
				if(next_ch == ";")
					tokens += copytext_char(content, i, j + 1)
					i = j + 1
					found_entity = TRUE
					break
				j++
			if(found_entity)
				continue
			tokens += ch
			i++
			continue

		// Handle HTML tag like <br>
		if(ch == "<")
			var/found_tag = FALSE
			var/j = i + 1
			while(j <= len)
				var/next_ch = copytext_char(content, j, j + 1)
				if(next_ch == ">")
					tokens += copytext_char(content, i, j + 1)
					i = j + 1
					found_tag = TRUE
					break
				j++
			if(found_tag)
				continue
			tokens += ch
			i++
			continue

		// Handle backslash icon macros like \icon[...]
		if(ch == "\\")
			var/found_macro = FALSE
			var/bracket_pos = 0
			var/j = i + 1
			while(j <= len && j < i + 10)
				var/next_ch = copytext_char(content, j, j + 1)
				if(next_ch == "\[")
					bracket_pos = j
					break
				j++
			if(bracket_pos)
				j = bracket_pos + 1
				while(j <= len)
					var/next_ch = copytext_char(content, j, j + 1)
					if(next_ch == "]")
						tokens += copytext_char(content, i, j + 1)
						i = j + 1
						found_macro = TRUE
						break
					j++
			if(found_macro)
				continue
			tokens += ch
			i++
			continue

		// Default: single character token
		tokens += ch
		i++

	return tokens

/**
 * Reveal the inner text progressively (typewriter effect) - ONLY FOR SPEECH
 */
/datum/chatmessage/proc/reveal_text(prefix, suffix, text_inner, lifespan)
	if(QDELETED(src) || !message)
		return

	var/list/tokens = tokenize_maptext(text_inner)
	var/n = length(tokens)

	if(n <= 0)
		scheduled_destruction = world.time + (lifespan - CHAT_MESSAGE_EOL_FADE)
		addtimer(CALLBACK(src, PROC_REF(end_of_life)), lifespan - CHAT_MESSAGE_EOL_FADE, TIMER_UNIQUE|TIMER_OVERRIDE)
		return

	// Calculate timing - 0.1-0.4 seconds total for reveal
	var/reveal_total = clamp(n * 0.1, 0.1, 0.4)
	var/step_delay = max(1, round(reveal_total / n))

	var/revealed_text = ""
	for(var/i = 1, i <= n, i++)
		if(QDELETED(src) || !message || !owned_by)
			return
		revealed_text += tokens[i]
		message.maptext = prefix + revealed_text + suffix
		sleep(step_delay)

	// Schedule end of life after text is fully revealed
	scheduled_destruction = world.time + (lifespan - CHAT_MESSAGE_EOL_FADE)
	addtimer(CALLBACK(src, PROC_REF(end_of_life)), lifespan - CHAT_MESSAGE_EOL_FADE, TIMER_UNIQUE|TIMER_OVERRIDE)

/mob/proc/create_chat_message(atom/movable/speaker, datum/language/message_language, raw_message, list/spans, message_mode)
	spans = spans?.Copy()

	var/atom/movable/originalSpeaker = speaker
	if (istype(speaker, /atom/movable/virtualspeaker))
		var/atom/movable/virtualspeaker/v = speaker
		speaker = v.source
		spans |= "virtual-speaker"

	if (originalSpeaker != src && speaker == src)
		return

	var/text
	if(spans.Find("emote"))
		text = raw_message
	else
		text = lang_treat(speaker, message_language, raw_message, spans, null, TRUE)

	new /datum/chatmessage(text, speaker, src, spans)

// Color generation defines
#define CM_COLOR_SAT_MIN	0.6
#define CM_COLOR_SAT_MAX	0.7
#define CM_COLOR_LUM_MIN	0.65
#define CM_COLOR_LUM_MAX	0.75

/datum/chatmessage/proc/colorize_string(name, sat_shift = 1, lum_shift = 1)
	var/static/list/color_cache = list()
	var/static/rseed = rand(1,26)

	var/cache_key = "[name]_[GLOB.round_id]_[sat_shift]_[lum_shift]"
	if(color_cache[cache_key])
		return color_cache[cache_key]

	var/hash = copytext_char(md5(name + GLOB.round_id), rseed, rseed + 6)
	var/h = hex2num(copytext_char(hash, 1, 3)) * (360 / 255)
	var/s = (hex2num(copytext_char(hash, 3, 5)) >> 2) * ((CM_COLOR_SAT_MAX - CM_COLOR_SAT_MIN) / 63) + CM_COLOR_SAT_MIN
	var/l = (hex2num(copytext_char(hash, 5, 7)) >> 2) * ((CM_COLOR_LUM_MAX - CM_COLOR_LUM_MIN) / 63) + CM_COLOR_LUM_MIN

	s *= clamp(sat_shift, 0, 1)
	l *= clamp(lum_shift, 0, 1)

	var/h_int = round(h/60)
	var/c = (1 - abs(2 * l - 1)) * s
	var/x = c * (1 - abs((h / 60) % 2 - 1))
	var/m = l - c * 0.5
	x = (x + m) * 255
	c = (c + m) * 255
	m *= 255
	switch(h_int)
		if(0)
			color_cache[cache_key] = "#[num2hex(c, 2)][num2hex(x, 2)][num2hex(m, 2)]"
			return color_cache[cache_key]
		if(1)
			color_cache[cache_key] = "#[num2hex(x, 2)][num2hex(c, 2)][num2hex(m, 2)]"
			return color_cache[cache_key]
		if(2)
			color_cache[cache_key] = "#[num2hex(m, 2)][num2hex(c, 2)][num2hex(x, 2)]"
			return color_cache[cache_key]
		if(3)
			color_cache[cache_key] = "#[num2hex(m, 2)][num2hex(x, 2)][num2hex(c, 2)]"
			return color_cache[cache_key]
		if(4)
			color_cache[cache_key] = "#[num2hex(x, 2)][num2hex(m, 2)][num2hex(c, 2)]"
			return color_cache[cache_key]
		if(5)
			color_cache[cache_key] = "#[num2hex(c, 2)][num2hex(m, 2)][num2hex(x, 2)]"
			return color_cache[cache_key]
/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}

/// Prepares text for maptext centered
#define MAPTEXT_CENTER(text) {"<span class='maptext center'>[##text]</span>"}

/// Large area entry maptext
#define MAPTEXT_BLACKMOOR(text) {"<span style='font-family: "Blackmoor LET"; font-size: 24pt; -dm-text-outline: 1px black'>[##text]</span>"}

/// Pixel maptext
#define MAPTEXT_PIXELIFY(text) {"<span style='font-family: "Pixelify Sans"; font-size: 8pt; -dm-text-outline: 1px black'>[##text]</span>"}

/// Pixel maptext
#define MAPTEXT_VATICANUS(text) {"<span style='font-family: "Vaticanus"; font-size: 8pt;'>[##text]</span>"}

/// Macro from Lummox used to get height from a MeasureText proc
#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (GLOB.filename_forbidden_chars.Replace(text, ""))

/// Simply removes the < and > characters, and limits the length of the message.
#define STRIP_HTML_SIMPLE(text, limit) (GLOB.angular_brackets.Replace(copytext(text, 1, limit), ""))

/// Removes everything enclose in < and > inclusive of the bracket, and limits the length of the message.
#define STRIP_HTML_FULL(text, limit) (GLOB.html_tags.Replace(copytext(text, 1, limit), ""))

#define SANITIZE_HEAR_MESSAGE(text) (GLOB.hearing_stripped_chars.Replace(text, ""))

///List of ckeys that have seen a blurb of a given key.
GLOBAL_LIST_EMPTY(blurb_witnesses)

/// Takes a screen loc string in the format
/// "+-left-offset:+-pixel,+-bottom-offset:+-pixel"
/// Where the :pixel is optional, and returns
/// A list in the format (x_offset, y_offset)
/// We require context to get info out of screen locs that contain relative info, so NORTH, SOUTH, etc
/proc/screen_loc_to_offset(screen_loc, view)
	if(!screen_loc)
		return list(64, 64)
	var/list/view_size = view_to_pixels(view)
	var/x = 0
	var/y = 0
	// Time to parse for directional relative offsets
	if(findtext(screen_loc, "EAST")) // If you're starting from the east, we start from the east too
		x += view_size[1]
	if(findtext(screen_loc, "WEST")) // HHHHHHHHHHHHHHHHHHHHHH WEST is technically a 1 tile offset from the start. Shoot me please
		x += world.icon_size
	if(findtext(screen_loc, "NORTH"))
		y += view_size[2]
	if(findtext(screen_loc, "SOUTH"))
		y += world.icon_size

	var/list/x_and_y = splittext(screen_loc, ",")

	var/list/x_pack = splittext(x_and_y[1], ":")
	var/list/y_pack = splittext(x_and_y[2], ":")

	var/x_coord = x_pack[1]
	var/y_coord = y_pack[1]

	if (findtext(x_coord, "CENTER"))
		x += view_size[1] / 2

	if (findtext(y_coord, "CENTER"))
		y += view_size[2] / 2

	x_coord = text2num(cut_relative_direction(x_coord))
	y_coord = text2num(cut_relative_direction(y_coord))

	x += x_coord * world.icon_size
	y += y_coord * world.icon_size

	if(length(x_pack) > 1)
		x += text2num(x_pack[2])
	if(length(y_pack) > 1)
		y += text2num(y_pack[2])
	return list(x, y)

/// Takes a list in the form (x_offset, y_offset)
/// And converts it to a screen loc string
/// Accepts an optional view string/size to force the screen_loc around, so it can't go out of scope
/proc/offset_to_screen_loc(x_offset, y_offset, view = null)
	if(view)
		var/list/view_bounds = view_to_pixels(view)
		x_offset = clamp(x_offset, world.icon_size, view_bounds[1])
		y_offset = clamp(y_offset, world.icon_size, view_bounds[2])

	// Round with no argument is floor, so we get the non pixel offset here
	var/x = round(x_offset / world.icon_size)
	var/pixel_x = x_offset % world.icon_size
	var/y = round(y_offset / world.icon_size)
	var/pixel_y = y_offset % world.icon_size

	var/list/generated_loc = list()
	generated_loc += "[x]"
	if(pixel_x)
		generated_loc += ":[pixel_x]"
	generated_loc += ",[y]"
	if(pixel_y)
		generated_loc += ":[pixel_y]"
	return jointext(generated_loc, "")

/**
 * Returns a valid location to place a screen object without overflowing the viewport
 *
 * * target: The target location as a purely number based screen_loc string "+-left-offset:+-pixel,+-bottom-offset:+-pixel"
 * * target_offset: The amount we want to offset the target location by. We explictly don't care about direction here, we will try all 4
 * * view: The view variable of the client we're doing this for. We use this to get the size of the screen
 *
 * Returns a screen loc representing the valid location
**/
/proc/get_valid_screen_location(target_loc, target_offset, view)
	var/list/offsets = screen_loc_to_offset(target_loc)
	var/base_x = offsets[1]
	var/base_y = offsets[2]

	var/list/view_size = view_to_pixels(view)

	// Bias to the right, down, left, and then finally up
	if(base_x + target_offset < view_size[1])
		return offset_to_screen_loc(base_x + target_offset, base_y, view)
	if(base_y - target_offset > world.icon_size)
		return offset_to_screen_loc(base_x, base_y - target_offset, view)
	if(base_x - target_offset > world.icon_size)
		return offset_to_screen_loc(base_x - target_offset, base_y, view)
	if(base_y + target_offset < view_size[2])
		return offset_to_screen_loc(base_x, base_y + target_offset, view)
	stack_trace("You passed in a scren location {[target_loc]} and offset {[target_offset]} that can't be fit in the viewport Width {[view_size[1]]}, Height {[view_size[2]]}. what did you do lad")
	return null // The fuck did you do lad

/// Takes a screen_loc string and cut out any directions like NORTH or SOUTH
/proc/cut_relative_direction(fragment)
	var/static/regex/regex = regex(@"([A-Z])\w+", "g")
	return regex.Replace(fragment, "")

/// Takes a string or num view, and converts it to pixel width/height in a list(pixel_width, pixel_height)
/proc/view_to_pixels(view)
	if(!view)
		return list(0, 0)
	var/list/view_info = getviewsize(view)
	view_info[1] *= world.icon_size
	view_info[2] *= world.icon_size
	return view_info

//Based on code ported from Nebula. https://github.com/NebulaSS13/Nebula/pull/357

/**Shows a ticker reading out the given text on a client's screen.
targets = mob or list of mobs to show it to.
duration = how long it lingers after it finishes ticking.
message = the message to display. Due to using maptext it isn't very flexible format-wise. 11px font, up to 480 pixels per line.
Use \n for line breaks. Single-character HTML tags (<b>, <i>, <u> etc.) are handled correctly but others display strangely.
Note that maptext can display text macros in strange ways, ex. \improper showing as "ÿ". Lines containing only spaces,
including ones only containing "\improper ", don't display.
scroll_down = by default each line pushes the previous line upwards - this tells it to start high and scroll down.
Ticks on \n - does not autodetect line breaks in long strings.
screen_position = screen loc for the bottom-left corner of the blurb.
text_alignment = "right", "left", or "center"
text_color = colour of the text.
blurb_key = a key used for specific blurb types so they are not shown repeatedly. Ex. someone who joins as CLF repeatedly only seeing the mission blurb the first time.
ignore_key = used to skip key checks. Ex. a USCM ERT member shouldn't see the normal USCM drop message,
but should see their own spawn message even if the player already dropped as USCM.**/
/proc/show_blurb(list/mob/targets, duration = 3 SECONDS, message, fade_time = 0.5 SECONDS, scroll_down, screen_position = "LEFT+0:16,BOTTOM+1:16",\
	text_alignment = "left", text_color = "#FFFFFF", outline_color = "#000000", blurb_key, ignore_key = FALSE, speed = 0.5)
	set waitfor = FALSE
	if(!islist(targets))
		targets = list(targets)
	if(!length(targets))
		return

	var/style = "font-family: 'Fixedsys'; font-size: 6px; text-align: [text_alignment]; color: [text_color]; -dm-text-outline: 1 [outline_color];"
	var/list/linebreaks = list() //Due to singular /'s making text disappear for a moment and for counting lines.

	var/linebreak = findtext(message, "\n")
	while(linebreak)
		linebreak++ //Otherwise it picks up the character immediately before the linebreak.
		linebreaks += linebreak
		linebreak = findtext(message, "\n", linebreak)

	var/list/html_tags = list()
	var/static/html_locate_regex = regex("<.*>")
	var/tag_position = findtext(message, html_locate_regex)
	var/reading_tag = TRUE
	while(tag_position)
		if(reading_tag)
			if(message[tag_position] == ">")
				reading_tag = FALSE
				html_tags += tag_position
			else
				html_tags += tag_position
			tag_position++
		else
			tag_position = findtext(message, html_locate_regex, tag_position)
			reading_tag = TRUE

	var/atom/movable/screen/text/T = new()
	T.screen_loc = screen_position
	// screen_loc = "CENTER, CENTER" results in list(240, 240)"
	var/list/offsets = screen_loc_to_offset(T.screen_loc, world.view)
	T.maptext_height -= offsets[2]
	switch(text_alignment)
		if("center")
			var/closest_edge = min(offsets[1], 480 - offsets[1])
			T.maptext_width = closest_edge * 2
			T.maptext_x = -(T.maptext_width * 0.5 - 16) //Centering the textbox.
		if("right")
			T.maptext_width = offsets[1]
			T.maptext_x = -(T.maptext_width - 32) //Aligning the textbox with the right edge of the screen object.
		if("left")
			T.maptext_width -= offsets[1]

	if(scroll_down)
		T.maptext_y = length(linebreaks) * 14

	for(var/mob/M as anything in targets)
		if(blurb_key)
			if(!ignore_key && (M.key in GLOB.blurb_witnesses[blurb_key]))
				continue
			GLOB.blurb_witnesses[blurb_key] |= M.key
		M.client?.screen += T

	for(var/i in 1 to length(message) + 1)
		if(i in linebreaks)
			if(scroll_down)
				T.maptext_y -= 14 //Move the object to keep lines in the same place.
			continue
		if(i in html_tags)
			continue
		T.maptext = MAPTEXT("<span style=\"[style]\">[copytext(message, 1, i)]</span>")
		if(speed)
			sleep(speed)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_blurb), targets, T, fade_time), duration)

/proc/fade_blurb(list/mob/targets, obj/T, fade_time = 0.5 SECONDS)
	animate(T, alpha = 0, time = fade_time)
	sleep(fade_time)
	for(var/mob/M as anything in targets)
		M.client?.screen -= T
	qdel(T)

/proc/show_blurb_all(duration = 3 SECONDS, message, fade_time = 0.5 SECONDS, scroll_down, screen_position = "LEFT+0:16,BOTTOM+1:16",\
	text_alignment = "left", text_color = "#FFFFFF", blurb_key, ignore_key = FALSE, speed = 0.5)
	show_blurb(GLOB.player_list, duration, message, fade_time, scroll_down, screen_position, text_alignment, text_color, blurb_key, ignore_key, speed)

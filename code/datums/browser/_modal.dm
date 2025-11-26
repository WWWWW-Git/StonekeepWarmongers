/**
 * Tracks the client's currently open browser modals.
 *
 * This is obviously not an ideal way to do this, but refactoring TGUI to allow browser datums is a bit later.
 **/
/mob/var/list/browser_modals = list()

/datum/browser/modal
	window_options = "can_close=1;can_minimize=0;can_maximize=0;can_resize=0;titlebar=1;"
	/// If this modal has been closed.
	var/final/closed = FALSE
	/// The time in deciseconds before this modal is cancelled.
	var/final/timeout = 0

/datum/browser/modal/New(mob/user, window_id, title = "", width = 0, nheight = 0, atom/owner = null, stealfocus = TRUE, timeout = 0)
	. = ..()
	src.timeout = timeout
	src.stealfocus = stealfocus
	if(!stealfocus)
		window_options += "focus=[FALSE];"

	user.browser_modals.Add(src)

/datum/browser/modal/Destroy(force, ...)
	if(!user)
		stack_trace("modal had no user when it was deleted, which isn't weird necessarily but is a sign for something going bad")
	else
		user.browser_modals.Remove(src)
	return ..()

/datum/browser/modal/close()
	. = ..()
	closed = TRUE

/datum/browser/modal/open(use_onclose)
	set waitfor = FALSE

	if(stealfocus)
		. = ..()
	else
		var/focusedwindow = winget(user, null, "focus")
		. = ..()

		//waits for the window to show up client side before attempting to un-focus it
		//winexists sleeps until it gets a reply from the client, so we don't need to bother sleeping
		for (var/i in 1 to 10)
			if (user && winexists(user, window_id))
				if (focusedwindow)
					winset(user, focusedwindow, "focus=true")
				else
					winset(user, "mapwindow", "focus=true")
				break
	if(timeout)
		addtimer(CALLBACK(src, PROC_REF(close)), timeout)

/datum/browser/modal/proc/wait()
	while(!selectedbutton && !closed && !QDELETED(src))
		stoplag(1)

/// Sets [var/selectedbutton] to the passed selectedbutton argument.
/// Exists to be overridden by subtypes for more handling.
/datum/browser/modal/proc/set_selectedbutton(selectedbutton)
	src.selectedbutton = selectedbutton
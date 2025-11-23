/// designed as a drop in replacement for alert(); functions the same. (outside of needing User specified)
/proc/browser_alert(mob/user, message = "", title = "VANDERLIN", list/buttons = list(CHOICE_OK), timeout = 0, stealfocus = TRUE)
	if(!user)
		user = usr

	if(!istype(user))
		if(isclient(user))
			var/client/client = user
			user = client.mob
		else
			return null

	if(isnull(user.client))
		return null

	var/datum/browser/modal/alert/alert = new(user, message, title, buttons, timeout, stealfocus)
	alert.open()
	alert.wait()
	if(alert)
		. = alert.selectedbutton
		qdel(alert)

/datum/browser/modal/alert
	var/final/list/buttons

/datum/browser/modal/alert/New(mob/user, message, title, list/buttons, timeout, stealfocus)
	if(!user)
		closed = TRUE
		return

	src.buttons = buttons.Copy()

	var/list/options = list()
	for(var/button in buttons)
		options += "<button type='submit' name='selectedbutton' value='[button]' [NULLABLE(buttons[1] == button) && "stealfocus"]>[button]</button>"

	var/window_width = 350 + (length(buttons) > 2 ? 50 : 0)
	var/window_height = 125 + (length(message) > 30 ? ceil(length(message) / 4) : 0)

	..(user, ckey("[user]-[message]-[title]-[world.time]-[rand(1, 10000)]"), title, window_width, window_height, src, stealfocus, timeout)
	set_content({"
	<form action="byond://">
		<input type="hidden" name="src" value="[REF(src)]">
		<center><b>[message]</b></center>
		<br/>
		<div style="display: flex; justify-content: space-between; text-align: center;">
			[options.Join("\n")]
		</div>
	</form>
	"})

/datum/browser/modal/alert/Topic(href, href_list)
	if(href_list["selectedbutton"])
		set_selectedbutton(href_list["selectedbutton"])

	closed = TRUE
	close()

/datum/browser/modal/alert/set_selectedbutton(selectedbutton)
	if(!(selectedbutton in buttons))
		CRASH("[user] selected non-existent button selectedbutton: [selectedbutton]")

	..()

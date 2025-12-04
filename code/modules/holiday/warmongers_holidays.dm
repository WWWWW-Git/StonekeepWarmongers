// Seperate file to avoid the scary shit happening in holidays.dm
// Most of this will just be ports from the previously said file

/datum/holiday/birthday
	name = "Birthday of Space Station 13"
	begin_day = 16
	begin_month = FEBRUARY

/datum/holiday/birthday/greet()
	var/game_age = text2num(time2text(world.timeofday, "YY")) - 3
	var/Fact
	switch(game_age)
		if(16)
			Fact = " SS13 is now old enough to drive!"
		if(18)
			Fact = " SS13 is now legal!"
		if(21)
			Fact = " SS13 can now drink!"
		if(26)
			Fact = " SS13 can now rent a car!"
		if(30)
			Fact = " SS13 can now go home and be a family man!"
		if(35)
			Fact = " SS13 can now run for President of the United States!"
		if(40)
			Fact = " SS13 can now suffer a midlife crisis!"
		if(50)
			Fact = " Happy golden anniversary!"
		if(65)
			Fact = " SS13 can now start thinking about retirement!"
		if(96)
			Fact = " Please send a time machine back to pick me up, I need to update the time formatting for this feature!" //See you later suckers
	if(!Fact)
		Fact = " SS13 is now [game_age] years old!"

	return "Say 'Happy Birthday' to Space Station 13, first publicly playable on February 16th, 2003![Fact]"

/datum/holiday/april_fools
	name = APRIL_FOOLS
	begin_day = 1
	end_day = 1
	begin_month = APRIL

/datum/holiday/christmas
	name = CHRISTMAS
	begin_day = 22
	begin_month = DECEMBER
	end_day = 27

/datum/holiday/christmas/celebrate()
	SSticker.login_music = 'sound/music/parade.ogg'
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/P = i
		if(P.client)
			P.client.playtitlemusic()

/datum/holiday/christmas/greet()
	return "Have a merry Yule!"

/datum/holiday/halloween
	name = HALLOWEEN
	begin_day = 28
	begin_month = OCTOBER
	end_day = 2
	end_month = NOVEMBER

/datum/holiday/halloween/celebrate()
	SSticker.login_music = 'sound/music/randysandy.ogg'
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/P = i
		if(P.client)
			P.client.playtitlemusic()

/datum/holiday/halloween/greet()
	return "Have a terrifying All-Hollow Evening!"

/datum/holiday/new_year
	name = NEW_YEAR
	begin_day = 30
	begin_month = DECEMBER
	end_day = 2
	end_month = JANUARY

/datum/holiday/birthday_war
	name = "Birthday of WARMONGERS"
	begin_day = 16
	begin_month = FEBRUARY

/datum/holiday/birthday_war/greet()
	var/game_age = text2num(time2text(world.timeofday, "YY")) - 24
	var/Fact
	switch(game_age)
		if(16) // implying itll ever reach this btw
			Fact = " WARMONGERS is now old enough to drive!"
		if(18)
			Fact = " WARMONGERS is now legal! Don't try anything."
		if(21)
			Fact = " WARMONGERS can now drink!"
		if(26)
			Fact = " WARMONGERS can now rent a car!"
		if(30)
			Fact = " WARMONGERS can now go home and be a family man!"
		if(35)
			Fact = " WARMONGERS can now run for President of the United States!"
		if(40)
			Fact = " WARMONGERS can now suffer a midlife crisis!"
		if(50)
			Fact = " Happy golden anniversary!"
		if(65)
			Fact = " WARMONGERS can now start thinking about retirement!"
		if(96)
			Fact = " Please send a time machine back to pick me up, I need to update the time formatting for this feature!" //See you later suckers
	if(!Fact)
		Fact = " WARMONGERS is now [game_age] years old!"

	return "Say 'Happy Birthday' to WARMONGERS, first publicly playable on August 3rd, 2024![Fact]"

/*
/datum/holiday/debugmas
	name = "Debugmas"
	begin_day = 4
	begin_month = NOVEMBER
	end_day = 27

/datum/holiday/debugmas/celebrate()
	SSticker.login_music = 'sound/music/parade.ogg'
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/P = i
		if(P.client)
			P.client.playtitlemusic()
*/

/datum/holiday/debugmas/greet()
	return "Have a merry Debugmas!"

/datum/holiday/peace // end of ww1
	name = "Interglobal Peace Day"
	begin_day = 11
	begin_month = NOVEMBER

/datum/holiday/peace/celebrate()
	SSticker.login_music = 'sound/music/rainbow.ogg'
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/P = i
		if(P.client)
			P.client.playtitlemusic()

/datum/holiday/peace/greet()
	return "Have a kind Interglobal Peace Day!"

/datum/holiday/peace2 // end of ww1
	name = "Second Interglobal Peace Day"
	begin_day = 2
	begin_month = JULY

/datum/holiday/peace2/celebrate()
	SSticker.login_music = pick('sound/music/rainbow.ogg','sound/music/thomas.ogg')
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/P = i
		if(P.client)
			P.client.playtitlemusic()

/datum/holiday/peace2/greet()
	return "Have a kind Second Interglobal Peace Day!"
/datum/warperk
	var/name = "Ordinary Person"
	var/desc = "I'm just a regular guy. I'll gain an extra TRIUMPH if my team wins."
	var/cost = 0

/datum/warperk/proc/apply(var/mob/living/carbon/human/H) // for special shit ig
	return

// 1-4 tri

/datum/warperk/madness
	name = "Madness"
	desc = "Screaming in pain heals you slightly."
	cost = 2

/datum/warperk/masochist
	name = "Masochist"
	desc = "You no longer feel pain, and losing a limb makes you gain +2 strength."
	cost = 3

/datum/warperk/masochist/apply(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_NOPAIN, TRAIT_GENERIC)

/datum/warperk/brutalist
	name = "Brutalist"
	desc = "Decapitating someone grants you +1 speed."
	cost = 2

/datum/warperk/athlete
	name = "Athlete"
	desc = "Running and jumping costs half as much stamina."
	cost = 1

/datum/warperk/headhunter
	name = "Headhunter"
	desc = "Dealing a killing blow via headshot makes your target explode into giblets."
	cost = 1

// 5-10 tri

/datum/warperk/gifted
	name = "Gifted"
	desc = "Increase a stat of your choice by 2."
	cost = 5

/datum/warperk/gifted/apply(mob/living/carbon/human/H)
	var/choice = input(H, "Choose a stat!", "WARMONGERS") as anything in list("STR","END","CON")
	switch(choice)
		if("STR")
			H.STASTR += 2
		if("END")
			H.STAEND += 2
		if("CON")
			H.STACON += 2

/datum/warperk/vampire
	name = "Vladimir"
	desc = "Drinking blood heals you."
	cost = 6

/datum/warperk/charge
	name = "Underelicted Duty"
	desc = "When you spawn you gain a speed boost to get back to the frontline quicker."
	cost = 5

/datum/warperk/charge/apply(mob/living/carbon/human/H)
	H.apply_status_effect(/datum/status_effect/buff/charge)

/datum/warperk/saint
	name = "Saint"
	desc = "When you die, nearby allies will be struck by fury and vigor."
	cost = 5

/datum/warperk/lightbrigade
	name = "Brigade of Light"
	desc = "You gain an ability that blinds all nearby enemies for a few seconds, but it blinds you aswell."
	cost = 6

/datum/warperk/lightbrigade/apply(mob/living/carbon/human/H)
	// todo
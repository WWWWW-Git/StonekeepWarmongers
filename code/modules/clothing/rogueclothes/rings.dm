

/obj/item/clothing/ring
	name = "ring"
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/roguetown/clothing/rings.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleevetype = "shirt"
	icon_state = ""
	slot_flags = ITEM_SLOT_RING
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dropshrink = 0.8

/obj/item/clothing/ring/silver
	name = "silver ring"
	icon_state = "ring_s"
	sellprice = 33

/obj/item/clothing/ring/silver/guild_mason
	name = "Mason guild ring"
	desc = "The wearer is a proud member of the Masons guild."
	icon_state = "guild_mason"
	sellprice = 0

/obj/item/clothing/ring/gold
	name = "gold ring"
	icon_state = "ring_g"
	sellprice = 70

/obj/item/clothing/ring/gold/guild_mercator
	name = "Mercator guild ring"
	desc = "The wearer is a proud member of the Mercator guild."
	icon_state = "guild_mercator"
	sellprice = 0

/obj/item/clothing/ring/active
	var/active = FALSE
	desc = "Unfortunately, like most magic rings, it must be used sparingly. (Right-click me to activate)"
	var/cooldowny
	var/cdtime
	var/activetime
	var/activate_sound

/obj/item/clothing/ring/active/attack_right(mob/user)
	if(loc != user)
		return
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, "<span class='warning'>Nothing happens.</span>")
			return
	user.visible_message("<span class='warning'>[user] twists the [src]!</span>")
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	update_icon()
	activate(user)

/obj/item/clothing/ring/active/proc/activate(mob/user)
	user.update_inv_wear_id()

/obj/item/clothing/ring/active/proc/demagicify()
	active = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/user = loc
		user.visible_message("<span class='warning'>The ring settles down.</span>")
		user.update_inv_wear_id()


/obj/item/clothing/ring/active/nomag
	name = "ring of null magic"
	icon_state = "ruby"
	activate_sound = 'sound/magic/antimagic.ogg'
	cdtime = 10 MINUTES
	activetime = 30 SECONDS
	sellprice = 100

/obj/item/clothing/ring/active/nomag/update_icon()
	..()
	if(active)
		icon_state = "rubyactive"
	else
		icon_state = "ruby"

/obj/item/clothing/ring/active/nomag/activate(mob/user)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, FALSE, FALSE, ITEM_SLOT_RING, INFINITY, FALSE)

/obj/item/clothing/ring/active/nomag/demagicify()
	. = ..()
	var/datum/component/magcom = GetComponent(/datum/component/anti_magic)
	if(magcom)
		magcom.RemoveComponent()

// ................... Ring of Protection ....................... (rare treasure, not for purchase)
/obj/item/clothing/ring/gold/protection
	name = "ring of protection"
	desc = "Old ring, inscribed with arcane words. Once held magical powers, perhaps it does still?"
	icon_state = "ring_protection"
	var/antileechy
	var/antimagika
	var/antishocky

/obj/item/clothing/ring/gold/protection/Initialize()
	. = ..()
	switch(rand(1,4))
		if(1)
			antileechy = TRUE
		if(2)
			antimagika = TRUE
		if(3)
			antishocky = TRUE
		if(4)
			return

/obj/item/clothing/ring/gold/protection/equipped(mob/user, slot)
	. = ..()
	if(antileechy)
		if (slot == SLOT_RING && istype(user))
			ADD_TRAIT(user, TRAIT_LEECHIMMUNE,"Unleechable")
		else
			REMOVE_TRAIT(user, TRAIT_LEECHIMMUNE,"Unleechable")

	if(antimagika)
		if (slot == SLOT_RING && istype(user))
			ADD_TRAIT(user, TRAIT_ANTIMAGIC,"Anti-Magic")
		else
			REMOVE_TRAIT(user, TRAIT_ANTIMAGIC,"Anti-Magic")

	if(antishocky)
		if (slot == SLOT_RING && istype(user))
			ADD_TRAIT(user, TRAIT_SHOCKIMMUNE,"Shock Immunity")
		else
			REMOVE_TRAIT(user, TRAIT_SHOCKIMMUNE,"Shock Immunity")

/obj/item/clothing/ring/gold/protection/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_LEECHIMMUNE,"Unleechable")
	REMOVE_TRAIT(user, TRAIT_ANTIMAGIC,"Anti-Magic")
	REMOVE_TRAIT(user, TRAIT_SHOCKIMMUNE, "Shock Immunity")
	
/obj/item/clothing/ring/gold/ravox
	name = "ring of ravox"
	desc = "Old ring, inscribed with arcane words. Just being near it imbues you with otherworldly strength."
	icon_state = "ring_ravox"

/obj/item/clothing/ring/gold/ravox/equipped(mob/living/user, slot)
	. = ..()
	if(user.mind)
		if (slot == SLOT_RING && istype(user))
			user.apply_status_effect(/datum/status_effect/buff/ravox)
		else
			user.remove_status_effect(/datum/status_effect/buff/ravox)

/obj/item/clothing/ring/silver/calm
	name = "soothing ring"
	desc = "A lightweight ring that feels entirely weightless, and easing to your mind as you place it upon a finger."
	icon_state = "ring_calm"

/obj/item/clothing/ring/silver/calm/equipped(mob/living/user, slot)
	. = ..()
	if(user.mind)
		if (slot == SLOT_RING && istype(user))
			user.apply_status_effect(/datum/status_effect/buff/calm)
		else
			user.remove_status_effect(/datum/status_effect/buff/calm)

/obj/item/clothing/ring/silver/noc
	name = "ring of noc"
	desc = "Old ring, inscribed with arcane words. Just being near it imbues you with otherworldly knowledge."
	icon_state = "ring_sapphire"

/obj/item/clothing/ring/silver/noc/equipped(mob/living/user, slot)
	. = ..()
	if(user.mind)
		if (slot == SLOT_RING && istype(user))
			user.apply_status_effect(/datum/status_effect/buff/noc)
		else
			user.remove_status_effect(/datum/status_effect/buff/noc)

//--------- Start of Warmongers Rings

/obj/item/clothing/ring/warmongers
	name = "ring of warmongering"
	desc = "Legends say this ring allows its wielder to kill other people."
	icon_state = ""

//--------- Start of Magical Warmongers Rings - MADE FOR KILLING!
//	Ring Types:
//	Copper = +1 Stat & 10% chance other effect (wip)
//	Silver = +2 Stat & 50% chance other effect
//	Gold   = +3 Stat & 100% chance other effect
//	Unique = Unique effect (Only 1 of each Unique Ring possible per round)

/obj/item/clothing/ring/warmongers/magic
	name = "magical ring of warmongering"
	desc = "Legends say this ring allows its wielder to kill other people, magically."
	icon_state = ""
	var/bonus_stat
	var/datum/status_effect/bonus_effect
	var/has_bonus_effect = TRUE
	var/currently_equipped = FALSE

	// Lists of possible stats and effects
	var/list/possible_stats = list(
		/datum/status_effect/buff/warmongers/ring
		)
	var/list/possible_effects = list(
		/datum/status_effect/buff/warmongers/shiny
	)

/obj/item/clothing/ring/warmongers/magic/Initialize()
	. = ..()
	roll_bonuses()
	update_description()

/obj/item/clothing/ring/warmongers/magic/proc/roll_bonuses()
	bonus_stat = pick(possible_stats)
	if(prob(50))
		has_bonus_effect = TRUE
		// Roll 1dX where X is the length of possible_effects
		bonus_effect = pick(possible_effects)

/obj/item/clothing/ring/warmongers/magic/proc/update_description()
	var/new_desc = "A ring imbued with long-forgotten magical energies."
	if(bonus_stat)
		new_desc += " You sense it enhances [bonus_stat]."
	if(has_bonus_effect && bonus_effect)
		new_desc += " It radiates with [initial(bonus_effect.name)] magic."
	desc = new_desc

/obj/item/clothing/ring/warmongers/magic/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_RING)
		apply_bonuses(user)

/obj/item/clothing/ring/warmongers/magic/dropped(mob/living/user)
	. = ..()
	if(currently_equipped)
		remove_bonuses(user)

/obj/item/clothing/ring/warmongers/magic/proc/apply_bonuses(mob/living/user)
	if(!user || currently_equipped)
		return
	if(bonus_stat)
		user.apply_status_effect(bonus_stat)
	if(has_bonus_effect && bonus_effect)
		user.apply_status_effect(bonus_effect)
	currently_equipped = TRUE
	to_chat(user, "<span class='notice'>You feel the magical energies of the [name] flow through you!</span>")

/obj/item/clothing/ring/warmongers/magic/proc/remove_bonuses(mob/living/user)
	if(!user || !currently_equipped)
		return
	if(bonus_stat)
		user.remove_status_effect(bonus_stat)
	if(has_bonus_effect && bonus_effect)
		user.remove_status_effect(bonus_effect)
	currently_equipped = FALSE
	to_chat(user, "<span class='warning'>The magical energies of the [name] fade away...</span>")

/obj/item/clothing/ring/warmongers/magic/examine(mob/user)
	. = ..()
	if(bonus_stat)
		. += "<span class='notice'>This ring grants [bonus_stat].</span>"
	if(has_bonus_effect && bonus_effect)
		. += "<span class='notice'>This ring also grants [initial(bonus_effect.name)].</span>"

//--------- Start of Standard Magical Warmongers Rings

/obj/item/clothing/ring/warmongers/magic/copper
	name = "magical copper ring"
	desc = "Carved runes softly glow and shimmer; wearing this copper ring is said to grant its wielder a minor boon."
	icon_state = "copper_runes"
	has_bonus_effect = TRUE

	// Copper Tier
	var/list/possible_stats_copper = list(
		/datum/status_effect/buff/warmongers/ring/strength1,
		/datum/status_effect/buff/warmongers/ring/perception1,
		/datum/status_effect/buff/warmongers/ring/intelligence1,
		/datum/status_effect/buff/warmongers/ring/constitution1,
		/datum/status_effect/buff/warmongers/ring/endurance1,
		/datum/status_effect/buff/warmongers/ring/speed1,
		/datum/status_effect/buff/warmongers/ring/fortune1,
		)
	var/list/possible_effects_copper = list(
		/datum/status_effect/buff/warmongers/shiny
	)

/obj/item/clothing/ring/warmongers/magic/copper/Initialize()
	. = ..()
	roll_bonuses()
	update_description()

/obj/item/clothing/ring/warmongers/magic/copper/proc/roll_bonuses()
	bonus_stat = pick(possible_stats_copper)
	if(prob(10))
		has_bonus_effect = TRUE
		// Roll 1dX where X is the length of possible_effects
		bonus_effect = pick(possible_effects_copper)

/obj/item/clothing/ring/warmongers/magic/silver
	name = "magical silver ring"
	desc = "Carved runes glow and shimmer; wearing this silver ring is said to grant its wielder a significant boon."
	icon_state = "silver_runes"
	has_bonus_effect = TRUE

		// Silver Tier
	var/list/possible_stats_silver = list(
		/datum/status_effect/buff/warmongers/ring/strength2,
		/datum/status_effect/buff/warmongers/ring/perception2,
		/datum/status_effect/buff/warmongers/ring/intelligence2,
		/datum/status_effect/buff/warmongers/ring/constitution2,
		/datum/status_effect/buff/warmongers/ring/endurance2,
		/datum/status_effect/buff/warmongers/ring/speed2,
		/datum/status_effect/buff/warmongers/ring/fortune2,
		)
	var/list/possible_effects_silver = list(
		/datum/status_effect/buff/warmongers/shiny
	)

/obj/item/clothing/ring/warmongers/magic/silver/Initialize()
	. = ..()
	roll_bonuses()
	update_description()

/obj/item/clothing/ring/warmongers/magic/silver/proc/roll_bonuses()
	bonus_stat = pick(possible_stats_silver)
	if(prob(50))
		has_bonus_effect = TRUE
		// Roll 1dX where X is the length of possible_effects
		bonus_effect = pick(possible_effects_silver)

/obj/item/clothing/ring/warmongers/magic/gold
	name = "magical gold ring"
	desc = "Carved runes energetically glow and shimmer; wearing this gold ring is said to grant its wielder a great boon."
	icon_state = "gold_runes"
	has_bonus_effect = TRUE
	
		// Gold Tier
	var/list/possible_stats_gold = list(
		/datum/status_effect/buff/warmongers/ring/strength3,
		/datum/status_effect/buff/warmongers/ring/perception3,
		/datum/status_effect/buff/warmongers/ring/intelligence3,
		/datum/status_effect/buff/warmongers/ring/constitution3,
		/datum/status_effect/buff/warmongers/ring/endurance3,
		/datum/status_effect/buff/warmongers/ring/speed3,
		/datum/status_effect/buff/warmongers/ring/fortune3,
		)
	var/list/possible_effects_gold = list(
		/datum/status_effect/buff/warmongers/shiny
	)

/obj/item/clothing/ring/warmongers/magic/gold/Initialize()
	. = ..()
	roll_bonuses()
	update_description()

/obj/item/clothing/ring/warmongers/magic/gold/proc/roll_bonuses()
	bonus_stat = pick(possible_stats_gold)
	bonus_effect = pick(possible_effects_gold)

//--------- Start of Unique Magical Warmongers Rings

/obj/item/clothing/ring/warmongers/magic/unique
	name = "true ring of warmongering"
	desc = "Etched into the ring are the initials - J.W."
	icon_state = ""

// Edax - Unique Effect: Consumes other, NON-UNIQUE rings to collect their power
/obj/item/clothing/ring/warmongers/magic/unique/edax
	name = "edax"
	desc = "It grins at you, beckoning you to feed it."
	icon_state = ""

// Mordax - Unique Effect: Grants the wielder vampiric aspects (pale skin, red eyes) and abilities (transfix, night vision)
/obj/item/clothing/ring/warmongers/magic/unique/mordax
	name = "mordax"
	desc = "Legends speak of red-eyed immortal warlords that feasted on the blood of thousands."
	icon_state = ""

// Mutantur - Unique Effect: Has two forms that can be switched on activating in hand.
// Form 1 - +2 STR, CON, END; Form 2 - +2 PER, INT, SPD
/obj/item/clothing/ring/warmongers/magic/unique/mutantur
	name = "mutantur"
	desc = "Two snakes share the same body, their heads pointed past each other at the top of the ring. One's eyes glow; the other's does not."
	icon_state = ""


//--------- End of Warmongers Rings

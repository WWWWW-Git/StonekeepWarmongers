
/obj/item/rogue/painting
	name = "painting"
	icon_state = "painting"
	desc = ""
	w_class = WEIGHT_CLASS_NORMAL
	static_price = TRUE
	sellprice = 20
	icon = 'icons/roguetown/items/misc.dmi'
	var/deployed_structure = /obj/structure/fluff/walldeco/painting

/obj/item/rogue/painting/attack_turf(turf/T, mob/living/user)
	if(isclosedturf(T))
		if(get_dir(T,user) in GLOB.cardinals)
			to_chat(user, "<span class='warning'>I place [src] on the wall.</span>")
			var/obj/structure/S = new deployed_structure(user.loc)
			switch(get_dir(T,user))
				if(NORTH)
					S.pixel_y = -32
				if(SOUTH)
					S.pixel_y = 32
				if(WEST)
					S.pixel_x = 32
				if(EAST)
					S.pixel_x = -32
			qdel(src)
			return
	..()

/obj/structure/fluff/walldeco/painting
	name = "painting"
	desc = "The artist is unknown. The subject is unknown. Maybe a memorial to a corpse that was trampled on the trail to this reality."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "painting_deployed"
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	var/stolen_painting = /obj/item/rogue/painting

/obj/structure/fluff/walldeco/painting/attack_hand(mob/user)
	if(do_after(user, 30, target = user))
		var/obj/item/I = new stolen_painting(user.loc)
		user.put_in_hands(I)
		qdel(src)
		return
	..()

/obj/structure/fluff/walldeco/painting/queen
	desc = "It's Queen Samantha I of Enigma. Her late husband would be so proud of what she has accomplished in his realm."
	icon_state = "queenpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/queen

/obj/item/rogue/painting/queen
	icon_state = "queenpainting"
	desc = "It's Queen Samantha I of Psydonia. Her late husband would be so proud of what she has accomplished in his realm. These mass-reproduced paintings are unfortunately devalued."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/queen

/obj/item/rogue/painting/seraphina
	icon_state = "Seraphinapainting"
	desc = "It's holy priest Seraphina, first of her name, blessed be her name."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/seraphina

/obj/structure/fluff/walldeco/painting/seraphina
	desc = "It's holy priest Seraphina, first of her name, blessed be her name."
	icon_state = "seraphinapainting_deployed"
	stolen_painting = /obj/item/rogue/painting/seraphina

/obj/item/rogue/painting/beer
	icon_state = "beerpainting"
	desc = "Remember what you're fighting for."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/beer

/obj/structure/fluff/walldeco/painting/beer
	desc = "Remember what you're fighting for."
	icon_state = "beerpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/beer

/obj/item/rogue/painting/beezer
	icon_state = "beezerpainting"
	desc = "The big man himself."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/beezer

/obj/structure/fluff/walldeco/painting/beezer
	desc = "The big man himself."
	icon_state = "beezerpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/beezer

/obj/item/rogue/painting/fatfuck
	icon_state = "fatfuckpainting"
	desc = "Evidently a self portrait."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/fatfuck

/obj/structure/fluff/walldeco/painting/fatfuck
	desc = "Evidently a self portrait."
	icon_state = "fatfuckpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/fatfuck

/obj/item/rogue/painting/regimer
	icon_state = "regimerpainting"
	desc = "A noble soldier of the KAITZAR."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/regimer

/obj/structure/fluff/walldeco/painting/regimer
	desc = "A noble soldier of the KAITZAR."
	icon_state = "regimerpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/regimer

/obj/item/rogue/painting/officers
	icon_state = "officerspainting"
	desc = "A bunch of officers planning their next move."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/officers

/obj/structure/fluff/walldeco/painting/officers
	desc = "A bunch of officers planning their next move."
	icon_state = "officerspainting_deployed"
	stolen_painting = /obj/item/rogue/painting/officers

/obj/item/rogue/painting/wench
	icon_state = "wenchpainting"
	desc = "A lovely wench holding up a bier."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/wench

/obj/structure/fluff/walldeco/painting/wench
	desc = "A lovely wench holding up a bier."
	icon_state = "wenchpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/wench

/obj/item/rogue/painting/massacre
	icon_state = "aftermathpainting"
	desc = "A whole lot of corpses in this painting. Some of the eyes seem to follow you."
	dropshrink = 0.5
	sellprice = 40
	deployed_structure = /obj/structure/fluff/walldeco/painting/massacre

/obj/structure/fluff/walldeco/painting/massacre
	desc = "A whole lot of corpses in this painting. Some of the eyes seem to follow you."
	icon_state = "aftermathpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/massacre
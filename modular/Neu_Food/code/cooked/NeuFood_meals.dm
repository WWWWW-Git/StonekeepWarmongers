/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*	- Defined as edible food that can be plated and usually needs rare tools or ingridients. Typically based on a snack but not necessarily
 *		 (Meals)		*
 *						*
 * * * * * * * * * * * **/



/*	..................   Pepper steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("steak" = 1, "pepper" = 1)
	name = "peppersteak"
	desc = "A delicacy in the PPU, steak with a very healthy seasoning of ground pepper."
	icon_state = "peppersteak"
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
/obj/item/reagent_containers/food/snacks/rogue/peppersteak/plated
	icon_state = "peppersteak_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG


/*	..................   Onion steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/onionsteak
	name = "onion steak"
	desc = "Roasted flesh garnished with tender fried onions. Some-lifers swear by it."
	icon_state = "onionsteak"
	tastes = list("steak" = 1, "onions" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT+3)
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
/obj/item/reagent_containers/food/snacks/rogue/onionsteak/plated
	icon_state = "onionsteak_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess =  SHELFLIFE_LONG


/*	.................   Wiener Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienercabbage
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("savory sausage" = 1, "cabbage" = 1)
	name = "wiener-cabbage"
	desc = "A rich and heavy meal, only the lucky in the Regime can get their hands on such a thing."
	icon_state = "wienercabbage"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff
/obj/item/reagent_containers/food/snacks/rogue/wienercabbage/plated
	icon_state = "wienercabbage_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_EXTREME


/*	.................   Wiener & Fried potato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("savory sausage" = 1, "potato" = 1)
	name = "wiener-potato"
	desc = "Stout and nourishing."
	icon_state = "wienerpotato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato/attackby(obj/item/I, mob/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions(loc)
				qdel(I)
				qdel(src)
	else
		return ..()
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato/plated
	icon_state = "wienerpotato_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_EXTREME
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato/plated/attackby(obj/item/I, mob/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions/plated(loc)
				qdel(I)
				qdel(src)
	else
		return ..()


/*	.................   Wiener & potato & onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("savory sausage" = 1, "potato" = 1)
	name = "wiener-meal"
	desc = "Stout and nourishing."
	icon_state = "wpotonion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions/plated
	icon_state = "wpotonion_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG

/*	.................   Frybird & Tato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdtato
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("frybird" = 1, "tato" = 1)
	name = "frybird-tato"
	desc = "Hearty, comforting and rich. Everything you are not."
	icon_state = "frybirdtato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
/obj/item/reagent_containers/food/snacks/rogue/frybirdtato/plated
	icon_state = "frybirdtato_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG


/*	.................   Valerian Omelette   ................... */
/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("fried cackleberries" = 1, "cheese" = 1)
	name = "valerian omelette"
	desc = "Fried cackleberries on a bed of half-melted cheese."
	icon_state = "omelette"
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = SHELFLIFE_DECENT
/obj/item/reagent_containers/food/snacks/rogue/friedegg/tiberian/plated
	icon_state = "omelette_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG

/*	.................   Plated fryfish   ................... */
/obj/item/reagent_containers/food/snacks/rogue/fryfish/carp/plated
	desc = "Fish is the only thing most coastal settlements can afford to eat. Pity!"
	icon_state = "carpcooked_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish/plated
	desc = "Fish is the only thing most coastal settlements can afford to eat. Pity!"
	icon_state = "clownfishcooked_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/fryfish/angler/plated
	desc = "Fish is the only thing most coastal settlements can afford to eat. Pity!"
	icon_state = "anglercooked_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/fryfish/eel/plated
	desc = "Fish is the only thing most coastal settlements can afford to eat. Pity!"
	icon_state = "eelcooked_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG


/*	.................   Chicken roast   ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	desc = "A plump bird, roasted to a perfect temperature and bears a crispy skin."
	eat_effect = null
	slices_num = 0
	name = "roast bird"
	icon_state = "roastchicken"
	tastes = list("tasty birdmeat" = 1)
	cooked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	rotprocess = SHELFLIFE_DECENT
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/plated
	icon_state = "roastchicken_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG


/*	.................   Cooked rat   ................... */
/obj/item/reagent_containers/food/snacks/rogue/friedrat/plated
	desc = "No-lifer delicacy."
	icon_state = "cookedrat_plated"
	item_state = "plate_food"
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_BULKY
	bonus_reagents = list(/datum/reagent/consumable/nutriment = 2)
	trash = /obj/item/cooking/platter
	rotprocess = SHELFLIFE_LONG


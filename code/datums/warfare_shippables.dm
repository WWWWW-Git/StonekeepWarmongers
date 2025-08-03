/datum/warshippable
	var/name = "shippable"
	var/list/items = list()
	var/reinforcement = 1 // on what wave this becomes available on

/datum/warshippable/smokebombs
	name = "FIVE SMOKE BOMBS"
	items = list(/obj/item/bomb/smoke,
			/obj/item/bomb/smoke,
			/obj/item/bomb/smoke,
			/obj/item/bomb/smoke,
			/obj/item/bomb/smoke
			)

/datum/warshippable/gasbombs
	name = "FOUR GAS BOMBS"
	items = list(/obj/item/bomb/poison,
			/obj/item/bomb/poison,
			/obj/item/bomb/poison,
			/obj/item/bomb/poison
			)

/datum/warshippable/bombs
	name = "FIVE BOMBS"
	items = list(/obj/item/bomb,
			/obj/item/bomb,
			/obj/item/bomb,
			/obj/item/bomb,
			/obj/item/bomb
			)

/datum/warshippable/crownpointer
	name = "CROWN POINTER"
	items = list(/obj/item/pinpointer/crown)

/datum/warshippable/firebombs
	name = "THREE FIRE BOMBS"
	items = list(/obj/item/bomb/fire,
			/obj/item/bomb/fire,
			/obj/item/bomb/fire
			)

/datum/warshippable/woodammo
	name = "WOODEN BALL POUCHES"
	items = list(/obj/item/quiver/woodbullets,
			/obj/item/quiver/woodbullets
			)

/datum/warshippable/normalammo
	name = "LEAD BALL POUCHES"
	items = list(/obj/item/quiver/bullets,
			/obj/item/quiver/bullets
			)

/datum/warshippable/cannonballs
	name = "LARGE LEAD BALLS"
	items = list(/obj/item/ammo_casing/caseless/rogue/cball,
			/obj/item/ammo_casing/caseless/rogue/cball,
			/obj/item/ammo_casing/caseless/rogue/cball,
			/obj/item/ammo_casing/caseless/rogue/cball
			)

/datum/warshippable/bombard
	name = "BOMBARDIER"
	items = list(/obj/structure/bombard)

/datum/warshippable/cannon
	name = "BARKSTONE"
	items = list(/obj/structure/cannon)

/datum/warshippable/maxim
	name = "THE MAXWELL"
	items = list(/obj/structure/maxim)

/datum/warshippable/caltrops
	name = "TETSUBISHI CALTROPS"
	items = list(/obj/item/rogue/caltrop,
			/obj/item/rogue/caltrop,
			/obj/item/rogue/caltrop
			)

/datum/warshippable/sandbags
	name = "TEN SAND BAGS"
	items = list(/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit,
			/obj/item/rogue/sandbagkit
			)

/datum/warshippable/wood
	name = "WOOD SUPPLIES"
	items = list(/obj/structure/closet/crate/chest/woodsupps)

/obj/structure/closet/crate/chest/woodsupps/PopulateContents()
	for(var/i = 0 to 10)
		new /obj/item/grown/log/tree(src)

/datum/warshippable/stone
	name = "STONE SUPPLIES"
	items = list(/obj/structure/closet/crate/chest/stonesupps)

/obj/structure/closet/crate/chest/stonesupps/PopulateContents()
	for(var/i = 0 to 10)
		new /obj/item/natural/stone(src)

/datum/warshippable/explodabarrel
	name = "EXPLODABARRELS"
	items = list(/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel,
			/obj/structure/fluff/explodabarrel
			)
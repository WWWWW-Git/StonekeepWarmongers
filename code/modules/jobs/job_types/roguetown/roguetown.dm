/datum/job/roguetown
	display_order = JOB_DISPLAY_ORDER_CAPTAIN

/datum/job/roguetown/New()
	. = ..()
	if(give_bank_account)
		for(var/X in GLOB.peasant_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.serf_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.church_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.garrison_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.noble_positions)
			peopleiknow += X
			peopleknowme += X
		for(var/X in GLOB.apprentices_positions)
			peopleiknow += X
			peopleknowme += X

/datum/outfit/job/roguetown
	uniform = null
	id = null
	ears = null
	belt = null
	back = null
	shoes = null
	box = null
	backpack = null
	satchel  = null
	duffelbag = null
	/// List of patrons we are allowed to use
	var/list/allowed_patrons
	/// Default patron in case the patron is not allowed
	var/datum/patron/default_patron

/datum/outfit/job/roguetown/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H.mind)
		if(H.gender == FEMALE)
			H.mind.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			H.mind.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		if(H.dna)
			if(H.dna.species)
				if(H.dna.species.name in list("Elf"))
					H.mind.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.underwear_color = null
	H.update_body()

/datum/outfit/job/roguetown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	var/datum/game_mode/warmongers/W = SSticker.mode

	var/datum/job/roguetown/J = SSjob.GetJob(H.job)
	H.client?.fit_viewport()
	
	if(J?.tutorial)
		to_chat(H, "<span class='info'><b>[uppertext(J.title)]</b></span>")
		to_chat(H, "<span class='info'>[J.tutorial]</span>")
		if(H.warfare_faction == RED_WARTEAM && (istype(W.warmode, /datum/warmode/assault) || istype(W.warmode, /datum/warmode/lords)) && !SSwarmongers.warfare_ready_to_die)
			to_chat(H, "<span class='notice'>YOU'RE PLAYING HEARTFELT! REMEMBER TO BUILD DEFENSES OR YOUR DEATH IS GUARANTEED!</span>")

	for(var/list_key in SStriumphs.post_equip_calls)
		var/datum/triumph_buy/thing = SStriumphs.post_equip_calls[list_key]
		thing.on_activate(H)
		
	var/obj/item/clothing/suit/U = H.wear_shirt
	if(check_badminlist(H.ckey)) // being a badmin takes priority over being a veteran
		U.attach_accessory(new /obj/item/clothing/accessory/medal/badmin(U))
	else if(H.client?.holder)
		U.attach_accessory(new /obj/item/clothing/accessory/medal/gold/admin(U))
	if(check_bypasslist(H.ckey))
		U.attach_accessory(new /obj/item/clothing/accessory/medal/silver/veteran(U))
	return

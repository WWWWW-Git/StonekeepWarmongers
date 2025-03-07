/obj/structure/roguemachine/atm
	name = "MEISTER"
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32

/obj/structure/roguemachine/atm/attack_hand(mob/user)
	to_chat(user, "<span class='warning'>The machine only hisses at me. It does not work.</span>")
	playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
	/*
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H in SStreasury.bank_accounts)
		var/amt = SStreasury.bank_accounts[H]
		if(!amt)
			say("Your balance is nothing.")
			return
		if(amt < 0)
			say("Your balance is NEGATIVE.")
			return
		var/list/choicez = list()
		if(amt > 10)
			choicez += "GOLD"
		if(amt > 5)
			choicez += "SILVER"
		if(amt > 1) choicez += "BRONZE"
		var/selection = input(user, "Make a Selection", src) as null|anything in choicez
		if(!selection)
			return
		amt = SStreasury.bank_accounts[H]
		var/mod = 1
		if(selection == "GOLD")
			mod = 10
		if(selection == "SILVER")
			mod = 5
		if(selection == "BRONZE") mod = 1
		var/coin_amt = input(user, "There is [SStreasury.treasury_value] mammon in the treasury. You may withdraw [amt/mod] [selection] COINS from your account.", src) as null|num
		coin_amt = round(coin_amt)
		if(coin_amt < 1)
			return
		amt = SStreasury.bank_accounts[H]
		if(!Adjacent(user))
			return
		if((coin_amt*mod) > amt)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SStreasury.withdraw_money_account(coin_amt*mod, H))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		budget2change(coin_amt*mod, user, selection)
	else
		to_chat(user, "<span class='warning'>The machine bites my finger.</span>")
		icon_state = "atm-b"
		H.flash_fullscreen("redflash3")
		playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		SStreasury.create_bank_account(H)
		spawn(5)
			say("New account created.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	*/

/*
/obj/structure/roguemachine/atm/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
*/

/obj/structure/roguemachine/atm/attackby(obj/item/P, mob/user, params)
	to_chat(user, "<span class='warning'>Now that's just silly, no?</span>")
	return
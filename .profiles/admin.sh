#!/usr/bin/env bash

#######################################################################################
# ███████ ██ ███    ██  █████  ██          ██████  ███████  █████  ██      ███    ███ #
# ██      ██ ████   ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ████  ████ #
# █████   ██ ██ ██  ██ ███████ ██          ██████  █████   ███████ ██      ██ ████ ██ #
# ██      ██ ██  ██ ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ██  ██  ██ #
# ██      ██ ██   ████ ██   ██ ███████     ██   ██ ███████ ██   ██ ███████ ██      ██ #
#######################################################################################
# This is a Final Realm profile settings file. DO NOT TOUCH.

###################################################
# [ User Account & Settings ]
###################################################

export USERNAME='admin'
export PASSWORD='testing'
export ADMIN=0 # Set to 1 to enable Admin access

###################################################
# [ Temporary Variables ]
###################################################
export cost=0
export cost1=0
export gcho=0
export echo=0
export e2cho=0
export e1=0
export npc_damage=0
export ls1=0
export killcount=0
export ls2=0
export la1=0
export la2=0
export hitpoints=100
export original_hitpoints=100
export armor_type='None'
export sword_type='None'
export sword_kind='Hand'
export buyword1='hi'
export buyword2='hi'
export current_level=1
export aan='a'
export bank_gold=0
export sword_choice='hi'
export sword_choice2='hi'
export sword_choice3='hi'
export sword_exist='hi'
export sword_price=0
export armor_choice='hi'
export armor_choice2='Armor'
export armor_price=0

###################################################
# [ Player Statistics ]
###################################################

# [ Player Statistics ] #
export player_xp=0
export xp_until_next_level=500
export original_xp=500
export money=505
export key=0
export damage=0
export total_level=13

# [ Begging Skill Stats ] #
export begging_level=1
export begging_xp_target=100
export begging_xp_total=45

# [ Thieving Skill Stats ] #
export thieving_level=1
export thieving_xp_target=100
export thieving_xp_total=36

# [ Hunting Skill Stats ] #
export hunting_level=3
export hunting_xp_target=100
export hunting_xp_total=80

# [ Fishing Skill Stats ] #
export fishing_level=1
export fishing_xp_target=100
export fishing_xp_total=30

# [ Farming Skill Stats ] #
export farming_level=1
export farming_xp_target=100
export farming_xp_total=31

# [ Tailoring Skill Stats ] #
export tailoring_level=3
export tailoring_xp_target=100
export tailoring_xp_total=85

# [ Cooking Skill Stats ] #
export cooking_level=1
export cooking_xp_target=100
export cooking_xp_total=41

# [ Woodcutting Skill Stats ] #
export woodcutting_level=1
export woodcutting_xp_target=100
export woodcutting_xp_total=38

# [ Mining Skill Stats ] #
export mining_level=1
export mining_xp_target=100
export mining_xp_total=35

# [ Smithing Skill Stats ] #
export smithing_level=1
export smithing_xp_target=100
export smithing_xp_total=33

###################################################
# [ Banking & Inventory ]
###################################################

# [ Bank ] #
export bank_1_gold=0
export bank_1_status='Open'
export bank_2_gold=0
export bank_2_status='Open'
export bank_3_gold=0
export bank_3_status='Open'
export bank_4_gold=0
export bank_4_status='Open'
export bank_5_gold=0
export bank_5_status='Open'

# [ Mundane Items Inventory ] #
export gold_mail=0
export bone=0
export dragon_hide=0
export runic_tablet=0
export clothes=51
export food=50
export cooked_food=0
export bait=0
export potion=0
export ingot=0
export seed=0
export bow=0
export fur=0
export gem=0
export log=0
export ore=0
export magical_orb=0

# Only skill that doesn't require a kit is begging, which no longer works
# once you earn enough gold for a fishing or hunting kit (100 gold)
# [ Skill Kits Inventory ] #
export kit_thieving=true
export kit_hunting=true
export kit_fishing=true
export kit_farming=true
export kit_tailoring=true
export kit_cooking=true
export kit_woodcutting=true
export kit_mining=true
export kit_smithing=true

# [ Armor Inventory ] #
export armor_1=0
export armor_2=0
export armor_3=0
export armor_4=0
export armor_5=0
export armor_6=0
export armor_7=0
export armor_8=0
export armor_9=0
export armor_10=0
export armor_11=0
export armor_12=0
export magic_armor_1=0
export magic_armor_2=0
export magic_armor_3=0
export magic_armor_4=0
export magic_armor_5=0
export magic_armor_6=0
export magic_armor_7=0
export magic_armor_8=0
export magic_armor_9=0
export magic_armor_10=0

# [ Swords Inventory ] #
export sword_1=0
export sword_2=0
export sword_3=0
export sword_4=0
export sword_5=0
export sword_6=0
export sword_7=0
export sword_8=0
export sword_9=0
export sword_10=0
export sword_11=0
export sword_12=0
export magic_sword_1=0
export magic_sword_2=0
export magic_sword_3=0
export magic_sword_4=0
export magic_sword_5=0
export magic_sword_6=0
export magic_sword_7=0
export magic_sword_8=0
export magic_sword_9=0
export magic_sword_10=0

###################################################
# [ Shop Prices ]
###################################################

# [ Mundane Items Pricing ] #
export price_gold_mail=300
export price_bone=550
export price_dragon_hide=750
export price_runic_tablet=250
export price_potion=200
export price_food=100
export price_ingot=473
export price_seed=150
export price_rotten_food=100
export price_bait=2
export price_fur=200
export price_ore=500
export price_log=275
export price_gem=1000
export price_bow=713
export price_magical_orb=15000

# [ Skill Kits Pricing ] # 
export price_kit_thieving=50
export price_kit_hunting=100
export price_kit_fishing=100
export price_kit_farming=150
export price_kit_tailoring=30
export price_kit_cooking=100
export price_kit_woodcutting=200
export price_kit_mining=300
export price_kit_smithing=350

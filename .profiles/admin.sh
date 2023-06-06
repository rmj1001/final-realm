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

export PLAYERNAME='admin'
export PASSWORD='testing'
export ADMIN=0 # Set to 1 to enable Admin access

###################################################
# [ Player Statistics ]
###################################################

# [ Player Statistics ] #
export player_xp=0
export xp_until_next_level=500
export original_xp=500
export money=470
export key=0
export damage=0
export total_level=13

# [ Begging Skill Stats ] #
export begging_level=6
export begging_xp_target=100
export begging_xp_total=85

# [ Thieving Skill Stats ] #
export thieving_level=4
export thieving_xp_target=100
export thieving_xp_total=5

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
export tailoring_level=4
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

# Only skill that doesn't require a kit is begging, which no longer works
# once you earn enough gold for a fishing or hunting kit (100 gold)
# [ Skill Kits Inventory ] #
export kit_thieving='Owned'
export kit_hunting='Owned'
export kit_fishing='Owned'
export kit_farming='Owned'
export kit_tailoring='Owned'
export kit_cooking='Owned'
export kit_woodcutting='Owned'
export kit_mining='Owned'
export kit_smithing='Owned'

# [ Mundane Items Inventory ] #
export goblin_mail=0
export bone=0
export dragon_hide=0
export runic_tablet=0
export clothes=71
export food=50
export cooked_food=0
export bait=0
export potion=0
export ingot=0
export seed=0
export bow=0
export fur=10
export gem=0
export log=0
export ore=0
export magical_orb=0

# [ Armor ] #
export armor_name='None'
export armor_type='None'
export armor_class=3 # Must be met or exceeded to hit

# [ Weapon ] #
export weapon_name='Your Hand'
export weapon_type='None'
export weapon_hit_dc=3 # Must be met or exceeded to hit
export weapon_dmg=3 # Damage dealt when hit

# [ Magic Wand ] #
export magic_wand_name='None'
export magic_wand_type='None' # Elemental damage
export magic_wand_hit_dc=0 # Must be met or exceeded to hit
export magic_wand_dmg=0 # Damage dealt when hit

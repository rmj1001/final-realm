#!/usr/bin/env bash

###################################################
# [ Sourcing & Maintenance ] #
###################################################
. ./.api.sh

TITLE "Final Realm by Roy"
EXIT=1

###################################################
# [ Prices for Mundane Items ] #
###################################################
export price_gold_mail=300
export price_bone=550
export price_dragon_hide=750
export price_runic_tablet=250
export price_potion=200
export price_food=100
export price_ingot=473
export price_seed=150
export price_rfood=100
export price_bait=2
export price_fur=200
export price_ore=500
export price_log=275
export price_gem=1000
export price_bow=713
export price_magical_orb=15000

###################################################
# [ Handling SIGINT ] #
###################################################
function ctrl_c() {
    PRINT "\n"
    [[ -z "${scriptNumber}" ]] && PRINT "Canceling.\n"
    clear
    exit 0
}

trap ctrl_c INT

###################################################
# [ Screen Header Text ] #
###################################################
function HEADER() {
    clear
    echo "                                                                                    "
    echo "███████ ██ ███    ██  █████  ██          ██████  ███████  █████  ██      ███    ███ "
    echo "██      ██ ████   ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ████  ████ "
    echo "█████   ██ ██ ██  ██ ███████ ██          ██████  █████   ███████ ██      ██ ████ ██ "
    echo "██      ██ ██  ██ ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ██  ██  ██ "
    echo "██      ██ ██   ████ ██   ██ ███████     ██   ██ ███████ ██   ██ ███████ ██      ██ "
    echo "                                                                                    "
    echo
}

###################################################
# [ Create & Save Profile ] #
###################################################

# TODO: Rename variables
function save_profile() {
    # Append profile file
    APPEND() {
        PRINT "${1}" >>"${PROFILE_FILE}"
    }

    echo "#" >"${PROFILE_FILE}"
    APPEND "# ███████ ██ ███    ██  █████  ██          ██████  ███████  █████  ██      ███    ███ "
    APPEND "# ██      ██ ████   ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ████  ████ "
    APPEND "# █████   ██ ██ ██  ██ ███████ ██          ██████  █████   ███████ ██      ██ ████ ██ "
    APPEND "# ██      ██ ██  ██ ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ██  ██  ██ "
    APPEND "# ██      ██ ██   ████ ██   ██ ███████     ██   ██ ███████ ██   ██ ███████ ██      ██ "
    APPEND "#"
    APPEND "#"
    APPEND "# This is a Final Realm profile settings file. DO NOT TOUCH."
    APPEND
    APPEND "# [ User Account ] #"
    APPEND "export USERNAME='${USERNAME}'"
    APPEND "export PASSWORD='${PASSWORD}'"
    APPEND ""
    APPEND "# [ Bank ] #"
    APPEND "export bank_1_gold=${bank_1_gold:-0}"
    APPEND "export bank_1_status='${bank_1_status:-Open}'"
    APPEND "export bank_2_gold=${bank_2_gold:-0}"
    APPEND "export bank_2_status='${bank_2_status:-Open}'"
    APPEND "export bank_3_gold=${bank_3_gold:-0}"
    APPEND "export bank_3_status='${bank_3_status:-Open}'"
    APPEND "export bank_4_gold=${bank_4_gold:-0}"
    APPEND "export bank_4_status='${bank_4_status:-Open}'"
    APPEND "export bank_5_gold=${bank_5_gold:-0}"
    APPEND "export bank_5_status='${bank_5_status:-Open}'"
    APPEND ""
    APPEND "# [ Temporary Variables ] #"
    APPEND "export cost='--'"
    APPEND "export cost1='--'"
    APPEND "export gcho='--'"
    APPEND "export echo='--'"
    APPEND "export e2cho='--'"
    APPEND "export e1='--'"
    APPEND "export npc_damage=0"
    APPEND "export ls1=0"
    APPEND "export killcount=0"
    APPEND "export ls2=0"
    APPEND "export la1=0"
    APPEND "export la2=0"
    APPEND "export hitpoints=100"
    APPEND "export original_hitpoints=100"
    APPEND "export armor_type='No'"
    APPEND "export sword_type='Your'"
    APPEND "export sword_kind='hand'"
    APPEND "export buyword1='hi'"
    APPEND "export buyword2='hi'"
    APPEND "export current_lvl=1"
    APPEND "export aan='a'"
    APPEND "export bank_gold=0"
    APPEND "export sword_choice='hi'"
    APPEND "export sword_choice2='hi'"
    APPEND "export sword_choice3='hi'"
    APPEND "export sword_exist='hi'"
    APPEND "export sword_price=0"
    APPEND "export armor_choice='hi'"
    APPEND "export armor_choice2='Armor'"
    APPEND "export armor_price=0"
    APPEND ""
    APPEND "# [ Player Statistics ] #"
    APPEND "export player_xp=0"
    APPEND "export xp_until_next_lvl=500"
    APPEND "export original_xp=500"
    APPEND "export money=100"
    APPEND "export key=0"
    APPEND "export damage=0"
    APPEND "export total_level=13"
    APPEND ""
    APPEND "# [ Woodcutting Skill Stats ] #"
    APPEND "export Woodcutting_lvl=1"
    APPEND "export Woodcutting_xp_remaining=100"
    APPEND "export Woodcutting_xp_gained=38"
    APPEND "export Woodcutting_current_xp=0"
    APPEND "export Woodcutting_xp_left=100"
    APPEND ""
    APPEND "# [ Cooking Skill Stats ] #"
    APPEND "export Cook_lvl=1"
    APPEND "export Cook_xp_remaining=100"
    APPEND "export Cook_xp_gained=41"
    APPEND "export Cook_current_xp=0"
    APPEND "export Cook_xp_left=100"
    APPEND ""
    APPEND "# [ Fishing Skill Stats ] #"
    APPEND "export Fishing_lvl=1"
    APPEND "export Fishing_xp_remaining=100"
    APPEND "export Fishing_xp_gained=30"
    APPEND "export Fishing_current_xp=0"
    APPEND "export Fishing_xp_left=100"
    APPEND ""
    APPEND "# [ Mining Skill Stats ] #"
    APPEND "export Mining_lvl=1"
    APPEND "export Mining_xp_remaining=100"
    APPEND "export Mining_xp_gained=35"
    APPEND "export Mining_current_xp=0"
    APPEND "export Mining_xp_left=100"
    APPEND ""
    APPEND "# [ Smithing Skill Stats ] #"
    APPEND "export Smithing_lvl=1"
    APPEND "export Smithing_xp_remaining=100"
    APPEND "export Smithing_xp_gained=33"
    APPEND "export Smithing_current_xp=0"
    APPEND "export Smithing_xp_left=100"
    APPEND ""
    APPEND "# [ Thieving Skill Stats ] #"
    APPEND "export Thieving_lvl=1"
    APPEND "export Thieving_xp_remaining=100"
    APPEND "export Thieving_xp_gained=36"
    APPEND "export Thieving_current_xp=0"
    APPEND "export Thieving_xp_left=100"
    APPEND ""
    APPEND "# [ Player Inventory ] #"
    APPEND "export dr=0" # TODO: ????
    APPEND "export gold_mail=0"
    APPEND "export bone=0"
    APPEND "export dragon_hide=0"
    APPEND "export runic_tablet=0"
    APPEND "export food=0"
    APPEND "export rotten_food=0"
    APPEND "export bait=0"
    APPEND "export ea=None" # TODO: ????
    APPEND "export potion=0"
    APPEND "export ingot=0"
    APPEND "export seed=0"
    APPEND "export bow=0"
    APPEND "export fur=0"
    APPEND "export gem=0"
    APPEND "export log=0"
    APPEND "export ore=0"
    APPEND "export magical_orb=0"
    APPEND "export axxx=0" # TODO: ????
    APPEND ""
    APPEND "# [ Armor ] #"
    APPEND "export armor_1=0"
    APPEND "export armor_2=0"
    APPEND "export armor_3=0"
    APPEND "export armor_4=0"
    APPEND "export armor_5=0"
    APPEND "export armor_6=0"
    APPEND "export armor_7=0"
    APPEND "export armor_8=0"
    APPEND "export armor_9=0"
    APPEND "export armor_10=0"
    APPEND "export armor_11=0"
    APPEND "export armor_12=0"
    APPEND "export magic_armor_1=0"
    APPEND "export magic_armor_2=0"
    APPEND "export magic_armor_3=0"
    APPEND "export magic_armor_4=0"
    APPEND "export magic_armor_5=0"
    APPEND "export magic_armor_6=0"
    APPEND "export magic_armor_7=0"
    APPEND "export magic_armor_8=0"
    APPEND "export magic_armor_9=0"
    APPEND "export magic_armor_10=0"
    APPEND ""
    APPEND "# [ Swords ] #"
    APPEND "export sword_1=0"
    APPEND "export sword_2=0"
    APPEND "export sword_3=0"
    APPEND "export sword_4=0"
    APPEND "export sword_5=0"
    APPEND "export sword_6=0"
    APPEND "export sword_7=0"
    APPEND "export sword_8=0"
    APPEND "export sword_9=0"
    APPEND "export sword_10=0"
    APPEND "export sword_11=0"
    APPEND "export sword_12=0"
    APPEND "export magic_sword_1=0"
    APPEND "export magic_sword_2=0"
    APPEND "export magic_sword_3=0"
    APPEND "export magic_sword_4=0"
    APPEND "export magic_sword_5=0"
    APPEND "export magic_sword_6=0"
    APPEND "export magic_sword_7=0"
    APPEND "export magic_sword_8=0"
    APPEND "export magic_sword_9=0"
    APPEND "export magic_sword_10=0"
    APPEND ""
    APPEND "# [ Pricing ] #"
    APPEND "export price_gold_mail=300"
    APPEND "export price_bone=550"
    APPEND "export price_dragon_hide=750"
    APPEND "export price_runic_tablet=250"
    APPEND "export price_potion=200"
    APPEND "export price_food=100"
    APPEND "export price_ingot=473"
    APPEND "export price_seed=150"
    APPEND "export price_rfood=100"
    APPEND "export price_bait=2"
    APPEND "export price_fur=200"
    APPEND "export price_ore=500"
    APPEND "export price_log=275"
    APPEND "export price_gem=1000"
    APPEND "export price_bow=713"
    APPEND "export price_magical_orb=15000"
}

###################################################
# [ First Menu ] #
# This is what is first seen when script is run
###################################################
function first_menu() {
    while [[ $EXIT -ne 0 ]]; do
        HEADER
        PRINT "Welcome to final realm!"
        PRINT "Type in the number for the action to perform."
        PRINT
        PRINT "1. Login"
        PRINT "2. Create an Account"
        PRINT "3. Exit"
        PRINT
        LINES
        read -r -p "ID > " scriptNumber
        LINES

        case "$(LOWERCASE ${scriptNumber})" in

        1 | 'login')
            login
            ;;

        2 | 'create an account')
            register
            ;;

        3 | 'exit')
            clear
            exit 0
            ;;

        *)
            PRINT
            [[ -z "${scriptNumber}" ]] && {
                PRINT "Canceling."
                PAUSE
                continue
            }

            [[ -n "${scriptNumber}" ]] && {
                PRINT "Invalid option '${scriptNumber}'. Aborting."
                PAUSE
                continue
            }
            ;;
        esac
    done
}

###################################################
# [ Login Screen ] #
###################################################
function login() {
    HEADER
    read -r -p "Username > " USERNAME

    export PROFILE_FILE="./.profiles/$(LOWERCASE ${USERNAME}).sh"

    # If profile file does not exist, cancel login.
    [[ ! -e "${PROFILE_FILE}" ]] && {
        PRINT "\nProfile '${USERNAME}' does not exist."
        PAUSE
        first_menu
    }

    # Source profile file
    . "${PROFILE_FILE}"

    read -r -s -p "Password (cAsE sEnsiTivE) > " password
    PRINT

    # If password doesn't match, cancel login.
    [[ ! "${password}" == "${PASSWORD}" ]] && {
        PRINT "\nPassword does not match."
        PAUSE
        first_menu
    }

    PRINT "\nWelcome to final realm, ${USERNAME}."
    PAUSE

    game_menu
}

###################################################
# [ Registration Screen ] #
###################################################
function register() {
    HEADER
    read -r -p "Username > " USERNAME

    export PROFILE_FILE="./.profiles/$(LOWERCASE ${USERNAME}).sh"

    # If profile file exists, cancel registration.
    [[ -e "${PROFILE_FILE}" ]] && {
        PRINT "\nProfile '${USERNAME}' already exists."
        PAUSE
        first_menu
    }

    read -r -s -p "Password (cAsE sEnsiTivE) > " password1
    PRINT
    read -r -s -p "Confirm Password > " password2
    PRINT

    # If confirmed password doesn't match actual password, cancel registration.
    [[ "${password1}" != "${password2}" ]] && {
        PRINT "\nDifferent passwords given. Cancelling."
        PAUSE
        first_menu
    }

    PASSWORD="${password1}"

    # Creates the new profile file
    save_profile

    # Confirmation
    PRINT "\nProfile '${USERNAME}' created!"
    PAUSE

    first_menu
}

###################################################
# [ Initialize Terminal UI ] #
###################################################
first_menu

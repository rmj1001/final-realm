#!/usr/bin/env bash

###################################################
# [ Important Functions ] #
###################################################
# Description: Replacement for 'echo'
# Usage:  PRINT "text"
# Returns: string
function PRINT() {
    printf "%b\n" "${@}"
}

# Description: 'echo' replacement w/o newline
# Usage:  NPRINT "text"
# Returns: string
function NPRINT() {
    printf "%b" "${@}"
}

# Description: Pauses script execution until the user presses ENTER
# Usage:  PAUSE
# Returns: int
function PAUSE() {
    NPRINT "\nPress <ENTER> to continue..."
    read -r
}

# Description: Sets the terminal window title
# Usage:  TITLE "test"
# Returns: void
function TITLE() {
    NPRINT "\033]2;${1}\a"
}

# Description: Generate a random number from 1 to the specified maximum
# Usage:  RANDOM_NUM 100
# Returns: int
function RANDOM_NUM() {
    eval "shuf -i 1-${1} -n 1"
}

# Description: Converts a string to all api.std.failMsg characters
# Usage:  name="$(LOWERCASE $name)"
# Returns: string
function LOWERCASE() {
    NPRINT "${1}" | tr "[:upper:]" "[:lower:]"
}

# Description: Converts a string to all UPPERCASE characters
# Usage:  name="$(UPPERCASE $name)"
# Returns: string
function UPPERCASE() {
    NPRINT "${1}" | tr "[:lower:]" "[:upper:]"
}

# Description: Trim all leading/trailing whitespace from a string
# Usage:  TRIM "   this      "
# Returns: string
function TRIM() {
    local var="$*"

    # remove leading whitespace characters
    var="${var##*( )}"

    # remove trailing whitespace characters
    var="${var%%*( )}"

    # Return trimmed string
    printf '%s' "$var"
}

function LINES() {
    for ((i = 0; i < COLUMNS; ++i)); do printf -; done
    PRINT
}

# Description: Find the path for a command
# Usage:  WHICH <cmd>
# Returns: string
function WHICH() {
    command -v "${@}"
}

# Description: Run code silently
# Usage:  SILENTRUN <command>
# Returns: return exit code
function SILENTRUN() {
    "$@" >/dev/null 2>&1
}

# Description: Run code silently and disown it
# Usage:  ASYNC <command>
# Returns: void
function ASYNC() {
    "$@" >/dev/null 2>&1 &
    disown
}

# Description: Check to see if input is 'yes' or empty
# Usage:  CHECK_YES <var>
# Returns: return code (0 for yes/empty, 1 for no)
function CHECK_YES() {
    [[ "$1" =~ [yY][eE]?[sS]? ]] && return 0
    [[ -z "$1" ]] && return 0

    return 1
}

# Description: Check to see if input is 'no' or empty
# Usage:  CHECK_NO <var>
# Returns: return code (0 for no/empty, 1 for yes)
function CHECK_NO() {
    [[ "$1" =~ [nN][oO]? ]] && return 0
    [[ -n "${1}" ]] && return 0

    return 1
}

# Description: Checks to see if input is a number
# Usage:  IS_NUMBER <var>
# Returns: return code (0 for yes)
function IS_NUMBER() {
    [[ "$1" =~ [0-9]+ ]] && return 0
    return 1
}

# Description: Print current time & date
# Usage: TIMESTAMP [-m/--multiline]?
# Returns: string
function TIMESTAMP() {
    local timestamp
    timestamp="$(date +"%I:%M%P %m/%d/%Y")"

    # Multi-line timestamp flag
    [[ "${1}" == "-m" || "${1}" == "--multiline" ]] && timestamp="$(date +"%I:%M%P")\n$(date +"%m/%d/%Y")"

    PRINT "${timestamp}"
}

###################################################
# [ Handling SIGINT ] #
###################################################
function stop_game() {
    [[ -n "${PLAYERNAME}" ]] && save_profile

    HEADER
    PRINT "Thanks for playing final realm!!!!!"
    PAUSE
    clear
    [[ "${1}" == "--logout" ]] || exit 0
    first_menu
}

function ctrl_c() {
    stop_game
}

trap ctrl_c INT

###################################################
# [ Handling script arguments ] #
###################################################
while [[ $# -gt 0 ]]; do

    case "$(LOWERCASE "${1}")" in

    -d | --debug)
        set -x
        shift
        ;;

    \? | -h | --help)
        PRINT "Final Realm by Roy"
        PRINT ""
        PRINT "Arguments:"
        PRINT "-d, --debug\t\tRun this script in debugging"
        PRINT "-h, --help\t\tShow this prompt"
        exit 0
        ;;

    *)
        PRINT "Invalid argument: '${1}'."
        exit 1
        ;;

    esac

done

###################################################
# [ Screen Header Text ] #
###################################################
function HEADER() {
    [[ ! "${1}" == "--no-clear" ]] && clear
    PRINT "#######################################################################################"
    PRINT "# ███████ ██ ███    ██  █████  ██          ██████  ███████  █████  ██      ███    ███ #"
    PRINT "# ██      ██ ████   ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ████  ████ #"
    PRINT "# █████   ██ ██ ██  ██ ███████ ██          ██████  █████   ███████ ██      ██ ████ ██ #"
    PRINT "# ██      ██ ██  ██ ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ██  ██  ██ #"
    PRINT "# ██      ██ ██   ████ ██   ██ ███████     ██   ██ ███████ ██   ██ ███████ ██      ██ #"
    PRINT "#######################################################################################"
    PRINT
}

###################################################
# [ Sourcing & Maintenance ] #
###################################################
EXIT=1
export PROFILES="./.profiles"
export ALLOW_ADMIN=1 # Default value, possibly overwritten in ENV

###################################################
# [ Shop Prices ] #
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

###################################################
# [ Profile Manipulation ] #
###################################################

# Generate the path for a profile
function profile_path() {
    PROFILE_FILE="${PROFILES}/$(LOWERCASE ${1}).sh"
    export PROFILE_FILE
}

# Check to see if a profile already exists
function profile_exists() {
    profile_path "${1}"

    # If profile file does not exist, cancel login.
    [[ -e "${PROFILE_FILE}" ]] && {
        return 0
    }

    return 1
}

# Source a profile in bash if it already exists
function open_profile() {
    # If profile file does not exist, cancel login.
    profile_exists "${1}" || {
        PRINT "\nProfile '${1}' does not exist."
        PAUSE
        return 1
    }

    # Source profile file
    profile_path "${1}"

    # shellcheck source=/dev/null
    . "${PROFILE_FILE}"

    return 0
}

function save_profile() {
    # Append profile file

    [[ "${PLAYERNAME}" == "" ]] && return 1

    PRINT "#!/usr/bin/env bash" >"${PROFILE_FILE}"

    APPEND() {
        PRINT "${1}" >>"${PROFILE_FILE}"
    }

    APPEND
    APPEND "$(HEADER --no-clear)"
    APPEND "# This is a Final Realm profile settings file. DO NOT TOUCH."
    APPEND
    APPEND "###################################################"
    APPEND "# [ User Account & Settings ]"
    APPEND "###################################################"
    APPEND
    APPEND "export PLAYERNAME='${PLAYERNAME}'"
    APPEND "export PASSWORD='${PASSWORD}'"
    APPEND "export ADMIN=${ADMIN:-0} # Set to 1 to enable Admin access"
    APPEND ""
    APPEND "###################################################"
    APPEND "# [ Player Statistics ]"
    APPEND "###################################################"
    APPEND ""
    APPEND "# [ Player Statistics ] #"
    APPEND "export player_xp=${player_xp:-0}"
    APPEND "export xp_until_next_level=${xp_until_next_level:-500}"
    APPEND "export original_xp=${original_xp:-500}"
    APPEND "export money=${money:-0}"
    APPEND "export key=${key:-0}"
    APPEND "export damage=${damage:-0}"
    APPEND "export total_level=${total_level:-13}"
    APPEND ""
    APPEND "# [ Begging Skill Stats ] #"
    APPEND "export begging_level=${begging_level:-1}"
    APPEND "export begging_xp_target=${begging_xp_target:-100}"
    APPEND "export begging_xp_total=${begging_xp_total:-45}"
    APPEND ""
    APPEND "# [ Thieving Skill Stats ] #"
    APPEND "export thieving_level=${thieving_level:-1}"
    APPEND "export thieving_xp_target=${thieving_xp_target:-100}"
    APPEND "export thieving_xp_total=${thieving_xp_total:-36}"
    APPEND ""
    APPEND "# [ Hunting Skill Stats ] #"
    APPEND "export hunting_level=${hunting_level:-1}"
    APPEND "export hunting_xp_target=${hunting_xp_target:-100}"
    APPEND "export hunting_xp_total=${hunting_xp_total:-30}"
    APPEND ""
    APPEND "# [ Fishing Skill Stats ] #"
    APPEND "export fishing_level=${fishing_level:-1}"
    APPEND "export fishing_xp_target=${fishing_xp_target:-100}"
    APPEND "export fishing_xp_total=${fishing_xp_total:-30}"
    APPEND ""
    APPEND "# [ Farming Skill Stats ] #"
    APPEND "export farming_level=${farming_level:-1}"
    APPEND "export farming_xp_target=${farming_xp_target:-100}"
    APPEND "export farming_xp_total=${farming_xp_total:-31}"
    APPEND ""
    APPEND "# [ Tailoring Skill Stats ] #"
    APPEND "export tailoring_level=${tailoring_level:-1}"
    APPEND "export tailoring_xp_target=${tailoring_xp_target:-100}"
    APPEND "export tailoring_xp_total=${tailoring_xp_total:-31}"
    APPEND ""
    APPEND "# [ Cooking Skill Stats ] #"
    APPEND "export cooking_level=${cooking_level:-1}"
    APPEND "export cooking_xp_target=${cooking_xp_target:-100}"
    APPEND "export cooking_xp_total=${cooking_xp_total:-41}"
    APPEND ""
    APPEND "# [ Woodcutting Skill Stats ] #"
    APPEND "export woodcutting_level=${woodcutting_level:-1}"
    APPEND "export woodcutting_xp_target=${woodcutting_xp_target:-100}"
    APPEND "export woodcutting_xp_total=${woodcutting_xp_total:-38}"
    APPEND ""
    APPEND "# [ Mining Skill Stats ] #"
    APPEND "export mining_level=${mining_level:-1}"
    APPEND "export mining_xp_target=${mining_xp_target:-100}"
    APPEND "export mining_xp_total=${mining_xp_total:-35}"
    APPEND ""
    APPEND "# [ Smithing Skill Stats ] #"
    APPEND "export smithing_level=${smithing_level:-1}"
    APPEND "export smithing_xp_target=${smithing_xp_target:-100}"
    APPEND "export smithing_xp_total=${smithing_xp_total:-33}"
    APPEND ""
    APPEND "###################################################"
    APPEND "# [ Banking & Inventory ]"
    APPEND "###################################################"
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
    APPEND "# Only skill that doesn't require a kit is begging, which no longer works"
    APPEND "# once you earn enough gold for a fishing or hunting kit (100 gold)"
    APPEND "# [ Skill Kits Inventory ] #"
    APPEND "export kit_thieving='${kit_thieving:-Not Owned}'"
    APPEND "export kit_hunting='${kit_hunting:-Not Owned}'"
    APPEND "export kit_fishing='${kit_fishing:-Not Owned}'"
    APPEND "export kit_farming='${kit_farming:-Not Owned}'"
    APPEND "export kit_tailoring='${kit_tailoring:-Not Owned}'"
    APPEND "export kit_cooking='${kit_cooking:-Not Owned}'"
    APPEND "export kit_woodcutting='${kit_woodcutting:-Not Owned}'"
    APPEND "export kit_mining='${kit_mining:-Not Owned}'"
    APPEND "export kit_smithing='${kit_smithing:-Not Owned}'"
    APPEND ""
    APPEND "# [ Mundane Items Inventory ] #"
    APPEND "export goblin_mail=${goblin_mail:-0}"
    APPEND "export bone=${bone:-0}"
    APPEND "export dragon_hide=${dragon_hide:-0}"
    APPEND "export runic_tablet=${runic_tablet:-0}"
    APPEND "export clothes=${clothes:-0}"
    APPEND "export food=${food:-0}"
    APPEND "export cooked_food=${cooked_food:-0}"
    APPEND "export bait=${bait:-0}"
    APPEND "export potion=${potion:-0}"
    APPEND "export ingot=${ingot:-0}"
    APPEND "export seed=${seed:-0}"
    APPEND "export bow=${bow:-0}"
    APPEND "export fur=${fur:-0}"
    APPEND "export gem=${gem:-0}"
    APPEND "export log=${log:-0}"
    APPEND "export ore=${ore:-0}"
    APPEND "export magical_orb=${magical_orb:-0}"
    APPEND ""
    APPEND "# [ Armor ] #"
    APPEND "export armor_name='${armor_name:-None}'"
    APPEND "export armor_type='${armor_type:-None}'"
    APPEND "export armor_class=${armor_class:-3} # Must be met or exceeded to hit"
    APPEND
    APPEND "# [ Weapon ] #"
    APPEND "export weapon_name='${weapon_name:-Your Hand}'"
    APPEND "export weapon_type='${weapon_type:-None}'"
    APPEND "export weapon_hit_dc=${weapon_hit_dc:-3} # Must be met or exceeded to hit"
    APPEND "export weapon_dmg=${weapon_hit_dmg:-3} # Damage dealt when hit"
    APPEND
    APPEND "# [ Magic Wand ] #"
    APPEND "export magic_wand_name='${magic_wand_name:-None}'"
    APPEND "export magic_wand_type='${magic_wand_type:-None}' # Elemental damage"
    APPEND "export magic_wand_hit_dc=${magic_wand_hit_dc:-0} # Must be met or exceeded to hit"
    APPEND "export magic_wand_dmg=${magic_wand_hit_dmg:-0} # Damage dealt when hit"
}

###################################################
# [ First Menu ] #
# This is what is first seen when script is run
###################################################
function first_menu() {
    TITLE "Final Realm"
    while [[ $EXIT -ne 0 ]]; do
        HEADER
        PRINT "Welcome to final realm!"
        PRINT "Type in the number for the action to perform."
        PRINT
        PRINT "1. Login"
        PRINT "2. Create an Account"
        PRINT
        PRINT "0. Exit"
        PRINT
        LINES
        read -r -p "ID > " option
        LINES

        case "$(LOWERCASE ${option})" in

        0 | 'exit')
            stop_game
            ;;

        1 | 'login')
            login
            ;;

        2 | 'create an account')
            register
            ;;

        3141592)
            developer_console
            ;;

        *)
            PRINT
            [[ -z "${option}" ]] && {
                PRINT "Canceling."
                PAUSE
                continue
            }

            [[ -n "${option}" ]] && {
                PRINT "Invalid option '${option}'. Aborting."
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
    read -r -p "Username > " PLAYERNAME

    open_profile "$PLAYERNAME" || first_menu

    read -r -s -p "Password (cAsE sEnsiTivE) > " password
    PRINT

    # If password doesn't match, cancel login.
    [[ ! "${password}" == "${PASSWORD}" ]] && {
        PRINT "\nPassword does not match."
        PAUSE
        first_menu
    }

    game_menu
}

###################################################
# [ Registration Screen ] #
###################################################
function register() {
    HEADER
    read -r -p "Username > " PLAYERNAME

    # If profile file exists, cancel registration.
    profile_exists "${PLAYERNAME}" && {
        PRINT "\nProfile '${PLAYERNAME}' already exists."
        PAUSE
        first_menu
    }

    # Create profiles folder if it doesn't exist.
    [[ ! -e "${PROFILES}" ]] && mkdir "${PROFILES}"

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
    PRINT "\nProfile '${PLAYERNAME}' created!"
    PAUSE

    first_menu
}

###################################################
# [ Developer Console ] #
###################################################
function developer_console() {
    TITLE "Final Realm | Developer Console"

    while [[ $EXIT -ne 0 ]]; do
        HEADER
        PRINT "Welcome to the Developer Console."
        PRINT "Choose an option."
        PRINT
        PRINT "1. List profiles"
        PRINT "2. Delete a profile"
        PRINT "3. Enable admin for profile"
        PRINT "4. Disable admin for profile"
        PRINT
        PRINT "0. Exit"
        PRINT
        read -r -p "ID > " option
        case "$(LOWERCASE ${option})" in
        0 | exit)
            first_menu
            ;;

        1 | 'list profiles')
            [[ ! $(ls -A ${PROFILES}) ]] && {
                LINES
                PRINT "There are no profiles."
                LINES
                PAUSE
                continue
            }

            LINES
            PRINT "Profiles:"
            shopt -s dotglob
            for profile in "${PROFILES}"/*; do
                file="${profile##*/}"
                PRINT "- ${file/.sh/}"
            done
            LINES
            PAUSE
            continue
            ;;
        2 | 'delete a profile')
            [[ ! $(ls -A ${PROFILES}) ]] && {
                LINES
                PRINT "There are no profiles to delete."
                LINES
                PAUSE
                continue
            }

            LINES
            read -r -p "Profile > " acc

            profile_exists "${acc}" || {
                PRINT "Profile '${acc}' does not exist."
                PAUSE
                continue
            }

            profile_path "${acc}"
            rm -f "${PROFILE_FILE}"

            PRINT "Profile '${acc}' successfully deleted."
            PAUSE
            continue
            ;;
        3 | 'enable admin for profile')
            [[ ! $(ls -A ${PROFILES}) ]] && {
                LINES
                PRINT "There are no profiles to delete."
                LINES
                PAUSE
                continue
            }

            LINES
            read -r -p "Profile > " acc

            open_profile "${acc}"
            ADMIN=1
            save_profile

            PRINT "Profile '${acc}' is now an admin."
            PAUSE
            continue
            ;;
        4 | 'disable admin for profile')
            [[ ! $(ls -A ${PROFILES}) ]] && {
                LINES
                PRINT "There are no profiles."
                LINES
                PAUSE
                continue
            }

            LINES
            read -r -p "Profile > " acc

            open_profile "${acc}"
            ADMIN=0
            save_profile

            PRINT "Profile '${acc}' is no longer an admin."
            PAUSE
            continue
            ;;

        *)
            PRINT
            [[ -z "${option}" ]] && {
                PRINT "Canceling."
                PAUSE
                continue
            }

            [[ -n "${option}" ]] && {
                PRINT "Invalid option '${option}'. Aborting."
                PAUSE
                continue
            }
            ;;
        esac
    done
}

###################################################
# [ Game Menu ] #
###################################################
function game_menu() {
    TITLE "Final Realm"
    while [[ $EXIT -ne 0 ]]; do
        HEADER
        PRINT "Welcome to Final Realm, ${PLAYERNAME}."
        PRINT "What would you like to do?"
        PRINT
        PRINT "#######################"
        PRINT "# Go on an Adventure"
        PRINT "#######################"
        PRINT "1. Wander Gielinor"
        PRINT "2. Enter the Stronghold"
        PRINT
        PRINT "#######################"
        PRINT "# Make Money"
        PRINT "#######################"
        PRINT "3. Work in the Guilds"
        PRINT "4. Quest Hall"
        PRINT
        PRINT "#######################"
        PRINT "# Spend Money"
        PRINT "#######################"
        PRINT "5. Bank"
        PRINT "6. Trading Post"
        PRINT "7. Weapons Shop"
        PRINT "8. Armor Shop"
        PRINT "9. Magic Shop"
        PRINT "10. Tavern"
        PRINT "11. The Smuggler"
        PRINT
        PRINT "#######################"
        PRINT "# Administration"
        PRINT "#######################"
        PRINT "12. Player Inventory"
        PRINT "13. Player Settings"
        PRINT "0. Log Out"
        PRINT
        LINES
        read -r -p "ID > " option
        LINES

        case "$(LOWERCASE ${option})" in
        0 | 'log out')
            stop_game --logout
            ;;

        1 | 'wander gielinor')
            wander_gielinor
            ;;

        2 | 'enter the stronghold')
            enter_stronghold
            ;;

        3 | 'work in the guilds')
            the_guilds
            ;;

        4 | 'quest hall')
            quest_hall
            ;;

        5 | 'bank')
            bank
            ;;

        6 | 'trading post')
            trading_post
            ;;

        7 | 'weapons shop')
            weapons_shop
            ;;

        8 | 'armor shop')
            armor_shop
            ;;

        9 | 'magic shop')
            magic_shop
            ;;

        10 | 'tavern')
            tavern
            ;;

        11 | 'the smuggler')
            the_smuggler
            ;;

        12 | 'player inventory')
            player_inventory
            ;;

        13 | 'player_settings')
            player_settings
            ;;

        3141592)
            admin_menu
            ;;

        *)
            [[ -n "${option}" ]] && {
                PRINT "Invalid option '${option}'."
                PAUSE
                continue
            }
            ;;
        esac
    done
}

###################################################
# [ Wandering Gielinor ] #
###################################################
function wander_gielinor() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ The Stronghold ] #
###################################################
function enter_stronghold() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ The Guilds ] #
###################################################
function the_guilds() {
    TITLE "Final Realm | Guilds"

    local GUILD_NAME=""
    local GUILD_LEVEL=0
    local GUILD_XP_TARGET=0
    local GUILD_XP_TOTAL=0
    local KIT_REQUIRED=true
    local OWNS_KIT=false
    local MATERIAL_REQUIRED=false
    local MATERIAL_NAME=""
    local TOTAL_MATERIALS=0
    local PRODUCED_GOOD_NAME=""
    local PRODUCED_GOOD_NAME2=""
    local PRODUCED_GOOD_TOTAL=""
    local PRODUCED_GOOD_TOTAL2=""

    # Chooses the guild to work for
    while [[ $EXIT -ne 0 ]]; do
        HEADER
        PRINT "Welcome to the guilds."
        PRINT "Which guild would you like to work for?"
        PRINT
        PRINT "1. Begging"
        PRINT "2. Thieving"
        PRINT "3. Hunting"
        PRINT "4. Fishing"
        PRINT "5. Farming"
        PRINT "6. Tailoring"
        PRINT "7. Cooking"
        PRINT "8. Woodcutting"
        PRINT "9. Mining"
        PRINT "10. Smithing"
        PRINT
        PRINT "0. Go back"
        PRINT
        LINES
        read -r -p "ID > " option
        LINES

        case "$(LOWERCASE ${option})" in
        0 | 'go back')
            game_menu
            ;;

        1 | 'begging')
            ((money >= 100)) && {
                PRINT "You have too much money to beg."
                PAUSE
                continue
            }

            GUILD_NAME="begging"
            GUILD_LEVEL=${begging_level}
            GUILD_XP_TARGET=${begging_xp_target}
            GUILD_XP_TOTAL=${begging_xp_total}

            KIT_REQUIRED=false
            MATERIAL_REQUIRED=false
            break
            ;;

        2 | 'thieving')
            GUILD_NAME="thieving"
            GUILD_LEVEL=${thieving_level}
            GUILD_XP_TARGET=${thieving_xp_target}
            GUILD_XP_TOTAL=${thieving_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_thieving}

            MATERIAL_REQUIRED=false
            break
            ;;

        3 | 'hunting')
            GUILD_NAME="hunting"
            GUILD_LEVEL=${hunting_level}
            GUILD_XP_TARGET=${hunting_xp_target}
            GUILD_XP_TOTAL=${hunting_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_hunting}

            MATERIAL_REQUIRED=false

            PRODUCED_GOOD_NAME="fur"
            PRODUCED_GOOD_TOTAL=${fur}
            PRODUCED_GOOD_NAME2="food"
            PRODUCED_GOOD_TOTAL2=${food}
            break
            ;;

        4 | 'fishing')
            GUILD_NAME="fishing"
            GUILD_LEVEL=${fishing_level}
            GUILD_XP_TARGET=${fishing_xp_target}
            GUILD_XP_TOTAL=${fishing_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_fishing}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="bait"
            TOTAL_MATERIALS=${bait}

            PRODUCED_GOOD_NAME="food"
            PRODUCED_GOOD_TOTAL=${food}
            break
            ;;

        5 | 'farming')
            GUILD_NAME="farming"
            GUILD_LEVEL=${farming_level}
            GUILD_XP_TARGET=${farming_xp_target}
            GUILD_XP_TOTAL=${farming_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_farming}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="seed"
            TOTAL_MATERIALS=${seed}

            PRODUCED_GOOD_NAME="food"
            PRODUCED_GOOD_TOTAL=${food}
            break
            ;;

        6 | 'tailoring')
            GUILD_NAME="tailoring"
            GUILD_LEVEL=${tailoring_level}
            GUILD_XP_TARGET=${tailoring_xp_target}
            GUILD_XP_TOTAL=${tailoring_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_tailoring}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="fur"
            TOTAL_MATERIALS=${fur}

            PRODUCED_GOOD_NAME="clothes"
            PRODUCED_GOOD_TOTAL=${clothes}
            break
            ;;

        7 | 'cooking')
            GUILD_NAME="cooking"
            GUILD_LEVEL=${cooking_level}
            GUILD_XP_TARGET=${cooking_xp_target}
            GUILD_XP_TOTAL=${cooking_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_cooking}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="food"
            TOTAL_MATERIALS=${food}

            PRODUCED_GOOD_NAME="cooked food"
            PRODUCED_GOOD_TOTAL=${cooked_food}
            break
            ;;

        8 | 'woodcutting')
            GUILD_NAME="woodcutting"
            GUILD_LEVEL=${woodcutting_level}
            GUILD_XP_TARGET=${woodcutting_xp_target}
            GUILD_XP_TOTAL=${woodcutting_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_woodcutting}

            MATERIAL_REQUIRED=false

            PRODUCED_GOOD_NAME="logs"
            PRODUCED_GOOD_TOTAL=${log}
            break
            ;;

        9 | 'mining')
            GUILD_NAME="mining"
            GUILD_LEVEL=${mining_level}
            GUILD_XP_TARGET=${mining_xp_target}
            GUILD_XP_TOTAL=${mining_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_mining}

            MATERIAL_REQUIRED=false

            PRODUCED_GOOD_NAME="ores"
            PRODUCED_GOOD_TOTAL=${ore}
            break
            ;;

        10 | 'smithing')
            GUILD_NAME="smithing"
            GUILD_LEVEL=${smithing_level}
            GUILD_XP_TARGET=${smithing_xp_target}
            GUILD_XP_TOTAL=${smithing_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_smithing}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="ore"
            TOTAL_MATERIALS=${ore}

            PRODUCED_GOOD_NAME="ingots"
            PRODUCED_GOOD_TOTAL=${ingot}
            break
            ;;

        *)
            PRINT
            [[ -z "${option}" ]] && {
                PRINT "Canceling."
                PAUSE
                continue
            }

            [[ -n "${option}" ]] && {
                PRINT "Invalid option '${option}'."
                PAUSE
                continue
            }
            ;;
        esac
    done

    [[ $KIT_REQUIRED == true ]] && [[ $OWNS_KIT == 'Not Owned' ]] && {
        PRINT "You do not have the required kit."
        PRINT "Please purchase it from guild store."
        PAUSE
        the_guilds
    }

    while [[ $EXIT -ne 0 ]]; do

        # Check if the guild requires materials and the player has some of it
        [[ $MATERIAL_REQUIRED == true ]] && ((TOTAL_MATERIALS <= 0)) && {
            PRINT "You do not have enough materials."
            PRINT "Please obtain some '${MATERIAL_NAME}'."
            PAUSE
            the_guilds
        }

        # If they make over 100 gold and they're begging, they have to stop
        ((money >= 100)) && [[ "${GUILD_NAME}" == "begging" ]] && {
            PRINT "You have too much money to beg."
            PAUSE
            the_guilds
        }

        HEADER
        PRINT "Guild: ${GUILD_NAME}"
        PRINT "Level: ${GUILD_LEVEL}"
        PRINT "Target XP: ${GUILD_XP_TARGET}"
        PRINT "Total XP: ${GUILD_XP_TOTAL}"
        PRINT "Money: ${money}"
        PRINT
        [[ $MATERIAL_REQUIRED == true ]] && PRINT "${MATERIAL_NAME}: ${TOTAL_MATERIALS}"
        [[ -n "${PRODUCED_GOOD_NAME}" ]] && PRINT "${PRODUCED_GOOD_NAME}: ${PRODUCED_GOOD_TOTAL}"
        [[ -n "${PRODUCED_GOOD_NAME2}" ]] && PRINT "${PRODUCED_GOOD_NAME2}: ${PRODUCED_GOOD_TOTAL2}"
        PRINT
        PRINT "Choose an option."
        PRINT "1. Work"
        PRINT "0. Go back"
        PRINT
        LINES
        read -r -p "ID > " option
        LINES
        case "$(LOWERCASE ${option})" in
        0 | 'go back')
            the_guilds
            ;;
        1 | 'work')

            GUILD_XP_TOTAL=$((GUILD_XP_TOTAL + 5))

            [[ $GUILD_XP_TOTAL -ge $GUILD_XP_TARGET ]] && {
                GUILD_LEVEL=$((GUILD_LEVEL + 1))
                GUILD_XP_TOTAL=0
                GUILD_XP_TARGET=100
            }

            [[ $MATERIAL_REQUIRED == true ]] && {
                TOTAL_MATERIALS=$((TOTAL_MATERIALS - 1))
            }

            case "${GUILD_NAME}" in
            'begging')
                money=$((money + 1))
                begging_level=$GUILD_LEVEL
                begging_xp_total=$GUILD_XP_TOTAL
                begging_xp_target=$GUILD_XP_TARGET
                ;;
            'thieving')
                money=$((money + 5))
                thieving_level=$GUILD_LEVEL
                thieving_xp_total=$GUILD_XP_TOTAL
                thieving_xp_target=$GUILD_XP_TARGET
                ;;
            'hunting')
                money=$((money + 5))
                hunting_level=$GUILD_LEVEL
                hunting_xp_total=$GUILD_XP_TOTAL
                hunting_xp_target=$GUILD_XP_TARGET
                fur=$((fur + 1))
                food=$((food + 1))
                PRODUCED_GOOD_TOTAL=${fur}
                PRODUCED_GOOD_TOTAL2=${food}
                ;;
            'fishing')
                money=$((money + 5))
                fishing_level=$GUILD_LEVEL
                fishing_xp_total=$GUILD_XP_TOTAL
                fishing_xp_target=$GUILD_XP_TARGET
                bait=$((bait - 1))
                food=$((food + 1))
                PRODUCED_GOOD_TOTAL=${food}
                ;;
            'farming')
                money=$((money + 5))
                farming_level=$GUILD_LEVEL
                farming_xp_total=$GUILD_XP_TOTAL
                farming_xp_target=$GUILD_XP_TARGET
                seed=$((seed - 1))
                food=$((food + 1))
                PRODUCED_GOOD_TOTAL=${food}
                ;;
            'tailoring')
                money=$((money + 5))
                tailoring_level=$GUILD_LEVEL
                tailoring_xp_total=$GUILD_XP_TOTAL
                tailoring_xp_target=$GUILD_XP_TARGET
                fur=$((fur - 1))
                clothes=$((clothes + 1))
                PRODUCED_GOOD_TOTAL=${clothes}
                ;;
            'cooking')
                money=$((money + 5))
                cooking_level=$GUILD_LEVEL
                cooking_xp_total=$GUILD_XP_TOTAL
                cooking_xp_target=$GUILD_XP_TARGET
                food=$((food - 1))
                cooked_food=$((cooked_food + 1))
                PRODUCED_GOOD_TOTAL=${cooked_food}
                ;;
            'woodcutting')
                money=$((money + 5))
                woodcutting_level=$GUILD_LEVEL
                woodcutting_xp_total=$GUILD_XP_TOTAL
                woodcutting_xp_target=$GUILD_XP_TARGET
                log=$((log + 1))
                PRODUCED_GOOD_TOTAL=${log}
                ;;
            'mining')
                money=$((money + 5))
                mining_level=$GUILD_LEVEL
                mining_xp_total=$GUILD_XP_TOTAL
                mining_xp_target=$GUILD_XP_TARGET
                ore=$((ore + 1))
                PRODUCED_GOOD_TOTAL=${ore}
                ;;
            'smithing')
                money=$((money + 5))
                smithing_level=$GUILD_LEVEL
                smithing_xp_total=$GUILD_XP_TOTAL
                smithing_xp_target=$GUILD_XP_TARGET
                ore=$((ore - 1))
                ingot=$((ingot + 1))
                PRODUCED_GOOD_TOTAL=${ingot}
                ;;
            esac
            ;;

        *)
            PRINT
            [[ -z "${option}" ]] && {
                PRINT "Canceling."
                PAUSE
                continue
            }

            [[ -n "${option}" ]] && {
                PRINT "Invalid option '${option}'."
                PAUSE
                continue
            }
            ;;
        esac
    done
}

###################################################
# [ Quest Hall ] #
###################################################
function quest_hall() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Bank ] #
###################################################
function bank() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Trading Post ] #
###################################################
function trading_post() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Weapons Shop ] #
###################################################
function weapons_shop() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Armor Shop ] #
###################################################
function armor_shop() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Magic Shop ] #
###################################################
function magic_shop() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Tavern ] #
###################################################
function tavern() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ The Smuggler ] #
###################################################
function the_smuggler() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Player Inventory ] #
###################################################
function player_inventory() {
    HEADER
    PRINT "#######################"
    PRINT "# Player Inventory"
    PRINT "#######################"
    PRINT
    PRINT "# [ Finances ] #"
    PRINT "Wallet: \t\t\$${money}"
    PRINT "Bank 1: \t\t\$${bank_1_gold}"
    PRINT "Bank 2: \t\t\$${bank_2_gold}"
    PRINT "Bank 3: \t\t\$${bank_3_gold}"
    PRINT "Bank 4: \t\t\$${bank_4_gold}"
    PRINT "Bank 5: \t\t\$${bank_5_gold}"
    PRINT
    PRINT "# [ Kits ] #"
    PRINT "Thieving: \t\t${kit_thieving}"
    PRINT "Hunting: \t\t${kit_hunting}"
    PRINT "Fishing: \t\t${kit_fishing}"
    PRINT "Farming: \t\t${kit_farming}"
    PRINT "Tailoring: \t\t${kit_tailoring}"
    PRINT "Cooking: \t\t${kit_cooking}"
    PRINT "Woodcutting: \t\t${kit_woodcutting}"
    PRINT "Mining: \t\t${kit_mining}"
    PRINT "Smithing: \t\t${kit_smithing}"
    PRINT
    PRINT "# [ Mundane Items ] #"
    PRINT "Goblin Mail: \t\t${goblin_mail}"
    PRINT "Bone: \t\t\t${bone}"
    PRINT "Dragon Hide: \t\t${dragon_hide}"
    PRINT "Runic Tablet: \t\t${runic_tablet}"
    PRINT "Clothes: \t\t${clothes}"
    PRINT "Food: \t\t\t${food}"
    PRINT "Cooked Food: \t\t${cooked_food}"
    PRINT "Bait: \t\t\t${bait}"
    PRINT "Potion: \t\t${potion}"
    PRINT "Ingot: \t\t\t${ingot}"
    PRINT "Seed: \t\t\t${seed}"
    PRINT "Bow: \t\t\t${bow}"
    PRINT "Fur: \t\t\t${fur}"
    PRINT "Gem: \t\t\t${gem}"
    PRINT "Log: \t\t\t${log}"
    PRINT "Ore: \t\t\t${ore}"
    PRINT "Magical Orb: \t\t${magical_orb}"
    PRINT
    PRINT "# [ Combat ] #"
    PRINT "Armor: \t\t\t${armor_name}"
    PRINT "Weapon: \t\t${weapon_name}"
    PRINT "Magic Wand: \t\t${magic_wand_name}"
    PAUSE
}

###################################################
# [ Player Settings ] #
###################################################
function player_settings() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Admin Menu ] #
###################################################
function admin_menu() {
    PRINT "This has not yet been coded."
    PAUSE
}

###################################################
# [ Initialize Terminal UI ] #
###################################################
first_menu

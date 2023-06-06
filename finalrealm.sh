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
    NPRINT "Press <ENTER> to continue..."
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
    local timestamp="$(date +"%I:%M%P %m/%d/%Y")"

    # Multi-line timestamp flag
    [[ "${1}" == "-m" || "${1}" == "--multiline" ]] && timestamp="$(date +"%I:%M%P")\n$(date +"%m/%d/%Y")"

    PRINT "${timestamp}"
}

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
export ENV="./.env.sh"
export ALLOW_ADMIN=1 # Default value, possibly overwritten in ENV

# Source developer environment file if it exists
[[ -e "${ENV}" ]] && . "${ENV}"

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
# [ Profile Manipulation ] #
###################################################

# Generate the path for a profile
function profile_path() {
    export PROFILE_FILE="${PROFILES}/$(LOWERCASE ${1}).sh"
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
    . "${PROFILE_FILE}"

    return 0
}

function save_profile() {
    # Append profile file
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
    APPEND "export USERNAME='${USERNAME}'"
    APPEND "export PASSWORD='${PASSWORD}'"
    APPEND "export ADMIN=${ADMIN:-0} # Set to 1 to enable Admin access"
    APPEND ""
    APPEND "###################################################"
    APPEND "# [ Temporary Variables ]"
    APPEND "###################################################"
    APPEND "export cost=${cost:-0}"
    APPEND "export cost1=${cost1:-0}"
    APPEND "export gcho=${gcho:-0}"
    APPEND "export echo=${echo:-0}"
    APPEND "export e2cho=${e2cho:-0}"
    APPEND "export e1=${e1:-0}"
    APPEND "export npc_damage=${npc_damage:-0}"
    APPEND "export ls1=${ls1:-0}"
    APPEND "export killcount=${killcount:-0}"
    APPEND "export ls2=${ls2:-0}"
    APPEND "export la1=${la1:-0}"
    APPEND "export la2=${la2:-0}"
    APPEND "export hitpoints=${hitpoints:-100}"
    APPEND "export original_hitpoints=${original_hitpoints:-100}"
    APPEND "export armor_type='${armor_type:-None}'"
    APPEND "export sword_type='${sword_type:-None}'"
    APPEND "export sword_kind='${sword_kind:-Hand}'"
    APPEND "export buyword1='${buyword1:-hi}'"
    APPEND "export buyword2='${buyword2:-hi}'"
    APPEND "export current_lvl=${current_lvl:-1}"
    APPEND "export aan='${aan:-a}'"
    APPEND "export bank_gold=${bank_gold:-0}"
    APPEND "export sword_choice='${sword_choice:-hi}'"
    APPEND "export sword_choice2='${sword_choice2:-hi}'"
    APPEND "export sword_choice3='${sword_choice3:-hi}'"
    APPEND "export sword_exist='${sword_exist:-hi}'"
    APPEND "export sword_price=${sword_price:-0}"
    APPEND "export armor_choice='${armor_choice:-hi}'"
    APPEND "export armor_choice2='${armor_choice2:-Armor}'"
    APPEND "export armor_price=${armor_price:-0}"
    APPEND ""
    APPEND "###################################################"
    APPEND "# [ Player Statistics ]"
    APPEND "###################################################"
    APPEND ""
    APPEND "# [ Player Statistics ] #"
    APPEND "export player_xp=${player_xp:-0}"
    APPEND "export xp_until_next_lvl=${xp_until_next_lvl:-500}"
    APPEND "export original_xp=${original_xp:-500}"
    APPEND "export money=${money:-100}"
    APPEND "export key=${key:-0}"
    APPEND "export damage=${damage:-0}"
    APPEND "export total_level=${total_level:-13}"
    APPEND ""
    APPEND "# [ Begging Skill Stats ] #"
    APPEND "export begging_lvl=${begging_lvl:-1}"
    APPEND "export begging_xp_target=${begging_xp_target:-100}"
    APPEND "export begging_xp_total=${begging_xp_total:-45}"
    APPEND ""
    APPEND "# [ Thieving Skill Stats ] #"
    APPEND "export thieving_lvl=${thieving_lvl:-1}"
    APPEND "export thieving_xp_target=${thieving_xp_target:-100}"
    APPEND "export thieving_xp_total=${thieving_xp_total:-36}"
    APPEND ""
    APPEND "# [ Hunting Skill Stats ] #"
    APPEND "export hunting_lvl=${hunting_lvl:-1}"
    APPEND "export hunting_xp_target=${hunting_xp_target:-100}"
    APPEND "export hunting_xp_total=${hunting_xp_total:-30}"
    APPEND ""
    APPEND "# [ Fishing Skill Stats ] #"
    APPEND "export fishing_lvl=${fishing_lvl:-1}"
    APPEND "export fishing_xp_target=${fishing_xp_target:-100}"
    APPEND "export fishing_xp_total=${fishing_xp_total:-30}"
    APPEND ""
    APPEND "# [ Farming Skill Stats ] #"
    APPEND "export farming_lvl=${farming_lvl:-1}"
    APPEND "export farming_xp_target=${farming_xp_target:-100}"
    APPEND "export farming_xp_total=${farming_xp_total:-31}"
    APPEND ""
    APPEND "# [ Tailoring Skill Stats ] #"
    APPEND "export tailoring_lvl=${tailoring_lvl:-1}"
    APPEND "export tailoring_xp_target=${tailoring_xp_target:-100}"
    APPEND "export tailoring_xp_total=${tailoring_xp_total:-31}"
    APPEND ""
    APPEND "# [ Cooking Skill Stats ] #"
    APPEND "export cooking_lvl=${cooking_lvl:-1}"
    APPEND "export cooking_xp_target=${cooking_xp_target:-100}"
    APPEND "export cooking_xp_total=${cooking_xp_total:-41}"
    APPEND ""
    APPEND "# [ Woodcutting Skill Stats ] #"
    APPEND "export woodcutting_lvl=${woodcutting_lvl:-1}"
    APPEND "export woodcutting_xp_target=${woodcutting_xp_target:-100}"
    APPEND "export woodcutting_xp_total=${woodcutting_xp_total:-38}"
    APPEND ""
    APPEND "# [ Mining Skill Stats ] #"
    APPEND "export mining_lvl=${mining_lvl:-1}"
    APPEND "export mining_xp_target=${mining_xp_target:-100}"
    APPEND "export mining_xp_total=${mining_xp_total:-35}"
    APPEND ""
    APPEND "# [ Smithing Skill Stats ] #"
    APPEND "export smithing_lvl=${smithing_lvl:-1}"
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
    APPEND "# [ Mundane Items Inventory ] #"
    APPEND "export gold_mail=${gold_mail:-0}"
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
    APPEND "# Only skill that doesn't require a kit is begging, which no longer works"
    APPEND "# once you earn enough gold for a fishing or hunting kit (100 gold)"
    APPEND "# [ Skill Kits Inventory ] #"
    APPEND "export kit_thieving=${kit_thieivng:-false}"
    APPEND "export kit_hunting=${kit_hunting:-false}"
    APPEND "export kit_fishing=${kit_fishing:-false}"
    APPEND "export kit_farming=${kit_farming:-false}"
    APPEND "export kit_tailoring=${kit_tailoring:-false}"
    APPEND "export kit_cooking=${kit_cooking:-false}"
    APPEND "export kit_woodcutting=${kit_woodcutting:-false}"
    APPEND "export kit_mining=${kit_mining:-false}"
    APPEND "export kit_smithing=${kit_smithing:-false}"
    APPEND ""
    APPEND "# [ Armor Inventory ] #"
    APPEND "export armor_1=${armor_1:-0}"
    APPEND "export armor_2=${armor_2:-0}"
    APPEND "export armor_3=${armor_3:-0}"
    APPEND "export armor_4=${armor_4:-0}"
    APPEND "export armor_5=${armor_5:-0}"
    APPEND "export armor_6=${armor_6:-0}"
    APPEND "export armor_7=${armor_7:-0}"
    APPEND "export armor_8=${armor_8:-0}"
    APPEND "export armor_9=${armor_9:-0}"
    APPEND "export armor_10=${armor_10:-0}"
    APPEND "export armor_11=${armor_11:-0}"
    APPEND "export armor_12=${armor_12:-0}"
    APPEND "export magic_armor_1=${magic_armor_1:-0}"
    APPEND "export magic_armor_2=${magic_armor_2:-0}"
    APPEND "export magic_armor_3=${magic_armor_3:-0}"
    APPEND "export magic_armor_4=${magic_armor_4:-0}"
    APPEND "export magic_armor_5=${magic_armor_5:-0}"
    APPEND "export magic_armor_6=${magic_armor_6:-0}"
    APPEND "export magic_armor_7=${magic_armor_7:-0}"
    APPEND "export magic_armor_8=${magic_armor_8:-0}"
    APPEND "export magic_armor_9=${magic_armor_9:-0}"
    APPEND "export magic_armor_10=${magic_armor_10:-0}"
    APPEND ""
    APPEND "# [ Swords Inventory ] #"
    APPEND "export sword_1=${sword_1:-0}"
    APPEND "export sword_2=${sword_2:-0}"
    APPEND "export sword_3=${sword_3:-0}"
    APPEND "export sword_4=${sword_4:-0}"
    APPEND "export sword_5=${sword_5:-0}"
    APPEND "export sword_6=${sword_6:-0}"
    APPEND "export sword_7=${sword_7:-0}"
    APPEND "export sword_8=${sword_8:-0}"
    APPEND "export sword_9=${sword_9:-0}"
    APPEND "export sword_10=${sword_10:-0}"
    APPEND "export sword_11=${sword_11:-0}"
    APPEND "export sword_12=${sword_12:-0}"
    APPEND "export magic_sword_1=${magic_sword_1:-0}"
    APPEND "export magic_sword_2=${magic_sword_2:-0}"
    APPEND "export magic_sword_3=${magic_sword_3:-0}"
    APPEND "export magic_sword_4=${magic_sword_4:-0}"
    APPEND "export magic_sword_5=${magic_sword_5:-0}"
    APPEND "export magic_sword_6=${magic_sword_6:-0}"
    APPEND "export magic_sword_7=${magic_sword_7:-0}"
    APPEND "export magic_sword_8=${magic_sword_8:-0}"
    APPEND "export magic_sword_9=${magic_sword_9:-0}"
    APPEND "export magic_sword_10=${magic_sword_10:-0}"
    APPEND ""
    APPEND "###################################################"
    APPEND "# [ Shop Prices ]"
    APPEND "###################################################"
    APPEND ""
    APPEND "# [ Mundane Items Pricing ] #"
    APPEND "export price_gold_mail=300"
    APPEND "export price_bone=550"
    APPEND "export price_dragon_hide=750"
    APPEND "export price_runic_tablet=250"
    APPEND "export price_potion=200"
    APPEND "export price_food=100"
    APPEND "export price_ingot=473"
    APPEND "export price_seed=150"
    APPEND "export price_rotten_food=100"
    APPEND "export price_bait=2"
    APPEND "export price_fur=200"
    APPEND "export price_ore=500"
    APPEND "export price_log=275"
    APPEND "export price_gem=1000"
    APPEND "export price_bow=713"
    APPEND "export price_magical_orb=15000"
    APPEND
    APPEND "# [ Skill Kits Pricing ] # "
    APPEND "export price_kit_thieving=50"
    APPEND "export price_kit_hunting=100"
    APPEND "export price_kit_fishing=100"
    APPEND "export price_kit_farming=150"
    APPEND "export price_kit_tailoring=30"
    APPEND "export price_kit_cooking=100"
    APPEND "export price_kit_woodcutting=200"
    APPEND "export price_kit_mining=300"
    APPEND "export price_kit_smithing=350"
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

        3141592)
            developer_console
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

    open_profile "$USERNAME" || first_menu

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
    read -r -p "Username > " USERNAME

    # If profile file exists, cancel registration.
    profile_exists "${USERNAME}" && {
        PRINT "\nProfile '${USERNAME}' already exists."
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
    PRINT "\nProfile '${USERNAME}' created!"
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
        PRINT "5. Exit"
        PRINT
        read -r -p "ID > " option
        case "$(LOWERCASE ${option})" in
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
        5 | exit)
            first_menu
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
        PRINT "Welcome to Final Realm, ${USERNAME}."
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
        PRINT "99. Exit"
        PRINT
        LINES
        read -r -p "ID > " scriptNumber
        LINES

        case "$(LOWERCASE ${scriptNumber})" in

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

        99 | exit)
            PRINT "Thanks for playing final realm!"
            PAUSE
            first_menu
            ;;

        *)
            [[ -n "${scriptNumber}" ]] && {
                PRINT "Invalid option '${scriptNumber}'."
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

    local GUILD=""
    local GUILD_LVL=0
    local GUILD_XP_TARGET=0
    local GUILD_XP_TOTAL=0
    local KIT_REQUIRED=true
    local OWNS_KIT=false
    local MATERIAL_REQUIRED=false
    local MATERIAL_NAME=""
    local TOTAL_MATERIALS=0

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
        PRINT "11. Exit"
        PRINT
        LINES
        read -r -p "ID > " scriptNumber
        LINES

        case "$(LOWERCASE ${scriptNumber})" in

        1 | 'begging')
            GUILD="begging"
            GUILD_LVL=${begging_lvl}
            GUILD_XP_TARGET=${begging_xp_target}
            GUILD_XP_TOTAL=${begging_xp_total}

            KIT_REQUIRED=false
            break
            ;;

        2 | 'thieving')
            GUILD="thieving"
            GUILD_LVL=${thieving_lvl}
            GUILD_XP_TARGET=${thieving_xp_target}
            GUILD_XP_TOTAL=${thieving_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_thieving}
            break
            ;;

        3 | 'hunting')
            GUILD="hunting"
            GUILD_LVL=${hunting_lvl}
            GUILD_XP_TARGET=${hunting_xp_target}
            GUILD_XP_TOTAL=${hunting_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_hunting}
            break
            ;;

        4 | 'fishing')
            GUILD="fishing"
            GUILD_LVL=${fishing_lvl}
            GUILD_XP_TARGET=${fishing_xp_target}
            GUILD_XP_TOTAL=${fishing_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_fishing}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="bait"
            TOTAL_MATERIALS=${bait}
            break
            ;;

        5 | 'farming')
            GUILD="farming"
            GUILD_LVL=${farming_lvl}
            GUILD_XP_TARGET=${farming_xp_target}
            GUILD_XP_TOTAL=${farming_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_farming}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="seed"
            TOTAL_MATERIALS=${seed}
            break
            ;;

        6 | 'tailoring')
            GUILD="tailoring"
            GUILD_LVL=${tailoring_lvl}
            GUILD_XP_TARGET=${tailoring_xp_target}
            GUILD_XP_TOTAL=${tailoring_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_tailoring}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="fur"
            TOTAL_MATERIALS=${fur}
            break
            ;;

        7 | 'cooking')
            GUILD="cooking"
            GUILD_LVL=${cooking_lvl}
            GUILD_XP_TARGET=${cooking_xp_target}
            GUILD_XP_TOTAL=${cooking_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_cooking}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="food"
            TOTAL_MATERIALS=${food}
            break
            ;;

        8 | 'woodcutting')
            GUILD="woodcutting"
            GUILD_LVL=${woodcutting_lvl}
            GUILD_XP_TARGET=${woodcutting_xp_target}
            GUILD_XP_TOTAL=${woodcutting_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_woodcutting}
            break
            ;;

        9 | 'mining')
            GUILD="mining"
            GUILD_LVL=${mining_lvl}
            GUILD_XP_TARGET=${mining_xp_target}
            GUILD_XP_TOTAL=${mining_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_mining}
            break
            ;;

        10 | 'smithing')
            GUILD="smithing"
            GUILD_LVL=${smithing_lvl}
            GUILD_XP_TARGET=${smithing_xp_target}
            GUILD_XP_TOTAL=${smithing_xp_total}

            KIT_REQUIRED=true
            OWNS_KIT=${kit_smithing}

            MATERIAL_REQUIRED=true
            MATERIAL_NAME="ore"
            TOTAL_MATERIALS=${ore}
            break
            ;;

        11 | exit)
            game_menu
            ;;

        *)
            PRINT
            [[ -z "${scriptNumber}" ]] && {
                PRINT "Canceling."
                PAUSE
                continue
            }

            [[ -n "${scriptNumber}" ]] && {
                PRINT "Invalid option '${scriptNumber}'."
                PAUSE
                continue
            }
            ;;
        esac
    done

    # Check if the guild requires a kit and the players has a kit
    [[ $KIT_REQUIRED ]] && [[ ! $OWNS_KIT ]] && {
        PRINT "You do not have the required kit."
        PRINT "Please purchase it from guild store."
        PAUSE
        the_guilds
    }

    # Check if the guild requires materials and the player has some of it
    [[ $MATERIAL_REQUIRED ]] && [[ $TOTAL_MATERIALS -eq 0 ]] && {
        PRINT "You do not have enough materials."
        PRINT "Please obtain some '${MATERIAL_NAME}'."
        PAUSE
        the_guilds
    }

    while [[ $EXIT -ne 0 ]]; do
        HEADER
        PRINT "Guild: ${GUILD}"
        PRINT "Level: ${GUILD_LVL}"
        PRINT "Target XP: ${GUILD_XP_TARGET}"
        PRINT "Total XP: ${GUILD_XP_TOTAL}"
        PRINT
        [[ $MATERIAL_REQUIRED ]] && PRINT "${MATERIAL_NAME}: ${TOTAL_MATERIALS}"

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
    PRINT "This has not yet been coded."
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

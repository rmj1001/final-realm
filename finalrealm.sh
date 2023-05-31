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
# [ Create & Save Profile ] #
###################################################

# TODO: Rename variables
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
    APPEND "# [ User Account ] #"
    APPEND "export USERNAME='${USERNAME}'"
    APPEND "export PASSWORD='${PASSWORD}'"
    APPEND "export ADMIN=${ADMIN:-0} # Set to 1 to enable Admin access"
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

    export PROFILE_FILE="${PROFILES}/$(LOWERCASE ${USERNAME}).sh"

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

    export PROFILE_FILE="${PROFILES}/$(LOWERCASE ${USERNAME}).sh"

    # If profile file exists, cancel registration.
    [[ -e "${PROFILE_FILE}" ]] && {
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
# Create the hidden environment file with top-level variables
function save_dev_env {
    [[ ! -e "${ENV}" ]] && touch "${ENV}"

    PRINT "#!/usr/bin/env bash\n" >"${ENV}"
    PRINT "# Set to 0 to disable, 1 to enable." >>"${ENV}"
    PRINT "ALLOW_ADMIN=${ALLOW_ADMIN:-1}" >>"${ENV}"
}

function developer_console() {
    TITLE "Final Realm | Developer Console"

    while [[ $EXIT -ne 0 ]]; do
        HEADER
        PRINT "Welcome to the Developer Console."
        PRINT "Choose an option."
        PRINT
        PRINT "1. List accounts"
        PRINT "2. Delete an account"
        PRINT "3. Lock admin access"
        PRINT "4. Unlock admin access"
        PRINT
        PRINT "5. Exit"
        PRINT
        read -r -p "ID > " option
        case "$(LOWERCASE ${option})" in
        1 | 'list accounts')
            [[ ! $(ls -A ${PROFILES}) ]] && {
                LINES
                PRINT "There are no profiles."
                LINES
                PAUSE
                continue
            }

            PRINT "Accounts:"
            shopt -s dotglob
            for profile in "${PROFILES}"/*; do
                file="${profile##*/}"
                PRINT "- ${file/.sh/}"
            done
            LINES
            PAUSE
            continue
            ;;
        2 | 'delete an account')
            [[ ! $(ls -A ${PROFILES}) ]] && {
                LINES
                PRINT "There are no profiles to delete."
                LINES
                PAUSE
                continue
            }

            LINES
            read -r -p "Account to delete > " acc

            PROFILE="${PROFILES}/$(LOWERCASE ${acc}).sh"

            [[ ! -e "${PROFILE}" ]] && {
                PRINT "Account '${acc}' does not exist."
                PAUSE
                continue
            }

            rm -f "${PROFILE}"
            PRINT "Account '${acc}' successfully deleted."
            PAUSE
            continue
            ;;
        3 | 'lock admin access')
            ALLOW_ADMIN=0
            save_dev_env

            PRINT "Admin accessed locked."
            PAUSE
            continue
            ;;
        4 | 'unlock admin access')
            ALLOW_ADMIN=1
            save_dev_env

            PRINT "Admin accessed unlocked."
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
# [ Initialize Terminal UI ] #
###################################################
first_menu

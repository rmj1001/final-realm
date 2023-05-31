#!/usr/bin/env bash

# Source api script
. ./.api.sh

TITLE "Final Realm by Roy"
EXIT=1

function ctrl_c() {
    PRINT "\n"
    [[ -z "${scriptNumber}" ]] && PRINT "Canceling.\n"
    clear
    exit 0
}

trap ctrl_c INT

function HEADER() {
    clear
    echo "                                                                                    "
    echo "███████ ██ ███    ██  █████  ██          ██████  ███████  █████  ██      ███    ███ "
    echo "██      ██ ████   ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ████  ████ "
    echo "█████   ██ ██ ██  ██ ███████ ██          ██████  █████   ███████ ██      ██ ████ ██ "
    echo "██      ██ ██  ██ ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ██  ██  ██ "
    echo "██      ██ ██   ████ ██   ██ ███████     ██   ██ ███████ ██   ██ ███████ ██      ██ "
    echo "                                                                                    "
    PRINT
    PRINT
    PRINT
}

###################################################
# Create/Save Profile
#
# TODO: Re-name variables
#
function save_profile() {
    # Append profile file
    APPEND() {
        PRINT "${1}" >>"${PROFILE_FILE}"
    }

    PRINT "# [ User Account ] #" >"${PROFILE_FILE}"
    APPEND "export USERNAME=\"${USERNAME}\""
    APPEND "export PASSWORD=\"${PASSWORD}\"\n"
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
    APPEND "export cost=\"--\""
    APPEND "export cost1=\"--\""
    APPEND "export gcho=\"--\""
    APPEND "export echo=\"--\""
    APPEND "export e2cho=\"--\""
    APPEND "export e1=\"--\""
    APPEND "export dmgnpc=0"
    APPEND "export ls1=0"
    APPEND "export killcount=0"
    APPEND "export ls2=0"
    APPEND "export la1=0"
    APPEND "export la2=0"
    APPEND "export hp=100"
    APPEND "export orighp=100"
    APPEND "export armtype=\"No\""
    APPEND "export swordtype=\"Your\""
    APPEND "export skind=\"hand\""
    APPEND "export buyword1=\"hi\""
    APPEND "export buyword2=\"hi\""
    APPEND "export curlvl=1"
    APPEND "export aan=\"a\""
    APPEND "export bankgold=0"
    APPEND "export swordchoice=\"hi\""
    APPEND "export swordchoice2=\"hi\""
    APPEND "export swordchoice3=\"hi\""
    APPEND "export swordexist=\"hi\""
    APPEND "export sprice=0"
    APPEND "export armchoice=\"hi\""
    APPEND "export armchoice2=\"Armor\""
    APPEND "export aprice=0"
    APPEND ""
    APPEND "# [ Player Statistics ] #"
    APPEND "export playerxp=0"
    APPEND "export xpuntil=500"
    APPEND "export origxp=500"
    APPEND "export money=100"
    APPEND "export key=0"
    APPEND "export damage=0"
    APPEND "export total_level=13"
    APPEND ""
    APPEND "# [ Woodcutting Skill Stats ] #"
    APPEND "export Woodcuttinglvl=1"
    APPEND "export Woodcuttingxpremain=100"
    APPEND "export Woodcuttingxpgain=38"
    APPEND "export Woodcuttingcurxp=0"
    APPEND "export Woodcuttingxpleft=100"
    APPEND ""
    APPEND "# [ Cooking Skill Stats ] #"
    APPEND "export Cooklvl=1"
    APPEND "export Cookxpremain=100"
    APPEND "export Cookxpgain=41"
    APPEND "export Cookcurxp=0"
    APPEND "export Cookxpleft=100"
    APPEND ""
    APPEND "# [ Fishing Skill Stats ] #"
    APPEND "export Fishinglvl=1"
    APPEND "export Fishingxpremain=100"
    APPEND "export Fishingxpgain=30"
    APPEND "export Fishingcurxp=0"
    APPEND "export Fishingxpleft=100"
    APPEND ""
    APPEND "# [ Mining Skill Stats ] #"
    APPEND "export Mininglvl=1"
    APPEND "export Miningxpremain=100"
    APPEND "export Miningxpgain=35"
    APPEND "export Miningcurxp=0"
    APPEND "export Miningxpleft=100"
    APPEND ""
    APPEND "# [ Smithing Skill Stats ] #"
    APPEND "export Smithinglvl=1"
    APPEND "export Smithingxpremain=100"
    APPEND "export Smithingxpgain=33"
    APPEND "export Smithingcurxp=0"
    APPEND "export Smithingxpleft=100"
    APPEND ""
    APPEND "# [ Thieving Skill Stats ] #"
    APPEND "export Thievinglvl=1"
    APPEND "export Thievingxpremain=100"
    APPEND "export Thievingxpgain=36"
    APPEND "export Thievingcurxp=0"
    APPEND "export Thievingxpleft=100"
    APPEND ""
    APPEND "# [ Player Inventory ] #"
    APPEND "export dr=0"
    APPEND "export gmail=0"
    APPEND "export hbone=0"
    APPEND "export dhide=0"
    APPEND "export rtab=0"
    APPEND "export food=0"
    APPEND "export rfood=0"
    APPEND "export bait=0"
    APPEND "export ea=None"
    APPEND "export potion=0"
    APPEND "export ingot=0"
    APPEND "export seed=0"
    APPEND "export bow=0"
    APPEND "export fur=0"
    APPEND "export gem=0"
    APPEND "export log=0"
    APPEND "export ore=0"
    APPEND "export morb=0"
    APPEND "export arm1=0"
    APPEND "export arm2=0"
    APPEND "export arm3=0"
    APPEND "export arm4=0"
    APPEND "export arm5=0"
    APPEND "export arm6=0"
    APPEND "export arm7=0"
    APPEND "export arm8=0"
    APPEND "export arm9=0"
    APPEND "export arm10=0"
    APPEND "export arm11=0"
    APPEND "export arm12=0"
    APPEND "export ma1=0"
    APPEND "export ma2=0"
    APPEND "export ma3=0"
    APPEND "export ma4=0"
    APPEND "export ma5=0"
    APPEND "export ma6=0"
    APPEND "export ma7=0"
    APPEND "export ma8=0"
    APPEND "export ma9=0"
    APPEND "export ma10=0"
    APPEND "export ms1=0"
    APPEND "export ms2=0"
    APPEND "export ms3=0"
    APPEND "export ms4=0"
    APPEND "export ms5=0"
    APPEND "export ms6=0"
    APPEND "export ms7=0"
    APPEND "export ms8=0"
    APPEND "export ms9=0"
    APPEND "export ms10=0"
    APPEND "export sword1=0"
    APPEND "export sword2=0"
    APPEND "export sword3=0"
    APPEND "export sword4=0"
    APPEND "export sword5=0"
    APPEND "export sword6=0"
    APPEND "export sword7=0"
    APPEND "export sword8=0"
    APPEND "export sword9=0"
    APPEND "export sword10=0"
    APPEND "export sword11=0"
    APPEND "export sword12=0"
    APPEND "export axxx=0"
    APPEND "export pgmail=300"
    APPEND "export phbone=550"
    APPEND "export pdhide=750"
    APPEND "export prtab=250"
    APPEND "export ppotion=200"
    APPEND "export pfood=100"
    APPEND "export pingot=473"
    APPEND "export pseed=150"
    APPEND "export prfood=100"
    APPEND "export pbait=2"
    APPEND "export pfur=200"
    APPEND "export pore=500"
    APPEND "export plog=275"
    APPEND "export pgem=1000"
    APPEND "export pbow=713"
    APPEND "export pmorb=15000"
}

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

function login() {
    HEADER
    read -r -p "Username > " USERNAME
    PROFILE_FILE="./.profiles/$(LOWERCASE ${USERNAME}).sh"

    [[ ! -e "${PROFILE_FILE}" ]] && {
        PRINT "\nProfile '${USERNAME}' does not exist."
        PAUSE
        first_menu
    }

    . "${PROFILE_FILE}"

    read -r -s -p "Password (cAsE sEnsiTivE) > " password
    PRINT

    [[ ! "${password}" == "${PASSWORD}" ]] && {
        PRINT "\nPassword does not match."
        PAUSE
        first_menu
    }

    PRINT "\nWelcome to final realm, ${USERNAME}."
    PAUSE

    game_menu
}

function register() {
    HEADER
    read -r -p "Username > " USERNAME

    export PROFILE_FILE="./.profiles/$(LOWERCASE ${USERNAME}).sh"

    [[ -e "${PROFILE_FILE}" ]] && {
        PRINT "\nProfile '${USERNAME}' already exists."
        PAUSE
        first_menu
    }

    read -r -s -p "Password (cAsE sEnsiTivE) > " password1
    PRINT
    read -r -s -p "Confirm Password > " password2
    PRINT

    [[ "${password1}" != "${password2}" ]] && {
        PRINT "\nDifferent passwords given. Cancelling."
        PAUSE
        first_menu
    }

    PASSWORD="${password1}"

    save_profile

    # Confirmation
    PRINT "\nProfile '${USERNAME}' created!"
    PAUSE

    first_menu
}

first_menu

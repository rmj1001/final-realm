#!/usr/bin/env bash

###################################################
# [ Important Functions ] #
###################################################
function PRINT() {
    printf "%b\n" "$@"
}

function LOWERCASE() {
    printf "%b" "${1}" | tr "[:upper:]" "[:lower:]"
}

###################################################
# [ Handling SIGINT ] #
###################################################
function ctrl_c() {
    clear
    exit 0
}

trap ctrl_c INT

###################################################
# [ Script Config ] #
###################################################
project_folder="${HOME}/.local/share/final-realm"
repository="${project_folder}/repository"
game="/usr/share/bin/final-realm"
mgr="/usr/share/bin/final-realm-mgr"
EXIT=1

###################################################
# [ Clone/Update local repository ] #
###################################################
function clone_or_update_repo() {
    REPO_EXISTS=false
    [[ -d "${repository}" ]] && REPO_EXISTS=true

    [[ $REPO_EXISTS == true ]] && {
        cd "${repository}" && git pull && return 0
    }

    mkdir -p "${repository}"
    git clone git@github.com:rmj1001/final-realm.git "${repository}"
}

###################################################
# [ Install files ] #
###################################################
function install_files() {
    sudo install -m +x -t "${game}" "${repository}/final-realm.sh"
    sudo install -m +x -t "${mgr}" "${repository}/final-realm-mgr.sh"
}

###################################################
# [ Uninstall Final Realm ] #
###################################################
function uninstall_files() {
    [[ -d "${project_folder}" ]] && rm -rf "${project_folder}"
    sudo rm -f "${game}"
    sudo rm -f "${mgr}"
}

###################################################
# [ Manager Menu ] #
###################################################
while [[ $EXIT -ne 0 ]]; do
    clear
    PRINT "#######################################################################################"
    PRINT "# ███████ ██ ███    ██  █████  ██          ██████  ███████  █████  ██      ███    ███ #"
    PRINT "# ██      ██ ████   ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ████  ████ #"
    PRINT "# █████   ██ ██ ██  ██ ███████ ██          ██████  █████   ███████ ██      ██ ████ ██ #"
    PRINT "# ██      ██ ██  ██ ██ ██   ██ ██          ██   ██ ██      ██   ██ ██      ██  ██  ██ #"
    PRINT "# ██      ██ ██   ████ ██   ██ ███████     ██   ██ ███████ ██   ██ ███████ ██      ██ #"
    PRINT "#######################################################################################"
    PRINT
    PRINT
    PRINT "Please choose an option."
    PRINT "1. Install or Upate"
    PRINT "2. Uninstall"
    PRINT
    PRINT "0. Exit"
    PRINT
    read -r -p "ID > " option

    case "$(LOWERCASE ${option})" in
    0 | 'exit')
        clear
        exit 0
        ;;
    1 | 'install or update' | 'install' | 'update')
        clone_or_update_repo
        install_files
        ;;
    2 | 'uninstall')
        uninstall_files
        ;;
    *)
        [[ -n "${option}" ]] && {
            PRINT "Invalid option '${option}'."
            read -r -p "PRESS <ENTER> TO CONTINUE..."
            continue
        }

        PRINT "You must choose an option."
        read -r -p "PRESS <ENTER> TO CONTINUE..."
        continue
        ;;
    esac

done

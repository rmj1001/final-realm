#!/usr/bin/env bash

PRINT() {
    printf "%b\n" "$@"
}

project_folder="${HOME}/.local/share/final-realm"
repository="${project_folder}/repository"

game="/usr/share/bin/final-realm"
mgr="/usr/share/bin/final-realm-mgr"

installer() {

    [[ -d "${repository}" ]] || mkdir -p "${repository}"

    git clone git@github.com:rmj1001/final-realm.git "${repository}"

    sudo install -m +x -t "${game}" "${repository}/final-realm.sh"
    sudo install -m +x -t "${mgr}" "${repository}/final-realm-mgr.sh"
}

uninstaller() {
    [[ -d "${project_folder}" ]] && rm -rf "${project_folder}"
    sudo rm -f "${game}"
    sudo rm -f "${mgr}"
}

updater() {
    cd "${repository}" || {
        PRINT "Repository does not exist."
        return 1
    }

    git pull

    sudo install -m +x -t "${game}" "${repository}/final-realm.sh"
    sudo install -m +x -t "${mgr}" "${repository}/final-realm-mgr.sh"
}

while [[ $EXIT -ne 0 ]]; do
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
    PRINT "1. Install"
    PRINT "2. Uninstall"
    PRINT "3. Update"
    PRINT
    read -r -p "ID > " option

    case "${LOWERCASE "${option}"}" in
        1 | 'install' )
            installer
        ;;
        2 | 'uninstall' )
            uninstaller
        ;;
        3 | 'update' )
            updater
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
    esac
done
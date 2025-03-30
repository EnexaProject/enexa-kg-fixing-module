#!/bin/bash
# Installs tentris on the system

set -euo pipefail

install_binary() {
    echo "Installing binary at /usr/local/bin/tentris"
    sudo cp tentris /usr/local/bin
    sudo chmod +x /usr/local/bin/tentris
}

create_datastore_dir() {
    echo "Creating datastore directory at /var/local/tentris"
    sudo mkdir -p /var/local/tentris
}

install_systemd_service() {
    if systemctl > /dev/null; then
        echo "Installing systemd unit at /etc/systemd/system/tentris@.service"
        sudo cp tentris@.service /etc/systemd/system
        sudo systemctl daemon-reload
    else
        echo "Skipping installation of systemd unit, systemd does not appear to exist on the system"
    fi
}

install_config() {
    echo "Installing config file at /etc/tentris.d/default.toml"

    if [[ -f /etc/tentris.d/default.toml ]]; then
        echo "There is already a config file present, do you want to overwrite it?"
        while true; do
            read -p "Display diff [D] / Keep own config [N] / Overwrite with new config [Y] " action

            case "$action" in
                [yY]*)
                    echo "Overwriting config file"
                    break
                    ;;
                [nN]*)
                    echo "Keeping config file"
                    return 0
                    ;;
                [dD]*)
                    diff -s systemd-tentris-server-config.toml /etc/tentris.d/default.toml || true
                    ;;
            esac
        done
    fi

    sudo mkdir -p /etc/tentris.d
    sudo cp systemd-tentris-server-config.toml /etc/tentris.d/default.toml
}

install_binary
create_datastore_dir
install_systemd_service
install_config

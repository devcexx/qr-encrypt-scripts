#!/bin/bash
set -eo pipefail

PBKDF2_ITER=300000
PBKDF2_MODE=sha256
PASSWD_PROMPT="Enter Master Password: "
OPENSSL="openssl aes-256-cbc -pbkdf2 -md $PBKDF2_MODE -iter $PBKDF2_ITER -salt"

eecho() {
    echo $@ >&2
}

hex() {
    xxd -p | tr -d '\n'
}

ask_master_password() {
    read -s -p "$PASSWD_PROMPT" password
    echo $password
    unset password
}

ask_master_verify_password() {
    read -s -p "$PASSWD_PROMPT" password_1
    eecho
    read -s -p "Verify - $PASSWD_PROMPT" password_2
    eecho

    if [ "$password_1" != "$password_2" ]; then
	eecho "Password mismatch"
	exit 1
    fi

    unset password_1
    echo $password_2
    unset password_2
}

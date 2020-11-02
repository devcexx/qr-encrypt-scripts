#!/bin/bash
set -eo pipefail
zbarcam --raw -1 $@ | base64 -d | ./decrypt_qr_data.sh

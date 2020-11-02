#!/bin/bash

source prelude.sh
SESS_KEY=$(openssl rand -hex 32)
IV=$(openssl rand -hex 16)

if [ $# -ge 1 ]; then
    MASTER_KEY=$1
else
    exec 69<<<"$(ask_master_verify_password)"
    MASTER_KEY="fd:69"
fi
(xxd -r -p <<< $IV; \
 xxd -r -p <<< $SESS_KEY | \
     $OPENSSL \
	 -e \
	 -iv $IV \
	 -pass "$MASTER_KEY" \
	 -in - \
	 -out -; \
 $OPENSSL \
     -e \
     -iv $IV \
     -K $SESS_KEY \
     -in - \
     -out -)

#!/bin/bash
source prelude.sh

read_bytes() {
    dd iflag=count_bytes count=$1 2>/dev/null
}

IV=$(read_bytes 16 | hex)
SESS_KEY=$(read_bytes 64 | \
	       $OPENSSL \
		   -d \
		   -iv $IV \
		   -in - \
		   -out - | hex)

eecho "Session key: $SESS_KEY"
$OPENSSL \
    -d \
    -iv $IV \
    -K $SESS_KEY \
    -in - \
    -out -

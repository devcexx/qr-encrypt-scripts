#!/bin/bash
zbarcam --raw -1 $@ | base64 -d

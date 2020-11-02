#!/bin/bash

set -x
set -e

rm -rf build
(cd pdfgen && latexmk -C)

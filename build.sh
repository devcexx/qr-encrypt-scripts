#!/bin/bash
source prelude.sh

gen_qr_pdf() {
    base64 | \
	./gen_qr.sh | \
	convert - "$1"
}

MASTER_KEY="$(ask_master_verify_password)"

BUILDI_FOLDER=build/items
mkdir -p $BUILDI_FOLDER
rm -rf $BUILDI_FOLDER/*
for file in items/*.sh
do
    unset ITEM_NAME
    unset ITEM_VALUE
    source $file

    if [ -z "$ITEM_NAME" ]; then
	eecho "Unset variable: ITEM_NAME"
	exit 1
    fi
    
    if [ -z "$ITEM_VALUE" ]; then
	eecho "Unset variable: ITEM_VALUE"
	exit 1
    fi

    fname=$(basename $file)
    echo "$ITEM_NAME" > $BUILDI_FOLDER/$fname.name
    
    exec 69<<<"$MASTER_KEY"
    ./encrypt_qr_data.sh "fd:69" <<< "$ITEM_VALUE" | \
	tee $BUILDI_FOLDER/$fname.enc | \
	gen_qr_pdf "$BUILDI_FOLDER/$fname.pdf"
done

SOURCES=("decrypt_qr_data.sh" "prelude.sh" "decrypt_qr.sh")
for src in ${SOURCES[@]}
do
    echo $src | sed 's/_/\\_/g' > $BUILDI_FOLDER/99-$src.name
    cat $src | gen_qr_pdf $BUILDI_FOLDER/99-$src.pdf
done

(cd pdfgen; latexmk -C && latexmk -shell-escape -lualatex)
mv pdfgen/document.pdf build

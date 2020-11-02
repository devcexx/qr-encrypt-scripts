## What is this?

A set of Bash scripts for encrypting little pieces of data and store
them on QRs.

## Requirements

1. `xxd`
1. `openssl`, for encrypt and decrypt data.
1. `qrencode`, for generating QR codes.
1. `lualatex`, for compiling PDFs.
1. `zbar`, for reading QRs, if needed.

## How To

1. Create a folder "items"
1. Create .sh files that defines both `ITEM_NAME` and `ITEM_VALUE`
   each, that will define the title of the element and its value,
   respectively. The `items/` should look like something like:
    * `01-item1.sh`:
	```sh
	ITEM_NAME="Item1"
	ITEM_VALUE="lorem ipsum"
	```
    * `02-item2.sh`:
	```sh
	ITEM_NAME="Item2"
	ITEM_VALUE="asdf fdsa"
	```

1. Run `./build.sh` for build the final PDF document.

## Scripts

1. `build.sh`: Take all the available items and generate a PDF with
   all of them.
1. `clean.sh`: Cleans the `build` folder.
1. `decrypt_qr_data.sh`: Decrypts raw information stored into a QR
   code from `stdin`.
1. `decrypt_qr.sh`: Executes `zbarcam`, reads a QR code and decrypts
   its contents.
1. `encrypt_qr_data.sh`: Encrypts `stdin` using the QR format into `stdout`.
1. `gen_qr.sh`: Runs `qrencode` for encoding information into a QR code.
1. `prelude.sh`: Just a bunch common of declarations for the rest of
   the scripts.
1. `read_qr.sh`: Execute `zbarcam` for reading a QR.

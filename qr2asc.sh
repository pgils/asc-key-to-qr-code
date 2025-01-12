#!/bin/sh

#####
#
# Author: Kevin Douglas <douglk@gmail.com>
#
# Simple command line script to restore ascii armor gpg keys from a QR image.
# You can use the following commands to import your restored keys:
#
#   gpg --import pgp-public-keys.asc
#   gpg --import pgp-private-keys.asc
#
# This script will allow you to convert QR images created with asc2qr.sh
# info an ascii armor pgp key.
#
# This script depends on the following libraries/applications:
#
#   zbar (http://zbar.sourceforge.net)
#
# If you need to backup or restore binary keys, see this link to get started:
#
#   https://gist.github.com/joostrijneveld/59ab61faa21910c8434c#file-gpg2qrcodes-sh
#
#####

# Name of the output key after decoding
output_key_name="mykey.asc"

# Dependency check
if ! err=$(type zbarimg); then
    echo "${err}"
    exit 1
fi

# Argument/usage check
if [ $# -lt 1 ]; then
    echo "usage: $(basename "${0}") <QR image 1> [QR image 2] [...]"
    exit 1
fi

# For each image on the command line, decode it into text
asc_key=""
for img in "$@"; do
    if [ ! -f "${img}" ]; then
        echo "image file not found: '${img}'"
        exit 1
    fi
    echo "decoding ${img}"
    if ! chunk=$(zbarimg --raw --set disable --set qrcode.enable "${img}" 2>/dev/null); then
        echo "failed to decode QR image"
        exit 2
    fi
    asc_key="${asc_key}${chunk}"
done

echo "creating ${output_key_name}"
echo "${asc_key}" >${output_key_name}

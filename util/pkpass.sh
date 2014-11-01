#!/bin/sh

# Creates a signed Apple Passbook from a directory tree according to
# documentation at https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/PassKit_PG/
#
# This script works on Mac and Linux. If Windows, you are on your own.
#
# OpenSSL commands were learned and improved from
# https://github.com/kyleroche/iOS6-passbook-helper/blob/master/pkpass.sh
#
# Script by Avi Alkalay <avi at unix dot sh>
# 2014-10-28
# Brazil

# Everywhere the $EMAILCHAR appears on passbook text files it will be substituted by "@".
# I'm doing this because my personal data on these files will be pushed to GitHub as
# an example into the Digital Business Card source code.
EMAILCHAR="ⓐ"

APPLEWWDRCA="`dirname $0`/AppleWWDRCA.pem"

CERTIFICATE="$1"
SOURCE="$2"
PASSWORD="$3"
PKPASS="$4"

if [[ ! -d "$SOURCE" ]]; then
	echo "$SOURCE" not a directory >&2
	echo "FORMAT: $0 certificate.p12 path/to/package/content password [PackageName]"
	exit 1
fi

TMPPP=$TMPDIR
[[ -z "$TMPPP" ]] && TMPPP="/tmp"

PRIVATEKEY="`mktemp $RANDOM.key.pem`"
CERT="`mktemp $RANDOM.cert.pem`"
PACKAGE=`mktemp -d $TMPPP/$RANDOM`

echo "Packaging directory $SOURCE in $PACKAGE"

(cd $SOURCE; find . | egrep -v ".DS_Store|signature|manifest.json" | sort | while read f; do
	if (echo "$f" | egrep -q ".strings|.json"); then
		sed -e "s|$EMAILCHAR|@|g" < "$f" > "$PACKAGE/$f"
	else
		echo "$f" | cpio --quiet -pdm $PACKAGE
	fi
done)

# start writing manifest 
echo "{" > "$PACKAGE/manifest.json"
first=true

for file in `find "$PACKAGE" -type f | sed -e "s|$PACKAGE/||" | sort`; do
	if [ "$file" = "manifest.json" -o "$file" = "signature" ]; then
		continue
	fi
	
	checksum=$(openssl sha1 "$PACKAGE/$file" | sed -e 's/SHA1\(.*\)= //')
	
	if [[ "$first" == "false" ]]; then
		echo "," >> "$PACKAGE/manifest.json"
	else
		first="false" 
	fi
	
	/bin/echo -n "    \"$file\": \"$checksum\"" >> "$PACKAGE/manifest.json"
done
echo >> "$PACKAGE/manifest.json"
echo "}" >> "$PACKAGE/manifest.json"


echo "Extracting crypto data from $CERTIFICATE"

openssl pkcs12 -in "$CERTIFICATE" -clcerts -nokeys -passin "pass:$PASSWORD" -out "$CERT"
openssl pkcs12 -in "$CERTIFICATE" -nocerts -passin "pass:$PASSWORD" -nodes -out "$PRIVATEKEY"

echo "Signing with $APPLEWWDRCA and $CERTIFICATE"

openssl smime -binary -sign -certfile $APPLEWWDRCA -signer "$CERT" -inkey "$PRIVATEKEY" -in "$PACKAGE/manifest.json" -out "$PACKAGE/signature" -outform DER

echo "Cleaning up"

rm -f "$CERT"
rm -f "$PRIVATEKEY"

if [[ -n "$PKPASS" ]]; then
	OUT="$PKPASS.pkpass"
else
	OUT="passbook.pkpass"
fi

current=`pwd`

rm $OUT

echo "Compressing into $OUT"

(cd "$PACKAGE"; zip -q9r "$current/$OUT" *)

#rm -rf "$PACKAGE"

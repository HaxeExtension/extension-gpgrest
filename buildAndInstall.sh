#!/bin/bash
dir=`dirname "$0"`
cd "$dir"

EXTNAME="extension-gpgrest"

rm -rf $EXTNAME.zip

zip -r $EXTNAME.zip haxelib.json Source

haxelib remove $EXTNAME
haxelib local $EXTNAME.zip

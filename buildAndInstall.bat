@ECHO OFF
SET EXTNAME="extension-gpgrest"

REM Build extension
zip -r %EXTNAME%.zip haxelib.json Source
haxelib local %EXTNAME%.zip

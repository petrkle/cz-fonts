#!/usr/bin/bash

TMP=tmp
FONTS=FontsFolder

[ -d $FONTS ] || mkdir $FONTS
[ -d $TMP ] || mkdir $TMP

for foo in `cat fonts.url`
do
	ARCHIVE=`basename $foo`

	if [ ! -f $TMP/$ARCHIVE ]
	then
		wget -qO $TMP/$ARCHIVE $foo
	fi
	unzip -qqod $FONTS $TMP/$ARCHIVE
done

detox -rs lower $FONTS/* 2> /dev/null

find $FONTS -type f ! -name "*.ttf" -and ! -name "*.otf" -exec rm \{\} \;

find $FONTS -type d -mindepth 1 -maxdepth 1 -exec rm -rf \{\} \;

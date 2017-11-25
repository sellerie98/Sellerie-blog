#!/bin/bash

outputFolder="../mimoja.de"
description="DESCRIPTION"

mkdir -p $outputFolder;

# initialize the index
printf "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset="utf-8" />\n<title>/sys/class/mimoja</title>\n<style type="text/css">body{margin:40px auto;max-width:700px;text-align:justify;line-height:1.6;font-size:16px;color:#444;padding:0 10px}h1,h2,h3{line-height:1.2}</style>\n</head>\n" > $outputFolder/index.html
echo "<h1>/sys/class/mimoja</h1>" >> $outputFolder/index.html
cat banner >> $outputFolder/index.html

for D in sources/*; do
    if [ -d "${D}" ]; then
        if [ -f $D/$description ]; then
	   desc=$(cat $D/$description);
	   echo "<h2>$desc</h2>" >> $outputFolder/index.html
	fi
        if [ -d "${D}" ]; then
            foldername=$(basename $D);
	    foldername=${foldername:3};

	    mkdir -p $outputFolder/$foldername;

            for file in $D/*.md; do
                # useless output
                echo "processing $file..."

                # get basename
                basename="$(basename "$file" .md)"
                path="sources/tech/$basename"
                # generate article HTML
                pandoc -o "$outputFolder/$foldername/$basename.html" --template=template -B header -A footer "$file"
                # add links to index
                echo "<a href=\"$foldername/$basename.html\">$basename</a><br/>" >> $outputFolder/index.html
            done

	    for CD in $D/*; do
    	        if [ -d "${CD}" ]; then
	    	    subfoldername=$(basename $CD);
		    echo "moving     $CD -> $outputFolder/${foldername}/$subfoldername";
		    cp -R $CD $outputFolder/${foldername}/;
		fi;
            done;
        fi
    fi
done

# finalize index
printf "<small>Thanks to twk for providing the static site generator</small>\n" >> $outputFolder/index.html
printf "</body>\n</html>\n" >> $outputFolder/index.html

# copy highlight.js
cp -R highlight.js $outputFolder/highlight

git add .

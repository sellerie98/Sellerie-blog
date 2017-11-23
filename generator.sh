#!/bin/sh

# initialize the index
printf "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n<meta charset="utf-8" />\n<title>/sys/class/mimoja</title>\n<style type="text/css">body{margin:40px auto;max-width:700px;text-align:justify;line-height:1.6;font-size:16px;color:#444;padding:0 10px}h1,h2,h3{line-height:1.2}</style>\n</head>\n" > index.html
echo "<h1>/sys/class/mimoja</h1>" >> index.html
cat banner >> index.html

echo "<h2>Tech stuff</h2>" >> index.html
for file in sources/tech/*.md
do
	# useless output
	echo "processing $file..."

	# get basename
	basename="$(basename "$file" .md)"
	path="sources/tech/$basename"
	# generate article HTML
	pandoc -o "$basename.html" --template=template -B header -A footer "$file" 

	# add links to index
	echo "<a href=\"$basename.html\">$basename</a><br/>" >> index.html
done

echo "<h2>Coocking stuff (DE)</h2>" >> index.html
for file in sources/cook/*.md
do
        # useless output
        echo "processing $file..."

        # get basename
        basename="$(basename "$file" .md)"
        path="sources/cook/$basename"
        # generate article HTML
        pandoc -o "$basename.html" --template=template -B header -A footer "$file" 

        # add links to index
        echo "<a href=\"$basename.html\">$basename</a><br/>" >> index.html
done


# finalize index
printf "<small>Thanks to twk for providing the static site generator</small>\n" >> index.html
printf "</body>\n</html>\n" >> index.html

# add all other files to git
git add *.html

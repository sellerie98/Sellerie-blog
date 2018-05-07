#!/bin/bash

./generator.sh
git add -a
git commit
git push
sudo cp ./aufmachen.jetzt/Technology_Stuff/* /var/www/aufmachen.jetzt/html/Technology_Stuff/
sudo cp ./aufmachen.jetzt/index.html /var/www/aufmachen.jetzt/html/index.html

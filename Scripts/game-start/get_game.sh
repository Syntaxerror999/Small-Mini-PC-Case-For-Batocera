#!/bin/bash
#VERSION=2.3

# Gets game's name and sends to the scratch pad
game="${3}" #EmulationStation arg to get current game's name

#Write game name to the scratch pad
sed -i "s|^\(NAME[[:blank:]]*=[[:blank:]]*\).*|\1${game//&/\\&}|" /tmp/elecrow.scratch


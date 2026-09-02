#!/bin/bash

#gets System being played and handles resetting the scratchpad

case "$1" in
	gameStart)
        system="$2"
        sed -i "s|^\(SYSTEM[[:blank:]]*=[[:blank:]]*\).*|\1$system|" /tmp/elecrow.scratch
        ;;
    gameStop)
    sed -i "s|^\(NAME[[:blank:]]*=[[:blank:]]*\).*|\1null|" /tmp/elecrow.scratch
    sed -i "s|^\(SYSTEM[[:blank:]]*=[[:blank:]]*\).*|\1null|" /tmp/elecrow.scratch
    sed -i "s|^\(UPDATE[[:blank:]]*=[[:blank:]]*\).*|\11|" /tmp/elecrow.scratch

esac
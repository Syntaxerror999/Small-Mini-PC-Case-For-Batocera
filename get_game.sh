#!/bin/bash

# Gets games name and sets the UPDATE flag in the scratch pad
game="${3}"

sed -i "s|^\(NAME[[:blank:]]*=[[:blank:]]*\).*|\1$game|" /tmp/elecrow.scratch
sed -i "s|^\(UPDATE[[:blank:]]*=[[:blank:]]*\).*|\11|" /tmp/elecrow.scratch


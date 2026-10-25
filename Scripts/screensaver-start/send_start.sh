#!/bin/bash
#VERSION=2.3

# send screen saver status flag to the scratch pad
sed -i "s|^\(STATUS[[:blank:]]*=[[:blank:]]*\).*|\11|" /tmp/elecrow.scratch


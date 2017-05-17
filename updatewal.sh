#!/bin/bash

# WAL theme previewer and setter by Adam Hallgat
# https://github.com/hallgat89/WAL-theme-previewer-for-Nitrogen
# download the WAL sript from here: https://github.com/dylanaraps/wal

trap "killall nitrogen" SIGINT SIGTERM

# the location of the WAL script
WAL="$HOME/.scripts/wal.sh -n -i"

nitrogen --sort=alpha &

# use image from nitrogen
NITCONF='$HOME/.config/nitrogen/bg-saved.cfg'
IMG="cat $NITCONF | grep file | cut -d'=' -f2"
NITIMG=$(eval "$IMG")

RUNS=`ps -A | grep nitrogen | wc -l`

# run while nitrogen runs
while [ "$RUNS" -gt "0" ]
do
    RUNS=`ps -A | grep nitrogen | wc -l`
    POLL=$(eval "$IMG")
    
    # check if nitrogen config changed
    if [ "$POLL" != "$NITIMG" ]
    then
        # set and preview new colorscheme
        NITIMG=$POLL
        $(eval $WAL "\"$NITIMG\"" -t)
        RUNS=`ps -A | grep nitrogen | wc -l`
        echo -e "\033[0mNC (No color)"
        echo -e "\033[1;37mWHITE\t\033[0;30mBLACK"
        echo -e "\033[0;34mBLUE\t\033[1;34mLIGHT_BLUE"
        echo -e "\033[0;32mGREEN\t\033[1;32mLIGHT_GREEN"
        echo -e "\033[0;36mCYAN\t\033[1;36mLIGHT_CYAN"
        echo -e "\033[0;31mRED\t\033[1;31mLIGHT_RED"
        echo -e "\033[0;35mPURPLE\t\033[1;35mLIGHT_PURPLE"
        echo -e "\033[0;33mYELLOW\t\033[1;33mLIGHT_YELLOW"
        echo -e "\033[1;30mGRAY\t\033[0;37mLIGHT_GRAY"
    
    
        # info about the top left pixel
        convert "$NITIMG" -crop "1x1+100+200" txt:-
    
        # get the top left pixel color of the image in hexa
        WALLBG=`convert "$NITIMG" -set colorspace sRGB -crop "1x1+100+200" txt:- | grep ^0,0: | cut -d'#' -f2 | cut -d' ' -f1`
    
        # replace the bgcolor in nitrogen config (4th line)
        sed -i "4s/.*/bgcolor=#${WALLBG:0:6}/" .config/nitrogen/bg-saved.cfg 
    
        # apply bgcolor in nitrogen
        nitrogen --restore 
    fi
     
    sleep 1
done

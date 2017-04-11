#!/bin/bash

# WAL theme previewer and setter by Adam Hallgat
# https://github.com/hallgat89/WAL-theme-reviewer-for-Nitrogen

# adjust the script

trap "killall nitrogen" SIGINT SIGTERM

# the location of the WAL script
WAL="~/.scripts/wal -n -i"

nitrogen --sort=alpha &

# use image from nitrogen
IMG="cat $HOME/.config/nitrogen/bg-saved.cfg | grep file | cut -d= -f2"
NITIMG=$(eval $IMG)

RUNS=`ps -A | grep nitrogen | wc -l`

while [ "$RUNS" -gt "0" ]
do
    RUNS=`ps -A | grep nitrogen | wc -l`
    POLL=$(eval $IMG)
    if [ "$POLL" != "$NITIMG" ]
    then
        NITIMG=$POLL
        $(eval $WAL "$NITIMG")
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
    fi
    sleep 1
done

nitrogen --restore

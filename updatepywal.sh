#!/bin/bash

# WAL theme previewer and setter by Adam Hallgat
# https://github.com/hallgat89/WAL-theme-previewer-for-Nitrogen
# download the WAL sript from here: https://github.com/dylanaraps/wal

trap "killall nitrogen" SIGINT SIGTERM

color () {
    # echo ""
    #black
    echo -e "\e[0;30m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 01 0;30m"
    #red
    echo -e "\e[0;31m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 02 0;31m"
    #green
    echo -e "\e[0;32m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 03 0;32m"
    #yellow
    echo -e "\e[0;33m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 04 0;33m"
    #blue
    echo -e "\e[0;34m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 05 0;34m"
    #purple
    echo -e "\e[0;35m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 06 0;35m"
    #cyan
    echo -e "\e[0;36m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 07 0;36m"
    #white
    echo -e "\e[0;37m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 08 0;37m"
    echo ""
    #black
    echo -e "\e[1;30m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 09 1;30m"
    #red
    echo -e "\e[1;31m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 10 1;31m"
    #green
    echo -e "\e[1;32m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 11 1;32m"
    #yellow
    echo -e "\e[1;33m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 12 1;33m"
    #blue
    echo -e "\e[1;34m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 13 1;34m"
    #purple
    echo -e "\e[1;35m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 14 1;35m"
    #cyan
    echo -e "\e[1;36m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 15 1;36m"
    #white
    echo -e "\e[1;37m ███ *** AaBbCs ---  ███ \\e[0m   ---> Color 16 1;37m"
    echo ""
    echo -e "\e[0;30m█████\\e[0m\e[0;31m█████\\e[0m\e[0;32m█████\\e[0m\e[0;33m█████\\e[0m\e[0;34m█████\\e[0m\e[0;35m█████\\e[0m\e[0;36m█████\\e[0m\e[0;37m█████\\e[0m"
    echo -e "\e[0m\e[1;30m█████\\e[0m\e[1;31m█████\\e[0m\e[1;32m█████\\e[0m\e[1;33m█████\\e[0m\e[1;34m█████\\e[0m\e[1;35m█████\\e[0m\e[1;36m█████\\e[0m\e[1;37m█████\\e[0m"
}

# the location of the WAL script
WAL="wal -n -i"

nitrogen --sort=alpha &

# use image from nitrogen
NITCONF='$HOME/.config/nitrogen/bg-saved.cfg'
IMG="cat $NITCONF | grep "file" | cut -d'=' -f2 | tail -1"
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
        
        # info about the top left pixel
        convert "$NITIMG" -crop "1x1+100+200" txt:-
        
        color
    
        # get the top left pixel color of the image in hexa
        WALLBG=`convert "$NITIMG" -crop "1x1+0+0" txt:- | grep ^0,0: | cut -d'#' -f2 | cut -d' ' -f1`
    
        # replace the bgcolor in nitrogen config (4th line)
        sed -i "4s/.*/bgcolor=#${WALLBG:0:6}/" .config/nitrogen/bg-saved.cfg 
    
        # set gsettings
        gsettings set org.gnome.desktop.background picture-uri 'file://'"$NITIMG" 
    
        # apply bgcolor in nitrogen
        nitrogen --restore 
    fi
     
    sleep 1
done

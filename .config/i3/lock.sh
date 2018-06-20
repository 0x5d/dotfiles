#!/usr/bin/env sh

SCREENSHOT=/tmp/screen.png
ICON=$HOME/.config/i3/icon.png
maim --hidecursor $SCREENSHOT
convert $SCREENSHOT -scale 10% -scale 1000% $SCREENSHOT

if [ -f $ICON ]
then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    R=$(file $ICON | grep -o '[0-9]* x [0-9]*')
    RX=$(echo $R | cut -d' ' -f 1)
    RY=$(echo $R | cut -d' ' -f 3)

    SR=$(xrandr --query | grep ' connected' | sed 's/primary //' | cut -f3 -d' ')
    for RES in $SR
    do
        echo $RES
        # monitor position/offset
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))

        convert $SCREENSHOT $ICON -geometry +$PX+$PY -composite -matte $SCREENSHOT
    done
fi

i3lock -p win -e -u -n -i $SCREENSHOT

#!/bin/sh

#MODPATH='/data/data/com.termux/files/home/VideoEnhancementPlusExtra/'

whichownerchanged=$(find /sys/class/leds/wled/ -user system |head -1|xargs basename)
whichcommandchangedowner=$(grep -n "$whichownerchanged" /system/vendor/etc/init/*.rc|head -1)
rcpath=$(echo "$whichcommandchangedowner"|awk -F ':' '{print $1}')
line=$(echo "$whichcommandchangedowner"|awk -F ':' '{print $2}')
command=$(echo "$whichcommandchangedowner"|awk -F ':' '{print $3}')
rcdir=$(dirname "$rcpath")
rcname=$(basename "$rcpath")
dirtobemake="$MODPATH$rcdir"
finalrcpath="$dirtobemake/$rcname"
mkdir -p "$dirtobemake"
head -"$line" "$rcpath" > "$finalrcpath"
echo "$command"|sed "s/$whichownerchanged/en_cabc/" >> "$finalrcpath"
tail +$(($line+1)) "$rcpath" >> "$finalrcpath"

# too late to mount, overwirte directly
echo -e "#!/bin/sh\n$command"|sed "s/$whichownerchanged/en_cabc/;s/^ *//;s/system *system/system.system/" > "$MODPATH/post-fs-data.sh"

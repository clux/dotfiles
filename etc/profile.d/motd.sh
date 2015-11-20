#!/bin/bash
export PATH=/usr/games:$PATH
# TODO: needs local/node/bin for jsontool

cpu5=$(awk '{printf("%3.1f%%", $2*100/'"$(nproc)"') }' < /proc/loadavg)
ifbytes() {
  ifconfig eth0 | grep -oE "$1 bytes:.*" | cut -d ":" -f2 | awk '{printf("%3.1fGB\n", $1/1073741824)}'
}

RECV=$(ifbytes RX)
SENT=$(ifbytes TX)

KERNEL=$(uname -r)
CPU=$(awk -F '[ :][ :]+' '/^model name/ { print $2; exit; }' /proc/cpuinfo)
ARCH=$(uname -m)
APT=$(apt-get -s dist-upgrade | awk '/^Inst/ { print $2 }' | wc -l)

disk=$(df -l --total | grep total | awk '{printf("%3.1f%%", $3*100/$2)}')
swap=$(free -m | tail -n 1 | awk '{print $3}')
# Memory
#meminuse=$(free -t -m | grep "buffers/cache" | awk '{print $3" MB";}')
memtotal=$(free -t -m | grep "Mem" | awk '{print $2" MB";}')
memusage=$(free -t | grep "buffers/cache" | awk '{printf("%3.1f%%", $3/($3+$4) * 100)}')

# Processes
#PSA=$(ps -Afl | wc -l)
#PSU=$(ps U $USER h | wc -l)

pm2statuses=$(pm2 jlist | json -a pm2_env.status)
PSPM2=$($pm2statuses | wc -l)
PSPM2DONE=$($pm2statuses | grep stopped | wc -l)

#System uptime
uptime=$(cat /proc/uptime | cut -f1 -d.)
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

#Color variables
W="\033[00;37m"
B="\033[01;36m"
R="\033[01;34m"
X="\033[01;37m"
A="\033[01;32m"

echo "Welcome to $(uname -n)" | cowsay -f eyes | lolcat
echo -e "$R======================================================="
echo -e "  $R KERNEL$W $KERNEL"
echo -e "  $R CPU$W $CPU"
echo -e "  $R ARCH$W $ARCH"
echo -e "  $R SYSTEM$W $APT packages can be updated"
echo -e "  $R USERS$W Currently $(users | wc -w) users logged on"
echo -e "$R======================================================="
echo -e "  $R CPU Usage$W $cpu5 (5 min)"
echo -e "  $R Memory Used$W $memusage of $memtotal"
if [ $swap -ne 0 ]; then
echo -e "  $R Swap in use$W  $swap MB"
fi
if [ $PSPM2 -ne 0 ]; then
echo -e "  $R Jobs$W Completed $PSPM2DONE out of $PSPM2"
fi
echo -e "  $R Network$W RX $RECV $B-$W TX $SENT"
echo -e "  $R System Uptime$W $upDays days $upHours hours $upMins minutes $upSecs seconds"
echo -e "  $R Disk Space Used$W $disk"
echo -e "$R======================================================="
echo -e "$X"

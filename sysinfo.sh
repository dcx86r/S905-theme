#!/bin/sh

#quick n dirty one-off sysinfo script for S905 SoC

#GPU clock set: echo [0-4] > /sys/class/mpgpu/cur_freq
#0 - 125MHz, 4 - 666MHz

ESC=$(printf "\e")
RESET="$ESC[00m"
cpuinfo=$(cat /proc/cpuinfo)
cores=$(echo "$cpuinfo" | grep -c ^processor)
mftr=$(echo "$cpuinfo" | sed -n /Hardware/p | awk '{print $NF}')
arch=$(echo "$cpuinfo" | sed -n /Processor/p | awk '{print $3 " " $4}')
cpu_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq)
cpu_clk=$(echo "scale=2;$cpu_freq/1000000" | bc)
gpu_clk=$(cat /sys/class/mpgpu/cur_freq)
mem=$(free -h | sed -n 2p | awk '{print $3 " / " $2}')
kern=$(uname -mrs)
temp=$(echo "$(cat /sys/class/thermal/thermal_zone0/temp)/1000" | bc)
gpu=$(cat /sys/class/misc/mali/device/modalias | sed -n s/^.*,//p)
term=$(echo $TERM)
shell=$(echo $SHELL)
cols=$(tput cols)
xpos=$(echo "($cols/2)-(35/2)" |bc)

CNTR() {
	printf '%*s' $xpos
}

CNTR
echo "$ESC[35m-----------------------------------$RESET"
echo
CNTR
echo "$ESC[32mOS$RESET  : $kern"
CNTR
echo "$ESC[32mSH$RESET  : $shell"
CNTR
echo "$ESC[32mTERM$RESET: $term"
CNTR
echo "$ESC[32mCPU$RESET : $mftr ($cores) @ $cpu_clk GHz [$temp°C]"
CNTR
echo "$ESC[32mGPU$RESET : $gpu @ $gpu_clk MHz"
CNTR
echo "$ESC[32mMEM$RESET : $mem"
echo
CNTR
echo -n "$ESC[41m"
printf '%*s' 5
echo -n "$ESC[42m"
printf '%*s' 5
echo -n "$ESC[43m"
printf '%*s' 5
echo -n "$ESC[44m"
printf '%*s' 5
echo -n "$ESC[45m"
printf '%*s' 5
echo -n "$ESC[46m"
printf '%*s' 5
echo -n "$ESC[47m"
printf '%*s' 5
echo "$RESET"
echo
CNTR
echo "$ESC[35m-----------------------------------$RESET"


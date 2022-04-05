#!/bin/sh
#===================================================================================
#
# FILE: gimmeram.sh
#
# USAGE: gimmeram.sh
#
# DESCRIPTION:
# Run the script in the background.
# Edit the parameters section before use.
#
# AUTHOR: Mátyás ARADI (matyasaradi) / gimmeram
#===================================================================================

## PARAMETERS

# kill the devourer_of_memory process
execute_command="killall devourer_of_memory"
command_name="The Devourer of Memory is closed."

first_warning_level=500 #MB free memory
continuous_warning_level=200 #MB free memory
execution_level=120 #MB free memory

## INIT
free_ram=99999999 #MB free memory

## SCRIPT
(
while true ;
do
    free_ram_in_bytes=$(grep MemAvailable /proc/meminfo | sed 's/[^0-9]*//g')
    free_ram_previous=$free_ram
    free_ram=$(($free_ram_in_bytes/1024))
    if [ $free_ram -lt $execution_level ]; then
        #execute_command="kill -9 $(ps -eo pid --sort=-%mem  | head -2 | tail -1)" # kill the top memory consuming process (you need to uncomment to use it)
        $execute_command
        notify-send -t 15000 -i ERROR "GIMME RAM!" "There was no free RAM! \n\n$command_name"
    fi

    if [ $free_ram -lt $continuous_warning_level ]; then
        notify-send -t 1 -i ERROR "GIMME RAM!" "$free_ram MB available"
    fi

    if [ $free_ram -lt $first_warning_level ]; then
        if [ $free_ram_previous -gt $first_warning_level ]; then
            notify-send -t 15000 "GIMME RAM!" "Memory goes out! \n\nClose unnecessary applications! \n$free_ram MB RAM available"
        fi
    fi

    sleep 1.7;
done
)


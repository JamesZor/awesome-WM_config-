# bash script to collect all wifi/network data and dump to text file.

#!/bin/bash
# $1 State [ connected, asleep, disconnected ] 
# $2 Connectivity [none, portal, limited, full, unkown ]
# $4 WIFI [enabled, disabled]
# -- active_con [ none, $name ]
nmcli g s | awk 'FNR == 2  {print $1, "\n" $2, "\n" $4}'  

active_connection=$(nmcli c s --a | awk 'FNR == 2 {print $1}')
if [ -z "$active_connection" ];
then
    echo "none"
else
    echo $active_connection
fi


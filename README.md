This script control fan speed in dependences of temperature CPU & SSD in linear or discreet modes.
For this script need package lm-sensors and probability something else.
I place command in cron for guarantee of continuity of work

cron
```
* * * * * root ps -A | grep myfancontrol.sh || sudo /home/{user}/myfancontrol.sh
```

usage 
```
myfancontrol.sh restart # for apply changes in script
myfancontrol.sh stop # for stopping script
```

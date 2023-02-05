Hello. I was looking for an application to replace Speedfan for linux. But none of them suited me for various reasons and I had to write my own script. I hope in this skin you will find the idea of controlling a computer fan. Without going into the details of the description of the script, I am laying out its basic commands, however, it is better to determine the initial setup, including the rotation speed and PWM correspondence table, experimentally. The code shows the configuration for my computer, but the parameters may differ on your system.

Description.
This script control fan speed in dependences of temperature CPU & SSD in linear or discreet modes.
For this script need package lm-sensors and probability something else.
I place command in cron for guarantee of continuity of work

Cron
```
* * * * * root ps -A | grep myfancontrol.sh || sudo /home/{user}/myfancontrol.sh
```

Usage 
```
myfancontrol.sh restart # for apply changes in script
myfancontrol.sh stop # for stopping script
```

P.S: This script worked fine for 10 months before I published it here

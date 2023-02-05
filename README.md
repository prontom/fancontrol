cron

```
* * * * * root ps -A | grep myfancontrol.sh || sudo /home/{user}/myfancontrol.sh
```

usage 
```
myfancontrol.sh restart
myfancontrol.sh stop
```

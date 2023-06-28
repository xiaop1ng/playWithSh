# SetUp

> cd home/
>
> yum  install ./google-chrome-stable_current_x86_64.rpm



python 3 

使用定时任务

```commandline
crontab -e

# input
0 */3 * * * /usr/bin/python3 /app/playWithSh/home/initSsr.py > /app/playWithSh/home/autoInitSsr.log


crontab -l
```
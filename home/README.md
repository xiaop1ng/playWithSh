# SetUp

python 3 

使用定时任务

```commandline
crontab -e

# input
0 */3 * * * /usr/bin/python3 /root/py/initSsr.py > /root/py/autoInitSsr.log


crontab -l
```
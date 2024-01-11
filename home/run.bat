@echo off
echo start application...
:: 启动 docker ，frps 自动启动
start "" "C:\Program Files\docker\docker.exe"
:: 启动脚本
python initSsr.py
echo application start success!
:: 打开 ss 客户端
start "" "C:\Shadowsocks-4.4.1.0\Shadowsocks.exe"
pause

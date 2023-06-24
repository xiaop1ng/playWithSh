import time
import platform
import datetime
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from time import localtime,strftime
from selenium.webdriver.chrome.service import Service
# from fake_useragent import UserAgent

# 创建chrome参数对象
options = webdriver.ChromeOptions()
# 解决DevToolsActivePort文件不存在的报错
options.add_argument('--no-sandbox')
# 指定浏览器分辨率
options.add_argument('window-size=1600x900')
# 谷歌文档提到需要加上这个属性来规避bug
options.add_argument('--disable-gpu')
# 隐藏滚动条, 应对一些特殊页面
options.add_argument('--hide-scrollbars')
# 不加载图片, 提升速度
options.add_argument('blink-settings=imagesEnabled=false')
# 隐身模式
options.add_argument("--incognito")


# ua = UserAgent()
# user_agent = ua.random
# print(user_agent)
# options.add_argument(f'user-agent={user_agent}')

sys = platform.system()
print("time: " + strftime("%Y-%m-%d %H:%M:%S", localtime()))
print("system: " + sys)
path='./chromedriver'
if sys == "Linux":
    # 浏览器不提供可视化页面. linux下如果系统不支持可视化不加这条会启动失败
    options.add_argument('--headless')
    path = '/root/py/chromedriver'
elif sys == "Windows":
    path = './chromedriver.exe'



u = ['colin2023', 'colin2022']
p = ['colin@2022', 'colin@2022']
hours = [0,2,4,6,8,10,12,14,16,18,20,22]
h = datetime.datetime.now().hour
try:
    idx = hours.index(h)%2
except Exception as e:
    idx = 0

print("curren user:" + u[idx])

# 初始化一个driver，chromedriver的路径选择的是相对路径，不行就写绝对路径
driver = webdriver.Chrome(options=options, service=Service(executable_path=path))
print("驱动完成初始化.")
print("正在启动终端.")


def playwithdocker(retry = True):
    print("play with docker invoke.")
    # 打开登录页 获取登录按钮
    oauth_url = "https://labs.play-with-docker.com/oauth/providers/docker/login"
    # 请求网页
    driver.get(oauth_url)
    user_name = driver.find_element(By.ID, "username")
    user_name.send_keys(u[idx])
    btn_continue = driver.find_element(By.CLASS_NAME, "_button-login-id")
    btn_continue.click()
    password = driver.find_element(By.ID, "password")
    password.send_keys(p[idx])
    btn_login = driver.find_element(By.CLASS_NAME, "_button-login-password")
    btn_login.click()
    time.sleep(3)
    # 网页主页面请求路径
    url = "https://labs.play-with-docker.com/"
    driver.get(url)
    time.sleep(5)
    btn_start = driver.find_element(By.CLASS_NAME, "btn-success")
    btn_start.click()
    # 检查浏览器地址是否 ooc，尝试从 playwithk8s 启动
    if driver.current_url == "https://labs.play-with-docker.com/ooc" and retry:
        playwithk8s(False)
    else:
        start()
    return


def playwithk8s(retry = True):
    print("play with k8s invoke.")
    # 打开登录页 获取登录按钮
    oauth_url = "https://labs.play-with-k8s.com/oauth/providers/docker/login"
    # 请求网页
    driver.get(oauth_url)
    user_name = driver.find_element(By.ID, "nw_username")
    user_name.send_keys(u[idx])
    password = driver.find_element(By.ID, "nw_password")
    password.send_keys(p[idx])
    btn_login = driver.find_element(By.ID, "nw_submit")
    btn_login.click()
    time.sleep(3)
    # 网页主页面请求路径
    url = "https://labs.play-with-k8s.com/"
    driver.get(url)
    time.sleep(5)
    btn_start = driver.find_element(By.CLASS_NAME, "btn-success")
    btn_start.click()
    # 检查浏览器地址是否 ooc，尝试从 playwithk8s 启动
    if driver.current_url == "https://labs.play-with-k8s.com/ooc" and retry:
        playwithdocker(False)
    else:
        start()
    return

def start():
    time.sleep(10)
    btn_new = driver.find_element(By.CLASS_NAME, "md-primary")
    if btn_new == None:
        time.sleep(50)
        btn_new = driver.find_element(By.CLASS_NAME, "md-primary")
    btn_new.click()

    print("等待主机启动.")
    time.sleep(30)
    terminal = driver.find_element(By.CLASS_NAME, "terminal-container")
    if terminal == None:
        time.sleep(60)
        terminal = driver.find_element(By.CLASS_NAME, "terminal-container")
    if terminal == None:
        time.sleep(60*2)
        terminal = driver.find_element(By.CLASS_NAME, "terminal-container")
    terminal.click()
    newline = driver.find_element(By.CLASS_NAME, "xterm-helper-textarea")
    newline.send_keys("curl https://raw.githubusercontent.com/xiaop1ng/playWithSh/main/home/ssr.sh | sh -")
    newline.send_keys(Keys.ENTER)

    print("done.")
    # 3分钟后退出浏览器，防止脚本没跑完就退出了
    time.sleep(60 * 3)
    # 退出浏览器
    driver.close()
    driver.quit()
# test
def test():
    try:
        playwithdocker()
    except Exception as e:
        print("Error: 打开终端异常，%s", e)

test()
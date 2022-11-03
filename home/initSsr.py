import time
import platform
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

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

sys = platform.system()
print("system: " + sys)
if sys == "Linux":
    # 浏览器不提供可视化页面. linux下如果系统不支持可视化不加这条会启动失败
    options.add_argument('--headless')


# 初始化一个driver，chromedriver的路径选择的是相对路径，不行就写绝对路径
driver = webdriver.Chrome(options=options, executable_path='./chromedriver')
print("驱动完成初始化.")

def playwithdocker(retry = True):
    # 打开登录页 获取登录按钮
    oauth_url = "https://labs.play-with-docker.com/oauth/providers/docker/login"
    # 请求网页
    driver.get(oauth_url)
    user_name = driver.find_element(By.ID, "username")
    user_name.send_keys('xiaop1ng')
    btn_continue = driver.find_element(By.CLASS_NAME, "_button-login-id")
    btn_continue.click()
    password = driver.find_element(By.ID, "password")
    password.send_keys("ping@1234")
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
    return

print("正在启动终端.")

def playwithk8s(retry = True):
    # 打开登录页 获取登录按钮
    oauth_url = "https://labs.play-with-k8s.com/oauth/providers/docker/login"
    # 请求网页
    driver.get(oauth_url)
    user_name = driver.find_element(By.ID, "nw_username")
    user_name.send_keys('xiaop1ng')
    password = driver.find_element(By.ID, "nw_password")
    password.send_keys("ping@1234")
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
    return

# test
playwithdocker()
time.sleep(10)
btn_new = driver.find_element(By.CLASS_NAME, "md-primary")
if btn_new == None:
    time.sleep(50)
    btn_new = driver.find_element(By.CLASS_NAME, "md-primary")
btn_new.click()

print("等待主机启动.")
time.sleep(30)
terminal = driver.find_element(By.CLASS_NAME, "terminal-container")
terminal.click()
newline = driver.find_element(By.CLASS_NAME, "xterm-helper-textarea")
newline.send_keys("curl https://raw.githubusercontent.com/xiaop1ng/playWithSh/main/home/ssr.sh | sh -")
newline.send_keys(Keys.ENTER)

time.sleep(60)
# 退出浏览器
print("done.")
driver.close()
driver.quit()
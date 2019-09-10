#!/usr/bin/python3

#This script gets Vault password using MFA and saves it to the file
file_path='/home/c/w/v_pass.txt'

import time
import sys

import subprocess

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

from selenium.webdriver.firefox.options import Options
options = Options()
options.add_argument('--headless')
driver = webdriver.Firefox(options=options)

#driver = webdriver.Firefox()

driver.implicitly_wait(25)
driver.get("https://thevault.int.thomsonreuters.com")
assert "Vault" in driver.title

elem = driver.find_element_by_xpath("//*[contains(@id,'_txtUsername')]")
elem.send_keys("UC261016")
elem = driver.find_element_by_xpath("//*[contains(@id,'_txtPassword')]")

with open('/etc/p_example.txt', 'r') as file:
    p = file.read().replace('\n', '')

v = subprocess.run(['/home/c/.local/bin/vipaccess'], stdout=subprocess.PIPE).stdout.decode('utf-8')
elem.send_keys(p+v)

elem = driver.find_element_by_xpath("//*[contains(@id,'_btnLogon')]")
elem.send_keys(Keys.RETURN)

#elem = driver.find_element_by_partial_link_text("mc261016")
#elem = driver.find_elements_by_xpath("//*[contains(text(), 'mc261016')]")
#elem = driver.find_element_by_xpath("//*[contains(@src,'password_show.gif')]")

#from selenium.webdriver.common.by import By
#from selenium.webdriver.support.ui import WebDriverWait
#from selenium.webdriver.support import expected_conditions as EC
#element = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.Title, "Show password")))
#elem = driver.find_element_by_xpath("//*[contains(@class,'td-column17')]")

elem = driver.find_element_by_xpath("//*[contains(@title,'Show password')]")
while True:
    try:
        time.sleep(3)
        elem.click()
        break
    except:
        print("sleeping")

elem = driver.find_element_by_xpath("//*[contains(@class,'account-password-display')]")

#print(elem.text)
f=open(file_path,"w")
f.write(elem.text)
f.close()

driver.close()
sys.exit(0)


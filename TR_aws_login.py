#!/usr/bin/python3

#This script login to TR AWS Web console using Vault password

file_path='/home/c/w/v_pass.txt'
url='https://mfs.thomsonreuters.com/adfs/ls/IdpInitiatedSignon.aspx'

import time
import sys

import subprocess

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import *

#from selenium.webdriver.firefox.options import Options
#options = Options()
#options.add_argument('--headless')
#driver = webdriver.Firefox(options=options)

#driver = webdriver.Firefox()

#driver = webdriver.Chrome()

options = webdriver.ChromeOptions()
#options.add_argument('--headless')
#options.add_argument('--profile-directory=Default')
options.add_argument("user-data-dir=/home/c/.config/google-chrome") #Path to your chrome profile

#disable "Chrome is being controlled by automated test software" notification
options.add_experimental_option("excludeSwitches", ['enable-automation']);

driver = webdriver.Chrome(chrome_options=options)

driver.implicitly_wait(7)
#driver.find_element_by_tag_name("body").send_keys(Keys.CONTROL + 't')
driver.get(url)

try:
    elem = driver.find_element_by_xpath("//*[contains(@id,'SignInButton')]")
    elem.click()
#except NoSuchElementException as e:
except Exception as e:
    pass #ignore, since this button may not appear sometimes
#    print("------ exception happened: SignInButton")
#    print(str(e))

try:
    elem = driver.find_element_by_xpath("//*[contains(@id,'idp_GoButton')]")
    elem.click()
#except NoSuchElementException as e:
except Exception as e:
    print("------ exception happened: idp_GoButton")
    print(str(e))

#time.sleep(2)
try:
    elem = driver.find_element_by_xpath("//*[contains(@id,'userNameInput')]")
    elem.send_keys("mc261016@mgmt.tlrg.com")

    elem = driver.find_element_by_xpath("//*[contains(@id,'passwordInput')]")

    with open(file_path, 'r') as file:
        p = file.read().replace('\n', '')

    elem.send_keys(p)
    elem.send_keys(Keys.RETURN)

except Exception as e:
    pass #ignore, since this the user session may already has been established

print("after entered credentials")

elem = driver.find_element_by_xpath("//input[contains(@id,'arn:aws:iam::074929092668:role/human-role/a205718-PowerUser2')]")
elem.click()
print("after radio button")

elem = driver.find_element_by_xpath("//a[contains(@id,'signin_button')]")
elem.click()
print("after profile choise")

#time.sleep(3)
#driver.close()
#print("driver closed")

print("done")
sys.exit(0)


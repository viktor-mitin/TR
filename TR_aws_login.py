#!/usr/bin/python3

#This script login to TR AWS Web console using Vault password

file_path='/home/c/w/v_pass.txt'
url='https://mfs.thomsonreuters.com/adfs/ls/IdpInitiatedSignon.aspx'

import time
import sys

import subprocess

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

from selenium.webdriver.firefox.options import Options
options = Options()
options.add_argument('--headless')
#driver = webdriver.Firefox(options=options)

driver = webdriver.Firefox()

driver.implicitly_wait(15)
driver.get(url)

elem = driver.find_element_by_xpath("//*[contains(@id,'SignInButton')]")
elem.click()

time.sleep(2)
elem = driver.find_element_by_xpath("//*[contains(@id,'userNameInput')]")
elem.send_keys("mc261016@mgmt.tlrg.com")

elem = driver.find_element_by_xpath("//*[contains(@id,'passwordInput')]")

with open(file_path, 'r') as file:
    p = file.read().replace('\n', '')

elem.send_keys(p)
elem.send_keys(Keys.RETURN)

elem = driver.find_element_by_xpath("//input[contains(@id,'idp_GoButton')]")
elem.click()
print("after GoButton")
time.sleep(5)


#driver.close()
sys.exit(0)


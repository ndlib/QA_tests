import unittest
import os
import time
import sys
from selenium import webdriver
from selenium.webdriver import Firefox
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.support import expected_conditions as expected
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.keys import Keys

BaseURL = os.environ.get('BaseURL')

class Usurper_Search_Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        options = Options()
        options.add_argument('-headless')
        # options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--no-sandbox')
        cls.driver = Firefox(options=options, log_path="/home/seluser/geckodriver.log")
        cls.driver.implicitly_wait(30)

    @classmethod
    def classTearDown(cls):
        cls.driver.quit()

    def test_homepage(self):
        driver = self.driver
        driver.implicitly_wait(10)
        driver.get("https://" + BaseURL)
        driver.find_element_by_xpath('//*[@id="maincontent"]/div/div[2]/div[1]/section/a[1]/h1') # This is in place to allow the browser window to properly wait until content is loaded before trying to assert the title
        print(''.join(['Page Title is: ',driver.title]))
        self.assertEqual(driver.title, "Hesburgh Libraries")

    def test_check_onesearch(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        driver.find_element_by_xpath('//*[@id="basic-search-field"]').send_keys('Shakespeare')
        driver.find_element_by_xpath('//*[@id="searchAppliance"]/span/button').click()
        driver.find_element_by_xpath('//*[@id="briefResultMoreOptionsButton"]/prm-icon[2]/md-icon') # Forces browser to wait until the "Show Action Options" button is visible
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "Shakespeare | Hesburgh Libraries")

    def test_check_nd_catalog(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        button = driver.find_element_by_id('selected-search')
        driver.execute_script("arguments[0].click();", button)
        search = driver.find_element_by_id('uSearchOption_1')
        driver.execute_script("arguments[0].click();", search)
        driver.find_element_by_xpath('//*[@id="basic-search-field"]').send_keys('Shakespeare')
        driver.find_element_by_xpath('//*[@id="searchAppliance"]/span/button').click()
        driver.find_element_by_xpath('//*[@id="briefResultMoreOptionsButton"]/prm-icon[2]/md-icon') # Forces browser to wait until the "Show Action Options" button is visible
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "Shakespeare | Hesburgh Libraries")

    def test_check_curate_nd(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        button = driver.find_element_by_id('selected-search')
        driver.execute_script("arguments[0].click();", button)
        search = driver.find_element_by_id('uSearchOption_2')
        driver.execute_script("arguments[0].click();", search)
        driver.find_element_by_id('basic-search-field').send_keys('Shakespeare')
        driver.find_element_by_xpath('//*[@id="searchAppliance"]/span/button').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "CurateND Search Results")

    def test_check_library_website(self):
        driver = self.driver
        driver.get("https://" + BaseURL)
        button = driver.find_element_by_id('selected-search')
        driver.execute_script("arguments[0].click();", button)
        search = driver.find_element_by_id('uSearchOption_3')
        driver.execute_script("arguments[0].click();", search)
        driver.find_element_by_xpath('//*[@id="basic-search-field"]').send_keys('Shakespeare')
        driver.find_element_by_xpath('//*[@id="searchAppliance"]/span/button').click()
        print(''.join(['Page Title Is: ', driver.title]))
        self.assertEqual(driver.title, "Website Search: | Hesburgh Libraries")

suite = unittest.TestLoader().loadTestsFromTestCase(Usurper_Search_Tests)
result = unittest.TextTestRunner(verbosity=2).run(suite)
sys.exit(not result.wasSuccessful())

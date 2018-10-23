from selenium import webdriver
from selenium.webdriver.support.ui import Select

def visitCategories(driver):
	visitedOptions = []
	visitedAll = False

	while not visitedAll:
		visited = False
		select = Select(driver.find_element_by_name("ctl00$ctl00$LeftBar$contentplaceholder_control_chooseBldg$dropdownlist_bldglist"))
		elements = driver.find_element_by_name("ctl00$ctl00$LeftBar$contentplaceholder_control_chooseBldg$dropdownlist_bldglist")
		for option in elements.find_elements_by_tag_name("option"):
			if option.text not in visitedOptions:
				optionText = option.text
				visitedOptions.append(optionText)
				select.select_by_visible_text(optionText)
				visited = True
				visitBuildings(driver)
				break;
		if not visited:
			visitedAll = True



def visitBuildings(driver):
	bldgLinks = driver.find_elements_by_css_selector('.nav_bldgList')
	for i in range(0, len(bldgLinks), 2):
		bldgLinks = driver.find_elements_by_css_selector('.nav_bldgList')
		bldgLinks[i].click()



driver = webdriver.Firefox()
driver.get("https://space.facilities.vt.edu/Lock/bldgAndRoom.aspx")
input("Press Enter After you've logged in...")
visitCategories(driver)

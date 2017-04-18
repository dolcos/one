pJS <- phantom()
Sys.sleep(5) # give the binary a moment

remDr <- remoteDriver(browserName = "phantomjs")

print("connected to phantomJS")

# RSelenium
# RSelenium::checkForServer()
# RSelenium::startServer()
# system("java -jar /opt/selenium/selenium")

# End()
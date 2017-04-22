pJS <- phantom(pjs_cmd = "/opt/phantomjs/phantomjs-2.1.1-linux-x86_64/bin/phantomjs")
Sys.sleep(5) # give the binary a moment

remDr <- remoteDriver(browserName = "phantomjs")

print("connected to phantomJS")

# RSelenium
# RSelenium::checkForServer()
# RSelenium::startServer()
# system("java -jar /opt/selenium/selenium")

# End()
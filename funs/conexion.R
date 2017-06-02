pJS <- phantom(pjs_cmd = "/opt/phantomjs/phantomjs-2.1.1-linux-x86_64/bin/phantomjs")
Sys.sleep(5) # give the binary a moment

remDr <- remoteDriver(browserName = "phantomjs")

print("connected to phantomJS")

con.mysql <- dbConnect(MySQL(), host="40.114.43.125", 
                       port= 3306, user = "athen", 
                       password = Sys.getenv("passmysql"),
                       dbname = "test")

print("connected to MySQL")

# RSelenium
# RSelenium::checkForServer()
# RSelenium::startServer()
# system("java -jar /opt/selenium/selenium")

# End()
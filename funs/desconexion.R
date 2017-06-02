pJS$stop() # close the PhantomJS process, note we dont call remDr$closeServer()

print("Disconneted from phantomJS")

dbDisconnect(con.mysql)

print("Disconneted from MySQL")

# End()
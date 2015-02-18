library(RSQLite)
# load the drive
drv <- dbDriver("SQLite")

con <- dbConnect(drv, "portal_mammals.sqlite")

dbListTables(con)
dbListFields(con, "surveys")

dbGetQuery(con, "SElECT species FROM surveys ORDER BY sex DESC")

species <- dbSendQuery(con,
                     "SELECT species FROM surveys")

fetch(species, 5)
dbClearResult(species)

dbDisconnect(con)

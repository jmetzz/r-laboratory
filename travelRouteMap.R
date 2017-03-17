

# Create Air Travel Route Maps in ggplot

# Read flight list
#flights <- read.csv("C:\\workspace\\personal\\scripts\\R\\flights.csv", stringsAsFactors = FALSE)
flights <- read.csv("/cygdrive/c/workspace/personal/scripts/R/flights.csv", stringsAsFactors = FALSE)

# Lookup coordinates
library(ggmap)
airports <- unique(c(flights$From, flights$To))
coords <- geocode(airports)
airports <- data.frame(airport=airports, coords)

# Add coordinates to flight list
flights <- merge(flights, airports, by.x="To", by.y="airport")
flights <- merge(flights, airports, by.x="From", by.y="airport")

# Plot flight routes
library(ggplot2)
library(ggrepel)
worldmap <- borders("world", colour="#efede1", fill="#efede1") # create a layer of borders


ggplot() + worldmap + 
 geom_curve(data=flights, aes(x = lon.x, y = lat.x, xend = lon.y, yend = lat.y), col = "#b29e7d", size = 1, curvature = .2) + 
 geom_point(data=airports, aes(x = lon, y = lat), col = "#970027") + 
 geom_text_repel(data=airports, aes(x = lon, y = lat, label = airport), col = "black", size = 2, segment.color = NA) + 
 theme(panel.background = element_rect(fill="white"), 
 axis.line = element_blank(),
 axis.text.x = element_blank(),
 axis.text.y = element_blank(),
 axis.ticks = element_blank(),
 axis.title.x = element_blank(),
 axis.title.y = element_blank()
 )


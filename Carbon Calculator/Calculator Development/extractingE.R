### Extracting E from Chave et al 2014
# relating tree circumference and height using Chave's equation
# Maximiliane Jousse

# E is a constant achieved using a regression based on temperature seasonality, climatic water deficit, and precipitation seasonality
# E values are available as a global gridded layer at 2.5 arc sec resolution.
# http://chave.ups-tlse.fr/pantropical_allometry.htm

library(dplyr) # package for pipeline
library(tidyr) # package for pipeline
library(ggplot2) # Package for plotting
library(ncdf4) # package for netcdf manipulation

# Setting working directory

################################################################################ 1. Importing data
# Open  file
E_ncdf <- nc_open("../Data/E.nc")
print(E_ncdf) #visualising info
# NOTE: projection: +proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs


# Extracting info
lat <- ncvar_get(E_ncdf, "latitude")
lon <- ncvar_get(E_ncdf, "longitude")
E <- ncvar_get(E_ncdf, "layer")

# removing fill values
fillvalue <- ncatt_get(E_ncdf, "layer", "_FillValue")
E[E == fillvalue$value] <- NA

#making Data frame
lonlat <- as.matrix(expand.grid(lon,lat))
E_vec <- as.vector(E)
E_df <- data.frame(cbind(lonlat, E_vec))
colnames(E_df) <- c("Lon", "Lat", "E")

################################################################################ 2. Extracting E
# since coords might not match exactly, extract coordinates within one degree
# take the mean E value

E_mean <- E_df %>% filter(Lon < -78 & Lon > -79 & Lat < 10 & Lat > 9) %>%
  drop_na() %>%
  summarise(E_mean = mean(E))
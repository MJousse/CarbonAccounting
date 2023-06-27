## Regression
# relating tree circumference and height with data collected in Panama

library(data.table)
library(tidyr)
library(dplyr)
library(ggplot2)
library(readxl)
library(broom)
library(cowplot)
library(viridis)
library(glue)
library(ggpubr)


################################################################################ 1. Importing data
s_data <- read_excel("C:/Users/max0j/OneDrive/Escritorio/McGill - PhD/Rotations/Rotation  3 - Catherine Potvin/Project 1 CarbonMonitoring/MJ_SARDINILLA_ALL_YEARS.xlsx")

# remove dead trees
s_data <- s_data %>% filter(Status != "Dead")


################################################################################ 2. Visualise data
# -> Can decide which type of regression is best
# -> one for basal diameter, one for DBH

################### DBH
#DBH
s_data %>% 
  select(SpeciesCode, Height, DBH)%>%
  drop_na() %>%
  ggplot(aes(x = DBH, y = Height, color = SpeciesCode)) +
  geom_point()+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH Sardinilla")


s_data %>% 
  select(SpeciesCode, Height, DBH) %>%
  mutate(lDBH = log(DBH), lHeight = log(Height))%>%
  drop_na() %>%
  ggplot(aes(x = lDBH, y = lHeight, color = SpeciesCode)) +
  geom_point()+
  xlab("ln(DBH)") +
  ylab("ln(Height)") +
  ggtitle("ln(Height) vs ln(DBH) Sardinilla")

#DBH ln(height) vs dbh
# CLEAREST PATTERN, LESS SPREAD
s_data %>% 
  select(SpeciesCode, Height, DBH) %>%
  mutate(lHeight = log(Height))%>%
  drop_na() %>%
  ggplot(aes(x = DBH, y = lHeight, color = SpeciesCode)) +
  geom_point()+
  xlab("DBH") +
  ylab("ln(Height)") +
  ggtitle("ln(Height) vs DBH Sardinilla")

#DBH, separate species
s_data %>% 
  select(SpeciesCode, Height, DBH)%>%
  drop_na() %>%
  ggplot(aes(x = DBH, y = Height)) +
  geom_point()+
  facet_grid(cols = vars(SpeciesCode))+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH Sardinilla")

# ln(Height)-DBH, seperate species
s_data %>% 
  select(SpeciesCode, Height, DBH) %>%
  mutate(lHeight = log(Height))%>%
  drop_na() %>%
  ggplot(aes(x = DBH, y = lHeight, color = SpeciesCode)) +
  geom_point()+
  xlab("DBH") +
  ylab("ln(Height)") +
  ggtitle("ln(Height) vs DBH Sardinilla")+
  facet_grid(cols = vars(SpeciesCode))


##########################   Basal Diameter
s_data %>% 
  select(SpeciesCode, Height, BasalDiam)%>%
  drop_na() %>%
  ggplot(aes(x = BasalDiam, y = Height, color = SpeciesCode)) +
  geom_point()+
  xlab("Basal diameter (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH Sardinilla")

#BasalDiam, separate species
#         defo more linear
s_data %>% 
  select(SpeciesCode, Height, BasalDiam)%>%
  drop_na() %>%
  ggplot(aes(x = BasalDiam, y = Height)) +
  geom_point()+
  facet_grid(cols = vars(SpeciesCode))+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH Sardinilla")

## SUMMARY
# clearest pattern is seen in ln(height) vs DBH

################################################################################ 2. Testing Regressions
# a:
# all species
# DBH
# Linear Height DBH regression

s_data %>% 
  select(SpeciesCode, Height, DBH)%>%
  drop_na() %>%
  ggplot(aes(x = DBH, y = Height)) +
  geom_point()+
  geom_smooth(method = "lm")+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH Sardinilla")


# b:
# Each species
# DBH
# Linear Height DBH regression
s_data %>% 
  select(SpeciesCode, Height, DBH)%>%
  drop_na() %>%
  ggplot(aes(x = DBH, y = Height)) +
  geom_point()+
  geom_smooth(method = "lm")+
  facet_grid(cols= vars(SpeciesCode)) +
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH Sardinilla")


# c:
# all species
# DBH
# Quadratic - fit a quadratic lm for log(height)-diameter
s_data$DBH2 <- s_data$DBH^2
glm1 <- lm(log(Height)~DBH+DBH2, data = s_data)
s_data %>%
  select(Height, DBH, SpeciesCode) %>%
  drop_na() %>%
  mutate(glm1fit = exp(fitted(glm1))) %>%
  ggplot(aes(x=DBH))+
  geom_point(aes(y=Height))+
  geom_line(aes(y=glm1fit), linetype = "dashed", color = "red")
# Doesn't work: parabola falls off


# d: 
# all species
# DBH
# fit lm for log(height)-log(diameter)
# CURRENT BEST

s_data$lDBH <- log(s_data$DBH)
s_data$lDBH2 <- s_data$lDBH^2

#quadratic
glm2q <- lm(log(Height)~lDBH + lDBH2, data = s_data)
#linear
glm2l <- lm(log(Height)~lDBH, data = s_data)
#looking at both
s_data %>%
  select(Height, DBH, lDBH, SpeciesCode) %>%
  drop_na() %>%
  mutate(lHeight = log(Height), glmfit1 = fitted(glm2q), glmfit2 = fitted(glm2l)) %>%
  ggplot(aes(x=DBH))+
  geom_point(aes(y=lHeight))+
  geom_line(aes(y=glmfit1), linetype = "dashed", color = "red")+
  geom_line(aes(y = glmfit2), color = 'blue')
#best - glm2l
glm2 <- lm(log(Height)~lDBH, data = s_data)
Pglm2 <- s_data %>%
  select(Height, DBH, lDBH, SpeciesCode) %>%
  drop_na() %>%
  mutate(lHeight = log(Height),C = exp(chaveTest(DBH))*100, glmfit = exp(fitted(glm2))) %>%
  ggplot(aes(x=DBH))+
  geom_bin_2d(aes(y = Height), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  #geom_point(aes(y=Height))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  geom_line(aes(y=C), color = "red")+
  xlab("DBH (cm)") +
  ylab("Height") +
  ggtitle("Ln Height vs DBH, Sardinilla")



# E: 
# all species
# DBH
# fit a lm for log(height)- diameter
glm3 <- lm(log(Height) ~ DBH, data = s_data)
s_data %>%
  select(Height, DBH, lDBH, SpeciesCode) %>%
  drop_na() %>%
  mutate(lHeight = log(Height), glmfit = exp(fitted(glm3))) %>%
  ggplot(aes(x=DBH))+
  geom_point(aes(y=Height))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "red")


# F:
# seperate species
# DBH
#  fit linear lm for log(height)-log(diameter)

#linear
TR.dat <- s_data %>% 
  select(SpeciesCode, Height, lDBH) %>%
  filter(SpeciesCode == "TR") %>%
  drop_na()
glm2.TR <- lm(log(Height)~lDBH, TR.dat)
CM.dat <- s_data %>% 
  select(SpeciesCode, Height, lDBH) %>%
  filter(SpeciesCode == "CM") %>%
  drop_na()
glm2.CM <- lm(log(Height)~lDBH, CM.dat)
AE.dat <- s_data %>% 
  select(SpeciesCode, Height, lDBH) %>%
  filter(SpeciesCode == "AE") %>%
  drop_na()
glm2.AE <- lm(log(Height)~lDBH, AE.dat)

#TR
TRglm2 <- s_data %>%
  select(Height, DBH, lDBH, SpeciesCode) %>%
  filter(SpeciesCode == "TR") %>%
  drop_na() %>%
  mutate(lHeight = log(Height), C = exp(chaveTest(DBH))*100, glmfit = exp(fitted(glm2.TR))) %>%
  ggplot(aes(x=DBH))+
  geom_bin_2d(aes(y = Height), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  #geom_point(aes(y=Height))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  geom_line(aes(y = C), color = "red" )+
  xlab("DBH (cm)") +
  ylab("Height") +
  ggtitle("TR: Ln Height vs DBH, Sardinilla")
#CM
CMglm2 <- s_data %>%
  select(Height, DBH, lDBH, SpeciesCode) %>%
  filter(SpeciesCode == "CM") %>%
  drop_na() %>%
  mutate(lHeight = log(Height),C = exp(chaveTest(DBH))*100, glmfit = exp(fitted(glm2.CM))) %>%
  ggplot(aes(x=DBH))+
  geom_bin_2d(aes(y = Height), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  #geom_point(aes(y=Height))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  geom_line(aes(y = C), color = "red" )+
  xlab("DBH (cm)") +
  ylab("Height") +
  ggtitle("CM: Ln Height vs DBH, Sardinilla")
#AE
AEglm2 <- s_data %>%
  select(Height, DBH, lDBH, SpeciesCode) %>%
  filter(SpeciesCode == "AE") %>%
  drop_na() %>%
  mutate(lHeight = log(Height), C = exp(chaveTest(DBH))*100, glmfit = exp(fitted(glm2.AE))) %>%
  ggplot(aes(x=DBH))+
  geom_bin_2d(aes(y = Height), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  #geom_point(aes(y=Height))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  geom_line(aes(y = C), color = "red" )+
  xlab("DBH (cm)") +
  ylab("Height") +
  ggtitle("AE: Ln Height vs DBH, Sardinilla")

graph <- list(Pglm2, TRglm2, CMglm2, AEglm2)
#gridplot all 3
plot_grid(plotlist=graph, nrow = 2, ncol = 2)




## SUMMARY:
# 1. Height- DBH All Species
# best: GLM2
# lHeight ~ lDBH

#2. Height-DBH Different species
# Use same model: GLM2
# lHeight ~ lDBH


################################################################################ TESTING EQUATIONS
glm2Test <- function(D) {
  lH <- 5.4015 + 0.642*log(D)
  return(lH)
}

chaveTest <- function(D) {
  lH <- 0.893 + 0.02418293 + 0.760*log(D) - 0.0340*((log(D))^2)
  # chaves equation gives height in in m
  return(lH)
}

glm2_iTest <- function(D) {
  lH <- 4.9476 + 0.6902*log(D)
  return(lH)
}

################################################################################ Testing GLM2 on S data

#Log(H) = 5.4015 + 0.642*Log(D)
# H = e^(5.4015 + 0.642*Log(D))

#TEST SET
df_t <- s_data %>% select(SpeciesCode, Height, DBH) %>% drop_na()
df_t$lH <- glm2Test(df_t$DBH)
df_t$H <- exp(df_t$lH)
df_t$ClH <- chaveTest(df_t$DBH)
df_t$CH <- exp(df_t$ClH)*100 #was in m



# Test log height
df_t %>%
  ggplot(aes(x = DBH, y = lH, colors = SpeciesCode))+
  geom_point()

#Test height - reg
df_t %>%
  ggplot(aes(x = DBH, y = H, colors = SpeciesCode))+
  geom_point()

# Test log height - chave
df_t %>%
  ggplot(aes(x = DBH, y = ClH, colors = SpeciesCode))+
  geom_point()

# Test height - chave
df_t %>%
  ggplot(aes(x = DBH, y = CH, colors = SpeciesCode))+
  geom_point()

#Data
df_t %>%
  ggplot(aes(x = DBH, y = Height, colors = SpeciesCode))+
  geom_point()+
  geom_line(aes(x = DBH, y= CH), color = 'red')+
  geom_line(aes(x = DBH, y = H), linetype = 'dashed', color = 'blue')

df_t %>% ggplot(aes(x = DBH, y = Height))+
  geom_bin_2d(bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_line(aes(x = DBH, y= CH), color = 'red')+
  geom_line(aes(x = DBH, y = H), linetype = 'dashed', color = 'blue')



df_t$lHeight <- log(df_t$Height)

df_t %>%
  ggplot(aes(x = DBH, y = lHeight, colors = SpeciesCode))+
  geom_point()

#### Plot all tests on our data in one
# height
df_t %>% 
  ggplot(aes(x = DBH, y = ClH))+
  geom_point()

# ln height
df_t$lHeight <- log(df_t$Height)
df_t %>% 
  select(DBH, lHeight,lH, ClH, SpeciesCode) %>%
  melt(id = c("DBH", "SpeciesCode")) %>%
  ggplot(aes(x = DBH, y= value, color = variable))+
  geom_point()


################################################################################ IPETI DATA
i_data <- fread("C:/Users/max0j/OneDrive/Escritorio/McGill - PhD/Rotations/Rotation  3 - Catherine Potvin/CarbonMonitoring/IpetiData/Data Sharing Summer 2023/Data_Sharing_PotvinLab_R/data/baseline_table.csv")
i_data <- i_data %>% filter(survival != 0) %>% select(-c("monotype", "owner"))

# units unsure, we are assuming height in m and dbh in cm 

# Visualsing height - DBH 
i_data %>% 
  filter(dbh != is.na(dbh)) %>%
  select(spcode, height, dbh) %>%
  mutate(height.cm = height*100) %>%
  ggplot(aes(x = dbh, y = height.cm, color = spcode)) +
  geom_point()+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH IpetiData")

#log height vs dbh
i_data %>% 
  filter(dbh != is.na(dbh)) %>%
  select(spcode, height, dbh) %>%
  mutate(height.cm = height*100, lheight.cm = log(height.cm)) %>%
  ggplot(aes(x = dbh, y = lheight.cm, color = spcode)) +
  geom_point()+
  xlab("DBH (cm)") +
  ylab("log(Height (cm))") +
  ggtitle("Height vs DBH IpetiData")

# species individually
#height-dbh
pltlist <- list()
for (i in unique(i_data$spcode)){
  if (nrow(i_data %>% filter(i_data$spcode == i)) < 500){
    next
  }else{
    plt <- i_data %>% 
      filter(dbh != is.na(dbh)) %>%
      select(spcode, height, dbh) %>%
      mutate(height.cm = height*100) %>%
      filter(spcode == i) %>%
      ggplot(aes(x = dbh, y = height.cm)) +
      geom_point()+
      xlab("DBH (cm)") +
      ylab("Height (cm)") +
      ggtitle(i)
    pltlist <- c(pltlist, list(plt))
  }
}
plot_grid(plotlist = pltlist, ncol = 3, nrow =4)

# species individually
#logheight-dbh
pltlist <- list()
for (i in unique(i_data$spcode)){
  if (nrow(i_data %>% filter(i_data$spcode == i)) < 500){
    next
  }else{
    plt <- i_data %>% 
      filter(dbh != is.na(dbh)) %>%
      select(spcode, height, dbh) %>%
      mutate(height.cm = height*100, lheight.cm = log(height.cm)) %>%
      filter(spcode == i) %>%
      ggplot(aes(x = dbh, y = lheight.cm)) +
      geom_point()+
      xlab("DBH (cm)") +
      ylab("Height (cm)") +
      ggtitle(i)
    pltlist <- c(pltlist, list(plt))
  }
}
plot_grid(plotlist = pltlist, ncol = 3, nrow =4)



### Fitting Chave, My reg
i_data$glm2.lheight <- glm2Test(i_data$dbh)
i_data$glm2.height <- exp(i_data$glm2.lheight)
i_data$chave.lheight <- chaveTest(i_data$dbh)
i_data$chave.height <- exp(i_data$chave.lheight)*100 #was in m

#test chave, glm2- height vs dbh
# data
i_data %>%
  mutate(height.cm = height*100) %>%
  ggplot(aes(x = dbh, y = height.cm, colors = spcode))+
  geom_point()+
  geom_line(aes(x = dbh, y= chave.height), color = 'red')+
  geom_line(aes(x = dbh, y = glm2.height), linetype = 'dashed', color = 'blue')
#hist data
i_data %>%
  mutate(height.cm = height*100) %>%
  ggplot(aes(x = dbh))+
  geom_bin_2d(aes(y = height.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_line(aes(y= chave.height), color = 'red')+
  geom_line(aes(y = glm2.height), linetype = 'dashed', color = 'blue')

#test chave, glm2- logheight vs dbh
#                                                                               PROBLEM - chave results way smaller. probably because of difference of units
# # data
# i_data %>%
#   mutate(height.cm = height*100, lheight.cm = log(height.cm)) %>%
#   ggplot(aes(x = dbh, y = lheight.cm, colors = spcode))+
#   geom_point()+
#   geom_point(aes(x = dbh, y= chave.lheight), color = 'red')+
#   geom_point(aes(x = dbh, y = glm2.lheight), color = 'blue')
# #hist data
# i_data %>%
#   mutate(height.cm = height*100, lheight.cm = log(height.cm)) %>%
#   ggplot(aes(x = dbh))+
#   geom_bin_2d(aes(y = lheight.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
#   geom_line(aes(y= chave.lheight), color = 'red')+
#   geom_line(aes(y = glm2.lheight), linetype = 'dashed', color = 'blue')

################################################################################ fitting a glm on ipeti data
i_data <- i_data %>% mutate(height.cm = height*100, ldbh = log(dbh), lheight.cm = log(height.cm))
i_data[is.na(i_data$lheight.cm) | is.na(i_data$dbh) | i_data=="Inf" | i_data == "-Inf"] = NA
glm2_i <- lm(lheight.cm~ldbh, data = i_data)

i_data %>%
  select(height.cm, dbh, ldbh, spcode, lheight.cm) %>%
  filter(dbh != is.na(dbh) & lheight.cm != (is.na(lheight.cm))) %>%
  mutate(lheight.cm = log(height.cm), glmfit = exp(fitted(glm2_i))) %>%
  ggplot(aes(x=dbh))+
  #geom_bin_2d(aes(y = height), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_point(aes(y=height.cm))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH, Ipeti")

i_data %>%
  select(height.cm, dbh, ldbh, spcode, lheight.cm) %>%
  filter(dbh != is.na(dbh) & lheight.cm != (is.na(lheight.cm))) %>%
  mutate(lheight.cm = log(height.cm), glmfit = exp(fitted(glm2_i))) %>%
  ggplot(aes(x=dbh))+
  geom_bin_2d(aes(y = height.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  #geom_point(aes(y=height.cm))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Ln Height vs DBH, Ipeti")

################################################################################ fitting a glm on Ipeti AND sardinilla data
i_data_r <- i_data %>% select(c("dbh", "height.cm", "spcode"))
s_data_r <- s_data %>% select(c("DBH", "Height", "SpeciesCode"))
colnames(s_data_r) <- c("dbh", "height.cm", "spcode")

data <- rbind(i_data_r, s_data_r) %>% na.omit()

#visualising data - height vs dbh
data %>% 
  ggplot(aes(x = dbh, y = height.cm, color = spcode)) +
  geom_point()+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH: Ipeti and Sardinilla Data")

#visualising data - lheight vs dbh
data %>% 
  mutate(lheight.cm = log(height.cm)) %>%
  ggplot(aes(x = dbh, y = lheight.cm, color = spcode)) +
  geom_point()+
  xlab("DBH (cm)") +
  ylab("log(Height (cm))") +
  ggtitle("Height vs DBH: Ipeti and Sardinilla Data")

#visualising data - lheight vs ldbh
data %>% 
  mutate(ldbh = log(dbh), lheight.cm = log(height.cm)) %>%
  ggplot(aes(x = ldbh, y = lheight.cm, color = spcode)) +
  geom_point()+
  xlab("DBH (cm)") +
  ylab("log(Height (cm))") +
  ggtitle("Height vs DBH: Ipeti and Sardinilla Data")


# GLMS
#test 1 - log(height) vs dbh
data$lheight.cm <- log(data$height.cm)
data$ldbh <- log(data$dbh)
data[is.na(data$lheight.cm) |is.na(data$ldbh) |data =="Inf" | data == "-Inf"] = NA
#glm <- lm(lheight.cm ~ dbh, data = data, na.action = "na.exclude")     # NOT AS GOOD                                   
glm <- lm(lheight.cm ~ ldbh, data = data, na.action = "na.exclude")

data %>%
  mutate(glmfit = exp(fitted(glm))) %>%
  ggplot(aes(x=dbh))+
  #geom_bin_2d(aes(y = height.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_point(aes(y=height.cm))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH, Ipeti and Sardinilla")
data %>%
  mutate(glmfit = fitted(glm)) %>%
  ggplot(aes(x=dbh))+
  #geom_bin_2d(aes(y = height.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_point(aes(y=lheight.cm))+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  xlab("DBH (cm)") +
  ylab("log(Height (cm))") +
  ggtitle("Height vs DBH, Ipeti and Sardinilla")
data %>%
  mutate(glmfit = exp(fitted(glm))) %>%
  ggplot(aes(x=dbh))+
  geom_bin_2d(aes(y = height.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH, Ipeti and Sardinilla")
data %>%
  mutate(glmfit = fitted(glm)) %>%
  ggplot(aes(x=dbh))+
  geom_bin_2d(aes(y = lheight.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_line(aes(y=glmfit), linetype = "dashed", color = "blue")+
  xlab("DBH (cm)") +
  ylab("log(Height (cm))") +
  ggtitle("Height vs DBH, Ipeti and Sardinilla")

################################################################################ seeing all results
data$glm2.lheight <- glm2Test(data$dbh)
data$glm2.height <- exp(data$glm2.lheight)
data$chave.lheight <- chaveTest(data$dbh)
data$chave.height <- exp(data$chave.lheight)*100 #was in m
data$glm2_i.lheight <- glm2_iTest(data$dbh)
data$glm2_i.height <- exp(data$glm2_i.lheight)

data %>%
  mutate(glmfit = exp(fitted(glm))) %>%
  ggplot(aes(x=dbh))+
  geom_point(aes(y=height.cm))+
  geom_line(aes(y=glmfit), color = "blue")+
  geom_line(aes(y= chave.height), linetype = 'dashed', color = 'red')+
  geom_line(aes(y = glm2.height), linetype = 'dashed', color = 'green')+
  geom_line(aes(y = glm2_i.height), linetype = 'dashed', color = 'cyan')+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH, Ipeti and Sardinilla")
data %>%
  mutate(glmfit = exp(fitted(glm))) %>%
  ggplot(aes(x=dbh))+
  geom_bin_2d(aes(y = height.cm), bins = 50, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_line(aes(y=glmfit), color = "blue")+
  geom_line(aes(y= chave.height), linetype = 'dashed', color = 'red')+
  geom_line(aes(y = glm2.height), linetype = 'dashed', color = 'green')+
  geom_line(aes(y = glm2_i.height), linetype = 'dashed', color = 'cyan')+
  xlab("DBH (cm)") +
  ylab("Height (cm)") +
  ggtitle("Height vs DBH, Ipeti and Sardinilla")


# log height, dbh
data %>%
  mutate(glmfit = fitted(glm), ldbh = log(dbh)) %>%
  ggplot(aes(x=ldbh))+
  geom_bin_2d(aes(y = lheight.cm), bins = 25, drop = TRUE) + scale_fill_viridis(discrete = FALSE)+
  geom_line(aes(y=glmfit), color = "blue")+
  geom_line(aes(y= chave.lheight), linetype = 'dashed', color = 'red')+
  geom_line(aes(y = glm2.lheight), linetype = 'dashed', color = 'green')+
  geom_line(aes(y = glm2_i.lheight), linetype = 'dashed', color = 'cyan')+
  xlab("log(DBH (cm))") +
  ylab("g(Height (cm))") +
  ggtitle("Height vs DBH, Ipeti and Sardinilla")

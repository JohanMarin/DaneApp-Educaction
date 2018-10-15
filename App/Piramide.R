library(data.table)
dataPiramide <- as.data.table(read.csv("../data/EstudiantesporSexo.csv"))

funtionPiramide <- function(dataSet, Year){
library(dplyr)
datos <- dataSet %>%
  filter(year == Year)

#  Variable and labs asignation
hpres <- datos$HPRES
hprim <- datos$HPRIM
hsec <- datos$HSEC
hmed <- datos$HMED
hext <- datos$Hombres

mpres <- datos$MPRES
mprim <- datos$MPRIM
msec <- datos$MSEC
mmed <- datos$MMED
mext <- datos$Mujeres
labs<- datos$DEPARTAMENTO

#organize the data set
df <- data.frame(labs = rep(labs, 10), 
                 values = c(hpres, hprim, hsec, hmed, hext, mpres, mprim, msec, mmed, mext), 
                 sex = rep(c("Hombre", "Mujer"), each = 5 * length(hpres)),
                 Grado = rep(rep(c("1. Prescolar", "2. Primaria", "3. Secundaria",
                                   "4. Media", "5. Extraedad"), each = length(hpres)), 2))

# Order deparments
library(plyr)
#Order max to min
labs.order <- ddply(df, .(labs), summarise, sum=sum(values))
labs.order <- labs.order$labs[order(labs.order$sum)]
labs.order <- rev(labs.order)
df$labs <- factor(df$labs, levels=labs.order)


# Common theme
library(ggplot2)
theme <- theme(axis.text.y = element_blank(), 
               axis.title.y = element_blank(),
               plot.title = element_text(size = 13, hjust = 0.5))


#### 1. "hombre" plot - to appear on the right
ggM <- ggplot(data = subset(df, sex == 'Hombre'), aes(x=labs)) +
  geom_bar(aes(y = values, fill = Grado), stat = "identity") +
  scale_y_continuous('') + labs(x = NULL) +  ggtitle("Hombre") +
  coord_flip() + theme

# get ggplot grob
gtM <- ggplotGrob(ggM)


#### 4. Get the legend
leg = gtM$grobs[[which(gtM$layout$name == "guide-box")]]


#### 1. back to "male" plot - to appear on the right
# remove legend
legPos = gtM$layout$l[grepl("guide", gtM$layout$name)]  # legend's position
gtM = gtM[, -c(legPos-1,legPos)] 


#### 2. "female" plot - to appear on the left - 
# reverse the 'Percent' axis using trans = "reverse"
ggF <- ggplot(data = subset(df, sex == 'Mujer'), aes(x=labs)) +
  geom_bar(aes(y = values, fill = Grado), stat = "identity") +
  scale_y_continuous('', trans = 'reverse') + 
  labs(x = NULL) +
  ggtitle("Mujer") +
  coord_flip() + theme

# get ggplot grob
gtF <- ggplotGrob(ggF)

# remove legend

gtF = gtF[, -c(legPos-1,legPos)]


## Swap the tick marks to the right side of the plot panel
# Get the row number of the left axis in the layout
rn <- which(gtF$layout$name == "axis-l")

# Extract the axis (tick marks and axis text)
axis.grob <- gtF$grobs[[rn]]
axisl <- axis.grob$children[[2]]  # Two children - get the second
# axisl  # Note: two grobs -  text and tick marks
# Get the tick marks - NOTE: tick marks are second
yaxis = axisl$grobs[[2]] 
yaxis$x = yaxis$x - unit(1, "npc") + unit(2.75, "pt") # Reverse them

# Add them to the right side of the panel
# Add a column to the gtable
library(gtable)
panelPos = gtF$layout[grepl("panel", gtF$layout$name), c('t','l')]
gtF <- gtable_add_cols(gtF, gtF$widths[3], panelPos$l)
# Add the grob
gtF <-  gtable_add_grob(gtF, yaxis, t = panelPos$t, l = panelPos$l+1)

# Remove original left axis
gtF = gtF[, -c(2,3)] 

#### 3. country labels - create a plot using geom_text - to appear down the middle
fontsize = 3
ggC <- ggplot(data = subset(df, sex == 'Hombre'), aes(x=labs)) +
  geom_bar(stat = "identity", aes(y = 0)) +
  geom_text(aes(y = 0,  label = labs), size = fontsize) +
  ggtitle("Departamento") +
  coord_flip() + theme_bw() + theme +
  theme(panel.border = element_rect(colour = NA))

# get ggplot grob
gtC <- ggplotGrob(ggC)

# Get the title
Title = gtC$grobs[[which(gtC$layout$name == "title")]]

# Get the plot panel
gtC = gtC$grobs[[which(gtC$layout$name == "panel")]]


#### Arrange the components
## First, combine "female" and "male" plots
gt = cbind(gtF, gtM, size = "first")

## Second, add the labels (gtC) down the middle
# add column to gtable
library(stringr)
maxlab = labs[which(str_length(labs) == max(str_length(labs)))]
library(grid)
gt = gtable_add_cols(gt, sum(unit(1, "grobwidth", textGrob(maxlab, 
                                                           gp = gpar(fontsize = fontsize*72.27/25.4))), unit(10, "mm")), 
                     pos = length(gtF$widths))

# add the grob
gt = gtable_add_grob(gt, gtC, t = panelPos$t, l = length(gtF$widths) + 1)

# add the title; ie the label 'country' 
titlePos = gtF$layout$l[which(gtF$layout$name == "title")]
gt = gtable_add_grob(gt, Title, t = titlePos, l = length(gtF$widths) + 1)


## Third, add the legend to the right
gt = gtable_add_cols(gt, sum(leg$width), -1)
gt = gtable_add_grob(gt, leg, t = panelPos$t, l = length(gt$widths))

# draw the plot
grid.newpage()
return(gt)
}

piramide2010 <- funtionPiramide(dataPiramide, 2010)
piramide2011 <- funtionPiramide(dataPiramide, 2011)
piramide2012 <- funtionPiramide(dataPiramide, 2012)
piramide2013 <- funtionPiramide(dataPiramide, 2013)



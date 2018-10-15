library(shiny)

if (!require('ggplot2')) install.packages('ggplot2')
if (!require('plotly')) install.packages('plotly')
if (!require('data.table')) install.packages('data.table')
if (!require('sp')) install.packages('sp')
if (!require('rgdal')) install.packages('rgdal')
if (!require('stringr')) install.packages('stringr')
if (!require('plyr')) install.packages('plyr')
if (!require('gtable')) install.packages('gtable')
if (!require('grid')) install.packages('grid')
library(plotly)
library(data.table)
library(sp)
library(ggplot2)

dataEducacion <- as.data.table(read.csv("../data/edData.csv"))
source("Piramide.R")
source("Mapa.R")

disableActionButton <- function(id,session) {
  session$sendCustomMessage(type="jsCode",
                            list(code= paste("$('#",id,"').prop('disabled',true)"
                                             ,sep="")))
}

shinyServer(function(input, output, session) {
  
#------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------

  selectData1 <- reactive({
    l <- dataEducacion$year == input$year & dataEducacion$region != "Colombia"
    
    if(input$region != 'Todas'){
      l <- l & dataEducacion$region %in% input$region
    }
    l
  })
  
  selectData2 <- reactive({
    d <- event_data("plotly_click")
    if (is.null(d)) {
      l <- dataEducacion$region == "Colombia"
    }else{ 
      depto <- (dataEducacion[epd == d$x  & pep == d$y])$departamento
      l<- dataEducacion$departamento == depto
    }
    l
  })
  
  output$scatterPlot <- renderPlotly({
    
    p1 <-ggplotly(
      ggplot(dataEducacion[selectData1()], aes(x = epd, y = pep
      ))+ geom_point(alpha = 1/2, 
                     aes(color = region, size = poblacion,
                         #HoverText
                         text = paste('<b><i>', departamento, '</i></b>','<br> PoblaciÃ³n: ', poblacion, '<br>Estudiantes:', 
                                      estudiantes, '<br>Docentes:', docentes))) +
        labs(x='Estudiantes por Docente') + 
        labs (y = 'Proporcion de Estudiantes en la Poblaciòn')+
        theme(legend.title=element_blank())
    )  
    
    d <- event_data("plotly_click")
    if (is.null(d)) {
      depto <- "COLOMBIA"
    }else{ 
      depto <-(dataEducacion[epd == d$x  & pep == d$y])$departamento
    }
    depto
    
    dat <- dataEducacion[selectData2()] 
    dataDocentes <- data.frame(labs = rep( c("Normalista Superior", "Licenciado", "Postgrado", "Profesional", "Tecnologo"),  each=4),
                               values = c(dat$norm_sup, dat$licenciado, dat$posgrado, dat$profesional, dat$tecnologo),
                               year = rep(dat$year,5)
    )
    dataEstudiantes <-  data.frame(labs = rep( c("Preescolar", "Primaria", "Secundaria", "Media", "Extraedad"),  each=4),
                                   values = c(dat$preescolar, dat$primaria, dat$secundaria, 
                                              dat$media, dat$extraedad),
                                   year = rep(dat$year, 5)
    )
    
    
    q1<- ggplotly(
      ggplot(dataDocentes, aes(x = year, y = values, color=labs))+ 
        geom_line(alpha = 1/2) + 
        labs (x = "AÃ±o") + 
        labs (y = "Docentes")+
        scale_color_grey( name="Escalafon",
                         labels=c("Normalista Superior", "Licenciado", "Postgrado", "Profesional", "Tecnologo"))+
        theme(legend.title=element_blank())+
        labs(title="Docentes y Estudiantes por Ecalafòn")+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    ) 
    
    q2 <-  ggplotly(
      ggplot(dataEstudiantes, aes(x = year, y = values, color=labs))+ 
        geom_line(alpha = 1/2) + 
        labs (x = "AÃ±o") + 
        labs (y = "Estudiantes")+
        theme(legend.title=element_blank())+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    )
    
    p2 <- subplot(q1, q2)

    
    if (is.null(d)) {
      p <- p1
    }else{ 
      p <- p2
    }
    

    p
  })
  
  
  output$linePlot <- renderPlotly({
    
    
    data <- dataEducacion[selectData1()] 
    dD <- apply(data[,13:17],2,sum)
    dataDocentes <- data.frame("Nombre" = c("Normalista Superior", "Licenciado", "Postgrado", "Profesional", "Tecnologo"), "Data" = dD[1:5])
    dE <- apply(data[,7:11],2,sum)
    dataEstudiantes <- data.frame("Nombre" = c("Preescolar", "Primaria", "Secundaria", "Media", "Extraedad"), "Data" = dE[1:5])
    
    p1 <- ggplotly(
      ggplot(dataDocentes, aes(Nombre, Data, fill= Nombre, las= 2)) + 
        geom_bar(stat="identity")+
        scale_fill_grey()+
        theme(legend.title=element_blank())+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    )
    
    p2 <- ggplotly(
      ggplot(dataEstudiantes, aes(Nombre, Data, fill= Nombre))+ 
        geom_bar(stat="identity")+
        labs(title="Docentes y Estudiantes por Ecalafòn")+
        theme(legend.title=element_blank())+
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
    )
    p0 <- subplot(p1, p2)
    
    d <- event_data("plotly_click")
    if (is.null(d)) {
      p <- p0
    }else{ 
      p <- NULL
    }
  
    
    p
  })
  
  
  #Buttom------------------
  

#-------------------------------------------------------------------------------------------- 
#---------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
    output$map <- renderText({
      paste("Cobertura de ", input$servicio, " en instituciones educativas 2014 vs 2015", sep = "")
          })
  
   output$mapa1 <- renderPlot({
    spplot(map2014, input$servicio)
  })
  
  output$mapa2 <- renderPlot({
    spplot(map2015, input$servicio)
  })
  

#---------------------------------------------------------------------------------------------  
#---------------------------------------------------------------------------------------------

   output$piramide <- renderPlot(
    if(input$year2 == 2010){
      grid.draw(piramide2010)
    }else if(input$year2 == 2011){
      grid.draw(piramide2011)
    }else if(input$year2 == 2012){
      grid.draw(piramide2012)
    }else{
      grid.draw(piramide2013)
    }
    )
  
  output$baseDatos <- renderText({
    paste("Base de datos ", input$data, sep = "")
  })
  
  output$table <- renderDataTable(
    if(input$data == "Covertura de Servicios"){
      servicios
    }else{ 
      if(input$data=="Hombres vs Mujeres"){
       dataPiramide
      }else{
        dataEducacion
      }}

  )
  
  

#------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------
})


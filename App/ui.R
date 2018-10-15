library(shiny)
if (!require('shinythemes')) install.packages('shinythemes')
library(shinythemes)
library(plotly)

shinyUI(
  fluidPage(theme = shinytheme("paper"),
      navbarPage("Covertura Educaciòn",
        tabPanel("Estudiantes vs Docentes",
          sidebarLayout(
             sidebarPanel(
               sliderInput(inputId = 'year',
                            label   = HTML("Elija el año que desea ver:"),
                            min     = 2014,
                            max     = 2017,
                            value   = 2014,
                            step    = 1,
                            animate = TRUE),
  
                selectInput(inputId = 'region',
                  label = 'Seleccione la Regiòn',
                  choices = c('Todas', 'Amazonia', 'Andina','Caribe', 'Insular', 'Orinoquia', 'Pacifico'),
                  selected = 'Todas'
                  ),
  
                br(),
  
               h5(" Autores", aling="center"),
               tags$p(tags$a(href="https://github.com/JohanMarin", "Johan D. Marin"), " & ",
                      tags$a(href="https://github.com/ousuga", "Olga C. Usuga", "\n")),
               tags$p(tags$a(href="http://www.udea.edu.co/wps/portal/udea/web/inicio/investigacion/grupos-investigacion/ingenieria-tecnologia/incas", "Grupo INCAS,"), " Universidad de Antioquia"),
               tags$img(src='logo-udea.png', height = 100, aling="center")
               ),
             

              mainPanel(
                plotlyOutput("scatterPlot"),
                plotlyOutput("linePlot")
                ))),
  #-------------------------------------------------------------------------------------------------------------------      
        tabPanel("Covertura de Servicios",
                 sidebarLayout(
                   sidebarPanel(
                     selectInput(inputId = 'servicio',
                                 label = 'Seleccione el servicio',
                                 choices = c("electricidad", "television", "telefono", "radio", "internet", "equipo", "total"),
                                 selected = 'electricidad'
                     ),
                     
                     br(),
                     
                     h4(" Autores"),
                     tags$p(tags$a(href="https://github.com/JohanMarin", "Johan D. Marin"), " & ",
                     tags$a(href="https://github.com/ousuga", "Olga C. Usuga", "\n")),
                     tags$p(tags$a(href="http://www.udea.edu.co/wps/portal/udea/web/inicio/investigacion/grupos-investigacion/ingenieria-tecnologia/incas", "Grupo INCAS,"), " Universidad de Antioquia"),
                     tags$img(src='logo-udea.png', height = 100, aling="center")
                            
                     ),
                   
                   mainPanel(
                     h4(textOutput("map"), aling="center"),
                     plotOutput("mapa1"),
                     plotOutput("mapa2")
                   ))), 
    
  #----------------------------------------------------------------------------------
  
  tabPanel("Hombres vs Mujeres",
           sidebarLayout(
             sidebarPanel(
               sliderInput(inputId = 'year2',
                           label   = HTML("Elija el año que desea ver:"),
                           min     = 2010,
                           max     = 2013,
                           value   = 2010,
                           step    = 1,
                           animate = TRUE),
               
               br(),
               
               h5(" Autores", aling="center"),
               tags$p(tags$a(href="https://github.com/JohanMarin", "Johan D. Marin"), " & ",
                      tags$a(href="https://github.com/ousuga", "Olga C. Usuga", "\n")),
               tags$p(tags$a(href="http://www.udea.edu.co/wps/portal/udea/web/inicio/investigacion/grupos-investigacion/ingenieria-tecnologia/incas", "Grupo INCAS,"), " Universidad de Antioquia"),
               tags$img(src='logo-udea.png', height = 100, aling="center")
               ),
             
             mainPanel(
               plotOutput("piramide")
             ))),
  
  #----------------------------------------------------------------------------------------
  #-------------------------------------------------------------------------------------
  tabPanel("Datos",
           sidebarLayout(
             sidebarPanel(
               selectInput(inputId = 'data',
                           label = 'Data',
                           choices = c("Estudiantes vs Docentes", "Covertura de Servicios","Hombres vs Mujeres"),
                           selected = "Estudiantes vs Docentes"
               ),
               
               br(),
               
               h4(" Autores"),
               tags$p(tags$a(href="https://github.com/JohanMarin", "Johan D. Marin"), " & ",
                      tags$a(href="https://github.com/ousuga", "Olga C. Usuga", "\n")),
               tags$p("Tomados de las bases de datos del ", tags$a(href="https://sitios.dane.gov.co/visor-anda/", "DANE")),
               tags$img(src='logo-udea.png', height = 100, aling="center")
               
             ),
            
               mainPanel(
                 h4(textOutput("baseDatos"), aling="center"),
                 dataTableOutput("table")
               )))
  
  )))
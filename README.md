# AppColEd
En esta aplicación se puede visualizar información a cerca de la educación basica presscolar primaria y secundaria.

Para visualizar la app en su computador solo necesita copiar y pegar el siguiente codigo en la consola de Rstudio.
```r
shiny::runGitHub("AppColEd", "johanmarin", subdir = "App", launch.browser= TRUE)
```
**Nota:** Es posible que la primera vez no funcione esto se debe a que no este instalado alguno de los paquetes requeridos, por lo que es necesario instalarlos y luego volver a correr la linea de codigo. o instalar previamente los paquetes requeridos.

```r
if (!require('shiny')) install.packages('shiny')
if (!require('ggplot2')) install.packages('ggplot2')
if (!require('plotly')) install.packages('plotly')
if (!require('data.table')) install.packages('data.table')
if (!require('sp')) install.packages('sp')
if (!require('rgdal')) install.packages('rgdal')
if (!require('stringr')) install.packages('stringr')
if (!require('plyr')) install.packages('plyr')
if (!require('gtable')) install.packages('gtable')
if (!require('grid')) install.packages('grid')
```

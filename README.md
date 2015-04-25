# Text Prediction App

The R scripts and data files uploaded herewith are the necessary files needed to launch the text prediction app.

The following is the `sessionInfo` when I run the app. Note that `shiny::eventReactive()` is utilized in `ui.R`. 
Therefore, you need to make sure that you have the correct versions of the packages. In the info session information,
you will see that for the `shinyapps` package, we are using version `0.3.63`, for the `shiny` package, the version
is `0.11.1`.

```
R version 3.1.1 (2014-07-10)
Platform: x86_64-apple-darwin13.1.0 (64-bit)

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] shinyapps_0.3.63 shiny_0.11.1    

loaded via a namespace (and not attached):
[1] digest_0.6.4    htmltools_0.2.6 httpuv_1.3.2    mime_0.2        R6_2.0.1       
[6] Rcpp_0.11.5     RJSONIO_1.3-0   tools_3.1.1     xtable_1.7-4 
```

If you are getting a `shiny::eventReactive()` error when running the application, it is highly likely that you have 
a lower version of `shiny`. To get the latest version and install directly from GitHub, run

```r
if (!require("devtools"))
   install.packages("devtools")
devtools::install_github("rstudio/shiny")
```

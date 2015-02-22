# ui.R
library(shiny)
shinyUI(fluidPage(
    titlePanel("STOCK VISUALIZATION Ver.2015"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Select a stock to examine.
                     Information will be collected from",
                     a("Quandl",href="https://www.quandl.com/",style="color:Orange"),
                     ". If you don't have the code of the stock,
                     you can search by typing the company which the stock belongs to into the first box.",
                     strong("Most time"), ". This'll give you the right stock code.
                     If you enter nothing, this app will use
                     the default setting, which is Apple Inc. After
                     the search result shows up, you can copy the 
                     stock code and paste it into the second box to visualize the historical data of the selected stock. 
                     You can also adjust the date range to be as you want,
                     but if the start date you enter is", strong("before the IPO date of the
                     selected stock"), ", only the data after the IPO date can be visualized.
                     The radio button at the buttom allows you to change the style of the chart.
                     Right below the stock plot is a stock forecast plot based on the historical
                     data from 2010-01-01 to today."),
            helpText(strong("The forecast training may take some time, please be patient.")),
            
            textInput("name","Stock/Company Name","APPLE"),
            
            actionButton("getInfo", "GET STOCK CODE"),
            
            textInput("code","Stock Code","GOOG/NASDAQ_AAPL"),
            
            dateRangeInput("dates", 
                           "Date range",
                           start = "2014-01-01", 
                           end = as.character(Sys.Date())),
            
            radioButtons("radio", label = h4("Chart Style"),
                         choices = list("Line" = 1, "CandleSticks" = 2),
                         selected = 1),
            
            radioButtons("radio2",label=h4("FORECASTING!"),
                         choices=list("forecast from today"=1,
                                      "forecast performance in 2014"=2)),
            
            br(),
            br(),
                     
            helpText("PS: 'Erorr:Requested entity does not exist' might due to your network connection to Quandl
                    or regular database upgrade of Quandl.")
            
            ),
        mainPanel(
            h4("NAME OF THE COMPANY YOU SEARCH FOR"),
            verbatimTextOutput("CN"),
            h4("CODO OF THE STOCK YOU SEARCH FOR"),
            verbatimTextOutput("SC"),
            h4("STOCK PLOT"),
            plotOutput("plot"),
            h4("FORECAST PLOT"),
            verbatimTextOutput("warn"),
            plotOutput("predictPlot"))
    )
))
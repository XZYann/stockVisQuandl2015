library(quantmod)
library(Quandl)
library(forecast)
Quandl.auth("LsYY_SqxwzmfH6N_gbTE")

shinyServer(function(input, output) {
    
    chartInput<-reactive({
        if (!input$code==""){
        Quandl(code=input$code,
            start_date=input$dates[1],
            end_date=input$dates[2],
            type="zoo")
        }
    })
    
    
    output$plot<-renderPlot({
        if (!input$code==""){
        if (input$radio==1){
            chartSeries(chartInput(),
                        name="line",type="line",TA=NULL)
        }else if (input$radio==2){
            candleChart(xts(chartInput()),
                        name="candlechart")
        }
        }
    })
    
    A<-reactive({
        Quandl(code=input$code,start_date="2010-01-01",
               end_dat=as.character(Sys.Date()),type="zoo")
    })
    
    output$predictPlot<-renderPlot({
        start.dat<-row.names(as.data.frame(A()))[1]
        if (start.dat=="2010-01-01"){
            mA<-to.monthly(A())
            openA<-Op(mA)
            ts1<-ts(openA,frequency=12)
            if (input$radio2=="1"){
                ets1<-ets(ts1,model="MMM")
                fcast<-forecast(ets1)
                plot(fcast,xlab="YEARS+1",ylab="STOCK PRICE")
            }else if (input$radio2=="2"){
                ts1train<-window(ts1,start=1,end=5)
                ts1test<-window(ts1,start=5,end=6)
                ets1<-ets(ts1train,model="MMM")
                fcast<-forecast(ets1)
                plot(fcast,xlab="YEARS+1",ylab="STOCK PRICE")
                lines(ts1test,col="red")
                legend("topright",lwd=1,col=c("red","blue"),
                       legend=c("historical data","forecast"))
            }
        }
    })
    
    output$warn<-renderText({
        start.dat<-row.names(as.data.frame(A()))[1]
        if (start.dat=="2010-01-01"){
            "Warning: The accuracy is not stable. The author is NOT RESPONSIBLE for any loss cost by stock trading based on this prediction :)"
        }else if(!start.dat=="2010-01-01"){
            "Warning: The selected stock has no or less than 5 periods(years) (i.e. The IPO data of the stock is after 2010-01-01)"
        }
    })
    
    nameInput<-reactive({
        input$getInfo
        isolate(Quandl.search(query=input$name,source='GOOG',silent=T))
    })
    
    output$CN<-renderText({
        nameInput()[[1]]$name
    })
    
    output$SC<-renderText({
        nameInput()[[1]]$code 
    })
    
    output$DC<-renderText({
        nameInput()[[1]]$description
    })
})
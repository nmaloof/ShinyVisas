library(data.table)
library(dplyr)

server <- function(input, output, session){
    #-----Read the Data Set-----#
    Visas <- fread("TestVisas.csv")
    
    #-----Get the Jobs SOC-----#
    getJobsSOC <- reactive({
        term <- toupper(input$JobCategory)
        UniqTerms <- unique(Visas$SOC_NAME)
        matched <- UniqTerms[grep(term, UniqTerms)]
        if(length(matched) > 5){
            return(matched[1:5])
        }else{
            return(matched[1:length(matched)])
        }
    })
    
    #-----Get The Jobs Title-----#
    getJobsTitle <- reactive({
        term <- input$JobTitle
        return(Visas[grep(term, Visas$JOB_TITLE, ignore.case = TRUE)])
    })
    
    #-----Get The Long/Lat-----#
    getJobLocat <- reactive({
        Locat <- Visas[SOC_NAME == input$SpecificJob] %>% select(., lat, lon) %>% 
            mutate(., latlong = paste(lat, lon, sep = ':'))
        return(Locat)
    })
    
    #-----Plot All Applicants-----#
    output$TotalApplicants <- renderPlotly({
        VD <- Visas[, .(TotalApplicants = .N), by = YEAR]
        plot_ly(
            data = VD, x = ~YEAR, y = ~TotalApplicants, type = "scatter",
            mode = "lines+markers"
        )
    })
    
    #-----Plot Applicants by Status-----#
    output$CaseApplicants <- renderPlotly({
        VD <- Visas[, .(TotalApplicants = .N), by = .(YEAR, CASE_STATUS)]
        plot_ly(
            data = VD, x = ~YEAR, y = ~TotalApplicants, color = ~CASE_STATUS,
            type = "scatter", mode = "lines+markers"
        )
    })
    
    #-----Plot Applicants by Percentage-----#
    output$FreqApplicants <- renderPlotly({
        VD <- Visas %>% group_by(., YEAR, CASE_STATUS) %>% summarise(., count = n())%>%
            mutate(., Proportion = count/sum(count))
        VD <- as.data.table(VD)
        plot_ly(
            data = VD, x = ~YEAR, y = ~Proportion, color = ~CASE_STATUS,
            type = "scatter", mode = "lines+markers"
        )
    })
    
    #-----Output The Job Choices-----#
    output$JobSOC <- renderUI({
        radioButtons(inputId = "SpecificJob", label = "Choose a Specific Job Category", choices = getJobsSOC())
    })
    
    #-----Output The Job Titles-----#
    # output$JobTitles <- renderUI({
    #     radioButtons(inputId = "SpecJobTitle", label = "Choose a Specific Job Title", choices = getJobsTitle())
    # })
    
    #-----Plot the Output of Jobs SOC-----#
    output$SOCPlot <- renderPlotly({
        VD <- Visas[SOC_NAME == input$SpecificJob, .(TotalApplicants = .N), by = YEAR]
        plot_ly(
            data = VD, x = ~YEAR, y = ~TotalApplicants, type = "scatter", mode = "lines+markers"
        )
    })
    
    #-----Plot the Output of Jobs Title-----#
    output$TitlePlot <- renderPlotly({
        VD <- getJobsTitle()[, .(TotalApplicants = .N), by = .(YEAR, CASE_STATUS)]
        plot_ly(
            data = VD, x = ~YEAR, y = ~TotalApplicants, color = ~CASE_STATUS,
            type = "scatter", mode = "lines+markers"
        )
    })
    
    #-----InfoBoxOutputs-----#
    #---First Half---#
    output$MinValue <- renderInfoBox({
        dat <- Visas[(SOC_NAME == input$SpecificJob) & CASE_STATUS == "CERTIFIED"]
        infoBox("Minimum $", min(dat$PREVAILING_WAGE), icon = icon("minus-square"), color = "purple", fill = T)
    })
    output$MaxValue <- renderInfoBox({
        dat <- Visas[(SOC_NAME == input$SpecificJob) & CASE_STATUS == "CERTIFIED"]
        infoBox("Maximum $", max(dat$PREVAILING_WAGE), icon = icon("plus-square"), color = "purple", fill = T)
    })
    output$MeanValue <- renderInfoBox({
        dat <- Visas[(SOC_NAME == input$SpecificJob) & CASE_STATUS == "CERTIFIED"]
        infoBox("Average $", round(mean(dat$PREVAILING_WAGE),2), icon = icon("bullseye"), color = "purple", fill = T)
    })
    output$MedianValue <- renderInfoBox({
        dat <- Visas[(SOC_NAME == input$SpecificJob) & CASE_STATUS == "CERTIFIED"]
        infoBox("Median $", median(dat$PREVAILING_WAGE), icon = icon("calculator"), color = "purple", fill = T)
    })
    output$FullTime <- renderInfoBox({
        dat <- Visas[(SOC_NAME == input$SpecificJob) & CASE_STATUS == "CERTIFIED"]
        infoBox("Full Time", sum(dat$FULL_TIME_POSITION == "Y"), icon = icon("credit-card-alt"), color = "purple", fill = T)
    })
    #---Second Half---#
    output$MinValue2 <- renderInfoBox({
        dat <- getJobsTitle()[CASE_STATUS == "CERTIFIED"]
        infoBox("Minimum $", min(dat$PREVAILING_WAGE), icon = icon("calculator"), color = "purple", fill = T)
    })
    output$MaxValue2 <- renderInfoBox({
        dat <- getJobsTitle()[CASE_STATUS == "CERTIFIED"]
        infoBox("Maximum $", max(dat$PREVAILING_WAGE), icon = icon("calculator"), color = "purple", fill = T)
    })
    output$MeanValue2 <- renderInfoBox({
        dat <- getJobsTitle()[CASE_STATUS == "CERTIFIED"]
        infoBox("Average $", round(mean(dat$PREVAILING_WAGE),2), icon = icon("bullseye"), color = "purple", fill = T)
    })
    output$MedianValue2 <- renderInfoBox({
        dat <- getJobsTitle()[CASE_STATUS == "CERTIFIED"]
        infoBox("Median $", median(dat$PREVAILING_WAGE), icon = icon("calculator"), color = "purple", fill = T)
    })
    output$FullTime2 <- renderInfoBox({
        dat <- getJobsTitle()[CASE_STATUS == "CERTIFIED"]
        infoBox("Full Time", sum(dat$FULL_TIME_POSITION == "Y"), icon = icon("credit-card-alt"), color = "purple", fill = T)
    })
    
        
    #-----Plot the GeoMap-----#
    output$GeoMap1 <- renderGvis({
        gvisMap(
            getJobLocat(), "latlong",
            options = list(region = "US", displayMode = "Markers", mapType = "normal",
                           width = "auto", height = "auto")
        )
    })
    
}

ui <- dashboardPage(
    skin = "black",
    ###----------Dashboard Header----------###
    dashboardHeader(
        title = "H-1B Visa Applicants"
    ),
    ###----------Dashboard Sidebar----------###
    dashboardSidebar(
        collapsed = TRUE,
        sidebarUserPanel(
            name = "Nicholas Maloof", image = "Nicholas1.jpg"
        ),
        sidebarMenu(
            menuItem(
                text = "Diagrams", tabName = "GraphTab",
                icon = icon("area-chart"), badgeLabel = "Charts",
                badgeColor = "blue"
            ),
            menuItem(
                text = "Specific Jobs", tabName = "SelectTab",
                icon = icon("id-card"), badgeLabel = "Careers",
                badgeColor = "red"
            ),
            menuItem(
                text = "Job Locations", tabName = "JobLocatTab",
                icon = icon("globe"), badgeLabel = "Where",
                badgeColor = "green"
            )
        )
    ),
    ###----------Dashboard Body----------###
    dashboardBody(
        tags$head(tags$style(HTML("
        .skin-black .main-header .logo {
                                  background: gray;
                                  color: white;
                                  font-family: Palatino;
                                  font-size: 20px;
                                  }
                                  .skin-black .main-header .logo:hover {
                                  background: rgb(0,0,0);
                                  }
                                  .skin-black .left-side, .skin-black .main-sidebar, .skin-black .wrapper{
                                  background: gray;
                                  }
                                  .skin-black .main-header .navbar{
                                  background: -webkit-linear-gradient(left, gray , black);
                                  }
                                  .skin-black .sidebar a{
                                  font-family: CenturyGothic;
                                  font-size: 15px;
                                  }
                                  p{
                                  font-family: cursive;
                                  font-size: 17px;
                                  }
                                  h1{
                                  font-family: Lobster;
                                  font-family: italic;
                                  }"))),
        tabItems(
            #-----Tab Item 1 Begins-----#
            tabItem(
                tabName = "GraphTab",
                fluidPage(
                    h1("A Look at Visas Through the Years"),
                    tabBox(
                        title = tagList(shiny::icon("line-chart"), "Visa Applicants"),
                        side = "left",
                        width = 12,
                        tabPanel(
                            title = "All",
                            plotlyOutput(outputId = "TotalApplicants")
                        ),
                        tabPanel(
                            title = "Status",
                            plotlyOutput(outputId = "CaseApplicants")
                        ),
                        tabPanel(
                            title = "Freq",
                            plotlyOutput(outputId = "FreqApplicants")
                        )
                    )
                )
            ),
            #-----Tab Item 1 Ends-----#
            
            #-----Tab Item 2 Begins-----#
            tabItem(
                tabName = "SelectTab",
                fluidPage(
                    h1("Searching for the Job You Want"),
                    fluidRow(
                        tabBox(
                            title = tagList(shiny::icon("search"), "Job Title Categories"),
                            side = "left",
                            width = 12,
                            height = 850,
                            tabPanel(
                                title = "Standard Occupation",
                                column(
                                    width = 6,
                                    textInput(
                                        inputId = "JobCategory", label = "Please Enter a Job Category",
                                        placeholder = "Insert Job Category", width = "100%"
                                    )
                                ),
                                column(
                                    width = 6,
                                    uiOutput(outputId = "JobSOC")
                                ),
                                br(),br(),br(),br(),br(),br(),br(),br(),
                                plotlyOutput(outputId = "SOCPlot"),
                                br(),
                                infoBoxOutput(outputId = "MinValue"),
                                infoBoxOutput(outputId = "MaxValue"),
                                infoBoxOutput(outputId = "MeanValue"),
                                infoBoxOutput(outputId = "MedianValue"),
                                infoBoxOutput(outputId = "FullTime")
                            ),
                            tabPanel(
                                title = "Job Title",
                                column(
                                    width = 12,
                                    textInput(
                                        inputId = "JobTitle", label = "Please Enter a Job Title",
                                        placeholder = "Insert Job Title", width = "100%"
                                    )
                                ),
                                br(),br(),br(),br(),
                                plotlyOutput(outputId = "TitlePlot"),
                                br(),
                                infoBoxOutput(outputId = "MinValue2"),
                                infoBoxOutput(outputId = "MaxValue2"),
                                infoBoxOutput(outputId = "MeanValue2"),
                                infoBoxOutput(outputId = "MedianValue2"),
                                infoBoxOutput(outputId = "FullTime2")
                            )
                        )
                    )
                )
            ),
            #-----Tab Item 2 Ends-----#
            
            
            #-----Tab Item 3 Begins-----#
            tabItem(
                tabName = "JobLocatTab",
                fluidPage(
                    h1("Where Are You Going to Work"),
                    htmlOutput(outputId = "GeoMap1")
                )
            )
            #-----Tab Item 3 Ends-----#
        )
    )
)
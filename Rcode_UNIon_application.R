## Sidebar Code
install.packages("ggmap")
install.packages("ggplot2")
install.packages("htmltools")
install.packages("shiny")
install.packages("shinydashboard")
install.packages("leaflet")

library(ggmap)
library(ggplot2)
library(htmltools)

ct<-read.csv(file.choose(),header = TRUE,stringsAsFactors = FALSE)
ct

if (interactive()) {
  
  # Package call
  library(shiny)
  library(shinydashboard)
  library(leaflet)
  
  header <- dashboardHeader(
    title = "서울시 대관 서비스",
    
    # Message menus
    dropdownMenu(type = "messages",
                 messageItem(from = "Sales Dept", message = "Sales are steady this month."),
                 messageItem(from = "New User", message = "How do I register?", icon = icon("question"), time = "13:45"),
                 messageItem(from = "Support",  message = "The new server is ready.", icon = icon("life-ring"), time = "2014-12-01")
    ),
    
    # Notification menus
    dropdownMenu(type = "notifications",
                 notificationItem(text = "5 new users today", icon("users")),
                 notificationItem(text = "12 items delivered", icon("truck"), status = "success"),
                 notificationItem(text = "Server load at 86%", icon = icon("exclamation-triangle"), status = "warning")
    ),
    
    # task menus
    dropdownMenu(type = "tasks",
                 badgeStatus = "success", taskItem(value = 90, color = "green", "Documentation"),  # Scroll bar
                 taskItem(value = 17, color = "aqua", "Project X"),
                 taskItem(value = 75, color = "yellow", "Server deployment"),
                 taskItem(value = 80, color = "red","Overall project")
    )
  )
  
  
  # sidebar menu
  sidebar <- dashboardSidebar(
    sidebarSearchForm(label = "School Search", "searchText", "searchButton"),
    sidebarMenu(
      id = "tabs",
      # Dashboard
      menuItem("Location", tabName = "dashboard", icon = icon("dashboard")),
      # Widgets
      menuItem("Conditions", tabName = "widgets", icon = icon("th"), badgeLabel = "new",
               badgeColor = "green"),
      # Charts
      menuItem("Charts", icon = icon("bar-chart-o"),
               menuSubItem("Sorting by Condition", tabName = "subitem1"),
               menuSubItem("Sorting by Ranking", tabName = "subitem2")
      ),
      # Source code for app
      menuItem("운영게시판", tabName = "code", icon = icon("file-code-o")
      ),
      # Control Slider : server?뿉?꽌 ?뿰?룞
      menuItemOutput("slider_sidebar"),
      # Text Input : server?뿉?꽌 ?뿰?룞
      menuItemOutput("Text_input")
    )
  )
  
  body <- dashboardBody(
    tabItems(
      tabItem("dashboard",
              fluidRow(
                column(width=9,
                       box(width=NULL,solidHeader=TRUE,m <- leaflet(ct) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', attribution='Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>% 
                             setView(127, 37.55, zoom = 12) %>% 
                             addCircles(~lng, ~lat, popup=ct$type, weight = 3, radius=40, 
                                        color="#ffa500", stroke = TRUE, fillOpacity = 0.8) %>% 
                             addLegend("bottomright", colors= "#ffa500", labels="University'", title="In Connecticut")
                       )),
                column(width = 3,
                       box(width = NULL, status = "warning",
                           uiOutput("routeSelect"),
                           checkboxGroupInput("directions", "Show",
                                              choices = c(
                                                Northbound = 4,
                                                Southbound = 1,
                                                Eastbound = 2,
                                                Westbound = 3
                                              ),
                                              selected = c(1, 2, 3, 4)
                           ),
                           p(
                             class = "text-muted",
                             paste("Note: a route number can have several different trips, each",
                                   "with a different path. Only the most commonly-used path will",
                                   "be displayed on the map."
                             )
                           ),
                           actionButton("zoomButton", "Zoom to fit buses")
                       ),
                       box(width = NULL, status = "warning",
                           selectInput("interval", "빌릴 시간",
                                       choices = c(
                                         "30 minutes" = 30,
                                         "1 hour" = 60,
                                         "2 hour" = 120,
                                         "3 hour" = 300,
                                         "4 hours" = 600
                                       ),
                                       selected = "60"
                           ),
                           uiOutput("timeSinceLastUpdate"),
                           actionButton("refresh", "Refresh now"),
                           p(class = "text-muted",
                             br(),
                             "Source data updates every 30 seconds."
                           )
                       )
                )
                
                
              )
              
              
              
      ),
      tabItem("widgets",
              fluidPage(
                titlePanel("Select List"),
                
                sidebarLayout(
                  sidebarPanel(
                    
                    
                    helpText("Please select the minimum limit"),
                    
                    
                    
                    radioButtons("Association", label = h3("인원"),
                                 choices = list("1 point" = 1, "2 point" = 2, "3 point" = 3,"4 point" = 4,"5 point" = 5)),
                    
                    radioButtons("Ratio", label = h3("대관 날짜, 시간"),
                                 choices = list("1 point" = 1, "2 point" = 2, "3 point" = 3,"4 point" = 4,"5 point" = 5)),
                    radioButtons("Program", label = h3("강의실 특성"),
                                 choices = list("1 point" = 1, "2 point" = 2, "3 point" = 3,"4 point" = 4,"5 point" = 5)),
                    radioButtons("Guide", label = h3("기자재"),
                                 choices = list("1 point" = 1, "2 point" = 2, "3 point" = 3,"4 point" = 4,"5 point" = 5)),
                    radioButtons("Service", label = h3("Overall service"),
                                 choices = list("1 point" = 1, "2 point" = 2, "3 point" = 3,"4 point" = 4,"5 point" = 5)),
                    radioButtons("Price", label = h3("Price Index"),
                                 choices = list("1 point" = 1, "2 point" = 2, "3 point" = 3,"4 point" = 4,"5 point" = 5))
                    
                    
                  ),
                  
                  
                  
                  
                  mainPanel(
                    
                    tableOutput("Table")
                  )
                )
              )
      ),
      tabItem("subitem1",
              "Sub-item 1 tab content"
      ),
      tabItem("subitem2",
              "Sub-item 2 tab content"
      )
    )
  )
  
  # App Start
  shinyApp(
    ui = dashboardPage(header, sidebar, body),
    
    server = shinyServer(function(input, output){
      
      
      
      
      sliderValues <- reactive({
        
        # Compose data frame
        data.frame(
          Name = c("Association",
                   "Ratio", 
                   "Program",
                   "Guide",
                   "Service",
                   "Price"),
          Value = c(input$Association,
                    input$Ratio, 
                    input$Program,
                    input$Guide,
                    input$Service,
                    input$Price), 
          stringsAsFactors=FALSE)
      }) 
      
      # Show the values using an HTML table
      output$Table <- renderTable({
        sliderValues()
      })
      
      
      # sidebar?쓽 menuItemOutput() ?뿰?룞
      output$slider_sidebar = renderMenu({
        sidebarMenu(uiOutput("input1"))
      })
      output$Text_input = renderMenu({
        sidebarMenu(uiOutput("input2"))
      })
      output$input1 = renderUI({
        sliderInput("Slider", label = "Threshold", 1, 20, 5)
      })
      output$input2 = renderUI({
        textInput("Text", label = "Text input")
      })
      
      points <- eventReactive(input$recalc, {
        cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
      }, ignoreNULL = FALSE)
      
      output$mymap <- renderLeaflet({
        leaflet() %>%
          addProviderTiles(providers$Stamen.TonerLite,
                           options = providerTileOptions(noWrap = TRUE)
          ) %>%
          addMarkers(data = points())
      })
    })
  )
}

DB<-read.csv(file.choose(),encoding="EUC-KR",header=TRUE)





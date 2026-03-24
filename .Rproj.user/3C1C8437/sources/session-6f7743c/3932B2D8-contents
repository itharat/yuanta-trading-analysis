library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(lubridate)
library(tidyr)

ui <- navbarPage(
  title = "Trading Analytics Dashboard",
  
  # 1. HOME PAGE
  tabPanel("Home",
           fluidPage(
             # Header Section
             div(style = "background-color: #f8f9fa; padding: 30px; border-radius: 10px; margin-bottom: 30px; border-top: 5px solid #ad1d28;",
                 h1("Trading Analytics Dashboard", style = "color: #ad1d28; font-weight: bold;"),
                 p("A comprehensive diagnostic tool for exploring trading behavior, client segmentation, and regional revenue performance.", 
                   style = "font-size: 18px; color: #555;")
             ),
             
             fluidRow(
               # Left Column: Business Questions
               column(6,
                      h3("Strategic Business Questions", style = "color: #333; font-weight: bold;"),
                      wellPanel(
                        tags$ul(
                          tags$li(strong("Revenue Drivers:"), "Which regions and segments are currently fueling our commission growth?"),
                          br(),
                          tags$li(strong("Market Concentration:"), "How dependent are we on specific stock sectors like Banking and Energy?"),
                          br(),
                          tags$li(strong("Client Opportunities:"), "Who are our 'Hidden Whales'—Retail clients trading at HNW volumes?"),
                          br(),
                          tags$li(strong("Risk Mitigation:"), "Why is Bangkok revenue declining, and how can we stabilize volatile northern markets?")
                        )
                      )
               ),
               
               # Right Column: Data Governance
               column(6,
                      h3("Data Architecture", style = "color: #333; font-weight: bold;"),
                      tableOutput("dataSourceTable"),
                      br(),
                      div(style = "background-color: #eee; padding: 15px; border-radius: 5px; border-left: 4px solid #5f7695;",
                          p(strong("Analyst:"), "Napatcha Itharat"),
                          p(strong("Reporting Period:"), "March 2025 - March 2026")
                      )
               )
             ),
             
             hr(),
             
             # Bottom Section: Dashboard Navigation Map
             h3("Navigating the Analysis", style = "color: #333; font-weight: bold; text-align: center;"),
             br(),
             fluidRow(
               column(3, wellPanel(style = "text-align: center; height: 150px;", icon("chart-pie", "fa-3x"), h4("Market Overview"), "Sector distribution & Top 10 Stocks")),
               column(3, wellPanel(style = "text-align: center; height: 150px;", icon("users", "fa-3x"), h4("Client Analysis"), "Regional segmentation & Southern focus")),
               column(3, wellPanel(style = "text-align: center; height: 150px;", icon("magnifying-glass-chart", "fa-3x"), h4("Outlier Detection"), "Identifying 'Whale' traders & micro-investors")),
               column(3, wellPanel(style = "text-align: center; height: 150px;", icon("arrow-trend-up", "fa-3x"), h4("Commission Trends"), "Monthly regional revenue tracking"))
             )
           )
  ),
  
  # 1. TOP STOCKS + SECTOR
  tabPanel("Market Overview",
           fluidPage(
             br(),
             h2("Top 10 Traded Stocks & Sector Analysis", style = "color: #ad1d28;"), 
             
             fluidRow(
               column(7, h3("Market Dominance"), plotOutput("topStocksPlot")),
               column(5, h3("Sector Distribution"), plotOutput("sectorPie"))
             ),
             
             hr(),
             
             h3("Yuanta Executive Insights"),
             fluidRow(
               column(4, 
                      wellPanel(
                        h4("Banking Dominance"),
                        p("The Insight: ", strong("6 out of 10"), " of our most traded stocks are from the Banking sector, accounting for 28.3% of total value."),
                        p("Business Impact: Clients are heavily focused on Value Stocks and Dividend yields."),
                        p("Action: Research should prioritize NIM (Net Interest Margin) reports.")
                      )
               ),
               column(4, 
                      wellPanel(
                        h4("Concentration Risk"),
                        p("The Insight: PTT leads, but the cluster of Banking and Energy means revenue is sensitive to SET Index heavyweights."),
                        p("Business Impact: High concentration represents a risk if these two sectors stagnate."),
                        p("Action: Cross-sell into under-traded sectors like Healthcare (10.6%).")
                      )
               ),
               column(4, 
                      wellPanel(
                        h4("Sector Rotation"),
                        p("The Insight: Energy and Banking combined control over ", strong("50% of the pie.")),
                        p("Business Impact: Retail clients follow 'Big Cap' trends closely."),
                        p("Action: Proactively alert clients to defensive rotations if banking volume drops.")
                      )
               )
             )
           )
  ),
  
  # 2. CLIENT DISTRIBUTION
  tabPanel("Client Analysis",
           fluidPage(
             br(),
             h2("Regional Client Segmentation", style = "color: #ad1d28;"),
             
             fluidRow(
               column(7, plotOutput("clientDistPlot")),
               column(5, plotOutput("southPlot"))
             ),
             
             hr(),
             
             h3("Strategic Regional Insights"),
             fluidRow(
               column(6, 
                      wellPanel(
                        h4("Unexpected Southern Dominance"),
                        p("Our data shows that the ", strong("Retail segment in the South"), " actually exceeds Bangkok in terms of raw client count.")
                      )
               ),
               column(6, 
                      wellPanel(
                        h4("Expansion Opportunity: Phuket & Hat Yai"),
                        p("With ", strong("Phuket and Hat Yai"), " showing high retail concentration, Yuanta should evaluate localized specialized support centers.")
                      )
               )
             )
           )
  ),
  
  # 3. OUTLIER DETECTION
  tabPanel("Outlier Detection",
           fluidPage(
             br(),
             h2("Trading Value Distribution", style = "color: #ad1d28; font-weight: bold;"),
             
             br(),
             # THE PLOT
             plotOutput("boxplot", height = "600px"),
             
             br(),
             # 3. OUTLIER DETECTION (Strategic Insights Section)
             h3("Strategic Data Insights", style = "color: #333333; margin-top: 25px;"),
             
             wellPanel(
               style = "background-color: #fdfdfd; border-left: 5px solid #ad1d28;",
               
               # Negative Outliers
               fluidRow(
                 column(1, icon("circle", style = "color: #ad1d28; font-size: 15px; margin-top: 10px;")),
                 column(11, 
                        p(strong("Micro-Investor Identification:"), 
                          "The red dots below the Retail box represent 'micro-investors.' While they hold accounts, their activity is significantly below the segment average, potentially increasing maintenance costs relative to revenue.")
                 )
               ),
               
               hr(style = "margin: 10px 0;"),
               
               # Positive Outlier Opportunity
               fluidRow(
                 column(1, icon("chart-line", style = "color: #5f7695; font-size: 20px;")),
                 column(11, 
                        p(strong("Predictability vs. Opportunity:"), 
                          "Institutional and Corporate boxes are 'tight' (predictable), whereas the", 
                          strong("Retail box is significantly taller."), 
                          "This high variance suggests many 'closet' High Net Worth individuals are currently categorized as Retail.")
                 )
               ),
               
               hr(style = "margin: 10px 0;"),
               
               # Hidden Whales
               fluidRow(
                 column(1, icon("magnifying-glass-chart", style = "color: #333333; font-size: 20px;")),
                 column(11, 
                        p(strong("Targeting 'Hidden Whales':"), 
                          "Focus on the", strong("top whiskers"), "of the Retail segment. These clients trade at volumes comparable to upper-tier segments and are prime targets for immediate upselling to premium services.")
                 )
               )
             )
           )
  ),
  
  # 4. COMMISSION TREND
  tabPanel("Commission Trends",
           fluidPage(
             br(),
             h2("Regional Revenue Performance", style = "color: #ad1d28;"),
             
             br(),
             # The Plot
             plotOutput("commissionRegion", height = "500px"),
             
             br(),
             # --- Added Strategic Insights Section ---
             h3("Strategic Revenue Insights"),
             wellPanel(
               tags$ul(
                 tags$li(strong("Southern Dominance:"), "The", span("South (purple line)", style="color: #cc79a7; font-weight: bold;"), 
                         "has clearly emerged as the top-performing region, consistently hitting the highest peaks (reaching over 4.0M in Q4 2025 and Q1 2026). 
                         It shows the strongest recovery after every dip."),
                 br(),
                 tags$li(strong("Bangkok’s Relative Decline:"), "Surprisingly,", span("Bangkok (coral line)", style="color: #f8766d; font-weight: bold;"), 
                         "has trended downward since July 2025. Once a top contender, it finished the period near the bottom of the group, 
                         suggesting a shift in trading activity away from the capital."),
                 br(),
                 tags$li(strong("High Volatility in the North:"), "The", span("North (green line)", style="color: #00ba38; font-weight: bold;"), 
                         "exhibits the most 'zigzag' behavior, with massive spikes followed by sharp drops. This suggests a region driven by 
                         high-frequency seasonal trading or specific market events rather than steady growth."),
                 br(),
                 tags$li(strong("Central Region Lag:"), "The", span("Central region (olive line)", style="color: #7c8e00; font-weight: bold;"), 
                         "remains the consistent underperformer, rarely breaking above the 2.5M mark. It follows the general market trend 
                         but lacks the volume seen in the other four regions.")
               )
             ),
             
             p(em("Note: Commission values are displayed in Millions (M) for better readability."))
           )
  )
)
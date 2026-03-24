server <- function(input, output) {
  output$dataSourceTable <- renderTable({
    data.frame(
      "File Name" = c("trading_transactions.csv", "clients.csv", "stock_master.csv", "daily_market_data.csv", "commission_rates.csv"),
      "Description" = c("12 months of client trading transactions", 
                        "Client demographic and account information", 
                        "Stock reference data (symbols, sectors, etc.)", 
                        "Daily stock prices and volumes", 
                        "Commission tier structure")
    )
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
  # Load data
  trades <- read_csv("trading_transactions.csv")
  clients <- read_csv("clients.csv")
  stocks <- read_csv("stock_master.csv")
  
  # Ensure IDs match
  trades <- trades %>% mutate(stock_id = as.character(stock_id))
  stocks <- stocks %>% mutate(stock_id = as.character(stock_id))
  
  trades_clients <- trades %>% left_join(clients, by = "client_id")
  data <- trades_clients %>% left_join(stocks, by = "stock_id")
  
  # TOP STOCKS
  output$topStocksPlot <- renderPlot({
    top_stocks <- data %>%
      filter(!is.na(symbol.x)) %>% 
      group_by(symbol.x) %>% 
      summarise(value = sum(gross_value_thb, na.rm = TRUE), .groups = "drop") %>%
      arrange(desc(value)) %>%
      slice_head(n = 10)
    
    ggplot(top_stocks, aes(x = reorder(symbol.x, value), y = value / 1000000)) +
      geom_col(fill = "steelblue") +
      coord_flip() +
      scale_y_continuous(labels = scales::unit_format(unit = "M")) + 
      labs(title = "Top 10 Traded Stocks (Million THB)", x = "Stock Symbol", y = "Value") +
      theme_minimal(base_size = 14)
  })
  
  # SECTOR PIE
  output$sectorPie <- renderPlot({
    sector_data <- data %>%
      filter(!is.na(sector)) %>%
      group_by(sector) %>%
      summarise(value = sum(gross_value_thb, na.rm = TRUE), .groups = "drop") %>%
      mutate(percent = value / sum(value) * 100)
    
    ggplot(sector_data, aes(x = "", y = value, fill = sector)) +
      geom_bar(stat = "identity", width = 1, color = "white") +
      coord_polar("y") +
      geom_text(aes(label = paste0(round(percent, 1), "%")), position = position_stack(vjust = 0.5), size = 5) +
      labs(title = "Sector Distribution (%)", fill = "Sector") +
      theme_void()
  })
  
  # CLIENT DISTRIBUTION
  output$clientDistPlot <- renderPlot({
    client_dist <- clients %>% count(segment, region)
    ggplot(client_dist, aes(region, n, fill = segment)) +
      geom_col(position = "dodge") +
      labs(
        title = "Client Distribution by Segment & Region",
        y = "Number of Clients",
        x = "Region"
      ) +
      theme_minimal() +
      theme(
        # BIG BOLD BLACK TITLE
        plot.title = element_text(size = 22, face = "bold", color = "black", margin = margin(b = 15)), 
        axis.text = element_text(size = 11),
        axis.title = element_text(size = 13, face = "bold"),
        legend.text = element_text(size = 11),
        legend.title = element_text(size = 12),
        plot.margin = margin(10, 10, 10, 10)
      )
  })
  
  # SOUTH FOCUS
  output$southPlot <- renderPlot({
    south <- clients %>%
      filter(region == "South", segment == "Retail") %>%
      count(province) %>%
      arrange(desc(n)) %>%
      head(5)
    
    ggplot(south, aes(reorder(province, n), n)) +
      geom_col(fill = "#ad1d28") + 
      coord_flip() +
      labs(
        title = "Top 5 Southern Provinces (Retail)",
        x = "Province",
        y = "Number of Clients"
      ) +
      theme_minimal() +
      theme(
        # BIG BOLD BLACK TITLE
        plot.title = element_text(size = 22, face = "bold", color = "black", margin = margin(b = 15)),
        axis.text = element_text(size = 11),
        axis.title = element_text(size = 13, face = "bold"),
        plot.margin = margin(10, 10, 10, 10)
      )
  })
  
  # BOXPLOT
  output$boxplot <- renderPlot({
    # Aggregate data exactly like your Python script
    client_total <- data %>% 
      group_by(client_id, segment) %>% 
      summarise(gross_value_thb = sum(gross_value_thb, na.rm = TRUE), .groups = "drop")
    
    ggplot(client_total, aes(x = reorder(segment, gross_value_thb, FUN = median), y = gross_value_thb)) + 
      geom_boxplot(fill = "#5f7695", color = "#333333", outlier.colour = "#ad1d28", outlier.shape = 1) + 
      scale_y_log10(labels = scales::label_number(suffix = "M", scale = 1e-6)) +
      labs(
        title = "Client Trading Value by Segment (Outlier Detection)",
        x = "Segment",
        y = "Total Trading Value (Millions THB - Log Scale)"
      ) +
      theme_minimal(base_size = 14) +
      theme(
        # Big, Bold, Black Heading
        plot.title = element_text(size = 22, face = "bold", color = "black", margin = margin(b = 20)),
        axis.title = element_text(face = "bold"),
        axis.text = element_text(color = "black"),
        panel.grid.minor = element_blank()
      )
  })
  
  # COMMISSION REGION
  output$commissionRegion <- renderPlot({
    df <- trades %>% 
      left_join(clients, by = "client_id") %>% 
      mutate(month = floor_date(as.Date(trade_date), "month"))
    
    region_summary <- df %>% 
      group_by(month, region) %>% 
      summarise(comm = sum(commission_thb, na.rm = TRUE), .groups = "drop")
    
    ggplot(region_summary, aes(x = month, y = comm, color = region, group = region)) +
      geom_line(size = 1.2) +
      geom_point(size = 2) +
      scale_y_continuous(labels = scales::label_number(suffix = "M", scale = 1e-6)) + 
      labs(title = "Commission Trend by Region", x = "Month", y = "Commission (Millions)") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "bottom")
  })
}
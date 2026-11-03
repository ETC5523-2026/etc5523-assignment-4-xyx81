library(shiny)
library(bslib)

# Use the dataset distributed with the package.
scenarios <- dataexplorer::quarantine_scenarios

# Keep each R0 value the same colour across selections.
r0_colours <- setNames(
  grDevices::hcl.colors(10, palette = "Dark 3"),
  as.character(1:10)
)

ui <- page_sidebar(
  title = "Border quarantine scenario explorer",
  fillable = FALSE,
  
  sidebar = sidebar(
    checkboxGroupInput(
      "r0_values",
      "Choose reproduction numbers (R0)",
      choices = sort(unique(scenarios$r0)),
      selected = c(3, 6)
    ),
    sliderInput(
      "min_efficacy",
      "Minimum vaccine efficacy (%)",
      min = 0,
      max = 90,
      value = 50,
      step = 10
    ),
    helpText(
      "R0 is the average number of secondary infections caused",
      "by one infected person in a fully susceptible population.",
      "Higher R0 values represent greater viral transmissibility."
    ),
    helpText(
      "Select one or more R0 values to compare scenarios.",
      "Move the slider to show only scenarios at or above",
      "the selected minimum vaccine efficacy.",
      "For example, 70% shows the simulated values",
      "70%, 80% and 90%."
    )
  ),
  
  p(
    "For public health students exploring the published",
    "quarantine simulation scenarios of Zachreson et al. (2022)."
  ),
  p(
    "How does relative infection pressure change with",
    "viral transmissibility and vaccine efficacy?"
  ),

  card(
    card_header("Compare infection pressure across scenarios"),
    card_body(
      fillable = FALSE,
      p(
        "Compare vaccine efficacy on the horizontal axis",
        "and relative infection pressure on the vertical axis.",
        "Lower values indicate less infection pressure.",
        "The dashed reference line marks the baseline level of 1."
      ),
      textOutput("selection_summary"),
      plotOutput("pressure_plot", height = "400px")
    )
  ),
    
  card(
    card_header("Selected simulation scenarios"),
    p(
      "Relative pressure of 1 equals the baseline",
      "(R0 = 3, vaccine efficacy = 0%).",
      "This measure is not an outbreak probability."
    ),
    tableOutput("scenario_table")
  ),
  
  card(
    card_header("Model context, limitations and sources"),
    card_body(
      fillable = FALSE,
      p(
        "These scenarios describe a historical quarantine model",
        "with a minimum 14-day stay, scheduled testing and",
        "infection-control measures."
      ),
      p(
        "All travellers and workers in the model are vaccinated.",
        "Vaccine efficacy here represents reduced susceptibility",
        "to infection; breakthrough cases are assumed to remain",
        "equally infectious. It is not efficacy against severe disease",
        "and it is not community vaccination coverage."
      ),
      p(
        "Relative infection pressure is compared with the fixed",
        "baseline of R0 = 3 and vaccine efficacy = 0%.",
        "A value of 0.5 means half the baseline pressure;",
        "a value of 2 means twice the baseline pressure."
      ),
      p(
        "Results depend on the model assumptions and the available",
        "parameter grid. They are not observed outbreak probabilities",
        "or forecasts for current conditions. Connecting lines",
        "do not estimate results between simulated scenarios."
      ),
      p(
        "Article: ",
        a(
          "Zachreson et al. (2022)",
          href = "https://doi.org/10.1126/sciadv.abm3624"
        )
      ),
      p(
        "Data: ",
        a(
          "Zachreson et al., supplementary code and data (2021)",
          href = "https://doi.org/10.5281/zenodo.5802433"
        ),
        ". The Zenodo record specifies CC BY 4.0.",
        "Data preparation selects and renames three columns",
        "without changing their values."
      )
    )
  )
)

server <- function(input, output, session) {
  selected_scenarios <- reactive({
    dataexplorer::select_scenarios(
      data = scenarios,
      r0_values = as.numeric(input$r0_values),
      min_efficacy = input$min_efficacy / 100
    )
  })
  
  output$selection_summary <- renderText({
    selected <- selected_scenarios()
    
    if (nrow(selected) == 0) {
      return(NULL)
    }
    
    sprintf(
      paste(
        "Showing %d scenarios for R0 values %s,",
        "with vaccine efficacy from %.0f%% to %.0f%%.",
        "Relative infection pressure ranges from %.3f to %.3f.",
        "%d of these scenarios are at or below the fixed baseline of 1.",
        "This count describes selected model scenarios, not an outbreak probability."
      ),
      nrow(selected),
      paste(sort(unique(selected$r0)), collapse = ", "),
      min(selected$vaccine_efficacy) * 100,
      max(selected$vaccine_efficacy) * 100,
      min(selected$relative_pressure),
      max(selected$relative_pressure),
      sum(selected$relative_pressure <= 1)
    )
  })
  
  output$pressure_plot <- renderPlot({
    selected <- selected_scenarios()
    
    validate(
      need(
        nrow(selected) > 0,
        "No scenarios selected. Choose at least one R0 value."
      )
    )
    
    pressure_plot <- ggplot2::ggplot(
      selected,
      ggplot2::aes(
        x = vaccine_efficacy * 100,
        y = relative_pressure,
        colour = factor(r0),
        group = factor(r0)
      )
    ) +
      ggplot2::geom_hline(
        yintercept = 1,
        linetype = "dashed",
        colour = "grey45"
      )
    
    # Draw connecting lines only when multiple efficacy values remain.
    if (length(unique(selected$vaccine_efficacy)) > 1) {
      pressure_plot <- pressure_plot +
        ggplot2::geom_line(linewidth = 0.9)
    }
    
    pressure_plot +
      ggplot2::geom_point(size = 3) +
      ggplot2::scale_colour_manual(
        values = r0_colours
      ) +
      ggplot2::scale_x_continuous(
        breaks = seq(0, 90, by = 10)
      ) +
      ggplot2::expand_limits(y = 0) +
      ggplot2::labs(
        x = "Vaccine efficacy (%)",
        y = "Relative infection pressure",
        colour = "R0",
        caption = paste(
          "Source: Zachreson et al. (2022), published simulation data.",
          "Points show available scenarios; lines guide comparison.",
          sep = "\n"
        )
      ) +
      ggplot2::theme_minimal(base_size = 14) +
      ggplot2::theme(
        legend.position = "bottom",
        panel.grid.minor = ggplot2::element_blank(),
        plot.caption = ggplot2::element_text(hjust = 0)
      )
  })
  
  output$scenario_table <- renderTable({
    selected <- selected_scenarios()
    
    validate(
      need(
        nrow(selected) > 0,
        "No scenarios selected. Choose at least one R0 value."
      )
    )
    
    data.frame(
      "R0" = sprintf("%.0f", selected$r0),
      "Vaccine efficacy (%)" = sprintf(
        "%.0f",
        selected$vaccine_efficacy * 100
      ),
      "Relative infection pressure" = sprintf(
        "%.3f",
        selected$relative_pressure
      ),
      check.names = FALSE
    )
  }, align = "r")
}

shinyApp(ui, server)
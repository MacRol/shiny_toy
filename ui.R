library(shiny)

#
# Define UI for shiny application that illustrates that K-Means Clustering algorithm
# does not always converge to the same solution.
#

shinyUI(fluidPage(
  
  # Title
  titlePanel("Randomness of K-Means Clustering"),
  
  # Sidebar with a slider for the desired number of clusters
  # and a text input for the seed value
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("Num_K",
                  "Slide to Desired Number of Clusters: ",
                  min = 1,
                  max = 20,
                  value = 1),
      numericInput("seed_val",
                   "Change Seed Value of K-Means Centroid Initialisation: ",
                   value = 14741),
      submitButton()
      ),
    
    # Main panel with plot showing initial data in differently shaped points
    # and showing results of K-Means clustering in coloured circles around
    # the points
    mainPanel(
      h4("Watch Seed Value Impacting Clustering Results, Especially for Larger Values of K!"),
      plotOutput("clustPlot")
    )
  )
  
  ))

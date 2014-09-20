library(shiny)
library(MASS)

shinyServer(function(input, output) {
  
  #
  # Embed the entire logic within the renderPlot() call, in order to achieve
  # 2 things:
  # - A reactive effect: re-execute each time input changes
  # - Have a plot as the output
  #
  
  output$clustPlot <- renderPlot({
    
    #
    # Generate 5 centroids via uniform distributions in 2 dimensions
    #
    num_clust <- 5
    siz_clust <- 20
    set.seed(1)
    x <- runif(num_clust, min = 20, max = 100)
    y <- runif(num_clust, min = 20, max = 100)
  
    #
    # Generate points around these centroids, distributed as bivariate normal
    # Make the covariance matrix orthogonal, with standard deviation = 7 in each dim
    #
  
    pts_clust <- matrix(rep(0, 2 * num_clust * siz_clust), nrow = num_clust * siz_clust, ncol = 2 )
    means_vector <- cbind(x = x, y = y)
    sigma_matrix <- matrix(c(81, 0, 0, 81), nrow = 2, ncol = 2, byrow = TRUE)
    set.seed(121)
    for (i in 1:num_clust) {
      for (j in 1:siz_clust) {
        pts_clust[(i - 1) * siz_clust + j, ] <- mvrnorm(n = 1, mu = means_vector[i,], Sigma = sigma_matrix)
      
      }
    }
    
    #
    # Now plot the points, and use shape to mark origin
    #
    plot(pts_clust, type = "n", 
         main = "Actual Data: 5 Bivariate Normal Sets of 20 Points, Indicated by Inner Shape \nK-Means Clustering Results: Indicated by Outer Circle Colour",
         xlab = "First Dimension", ylab = "Second Dimension",
         xlim = c(0, 120), ylim = c(0, 120))
    
    for (i in 1: num_clust) {
      for (j in 1:siz_clust) {
        points(x = pts_clust[(i - 1) * siz_clust + j, 1], y = pts_clust[(i - 1) * siz_clust + j, 2], pch = i-1)
      }
    }
    
    #
    # Now perform cluster analysis
    # NOTE: for shiny application, make the value of seed and the value of K inputs,
    # by writing (in ui.R) slider inputs or value inputs for them, and by extracting
    # the proper subset of this script and turning into the function in server.R
    #
    seed_val <- input$seed_val
    set.seed(seed_val)
    Num_K <- input$Num_K
    km_obj <- kmeans(pts_clust, Num_K)
    
    #
    # Plot cluster assignment as circle with color to mark cluster assignment
    #
    points(pts_clust, col = km_obj$cluster, pch = 1, cex = 2)
  }, width = 600, height = 600)
})
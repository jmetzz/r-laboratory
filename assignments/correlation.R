
correlation <- function(directory, threshold = 0){
  ## directory: the path to the directory where the input files are located
  ## threshold: the number of completely observed observations required 
  ## to calculate the correlation between nitrate and sulfate
  ##
  ## Returns a numeric vector of correlations (not rounded)
  
  if(!exists("complete", mode="function")) source("complete.R")
  
  if (!dir.exists(directory)){
    print(paste("Directory '", directory, "' does not exist" ))
    return(NA)
  }

  data <- complete(directory)
  indexes <- data$count > threshold
  monitors <- data[indexes, ]$id
  
  corr <- numeric()
  for (monitor in monitors){
    filename <- paste(str_pad(monitor, 3, pad = "0"), "csv", sep = ".")
    data <- read.csv(paste(directory, filename, sep="/"))

    corr <- append(corr, cor(as.vector(data$sulfate), as.vector(data$nitrate), 
                             use = "complete.obs"))
    # If use is "complete.obs" then missing values are handled by casewise deletion 
    # (and if there are no complete cases, that gives an error)
  }
  corr
}
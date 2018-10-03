
require(stringr)

complete <- function(directory, id_vector = 1:332){
  ## directory: the path to the directory where the input files are located
  ## id_vector: an integer vector with monitor ID numbers to be used
  ##
  ## Returns a dataframe of the form
  ## id nobs
  ## 1  117
  ## 2  456
  ## ...
  ## where 'id' is the monitor ID and 'nobs' is the 
  ## number of complete cases
  
  if (!dir.exists(directory)){
    print(paste("Directory '", directory, "' does not exist" ))
    return(NA)
  }
  
  count <- numeric()
  for (monitor in id_vector){
    filename <- paste(str_pad(monitor, 3, pad = "0"), "csv", sep = ".")
    data <- read.csv(paste(directory, filename, sep="/"))
    values <- !is.na(data[, 2:3])
    logic_vec <- rep(FALSE, nrow(values))
    for (row in 1:nrow(values)) { 
      logic_vec[row] <- all(values[row,]) 
    }
    count <- append(count, sum(logic_vec))
  }
  data.frame(id=c(1:length(count)), count)
}
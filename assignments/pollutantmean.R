library(stringr)

pollutantmean <- function (directory, pollutant, id_vector = 1:332){
  ## directory: the path to the directory where the input files are located
  ## pollutant:  sulfate or nitrate
  ## id_vector: an integer vector with monitor ID numbers to be used
  ## Return: the mean of the pollutant across all monitors list, ignoring NA values

  if (!dir.exists(directory)){
    print(paste("Directory '", directory, "' does not exist" ))
    return(NA)
  }

  amount <- 0
  qtt <- 0
  for (monitor in id_vector){
    filename <- paste(str_pad(monitor, 3, pad = "0"), "csv", sep = ".")
    print(filename)
    data <- read.csv(paste(directory, filename, sep="/"))
    indexes <- !is.na(data[pollutant])
    relevant_data <- data[pollutant][indexes]
    amount <- amount + sum(relevant_data)
    qtt <- qtt + length(relevant_data)
  }
  amount / qtt
}
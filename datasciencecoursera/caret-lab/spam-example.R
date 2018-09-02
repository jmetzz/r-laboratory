library(caret)
library(kenlab)
data(spam)

inTrain <- createDataPartition(y=spam$type, p=0.75, list=FALSE)
training <- spam[inTrain,]
test <- spam[-inTrain,]
dim(training)
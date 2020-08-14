#Install necessary packages

install.packages("tensorflow")
install.packages("keras")
install.packages("tidyverse")

#Use necessary packages
library(tensorflow)
library(keras)
library(tidyverse)
library(ggplot2)




#Import desired dataset
fashion_mnist <- dataset_fashion_mnist()
fashion_mnist$train
c(train_images, train_labels) %<-% fashion_mnist$train
c(test_images, test_labels) %<-% fashion_mnist$test
class_names <- c(
  "T-shirt/Top",
  "Trouser",
  "Pullover",
  "Dress",
  "Coat",
  "Sandal",
  "Shirt",
  "Sneaker",
  "Bag",
  "AnkleBoot")





#Data Exploration
dim(train_images)
dim(test_images)
dim(train_labels)
dim(test_labels)
head(train_images)
head(test_images)
head(train_labels)
head(test_labels)




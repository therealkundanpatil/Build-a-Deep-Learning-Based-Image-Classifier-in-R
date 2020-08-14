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


#Data Preprocessing(Normalization)
train_images <- train_images / 255
test_images <- test_images / 255

image_1 <- as.data.frame(train_images[1, , ])
colnames(image_1) <- seq_len(ncol(image_1))
image_1$y <- seq_len(nrow(image_1))
image_1 <- gather(image_1, "x", "value" , -y) 
image_1$x <- as.integer(image_1$x)

ggplot( image_1 , aes( x = x, y = y, fill = value )) +
  geom_tile() +
  scale_fill_gradient( low = "white", high = "black", na.value = NA ) +
  scale_y_reverse() +
  theme_minimal() +
  theme(panel.grid = element_blank()) + 
  theme(aspect.ratio = 1) + 
  xlab("") + 
  ylab("")

par(mfcol = c( 5, 5 ))
par(mar = c( 0, 0, 1.5, 0), xaxs = "i", yaxs = "i")

for (i in 1:25){
  img <- train_images[i, ,]
  img <- t(apply(img, 2, rev))
  image( 1:28, 1:28, img, col = gray((0:255) / 255), xaxt = "n", yaxt = "n", main = paste(class_names[train_labels[i]+1]))
}
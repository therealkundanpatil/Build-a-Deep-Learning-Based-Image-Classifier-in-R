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
  image( 1:28, 
         1:28, 
         img, 
         col = gray((0:255) / 255), 
         xaxt = "n", 
         yaxt = "n", 
         main = paste(class_names[ train_labels[i] + 1 ])
        )
}




#Building model
model <- keras_model_sequential()
model %>% 
  layer_flatten(input_shape = c(28, 28)) %>%
  layer_dense(unit = 128, activation = "relu") %>%
  layer_dense(unit = 10, activation = "softmax")
summary(model)




#compile the model
model %>% compile(optimizer = "adam",
                  loss = "sparse_categorical_crossentropy",
                  metrics = c("accuracy"))




#Training and evaluating the model
model %>% fit( train_images, train_labels, epochs = 10, validation_split = 0.2)
score <- model %>% evaluate( test_images, test_labels)
cat("Test Loss: ", score["loss"], "\n")
cat("Test Accuracy: ", score["accuracy"],"\n")




#Prediction using model
predictions <- model %>% predict(test_images)
which.max(predictions[1,])

#Plot with predicted images
par(mfcol = c(5, 5))
par(mar = c(0, 0, 1.5, 0), xaxs = "i", yaxs = "i")
for (i in 1:25){
  img <- test_images[i, ,]
  img <- t(apply(img, 2, rev))
  
  predicted_labels <- which.max(predictions[i,]) -1
  true_labels <- test_labels[i]
  if(predicted_labels == true_labels){
    color = "#008800"
  }
  else{
    color = "#bb0000"
  }
  
  image(
    1:28 ,
    1:28 ,
    img ,
    col = gray((0:255) / 255),
    xaxt = "n",
    yaxt = "n",
    main = paste0(class_names[predicted_labels + 1], "(",
                  class_names[true_labels + 1], ")"),
    col.main = color
  )
}

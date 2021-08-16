library(keras)

#Cargar datos
mnist <- dataset_mnist()
#Se divide por 255 para "normalizar" los datos (que vivan entre 0 y 1)
mnist$train$x <- mnist$train$x / 255
mnist$test$x <- mnist$test$x / 255

#Define modelo secuencial con un sólo layer de 128 neuronas.
#Activación RELU
model <- keras_model_sequential() %>% 
  layer_flatten(input_shape = c(28, 28)) %>% 
  layer_dense(units = 128, activation = "relu") %>%
  layer_dropout(rate = 0.2) %>% 
  layer_dense(units = 10, activation = "softmax")

#Compilar usando optimizador ADAM el cuál es generalmente mejor
#Función de costo como Cross-Entropy para variable multi-categórica
model %>% 
  compile(
    optimizer = "adam",
    loss = "sparse_categorical_crossentropy",
    metrics = "accuracy"
  )

#Ajustar modelo
model %>% 
  fit(
    x = mnist$train$x, y = mnist$train$y,
    epochs = 5,
    validation_split = 0.3,
    verbose = 2
  )

# Evalua el modelo. Estoy feliz si está arriba de 0.97
model %>% 
  evaluate(mnist$test$x, mnist$test$y, verbose = 0)

#Guarda en escritorio
save_model_tf(model, "mnist-tf-model")

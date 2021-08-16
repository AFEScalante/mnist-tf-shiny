library(shiny)
library(keras)

# Carga el modelo
model <- load_model_tf("mnist-tf-model/")

# Define la UI ----
ui <- fluidPage(
  #  Definiendo el tema
  theme = bslib::bs_theme(
    bg = "#263f3f", 
    fg = "white", 
    base_font = font_google(family = "Open Sans")
  ),
  # Título de la app
  titlePanel("Reconocimiento de dígitos con TensorFlow en R"),
  sidebarLayout(
    sidebarPanel(
      # Input: Imágen en JPEG (sólo aceptará imágenes de 28x28 píxeles)
      fileInput("image_path", label = "Carga imagen JPEG")
    ),
    mainPanel(
      textOutput(outputId = "prediction"),
      plotOutput(outputId = "image")
    )
  )
)

# Server ----
server <- function(input, output) {
  
  image <- reactive({
    req(input$image_path)
    jpeg::readJPEG(input$image_path$datapath)
  })

  output$prediction <- renderText({
    
    img <- image() %>% 
      array_reshape(., dim = c(1, dim(.), 1))
    
    paste0("La predicción de digito es: ", predict_classes(model, img))
  })
  
  output$image <- renderPlot({
    plot(as.raster(image()))
  })
  
}

shinyApp(ui, server)
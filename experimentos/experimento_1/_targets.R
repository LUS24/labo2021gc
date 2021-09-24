# Archivo principal del experimento
if(!require(here)) install.packages("here")
library(here)

if(!require(targets)) install.packages("targets")
library(targets)

source(here("R", "functions.R"))

packages <- c("data.table",
              "visNetwork",
              "R.utils",     # Permite a data table leer archivos .gz de manera directa.
              "rlist",
              "yaml",
              "parallel",
              "randomForest",#solo se usa para imputar nulos
              "ranger",
              "DiceKriging", # Paquete para Bayesian optimization
              "mlrMBO"       # Paquete para Bayesian optimization
              )

tar_option_set(packages = packages)

list(
  # Configuración inicial
  tar_target(
    carpetas,
    c("datos_transformados", "logs", "kaggle", "informes")
  ),
  tar_target(
    crear_carpetas,
    crear_carpetas_de_experimento(carpetas)
  ),
  tar_target(
    path_datos_train,
    "../../data/originals/paquete_premium_202011.csv"
  ),
  tar_target(
    path_datos_test,
    "../../data/originals/paquete_premium_202101.csv"
  ),
  tar_target(
    path_datos_train_transformados,
    "./datos_transformados/paquete_premium_202011_02_ext.csv"
  ),
  tar_target(
    path_datos_test_transformados,
    "./datos_transformados/paquete_premium_202101_02_ext.csv"
  ),
  tar_target(
  # Cargar datos originales
    datos_train,
    fread(path_datos_train)
  ),
  tar_target(
    datos_test,
    fread(path_datos_test)
  ),
  # Transformar datos
  tar_target(
    ejecutar_feature_eng_train,
    EnriquecerDataset(datos_train, path_datos_train_transformados)    
  ),
  tar_target(
    ejecutar_feature_eng_test,
    EnriquecerDataset(datos_test, path_datos_test_transformados)    
  )
)

# tar_glimpse()
# tar_visnetwork()
# tar_make()
# tar_outdated()

# tar_progress()
# tar_meta()



# tar_read

# IMPORTAR DATOS ----------------------------------------------------------

ventas <- read.csv("Ventas Nexa/Datos/ventas_transformacion.csv",
                   stringsAsFactors = FALSE) # Considera las variables categóricas NO factores
library(readr)
ventas <- read_csv("C:/Users/maite/OneDrive - UPV/INTELIGENCIA DE NEGOCIOS 1/XAVI/Ventas Nexa/Datos/ventas_transformacion.csv")
#Si pone TRUE se  pasa a factores


# Leer Datos --------------------------------------------------------------

dim(ventas) # Las dimensiones
str(ventas) #Estructura de los datos
head(ventas) #Para ver si se han cargado correctamente


# Importar la libreria ----------------------------------------------------


library("dplyr")

ventas <- read.csv("Datos/ventas_transformacion.csv")
# Operador Pipe -----------------------------------------------------------


ventas_validas <- ventas |>
  filter(estado =="Completado") |>
  select(fecha, canal, producto, unidades, #PRIMERO DA ERROR PORQUE NO HEMOS IMPORTADO LIBRERIA
         precio_unitario, coste_unitario,
         descuento_pct)

# Filter y select ---------------------------------------------------------

ventas_2025 <- ventas |>
  filter( #filas
    fecha >="2025-01-01",
    fecha < "2026-01-01",
    estado != "Cancelado" #No es igual a cancelado
  ) |>
  select(fecha, region, canal, producto, unidades, precio_unitario, coste_unitario) #columnas


# Mutate ------------------------------------------------------------------

#Sirve para crear varias columnas nuevas

ventas <- ventas |>
  mutate(
    importe_bruto = unidades * precio_unitario,
    importe_neto = importe_bruto * (1 - descuento_pct/100),
    coste_total = unidades * coste_unitario,
    margen = importe_neto - coste_total
  )


# Condicional if_else -----------------------------------------------------

ventas <-ventas |>
  mutate(
    prioridad = if_else(
      margen >= 30,
      "Alta",
      "Revisar"
    )
  )


# Case_when  --------------------------------------------------------------

ventas <-ventas |>
  mutate(
    segmento_ticket = case_when(
      importe_neto >= 200 ~ "Alto",
      importe_neto >= 100 ~ "Medio",
      TRUE ~ "Bajo"
    )
  )
#Cuanto más retristivo al principio mejor porque será más eficiente<

# Arrenge - Ordenar -------------------------------------------------------

top_pedidos <- ventas |>
  arrange (desc (importe_neto)) |>
  select (pedido_id, canal, producto, importe_neto, margen)

# Agrupar y resumir -------------------------------------------------------

resumen_canal <- ventas |>
  filter(estado == "Completado") |>
  group_by(canal) |> #Agrupa los datos
  summarise (
    pedidos = n(),
    facturacion = sum(importe_neto),
    ticket_medio = mean(importe_neto),
    groups ="drop"
  )

#agrupamos por region y canal
resumen_region_canal <- ventas |>
  filter(estado == "Completado") |>
  group_by(region,canal) |> #Agrupa los datos
  summarise (
    pedidos = n(),
    facturacion = sum(importe_neto),
    mediana = median(importe_neto),
    groups ="drop"
  )

#PIVOTAR DATOS: LARGO Y ANCHO
library("tidyverse")

ventas_mes <- data.frame(
  producto = c("A", "B"),
  ventas_ene = c(120, 80),
  ventas_feb = c(145, 92)
)

tabla_larga <- data.frame(
  producto = c("A", "A", "B"),
  mes = c("ene", "feb", "ene"),
  ventas = c(120, 145, 80)
)

tabla_larga_completa <- data.frame(
  producto = c("A", "A", "B", "B"),
  mes = c("ene", "feb", "ene", "feb"),
  ventas = c(120, 145, 80, 92)
)

# 1. Convertimos la tabla ancha a formato largo
ventas_mes_largo <- ventas_mes |>
  pivot_longer(
    cols = starts_with("ventas_"),
    names_to = "mes",
    values_to = "ventas"
  )

# 2. Convertimos esa nueva tabla larga de vuelta a formato ancho
ventas_mes_ancho <- ventas_mes_largo |>
  pivot_wider(
    names_from = "mes",
    values_from = "ventas" 
  )

# COUNT: Cuando solo necesitamos el numero de observaciones por gr --------
ventas|>
  count(canal, estado,
        sort=TRUE,
        name="pedidos")

ventas|>
  count(canal, estado,
        sort=FALSE,
        name="pedidos")


# REVISAR TIPOS ANTES DE TRANSFORMAR --------------------------------------

glimpse(ventas)

class(ventas$fecha)
class(ventas$precio_unitario)
class(ventas$canal)

summary(ventas)


# LIMPIAR TEXTO -----------------------------------------------------------
#nos ayuda a filtrat datos correctamente
ventas<-ventas|>
  mutate(
    canal=str_trim(canal),
    canal=str_to_lower(canal),#convierte todo en minuscula
    canal=str_to_title(canal) #pone primera letra en mayuscula
  )


ventas_limpias<-ventas|>
  rename(cliente=cliente_id,
         importe_bruto=importe
         )|>
  distinct(pedido_id,keep_all=TRUE)  #eliminamos el dublicado


#VALORES AUSENTES
colSums(is.na(ventas))
#con is.na estamos identificando los valores faltantes

ventas|>
  filter(is.na(satisfaccion)|is.na(tiempo_entrega_dias))

#NA no significa cero-> puede significar que el valor no se resgistró, no se conoce o no aplica


# TRANSFORMAR VARIAS COLUMNAS ---------------------------------------------

#across() aplica la misma operación a una selección de variables. pasa de NA a 0
ventas<-ventas|>
  mutate(
    across(
      c(descuento_pct,coste_envio),
      ~coalesce(.x,0)
    )
  )


# CONVERTIR TEXTO EN NÚMEROS ----------------------------------------------

#no tenemos el data set, es solo un ejemplo
camiones<-camiones|>
  mutate(
    km=str_remove(km," km"),
    km= str_remove_all(km, "\\s"),
    km=as.numeric(km)
  )

---------------------------------------------------------------------------------
  

# LAS FECHAS DEBEN SER FECHAS ---------------------------------------------

ventas<- ventas|>
  mutate(
    fecha=as.Date(fecha,format="%Y-%m-%d")
    )
                  class(ventas$fecha)
                  

                  library(tidyverse)
                  
                  ventas_nexa<- tibble::tribble(
                    ~canal, ~region, ~importe_neto,
                    ~visitas, ~unidades,
                    "Online", "Norte", 80, 20, 1,
                    "Online", "Norte", 120, 35, 2,
                    "Online", "Sur", 95, 25, 1,
                    "Online", "Centro", 145, 44, 3,
                    "Online", "Sur", 110, 30, 2,
                    "Tienda", "Norte", 70, 18, 1,
                    "Tienda", "Centro", 90, 22, 1,
                    "Tienda", "Centro", 105, 25, 2,
                    "Tienda", "Sur", 260, 70, 3,
                    "Tienda", "Sur", 115, 28, 2
                  )                 
              

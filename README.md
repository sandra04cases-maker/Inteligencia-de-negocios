# El impacto de la IA en la productividad empresarial

Proyecto de la asignatura **Inteligencia de Negocios I** (UPV).

**Autoras:** Sandra Cases y Maite Sandoval

Analizamos si el número de departamentos que usan IA influye en la productividad de las empresas (valor añadido por empleado) y si ese efecto depende del tamaño de la empresa.

## Contenido

```
├── RMarkdown_proyecto_7.Rmd   # Informe con todo el código
└── README.md
```

## Requisitos

- R y RStudio
- LaTeX con `xelatex` (por ejemplo, TinyTeX: `tinytex::install_tinytex()`)

Paquetes de R:

```r
install.packages(c("readxl", "tidyverse", "clickR", "mice", "gridExtra",
                   "ggthemes", "lmtest", "ggeffects", "MASS", "knitr", "rmarkdown"))
```

| Paquete | Uso |
|---|---|
| `readxl` | Lectura de los Excel |
| `tidyverse` | Manipulación de datos y gráficos |
| `clickR` | Limpieza (`fix_NA`) y descriptivos |
| `mice` | Imputación múltiple |
| `gridExtra` | Combinación de gráficos |
| `ggthemes` | Temas de gráficos |
| `lmtest` | Test de Breusch-Pagan |
| `ggeffects` | Predicciones del modelo |
| `MASS` | Regresión robusta (`rlm`) |
| `knitr`, `rmarkdown` | Generación del PDF |

## Datos

Los datos son privados y **no se incluyen en el repositorio**. Para reproducir el análisis, coloca estos archivos en una carpeta `Datos 26-27/` junto al `.Rmd`:

- `indicadores_ia_web_2023.xlsx`
- `indicadores_ia_web_2025.xlsx`
- `informacion_financiera.xlsx`
- `muestra_empresarial_sabi.xlsx`

## Ejecución

1. Abre `RMarkdown_proyecto_7.Rmd` en RStudio.
2. Pulsa **Knit → Knit to PDF**, o ejecuta `rmarkdown::render("RMarkdown_proyecto_7.Rmd")`.

Los procesos aleatorios (imputación y test chi-cuadrado) usan `set.seed(123)`, por lo que los resultados son reproducibles.

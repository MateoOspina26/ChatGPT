#Mateo Tareas Puce
## Análisis de edad e ingreso

El script `wage_age_analysis.R` carga la base `salarios_edad.csv` empleando rutas robustas con el paquete **here**.
Realiza las gráficas con **ggplot2**, ajusta un modelo lineal y otro cuadrático,
y calcula apalancamiento y residuos estandarizados.

El archivo `spline_wage_age.R` aplica splines suavizados sobre la misma data.
Explora distintos valores del parámetro de suavizado (lambda) y distintos grados
 de libertad usando `smooth.spline`. Se escogen los mejores modelos por
criterio de validación cruzada y se visualizan ambos ajustes con **ggplot2**.

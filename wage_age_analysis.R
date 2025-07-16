# Analisis no lineal de edad e ingreso por hora

# Cargar librerias
library(readr)
library(ggplot2)

# ruta robusta al archivo
# cambia "salarios_edad.csv" si el nombre del archivo es diferente
df <- read_csv(here::here("salarios_edad.csv"))

# Vista preliminar
head(df)

# Correlacion age-wage
correlacion <- cor(df$age, df$wage, use = "complete.obs")
cat("La correlacion entre edad e ingreso por hora es:", round(correlacion,3),"\n")

# Diagrama de dispersion
p1 <- ggplot(df, aes(age, wage)) +
  geom_point(alpha = 0.5) +
  labs(title = "Relacion entre Edad y Salario por Hora",
       x = "Edad", y = "Ingreso por hora")
print(p1)

# Modelo lineal y residuos estandarizados
modelo <- lm(wage ~ age, data = df)
residuos_std <- rstandard(modelo)

ggplot(data.frame(age = df$age, resid = residuos_std), aes(age, resid)) +
  geom_point(alpha = 0.5, colour = "red") +
  geom_hline(yintercept = c(-2,0,2), linetype = "dashed",
             colour = c("red","black","red")) +
  labs(title = "Residuos estandarizados del modelo lineal",
       x = "Edad", y = "Residuos estandarizados")

# Resumen del modelo lineal
print(summary(modelo))

# Analisis de apalancamiento
apalancamiento <- hatvalues(modelo)

n <- nrow(df)
p <- 2
umbral <- 2 * p / n

df_bajo_apalancamiento <- df[apalancamiento < umbral,]

cat("Umbral de apalancamiento:", round(umbral,5),"\n")
cat("Observaciones con bajo apalancamiento:", nrow(df_bajo_apalancamiento),
    "de", n, "\n")
head(df_bajo_apalancamiento)

# Modelo no lineal con termino cuadratico
modelo_quad <- lm(wage ~ age + I(age^2), data = df)
print(summary(modelo_quad))


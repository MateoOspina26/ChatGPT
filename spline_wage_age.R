# Modelo spline suavizado para relacion edad-ingreso

# Cargar librerias
library(readr)
library(ggplot2)

# Ruta robusta al archivo
# Cambia "salarios_edad.csv" si el nombre es diferente

ruta <- here::here("salarios_edad.csv")
df <- read_csv(ruta)

# --------------------------
# Buscar mejor modelo por lambda (spar)
# --------------------------
lambdas <- seq(0, 1, length.out = 6)
fits_lambda <- lapply(lambdas, function(l) {
  smooth.spline(df$age, df$wage, spar = l, cv = TRUE)
})
cv_lambda <- sapply(fits_lambda, function(f) f$cv.crit)
best_lambda <- lambdas[which.min(cv_lambda)]
best_fit_lambda <- fits_lambda[[which.min(cv_lambda)]]

# --------------------------
# Buscar mejor modelo por grados de libertad
# --------------------------
dfs <- 3:8
fits_df <- lapply(dfs, function(d) {
  smooth.spline(df$age, df$wage, df = d, cv = TRUE)
})
cv_df <- sapply(fits_df, function(f) f$cv.crit)
best_df <- dfs[which.min(cv_df)]
best_fit_df <- fits_df[[which.min(cv_df)]]

cat("Mejor lambda:", round(best_lambda, 3), "CV:", round(min(cv_lambda), 3), "\n")
cat("Mejor grados de libertad:", best_df, "CV:", round(min(cv_df), 3), "\n")

# --------------------------
# Visualizacion de los ajustes
# --------------------------
age_grid <- seq(min(df$age), max(df$age), length.out = 100)

pred_lambda <- predict(best_fit_lambda, age_grid)
pred_df <- predict(best_fit_df, age_grid)

plot_data <- rbind(
  data.frame(age = age_grid, wage = pred_lambda$y, modelo = "Lambda"),
  data.frame(age = age_grid, wage = pred_df$y, modelo = "GradosLibertad")
)

ggplot(df, aes(age, wage)) +
  geom_point(alpha = 0.4) +
  geom_line(data = plot_data, aes(age, wage, colour = modelo,
                                  linetype = modelo)) +
  labs(title = "Modelos Spline suavizados", x = "Edad",
       y = "Ingreso por hora")

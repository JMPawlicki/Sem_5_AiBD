library(dplyr)
library(devtools)
library(ggplot2)

# Wektory

# Cwiczenie 1
cat("Cwiczenie 1 \n")
cat("\n")
wektor <- c(5, 10, 15, 20, 25) # wektor liczb
cat(wektor, "\n")

cat(wektor[wektor > 15], "\n")      # Liczby większe od 15

sum <- 0                        # Suma
for (i in 1:length(wektor)) {
  sum <- sum + wektor[i]
}
average <- sum/length(wektor)   # Średnia

# Alternative, average <- mean(wektor)

cat(average, "\n")

sum <- 0                      # Suma pierwszych 3
for (i in 1:3) {
    sum <- sum + wektor[i]
}
cat(sum, "\n")
cat("\n")

# Struktury sterujące

# Cwiczenie 2
cat("Cwiczenie 2 \n")
cat("\n")

# Lista wynikow egzaminu
wyniki <- c(75, 48, 90, 60, 30)

for (n in wyniki){
    if (n >= 60){
        cat(n, "- Zaliczone! \n")
    }
    else {
       cat(n, "- Niezaliczone :( \n")
    }
}

# Data Frame

# Cwiczenie 3
cat("Cwiczenie 3 \n")
cat("\n")

df <- data.frame(                   # Data frame 1
  Imię = c("Jan", "Ola", "Ela"),
  Wiek = c(25, 30, 28),
  Punkty = c("85", "92", "78")
)
print(df)
cat("\n")

ocena <- c("4+", "5", "4")          # Dodanie kolumny Ocena
df2 <- data.frame(df, Ocena = ocena)
print(df2)
cat("\n")

filtered_df <- df2 %>%              # Filtracja
    filter(Wiek < 30)
    print(filtered_df)

cat("\n")

# Wizualizacja danych

#Cwiczenie 4

dane <- data.frame(
    Przedmiot = c("Analiza i Bazy Danych", "Metody numeryczne", "Eksploracja danych"),
    Średnia = c(71, 67, 89)
)

wykres_slupkowy <- ggplot(dane, aes(x = Przedmiot, y = Średnia)) +
    geom_bar(stat = "identity", fill = "lightgreen") +
    labs(title = "Średnie z przedmiotów dla rocznika 2022",
        x = "Przedmiot",
        y = "Średnia ocen")
#print(wykres_slupkowy)

# Zadanie domowe
cat("Zadanie domowe \n")
cat("\n")
# Test 1 Wyniki testów Matematyki dla Grupy A i Grupy B
#wyniki_grupa_A <- c(60, 65, 75, 68, 62)
#wyniki_grupa_B <- c(78, 80, 85, 92, 88)

# Test 2 Wyniki testów Matematyki dla Grupy A i Grupy B
wyniki_grupa_A <- c(80, 65, 75, 68, 72)
wyniki_grupa_B <- c(78, 80, 85, 92, 88)

avg_A = mean(wyniki_grupa_A)
avg_B = mean(wyniki_grupa_B)

grupy <- c("Grupa A", "Grupa B")
średnie <- c(avg_A, avg_B)

if (avg_A < 70){
    grupy <- c("Grupa B")
    średnie <- c(avg_B)
    cat("    Grupa A ma zbyt niską średnią by się pokazywać")
}

dane <- data.frame(Grupy = grupy, Średnie = średnie)

wykres <- ggplot(dane, aes(x = Grupy, y = Średnie)) +
    geom_bar(stat = "identity", fill = "lightgreen") +
    labs(title = "Średnia wyników",
        x = "Grupa",
        y = "Średnia ocen")
print(wykres)





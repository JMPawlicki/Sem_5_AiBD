# NIE EDYTOWAĆ *****************************************************************
dsn_database = "wbauer_adb_2023"   # Specify the name of  Database
dsn_hostname = "pgsql-196447.vipserv.org"  # Specify host name 
dsn_port = "5432"                # Specify your port number. 
dsn_uid = "wbauer_adb"         # Specify your username. 
dsn_pwd = "adb2020"        # Specify your password.

library(DBI)
library(RPostgres)
library(testthat)

con <- dbConnect(Postgres(), dbname = dsn_database, host=dsn_hostname, port=dsn_port, user=dsn_uid, password=dsn_pwd) 
# ******************************************************************************

film_in_category<- function(category_id)
{
  # Funkcja zwracająca wynik zapytania do bazy o tytuł filmu, język, oraz kategorię dla zadanego id kategorii.
  # Przykład wynikowej tabeli:
  # |   |title          |language    |category|
  # |0	|Amadeus Holy	|English	|Action|
  # 
  # Tabela wynikowa ma być posortowana po tylule filmu i języku.
  # 
  # Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL
  # 
  # Parameters:
  # category_id (integer): wartość id kategorii dla którego wykonujemy zapytanie
  # 
  # Returns:
  # DataFrame: DataFrame zawierający wyniki zapytania
  # 
  if (!is.integer(category_id) | category_id <= 0){return(NULL)}
   query <- paste("SELECT f.title, l.name AS language, c.name AS category
                  FROM film f
                  JOIN film_category fc ON f.film_id = fc.film_id
                  JOIN category c ON fc.category_id = c.category_id
                  JOIN language l ON f.language_id = l.language_id
                  WHERE c.category_id = $1")

  df <- dbGetQuery(con, query, params = list(category_id))
  return(df)
}


number_films_in_category <- function(category_id){
  #   Funkcja zwracająca wynik zapytania do bazy o ilość filmów w zadanej kategori przez id kategorii.
  #     Przykład wynikowej tabeli:
  #     |   |category   |count|
  #     |0	|Action 	|64	  | 
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     category_id (integer): wartość id kategorii dla którego wykonujemy zapytanie
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (!is.integer(category_id) | category_id <= 0){return(NULL)}
  query <- paste("SELECT c.name AS category, COUNT(f.title) AS count
            FROM film f
            INNER JOIN film_category fc ON fc.film_id = f.film_id AND fc.category_id = $1
            INNER JOIN category c ON fc.category_id = c.category_id
            GROUP BY c.name")
  df <- dbGetQuery(con, query, params = list(category_id))
  return(df)
}

number_film_by_length <- function(min_length, max_length){
  #   Funkcja zwracająca wynik zapytania do bazy o ilość filmów dla poszczegulnych długości pomiędzy wartościami min_length a max_length.
  #     Przykład wynikowej tabeli:
  #     |   |length     |count|
  #     |0	|46 	    |64	  | 
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     min_length (int,double): wartość minimalnej długości filmu
  #     max_length (int,double): wartość maksymalnej długości filmu
  #     
  #     Returns:
  #     pd.DataFrame: DataFrame zawierający wyniki zapytania
  if (min_length < 0 || max_length < 0 || !is.numeric(min_length) || !is.numeric(max_length)) {return(NULL)}
  query <- paste("SELECT film.length, COUNT(*) AS count
                 FROM film
                 WHERE film.length >= $1
                 AND film.length <= $2
                 GROUP BY film.length")
  df <- dbGetQuery(con, query, params = list(min_length, max_length))
  if (is.null(df) || nrow(df) == 0) {return(NULL)}
  return(df) 
}



client_from_city<- function(city){
  #   Funkcja zwracająca wynik zapytania do bazy o listę klientów z zadanego miasta przez wartość city.
  #     Przykład wynikowej tabeli:
  #     |   |city	    |first_name	|last_name
  #     |0	|Athenai	|Linda	    |Williams
  #     
  #     Tabela wynikowa ma być posortowana po nazwisku i imieniu klienta.
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     city (character): nazwa miaste dla którego mamy sporządzić listę klientów
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (!is.character(city)){return(NULL)}
  query <- paste("SELECT ci.city, c.first_name, c.last_name
              FROM customer c
              JOIN address a ON c.address_id = a.address_id
              JOIN city ci ON a.city_id = ci.city_id
              WHERE ci.city = $1")
                        
  df <- dbGetQuery(con, query, params = list(city))
  return(df)
}

avg_amount_by_length<-function(length){
  #   Funkcja zwracająca wynik zapytania do bazy o średnią wartość wypożyczenia filmów dla zadanej długości length.
  #     Przykład wynikowej tabeli:
  #     |   |length |avg
  #     |0	|48	    |4.295389
  #     
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     length (integer,double): długość filmu dla którego mamy pożyczyć średnią wartość wypożyczonych filmów
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (!is.numeric(length)){return(NULL)}
  query <- paste("SELECT f.length AS length, AVG(p.amount) AS avg
            FROM film f
            JOIN inventory i ON f.film_id = i.film_id
            JOIN rental r ON i.inventory_id = r.inventory_id
            JOIN payment p ON r.rental_id = p.rental_id
            WHERE f.length = $1
            GROUP BY f.length
            ORDER BY f.length")
  df <- dbGetQuery(con, query, params = list(length))
  return(df)
}


client_by_sum_length<-function(sum_min){
  #   Funkcja zwracająca wynik zapytania do bazy o sumaryczny czas wypożyczonych filmów przez klientów powyżej zadanej wartości .
  #     Przykład wynikowej tabeli:
  #     |   |first_name |last_name  |sum
  #     |0  |Brian	    |Wyman  	|1265
  #     
  #     Tabela wynikowa powinna być posortowane według sumy, imienia i nazwiska klienta.
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     sum_min (integer,double): minimalna wartość sumy długości wypożyczonych filmów którą musi spełniać klient
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania
  if (!is.numeric(sum_min) | sum_min <= 0){return(NULL)}
  query <- paste("SELECT c.first_name, c.last_name, 
                  SUM(f.length) sum
                  FROM customer c
                  JOIN rental r ON c.customer_id = r.customer_id
                  JOIN inventory i ON r.inventory_id = i.inventory_id
                  JOIN film f ON i.film_id = f.film_id
                  GROUP BY c.first_name, c.last_name
                  HAVING SUM(f.length) > $1
                  ORDER BY sum, c.last_name, c.first_name")
  df <- dbGetQuery(con, query, params = list(sum_min))
  return(df)
}


category_statistic_length<-function(name){
  #   Funkcja zwracająca wynik zapytania do bazy o statystykę długości filmów w kategorii o zadanej nazwie.
  #     Przykład wynikowej tabeli:
  #     |   |category   |avg    |sum    |min    |max
  #     |0	|Action 	|111.60 |7143   |47 	|185
  #     
  #     Jeżeli warunki wejściowe nie są spełnione to funkcja powinna zwracać wartość NULL.
  #         
  #     Parameters:
  #     name (character): Nazwa kategorii dla której ma zostać wypisana statystyka
  #     
  #     Returns:
  #     DataFrame: DataFrame zawierający wyniki zapytania

  if (!is.character(name)){return(NULL)}
  query <- paste("SELECT c.name AS category,
                    AVG(f.length) AS avg,
                    SUM(f.length) AS sum,
                    MIN(f.length) AS min,
                    MAX(f.length) AS max
                    FROM film f
                    INNER JOIN film_category fc ON f.film_id = fc.film_id
                    INNER JOIN category c ON fc.category_id = c.category_id
                    WHERE c.name = $1
                    GROUP BY c.name
                    ORDER BY c.name")
    
    # Wykonanie zapytania i zapisanie wyników do ramki danych
    df <- dbGetQuery(con, query, params = list(name))
  return(df)
}

# NIE EDYTOWAĆ *****************************************************************
test_dir('tests/testthat')
# ******************************************************************************
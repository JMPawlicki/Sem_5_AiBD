library(DBI)
library(RPostgres)

dsn_database <- "wbauer_adb_2023"
dsn_hostname <- "pgsql-196447.vipserv.org"
dsn_port <- "5432"
dsn_uid <- "wbauer_adb"
dsn_pwd <- "adb2020"

con <- dbConnect(Postgres(),
                 dbname = dsn_database,
                 host = dsn_hostname,
                 port = dsn_port,
                 user = dsn_uid,
                 password = dsn_pwd)

# 1. Ile kategorii filmów mamy w wypożyczalni?

cat("# 1")
cat("\n")

df1 <- dbGetQuery(con, "SELECT name FROM category")

cat("Ilość filmów w wypożyczalni:", nrow(df1), "\n")
cat("\n")

# 2. Wyświetl listę kategorii w kolejności alfabetycznej.

cat("# 2")
cat("\n")

df2 <- dbGetQuery(con, "SELECT name FROM category ORDER BY name ASC")

print(df2)
cat("\n")

# 3. Znajdź najstarszy i najmłodszy film do wypożyczenia.

cat("# 3")
cat("\n")

df3 <- dbGetQuery(con, "SELECT MIN(release_year) AS najstarszy,
                MAX(release_year) AS najmlodszy FROM film")

cat("Najstarszy film:", df3$najstarszy, "\n")
cat("Najmłodszy film:", df3$najmlodszy, "\n")
cat("\n")

# 4. Ile wypożyczeń odbyło się między 2005-07-01 a 2005-08-01?

cat("# 4")
cat("\n")

df4 <- dbGetQuery(con, "SELECT rental_date FROM rental
                    WHERE rental_date BETWEEN '2005-07-01' AND '2005-08-01'")

cat("Ilość wypożyczeń między 2005-07-01 a 2005-08-01:", nrow(df4), "\n")
cat("\n")

# 5. Ile wypożyczeń odbyło się między 2010-01-01 a 2011-02-01?

cat("# 5")
cat("\n")

df5 <- dbGetQuery(con, "SELECT rental_date FROM rental
                    WHERE rental_date BETWEEN '2010-01-01' AND '2011-02-01'")

cat("Ilość wypożyczeń między 2010-01-01 a 2011-02-01:", nrow(df5), "\n")
cat("\n")

# 6. Znajdź największą płatność wypożyczenia.

cat("# 6")
cat("\n")

df6 <- dbGetQuery(con, "SELECT MAX(amount) AS najwiecej FROM payment")

cat("Największa płatność:", max(df6), "\n")
cat("\n")

# 7. Znajdź wszystkich klientów z Polski, Nigerii lub Bangladeszu.

cat("# 7")
cat("\n")

df7 <- dbGetQuery(con, "SELECT * FROM customer WHERE address_id IN 
                        (SELECT address_id FROM address WHERE city_id IN 
                        (SELECT city_id FROM city WHERE country_id IN 
                        (SELECT country_id FROM country WHERE country IN 
                        ('Poland', 'Nigeria', 'Bangladesh'))))")

cat("Klienci z Polski, Nigerii lub Bangladeszu:\n")
print(df7)
cat("\n")

# 8. Gdzie mieszkają członkowie personelu?

cat("# 8")
cat("\n")

df8 <- dbGetQuery(con, "SELECT first_name, last_name, 
                        (SELECT address FROM address WHERE 
                        address_id = staff.address_id) AS address FROM staff")

cat("Adresy członków personelu:\n")
print(df8)
cat("\n")

# 9. Ilu pracowników mieszka w Argentynie lub Hiszpanii?

cat("# 9")
cat("\n")

df9 <- dbGetQuery(con, "SELECT * FROM staff WHERE address_id IN 
                        (SELECT address_id FROM address WHERE city_id IN 
                        (SELECT city_id FROM city WHERE country_id IN 
                        (SELECT country_id FROM country WHERE country IN 
                        ('Argentina', 'Spain'))))")

cat("Ilość pracowników w Argentynie lub Hiszpanii:", nrow(df9), "\n")
cat("\n")

# 10. Jakie kategorie filmów zostały wypożyczone przez klientów?

cat("# 10")
cat("\n")

df10 <- dbGetQuery(con, "SELECT DISTINCT category.name FROM 
                        category, film_category, inventory, rental, customer
                        WHERE category.category_id = film_category.category_id
                        AND film_category.category_id = inventory.film_id
                        AND inventory.inventory_id = rental.inventory_id
                        AND rental.customer_id = customer.customer_id")

cat("Kategorie filmów wypożyczanych przez klientów:", "\n")
print(df10)
cat("\n")

# 11. Znajdź wszystkie kategorie filmów wypożyczonych w Ameryce.

cat("# 11")
cat("\n")

df11 <- dbGetQuery(con, "SELECT DISTINCT category.name FROM 
                        category, film_category, inventory, rental,
                        customer, address, city, country
                        WHERE category.category_id = film_category.category_id
                        AND film_category.category_id = inventory.film_id
                        AND inventory.inventory_id = rental.inventory_id
                        AND rental.customer_id = customer.customer_id
                        AND customer.address_id = address.address_id
                        AND address.city_id = city.city_id
                        AND city.country_id = country.country_id
                        AND country.country = 'United States'")

cat("Kategorie filmów wypożyczanych w Ameryce:", "\n")
print(df11)
cat("\n")

# 12. Znajdź wszystkie tytuły filmów, w których grał: Olympia Pfeiffer lub Julia Zellweger lub Ellen Presley

cat("# 12")
cat("\n")

df12 <- dbGetQuery(con, "SELECT DISTINCT film.title FROM 
                        film, film_actor, actor
                        WHERE film.film_id = film_actor.film_id
                        AND film_actor.actor_id = actor.actor_id

                        AND (actor.first_name = 'Olympia' 
                        AND actor.last_name = 'Pfeiffer')

                        OR (actor.first_name = 'Julia' 
                        AND actor.last_name = 'Zellweger')

                        OR (actor.first_name = 'Ellen' 
                        AND actor.last_name = 'Presley')")

cat("Tytuły filmów, w których grał: Olympia Pfeiffer
lub Julia Zellweger lub Ellen Presley:", "\n")
print(df12)
cat("\n")
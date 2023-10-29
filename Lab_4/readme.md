[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/rL7g7-Pq)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12582467&assignment_repo_type=AssignmentRepo)
# Łączenie tabel i podzapytania

## Przykładowe tabele obrazujące łączenie

Do zobrazowania operacji łączenia zostaną użyte tabele:

``` sql
CREATE TABLE shape_a ( id INT PRIMARY KEY, shape VARCHAR (100) NOT NULL);

CREATE TABLE shape_b ( id INT PRIMARY KEY, shape VARCHAR (100) NOT NULL);
```

Polecenie CREATE TABLE tworzy tabelę o zadanej nazwie i strukturze. Ogólna postać to:

``` sql
CREATE TABLE tab_name ( col_name1 data_type constrain, col_name1
data_type constrain, ... );
```

Należy uzupełnić ją danymi:

``` sql
INSERT INTO shape_a (id, shape) VALUES (1, 'Trójkąt'), (2, 'Kwadrat'), (3, 'Deltoid'), (4, 'Traper');

INSERT INTO shape_b (id, shape) VALUES (1, 'Kwadrat'), (2, 'Trójkąt'), (3, 'Romb'), (4, 'Równoległobok');
```

Komenda INSERT INTO pozwala na dodanie do tabeli rekordów. Ogólna postać to:

``` sql
INSERT INTO tab_name (col1_name, col2_name2, ...) VALUES (val1_col1,
val2_col2), (val2_col1, val2_col2), ...
```

## Inner join

Jest to podstawowy rodzaj złączenie. Ten sposób złączenia wybiera te wiersze, dla których warunek złączenia jest spełniony. W żadnej z łączonych tabel kolumna użyta do łączenia nie może mieć wartości NULL.

#### Przykład:

``` sql
SELECT a.id id_a, a.shape shape_a, b.id id_b, b.shape shape_b 
FROM shape_a a INNER JOIN shape_b b ON a.shape = b.shape;
```

W zapytaniu powyżej użyto *aliasów* nazw tabel i column wynikowych, jest to szczególnie przydatne przy długich nazwach tabel i wprowadza czytelność w zapytaniu.

#### Wynik:

| id_a | shape_a | id_b | shape_b |
|------|---------|------|---------|
| 1    | Trójkąt | 2    | Trójkąt |
| 2    | Kwadrat | 1    | Kwadrat |

## OUTER JOIN

Istnieją trzy rodzaje złączeń OUTER: - LEFT OUTER JOIN, - RIGHT OUTER JOIN, - FULL OUTER JOIN.

### LEFT OUTER JOIN

Ten rodzaj złączenie zwróci wszystkie rekordy z lewej tablicy i dopasuje do nich rekordy z prawej tablicy które spełniją zadany warunek złączenia. Jeżeli w prawej tablicy nie występują rekordy spełnijące warunek złączenia z lewą w ich miejscu pojawią się wartości NULL.

#### Przykład 1:

``` sql
SELECT a.id id_a, a.shape shape_a, b.id id_b, b.shape shape_b 
FROM shape_a a LEFT JOIN shape_b b ON a.shape = b.shape;
```

#### Wynik:

| id_a | shape_a | id_b | shape_b |
|------|---------|------|---------|
| 1    | Trójkąt | 2    | Trójkąt |
| 2    | Kwadrat | 1    | Kwadrat |
| 3    | Deltoid | NULL | NULL    |
| 4    | Traper  | NULL | NULL    |

#### Przykład 2:

``` sql
SELECT b.id id_b, b.shape shape_b, a.id id_a, a.shape shape_a
FROM shape_b b LEFT JOIN shape_a a ON a.shape = b.shape;
```

#### Wynik:

| id_a | shape_a       | id_b | shape_b |
|------|---------------|------|---------|
| 1    | Kwadrat       | 2    | Kwadrat |
| 2    | Trójkąt       | 1    | Trójkąt |
| 3    | Romb          | NULL | NULL    |
| 4    | Równoległobok | NULL | NULL    |

### RIGHT OUTER JOIN

Działa jak left outer join z tym, że prawa tablica w zapytaniu jest brana w całości.

#### Przykład:

``` sql
SELECT a.id id_a, a.shape shape_a, b.id id_b, b.shape shape_b 
FROM shape_a a RIGHT JOIN shape_b b ON a.shape = b.shape;
```

#### Wynik:

| id_a | shape_a | id_b | shape_b       |
|------|---------|------|---------------|
| 2    | Kwadrat | 1    | Kwadrat       |
| 1    | Trójkąt | 2    | Trójkąt       |
| NULL | NULL    | 3    | Romb          |
| NULL | NULL    | 4    | Równoległobok |

### FULL OUTER JOIN

Jest złączeniem które zwraca: - wiersze dla których warunek złączenia jest spełniony, - wiersze z lewej tabeli dla których nie ma odpowiedników w prawej, - wiersze z prawej tabeli dla których nie ma odpowiedników w lewej.

#### Przykład:

``` sql
SELECT a.id id_a, a.shape shape_a, b.id id_b, b.shape shape_b 
FROM shape_a a FULL JOIN shape_b b ON a.shape = b.shape;
```

| id_a | shape_a  | id_b | shape_b       |
|------|----------|------|---------------|
| 1    | Trójkąt  | 2    | Trójkąt       |
| 2    | Kwadrat  | 1    | Kwadrat       |
| 3    | Deltoid" | NULL | NULL          |
| 4    | Traper   | NULL | NULL          |
| NULL | NULL     | 3    | Romb          |
| NULL | NULL     | 4    | Równoległobok |

## Podzapytania

Podzapytanie zagnieżdżone SELECT znajduje się wewnątrz zewnętrznego zapytania SELECT, np. po klauzuli WHERE, HAVING lub FROM. W przypadku tego rodzaju zapytań w pierwszej kolejności wykonywane są wewnętrzne zapytania SELECT, a ich wynik jest wykorzystywany do zewnętrznego zapytania SELECT. Stąd łatwo zuważyć, że mogą one służyć do poprawy wydajności obsługi zapytania. Należy dobierać podzapytania tak by najbardziej zagnieżdżone podzapytanie zawierało najmniejszy zbiór poszukiwań.

#### Przykład:

Jeżeli chcemy znaleźć w bazie informację o tytułach filmów zwróconych w zadanym okresie możemy wykonać następujące zapytanie:

``` sql
SELECT film_id, title FROM film 
WHERE film_id IN ( 
  SELECT inventory.film_id 
  FROM rental INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id 
  WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30' 
);
```

#### Wynik

| film_id | title             |
|---------|-------------------|
| 307     | Fellowship Autumn |
| 255     | Driving Polish    |
| 388     | Gunfight Moon     |
| 130     | Celebrity Horn    |
| 563     | Massacre Usual    |
| 397     | Hanky October     |
| ...     | ...               |

### Używanie podzapytań

Pod zapytania mogą być używane w : - SELECT, - UPDATE, - DELETE, - Funkcjach agregujących, - Do definiowania tabel tymczasowych.

Używając podzapytań zapytania SQL szybko mogą stać się mało czytelne. Przez co będą trudne w zrozumieniu i późniejszym utrzymaniu. W celu analizy zapytań można użyć klauzuli **EXPLAIN**, która przeanalizuje zapytanie. Klauzula ta może służyć również do porównywania wydajności zapytań

#### Przykład:

``` sql
EXPLAIN SELECT \* FROM film
```

## Funkcje agregujące

Funkcje agregujące wykonują obliczenia na zestawie wierszy i zwracają pojedynczy wiersz. PostgreSQL udostępnia wszystkie standardowe funkcje agregujące SQL w następujący sposób: - AVG () - zwraca średnią wartość. - COUNT () - zwraca liczbę wartości. - MAX () - zwraca maksymalną wartość. - MIN () - zwraca minimalną wartość. - SUM () - zwraca sumę wszystkich lub różnych wartości.

Pełna lista funkcji agregującej: <https://www.postgresql.org/docs/9.5/functions-aggregate.html>

Często używamy funkcji agregujących z klauzulą GROUP BY w instrukcji SELECT. W tych przypadkach klauzula GROUP BY dzieli zestaw wyników na grupy wierszy i funkcja agregująca wykonuje obliczenia dla każdej grupy, np. maksimum, minimum, średnia itp. Funkcji agregujących można używać funkcji agregujących jako wyrażeń tylko w następujących klauzulach: SELECT i HAVING.

### GROUP BY

Klauzula GROUP BY dzieli wiersze zwrócone z instrukcji SELECT na grupy. Dla każdej grupy można zastosować funkcję agregującą, np. SUM aby obliczyć sumę pozycji lub COUNT aby uzyskać liczbę elementów w grupach.

Poniższa instrukcja ilustruje składnię klauzuli GROUP BY:

``` sql
SELECT column_1, aggregate_function(column_2) FROM tbl_name GROUP BY
column_1;
```

Klauzula GROUP BY musi pojawić się zaraz po klauzuli FROM lub WHERE, n0astępnie GROUP BY zawiera listę kolumna oddzielonych przecinkami.

### HAVING

Często używamy klauzuli HAVING w połączeniu z klauzulą GROUP BY do filtrowania wierszy grup które nie spełniają określonego warunku.


Poniższa instrukcja ilustruje typową składnię klauzuli HAVING:

``` sql
SELECT
column_1, aggregate_function (column_2) 
FROM tbl_name GROUP BY column_1
HAVING condition; 
```

Klauzula HAVING ustawia warunek dla wierszy grup utworzonych przez klauzulę GROUP BY po Klauzula GROUP BY ma zastosowanie, podczas gdy klauzula WHERE określa wcześniej warunki dla poszczególnych wierszy.

## Testy jednostkowe

To laboratorium zostanie ocenione za pomocą testów jednostkowych wykonanych za pomocą bliblioteki [*testthat*](https://testthat.r-lib.org/). Aby możliwe było ich uruchomienie należy zainstalować następujące pakiety:

``` r
install.packages(c("devtools", "testthat", "knitr"))
```

**UWAGA**: Testy są skonstuowane tak by uruchamiały się za każdym razem gdy uruchamia się skrypt *main.R*. Z tego powodu nie można w nim edytować lini kodu które znajdują się pomiędzy znacznikami:

```r
# NIE EDYTOWAĆ *****************************************************************
...
#*******************************************************************************
```

Dodatkowo w obszarza zabronionym do edycji znajduje się połączenie do bazy danych które możńa używać w funkcjach do wykonania. Zabronine jest również przeprowadzanie zmian w katalogu **tests** i wszystkich podkatalogach.

## Zadania:

Przygotuj implementację funkcji z pliku **main.R** i odpowiedź na pytania:

1.  Znajdź listę wszystkich filmów o tej samej długości.
2.  Znajdź wszystkich klientów mieszkających w tym samym mieście.
3.  Oblicz średni koszt wypożyczenia wszystkich filmów.
4.  Oblicz i wyświetl liczbę filmów we wszystkich kategoriach.
5.  Wyświetl liczbę wszystkich klientów pogrupowanych według kraju.
6.  Wyświetl informacje o sklepie, który ma więcej niż 100 klientów i mniej niż 300 klientów.
7.  Wybierz wszystkich klientów, którzy oglądali filmy ponad 200 godzin.
8.  Oblicz średnią wartość wypożyczenia filmu.
9.  Oblicz średnią wartość długości filmu we wszystkich kategoriach.
10. Znajdź najdłuższe tytuły filmowe we wszystkich kategoriach.
11. Znajdź najdłuższy film we wszystkich kategoriach. Porównaj wynik z pkt 10.

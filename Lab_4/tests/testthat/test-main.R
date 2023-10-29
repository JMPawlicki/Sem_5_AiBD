load("expected")

result_film_in_category = expected$film_in_category 

result_number_films_in_category = expected$number_films_in_category 

result_number_film_by_length = expected$number_film_by_length  

result_client_from_city = expected$client_from_city  

result_avg_amount_by_length = expected$avg_amount_by_length  

result_client_by_sum_length = expected$client_by_sum_length 

result_category_statistic_length = expected$category_statistic_length 


# Define a test
test_that("Test for film_in_category",{
  for (i in result_film_in_category){
    result <- film_in_category(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)

test_that("Test for number_films_in_category",{
  for (i in result_number_films_in_category){
    result <- number_films_in_category(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)
 
test_that("Test for number_film_by_length",{
  for (i in result_number_film_by_length){
    result <- number_film_by_length(i[[1]],i[[2]])
    expect_identical(result, i[[length(i)]])
  }
}
)
 
test_that("Test for client_from_city",{
  for (i in result_client_from_city){
    result <- client_from_city(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)
 
test_that("Test for avg_amount_by_length",{
  for (i in result_avg_amount_by_length){
    result <- avg_amount_by_length(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)

test_that("Test for client_by_sum_length",{
  for (i in result_client_by_sum_length){
    result <- client_by_sum_length(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)

test_that("Test for category_statistic_length",{
  for (i in result_category_statistic_length){
    result <- category_statistic_length(i[[1]])
    expect_identical(result, i[[-1]])
  }
}
)
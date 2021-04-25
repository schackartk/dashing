source('../src/helpers.R')

test_that("as_dollar() works", {
  expect_equal("$17.59", as_dollar("17.59"))
  expect_equal("$17.59", as_dollar(17.59))
})
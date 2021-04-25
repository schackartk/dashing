source('../src/helpers.R')

test_that('as_dollar() works', {
  expect_equal('$17.59', as_dollar("17.59"))
  expect_equal('$17.59', as_dollar(17.59))
})

test_that('as_hour() works', {
  expect_equal(3.5, as_hour('3:30'))
  expect_equal(0.5, as_hour('0:30'))
  expect_equal(1.5, as_hour('0:90'))
})
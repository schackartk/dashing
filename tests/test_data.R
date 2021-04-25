source('../src/config.R')
source('../src/helpers.R')

test_that('data file is where expected', {
  expect_equal(TRUE, file.exists(data_paths['excel_file']))
})

test_that('df_dashes imports cleanly', {
  df <- read_excel(path = data_paths['excel_file'],
                   sheet = data_paths['dashes'])
  expect_equal(9, ncol(df))
  
  df_col_names <- c('date', 'time_in', 'time_out',
                    'odo_in', 'odo_out', 'earnings',
                    'active_time', 'dash_time', 'deliveries')
  expect_equal(df_col_names, colnames(df))
})

test_that('df_deliveries imports cleanly', {
  df <- read_excel(path = data_paths['excel_file'],
                   sheet = data_paths['deliveries'])
  expect_equal(5, ncol(df))
  
  df_col_names <- c('date', 'base_pay', 'peak_pay',
                    'tip', 'place')
  expect_equal(df_col_names, colnames(df))
})
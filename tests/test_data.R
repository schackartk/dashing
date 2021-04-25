source('../src/config.R')
source('../src/helpers.R')

test_that('df_dashes imports cleanly', {
  df_dashes <- read_excel(path = data_paths['excel_file'],
                          sheet = data_paths['dashes'])
  expect_equal(9, ncol(df_dashes))
  
  df_col_names <- c('date', 'time_in', 'time_out',
                    'odo_in', 'odo_out', 'earnings',
                    'active_time', 'dash_time', 'deliveries')
  expect_equal(df_col_names, colnames(df_dashes))
})
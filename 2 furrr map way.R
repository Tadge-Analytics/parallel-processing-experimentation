

# the set up

###################################################################
###################################################################


# preferably start each of these processes with a clean environment

# specify the file path

xlsx_file_path <- "diamonds.xlsx"

###################################################################

# create the file if we don't already have it

if (!file.exists(xlsx_file_path)) {openxlsx::write.xlsx(ggplot2::diamonds, xlsx_file_path, asTable = T)}

###################################################################

# specify some function to test out

the_process_to_use <- function(file_path) {
  
  # file_path <- "diamonds.xlsx"
  
  read_excel(xlsx_file_path, progress = FALSE) %>% 
    nrow()
  
}



# the test

###################################################################
###################################################################

tictoc::tic()

library(tidyverse)
library(furrr) 


# this also loads the future package

all_cores <- parallelly::availableCores()
future::plan(multisession, workers = all_cores)


how_many_files <- 100



process_result <-
  tibble(row_id = 1:how_many_files, file_path = xlsx_file_path) %>% 
  mutate(imported_data = future_map(file_path, ~.x %>% the_process_to_use(), .progress = TRUE))


tictoc::toc()



















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

run_with_progress_bar <- TRUE
# run_with_progress_bar <- FALSE



if (!run_with_progress_bar) {
  
  
  tictoc::tic()
  
  
  library(tidyverse)
  library(doFuture)
  library(readxl) # we need to load this package so that the foreach otherwise "read_excel()" within the foreach won't be found
  
  
  doFuture::registerDoFuture()
  plan(multisession)
  
  
  how_many_files <- 100
  
  
  result_of_foreach <- 
    foreach(file_id=1:how_many_files) %dopar% {
      
      
      xlsx_file_path %>% 
        the_process_to_use()
      
    }
  
  
  
  process_result <- 
    result_of_foreach %>% 
    enframe()
  
  
  tictoc::toc()
  
  
}


###################################################################



if (run_with_progress_bar) {
  
  
  tictoc::tic()
  
  
  library(tidyverse)
  library(doFuture)
  library(readxl) # we need to load this package so that the foreach otherwise "read_excel()" within the foreach won't be found
  library(progressr)
  
  progressr::handlers(global = TRUE)
  
  doFuture::registerDoFuture()
  plan(multisession)
  

  
  how_many_files <- 100
  
  
  my_fcn <- function(how_many_files) {
    
    p <- progressor(along = 1:how_many_files)
    
    foreach(x = 1:how_many_files) %dopar% {
      
      x %>% 
        the_process_to_use()
      
      p(sprintf("x=%g", x))
      
    }
  }
  
  
  result_of_foreach <- my_fcn(how_many_files)
  
  
  process_result <- 
    result_of_foreach %>% 
    enframe()
  
  
  
  
  tictoc::toc()
  
  
}






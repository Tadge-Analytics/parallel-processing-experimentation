

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
library(doSNOW)
library(doParallel)



# all_cores <- parallel::detectCores(logical = FALSE)
all_cores <- parallel::detectCores()
cl <- parallel::makePSOCKcluster(all_cores)
doSNOW::registerDoSNOW(cl)


how_many_files <- 100


progress_bar <- txtProgressBar(max = how_many_files, style = 3)
progress <- function(n) setTxtProgressBar(progress_bar, n)

required_packages <- c("tidyverse", "readxl")



result_of_foreach <- 
  foreach(file_id=1:how_many_files, .options.snow = list(progress = progress), .packages = required_packages) %dopar% {
    
    
    xlsx_file_path %>% 
      the_process_to_use()
    
    
  }


process_result <- 
  result_of_foreach %>% 
  enframe()


stopCluster(cl)
close(progress_bar)




tictoc::toc()

















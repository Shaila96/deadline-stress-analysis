#-------------------------#
#--------LIBRARIES--------#
#-------------------------#
# library(XLConnect)
# library(scales)
# library(ggplot2)
# library(dplyr)
# library(readr)
# 
# require(xlsx)
# library(readxl)
# library(lubridate)







#-------------------------#
#-----GLOBAL VARIABLES----#
#-------------------------#
script_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
source(file.path(script_dir, 'us-common-functions.R'))
source(file.path(script_dir, 'us-filter-pp.R'))
source(file.path(script_dir, 'us-down-sample-pp.R'))


current_dir <- dirname(script_dir)
setwd(current_dir)

log.file <- file.path(log_dir, paste0('curation-log-', format(Sys.Date(), format='%m-%d-%y'), '.txt'))
file.create(log.file)





#-------------------------#
#---FUNCTION DEFINITION---#
#-------------------------#
curate_baseline_data <- function(subj_name, day_serial, session_name) {
  session_dir <- file.path(raw_data_dir, grp_dir, subj_name, day_serial, session_name)
}

curate_working_session_data <- function(subj_name, day_serial, session_name) {
  session_dir <- file.path(raw_data_dir, grp_dir, subj_name, day_serial, session_name)
}



curate_session_data <- function(subj_name, day_serial, session_name) {
  if (session_name==session_list[1]) { ## Baseline
    curate_baseline_data(subj_name, day_serial, session_name)
  } else { ## WorkingSession
    curate_working_session_data(subj_name, day_serial, session_name)
  }
}

curate_day_data <- function(subj_name, day_serial) {
  day_dir <- file.path(raw_data_dir, grp_dir, subj_name, day_serial)
  sapply(session_list, function(session_name) {
    
    tryCatch({
      curate_session_data(subj_name, day_serial, session_name)
      
      write(paste0(subj_name, '-', day_serial, '-', session_name, ': SUCCESSFUL'), file=log.file, append=TRUE)
      message(paste0(subj_name, '-', day_serial, '-', session_name, ': SUCCESSFUL'))
    },
    error=function(cond) {
      write('----------------------------------------------------------', file=log.file, append=TRUE)
      write(paste0(subj_name, '-', day_serial, '-', session_name, ': ERROR!'), file=log.file, append=TRUE)
      write(paste0(cond, '\n'), file=log.file, append=TRUE)
      
      message('----------------------------------------------------------')
      message(paste0(subj_name, '-', day_serial, '-', session_name, ': ERROR!'))
      message(paste0(cond, '\n'))
    })
  })
}



curate_data <- function() {
  # subj_list <- get_dir_list(file.path(raw_data_dir, grp_dir))
  subj_list <- read.csv(file.path(curated_data_dir, utility_data_dir, subj_list_file_name))$Subject
  
  sapply(subj_list, function(subj_name) {
    # sapply(subj_list[1], function(subj_name) {
    
    subj_dir <- file.path(raw_data_dir, grp_dir, subj_name)
    day_list <- get_dir_list(subj_dir)
    
    sapply(day_list, function(day_serial) {
      curate_day_data(subj_name, day_serial)
    })
  })
}






#-------------------------#
#-------Main Program------#
#-------------------------#
curate_data()





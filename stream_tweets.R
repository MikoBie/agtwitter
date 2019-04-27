#!/usr/bin/Rscript --vanilla

cat('\nLoad libraries')
list.of.packages <- c("rtweet",
                      "tidyverse",
                      "magrittr",
                      "dplyr",
                      "openssl",
                      "stringr",
                      "jsonlite")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE)

stream_to_json <- function(words, con){
  tryCatch(
    stream_tweets(q = words,
                  timeout = 60 * 9,
                  parse = TRUE) %>%
      filter(lang == "pl") %>%
      stream_out(x = .,
                 con = con,
                 pagesize = 1),
    error = function(e){
      print(e)
    },
    warning = function(w){
      print(w)
    }
  )
}

cat('\nSet variables')
ROOT_PATH <- getwd()
DATA_PATH <- file.path(ROOT_PATH,"data")
TIME <- Sys.time() %>%
  str_replace_all(pattern = "-",
                  replacement = "_") %>%
  str_replace_all(pattern = " ",
                  replacement = "_") %>%
  str_replace_all(pattern = ":",
                  replacement = "_")
FILE_NAME <- paste0("stream",TIME,".jl")

con_out <- file(file.path(DATA_PATH,FILE_NAME), open="wb")
while (readLines("control.txt") == "CONTINUE"){
  WORDS <- read.csv2("words.csv") %$%
    word %>%
    as.character() %>%
    paste(collapse = ", ")
  stream_to_json(words = WORDS,
                 con = con_out)
  if (file.info(file.path(DATA_PATH,FILE_NAME))$size > 100000000) {
    close(con_out)
    gc()
    TIME <- Sys.time() %>%
      str_replace_all(pattern = "-",
                      replacement = "_") %>%
      str_replace_all(pattern = " ",
                      replacement = "_") %>%
      str_replace_all(pattern = ":",
                      replacement = "_")
    FILE_NAME <- paste0("stream",TIME,".jl")
    con_out <- file(file.path(DATA_PATH,FILE_NAME), open="wb")
  }
}
close(con_out)

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

cat('\nSet variables')
ROOT_PATH <- getwd()
DATA_PATH <- file.path(ROOT_PATH,"data")
FILE_NAME <- "stream2.jl"

con_out <- file(file.path(DATA_PATH,FILE_NAME), open="wb")
while (readLines("control.txt") == "CONTINUE"){
  WORDS <- read.csv2("words.csv") %$%
    word %>%
    as.character() %>%
    paste(collapse = ", ")
  stream_tweets(q = WORDS,
                timeout = 60*9,
                parse = TRUE) %>%
    filter(lang == "pl") %>%
    stream_out(x = .,
               con = con_out,
               pagesize = 1)
}
close(con_out)

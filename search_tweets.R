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
WORDS <- c("kler",
           "KLER",
           "ksiądz",
           "księża",
           "ks.",
           "ks",
           "biskup",
           "arcybiskup",
           "smarzewski",
           "Smarzewski",
           "smarzowski",
           "Smarzowski",
           "gajos",
           "Gajos",
           "Wienckiewicz",
           "wienckiewicz",
           "Wieckiewicz",
           "Wieckiewicz",
           "wieckiewicz",
           "więckiewicz",
           "Jakubik",
           "jakubik",
           "Jakubiak",
           "jakubiak",
           "Braciak",
           "braciak",
           "kulig",
           "Kulig",
           "kulik",
           "Kulik",
           "kościół",
           "kosciol",
           "ksiadz",
           "ksieza",
           "pedofilia",
           "pedofil") %>%
  paste(collapse = " OR ")

con_out <- file(file.path(DATA_PATH,"kler.jl"), open="wb")

cat('\nStart downloading')
twitter <- search_tweets2(q = WORDS,
                          n = 18000,
                          lang = "pl",
                          max_id = NULL)

twitter %>% 
  stream_out(con = con_out,
             pagesize = 1)

Sys.sleep(60 * 15)

while((twitter %>% nrow() > 0) == TRUE){
  id <- min(twitter$status_id)

  twitter <- search_tweets2(q = WORDS,
                            n = 18000,
                            lang = "pl",
                            max_id = id)

  twitter %>%
    stream_out(con = con_out,
               pagesize = 1)
  Sys.sleep(60 * 15)
}

close(con_out)

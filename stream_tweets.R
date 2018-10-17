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
  paste(collapse = ", ")

con_out <- file(file.path(DATA_PATH,"stream.jl"), open="wb")
while (readLines("control.txt") == "CONTINUE"){
  stream_tweets(q = WORDS,
                timeout = 60 * 15,
                parse = TRUE) %>%
    filter(lang == "pl") %>%
    stream_out(x = .,
               con = con_out,
               pagesize = 1)
}
close(con_out)

#!/usr/bin/Rscript --vanilla

cat('\nLoad libraries')
list.of.packages <- c("rtweet",
                      "tidyverse",
                      "magrittr",
                      "jsonlite",
                      "stringr")



new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
lapply(list.of.packages, require, character.only = TRUE)

cat('\nType in the name of the file and hit enter:')

file_name <- file.info(dir()) %>%
  mutate(name = rownames(.)) %>%
  arrange(desc(size)) %>%
  slice(1) %>%
  filter(str_detect(name,".json")) %$%
  name

file_name_out <- file_name %>%
  str_remove("-") %>%
  str_split("(?<=([:lower:]{6}\\d{4}))") %>%
  unlist() %>%
  paste(collapse = "_") %>%
  str_split("(?<=([_]\\d{2}))") %>%
  unlist() %>%
  paste(collapse = "_") %>%
  str_split("(?<=([_]\\d{2}))") %>%
  unlist() %>%
  paste(collapse = "_") %>%
  str_split("(?<=([_]\\d{2}))") %>%
  unlist() %>%
  paste(collapse = "_") %>%
  str_split("(?<=([_]\\d{2}))") %>%
  unlist() %>%
  paste(collapse = "_") %>%
  str_replace_all("[_]{2,}", "_") %>%
  str_replace("json", "jl")
  
  
cat('/nLoad data')
parse_stream(file_name) %>%
  filter(lang %in% c("pl","es")) %>%
  stream_out(file(file_name_out))


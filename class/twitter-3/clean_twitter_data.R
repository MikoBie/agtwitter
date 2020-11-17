## Function to clean the data. It returns status id, created_at, text, user_id, favourite_count
## retweet_count, hashtags, is_retweet, is_quote
library(rtweet) 
library(dplyr) 
library(magrittr)
library(tidytext) 
library(stringr)
library(DataCombine)
library(reshape2)
library(tidyr)

data("emojis")

emojis <- emojis %>%
  mutate(code=iconv(code,from="latin1",to="ascii",sub="byte")) %>%
  mutate(description=paste0(" ",description," ")) 

clean_twitter_data <- function(data){
    data %>%
    select(text,created_at,screen_name,status_id,favorite_count,retweet_count,hashtags,is_retweet,is_quote) %>%
    ## Transform coding from one format to another #seeingIsBelieving
    mutate(text=iconv(text,from="latin1",to="ascii",sub="byte")) %>%
    ## Crucial transformation, which kept me awake one fun night. Transform dataset from one format to another. Without it the next function doesn't work
    as.data.frame() %>%
    ## Replace emojis with their descriptions. It takes a while and might return some warnings, but you can igonre them.
    FindReplace(Var = "text",
                replaceData = emojis,
                from = "code", to = "description",
                exact = FALSE) %>%
    ## Getting rid of emojis which we were not able to match with description
    mutate(text=str_replace_all(string=text,
                                replacement="",
                                pattern="(<[:alnum:]{2}>)")) %>%
    ## In each row in text column look for phrase containing link and replace it with nothing
    mutate(text=str_replace_all(string=text,
                                pattern="http[[:alnum:][:punct:]]*",
                                replacement = ""))
}
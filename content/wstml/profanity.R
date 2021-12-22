# Replace censored words by uncensored words (we will do the censoring
# ourselves later)
tidy_lyrics %>% 
  left_join(profanity_df, by = c("word" = "censored")) %>% 
  rev() %>% 
  mutate(word = ifelse(is.na(uncensored), word, uncensored)) %>% 
  select(-uncensored)

# Check there are no pre-censored words left (takes ~ 20 seconds)
tidy_lyrics %>% 
  left_join(profanity_df, by = c("word" = "censored")) %>% 
  rev() %>% 
  mutate(word = ifelse(is.na(uncensored), word, uncensored)) %>% 
  select(-uncensored) %>% 
  filter(str_detect(word, "_")) %>% 
  pull(word) %>% 
  unique()

profanity_df <- readr::read_rds("data/profanity_df.rds")

# Load in profanity from lexicon
library(lexicon)
pr_data <- objects("package:lexicon") %>% 
  keep(~str_detect(.x, "profanity")) %>% 
  map(~data(list = .x))

pr_vec <- c(profanity_alvarez, profanity_arr_bad, profanity_banned, 
  profanity_racist, profanity_zac_anger, profanity_df$uncensored) %>% 
  unique()

message(length(pr_vec), " distinct profanities.")

# Create a lookup table of censored and uncensored words
pr_starred <- tibble::tibble("uncensored" = pr_vec) %>%
  mutate("censored" = str_replace_all(uncensored, "[aeiou, @]", "*"))

pr_starred %>% slice_sample(n = 20)

# Check all the originally censored words (using _'s) are now 
# censored with *'s
profanity_df %>% 
  select(-censored) %>% 
  left_join(pr_starred, by = "uncensored") %>% 
  filter(is.na(censored))

tidy_lyrics %>% 
  left_join(pr_starred, by = c("word" = "censored")) %>% 
  mutate(word = ifelse(is.na(uncensored), word, uncensored)) %>% 
  select(-uncensored)






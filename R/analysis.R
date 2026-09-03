# From Topics to Toxicity
# Extracted from the submitted knitted HTML report.
# Original code preserved, including file paths and known errors; see README.


# ---- Source block 1 ----
getwd()

# ---- Source block 2 ----
setwd("/Users/julianadam/Downloads/AndrewTateStaff")

# ---- Source block 3 ----
# Load relevant packages
library(jsonlite)
library(tidyverse)

# Read the file line by line. Change the extension of the file to txt first.
lines <- readLines("~/downloads/AndrewTateStaff/01HPSF09FAHXNTTDEKWQ7XPCMQ.txt")

# Parse each line into a list of data frames
parsed_data <- lapply(lines, function(line) {
  fromJSON(line) # Parse JSON array into a data frame
})

# Get all unique column names from the parsed data
all_columns <- unique(unlist(lapply(parsed_data, colnames)))

# Standardizing the columns in each data frame
standardized_data <- lapply(parsed_data, function(df) {
  missing_cols <- setdiff(all_columns, colnames(df))
  df[missing_cols] <- NA
  df <- df[all_columns]
  return(df)
})

# Combining here the standardized data frames using bind_rows
df <- bind_rows(standardized_data)

# ---- Source block 4 ----
# Identify columns that are lists
list_cols <- sapply(df, is.list)
print(list_cols)

# ---- Source block 5 ----
# Luckily for us, all of these columns only contain irrelevant data to our analysis, so we can simply leave them out.
sdf <- select(df, '_id', nonce, channel, author, sort_id, content, timestamp, edited)

# Convert timestamp to human-readable format
sdf$timestamp <- as.POSIXct(as.numeric(df$timestamp) / 1000, origin = "1970-01-01")

# Write the file in the working directory.
write.csv(sdf, "output_file.csv", row.names = FALSE)

# Testing if file is saved correctly
testcsv <- read.csv('output_file.csv')

# ---- Source block 6 ----
# Load necessary libraries
library(jsonlite)
library(data.table)

# List all CSV files
csv_files <- list.files(path = "~/downloads/AndrewTateStaff/Health & Fitness", pattern = "*.csv", full.names = TRUE)

# Read and combine CSV files
csv_combined <- rbindlist(lapply(csv_files, fread), fill = TRUE)

# Save the combined CSV to a new file 
fwrite(csv_combined, "combined_csv_output.csv")

# ---- Source block 7 ----
# Load libraries
library(stm)
library(quanteda)
library(magrittr)
library(wordcloud)
library(tidyverse)
library(tidytext)
library(tidymodels)
library(textrecipes)

# Load CSV data
csv_data_fitness <- read.csv("~/downloads/AndrewTateStaff/Health and Fitness Groupchat.csv", stringsAsFactors = FALSE)
fitness_data2 <- slice_sample(csv_data_fitness, prop = .22) # slices the dataset to leave about ~100.000 observations

# Create a corpus and model
processed <- textProcessor(fitness_data2$content, metadata = fitness_data2) # Prepares the fitness_data2 for modeling, by removing punctuation, stopwords and numbers. Words are additionally stemmed to reduce them to their root form

# ---- Source block 8 ----
out <- prepDocuments(processed$documents, processed$vocab, processed$meta) # Further prepares processed text for modeling by aligning the vocabulary and documents 

# ---- Source block 9 ----
docs <- out$documents # Extracts processed documents for use in STM model 
vocab <- out$vocab # Extracts vocabulary for use in STM model 
meta <- out$meta # Extracts metadata for use in STM model 

m <- stm(documents = out$documents, vocab = out$vocab, K = 8,  max.em.its = 500, data = out$meta) # Creates model, specifying 8 topics to discover, and setting a max number of iterations to 500

# ---- Source block 10 ----
# Inspecting model results
plot(m, type="summary", labeltype = "frex") # Displays a summary of the topics, showing the most representative words for each; uses FREX scores for labelling, in order to account for terms that are both frequent and exclusive to a topic 

# ---- Source block 11 ----
labelTopics(m, topic=8) # Displays the most representative words for a specified topic

# ---- Source block 12 ----
# Visualizing model results 
cloud(m, topic=7) # Creates a word cloud for a specified topic 

# ---- Source block 13 ----
plot(m, type="perspectives", topics=c(7,8)) # Compares two topics to highlight differences in their associated words 

# ---- Source block 14 ----
corr = topicCorr(m) # Computes the correlation between topics in the model
plot(corr)

# ---- Source block 15 ----
# Load CSV data
csv_data_main <- read.csv("~/downloads/AndrewTateStaff/Main Groupchat.csv", stringsAsFactors = FALSE)
main_data2 <- slice_sample(csv_data_main, prop = .1) # slices the dataset to leave about ~50.000 observations

# Creating a corpus and model
processed <- textProcessor(main_data2$content, metadata = main_data2) # Prepares the fitness_data2 for modeling, by removing punctuation, stopwords and numbers. Words are additionally stemmed to reduce them to their root form

# ---- Source block 16 ----
out <- prepDocuments(processed$documents, processed$vocab, processed$meta) # Further prepares processed text for modeling by aligning the vocabulary and documents

# ---- Source block 17 ----
docs <- out$documents # Extracts processed documents for use in STM model 
vocab <- out$vocab # Extracts vocabulary for use in STM model 
meta <- out$meta # Extracts metadata for use in STM model 

m2 <- stm(documents = out$documents, vocab = out$vocab, K = 8,  max.em.its = 500, data = out$meta) # Creates model, specifying 8 topics to discover, and setting a max number of iterations to 500

# ---- Source block 18 ----
# Inspecting model results
plot(m2, type="summary", labeltype = "frex") # Displays a summary of the topics, showing the most representative words for each; uses FREX scores for labelling, in order to account for terms that are both frequent and exclusive to a topic 

# ---- Source block 19 ----
labelTopics(m2, topic=3) # Displays the most representative words for a specified topic

# ---- Source block 20 ----
# Visualizing model results 
cloud(m2, topic=8) # Creates a word cloud for a specified topic 

# ---- Source block 21 ----
plot(m2, type="perspectives", topics=c(7,8)) # Compares two topics to highlight differences in their associated words

# ---- Source block 22 ----
corr2 = topicCorr(m2) # Computes the correlation between topics in the model
plot(corr2)

# ---- Source block 23 ----
# Load CSV data
csv_data_admin <- read.csv("~/downloads/AndrewTateStaff/Admin Groupchat.csv", stringsAsFactors = FALSE)
admin_data2 <- slice_sample(csv_data_main, prop = .1) # slices the dataset to leave about ~50.000 observations

# Creating a corpus and model
processed <- textProcessor(admin_data2$content, metadata = admin_data2) # Prepares the fitness_data2 for modeling, by removing punctuation, stopwords and numbers. Words are additionally stemmed to reduce them to their root form

# ---- Source block 24 ----
out <- prepDocuments(processed$documents, processed$vocab, processed$meta) # Further prepares processed text for modeling by aligning the vocabulary and documents

# ---- Source block 25 ----
docs <- out$documents # Extracts processed documents for use in STM model 
vocab <- out$vocab # Extracts vocabulary for use in STM model 
meta <- out$meta # Extracts metadata for use in STM model 

m3 <- stm(documents = out$documents, vocab = out$vocab, K = 8,  max.em.its = 500) # Creates model, specifying 8 topics to discover, and setting a max number of iterations to 500

# ---- Source block 26 ----
# Inspecting model results
plot(m3, type="summary", labeltype = "frex") # Displays a summary of the topics, showing the most representative words for each; uses FREX scores for labelling, in order to account for terms that are both frequent and exclusive to a topic 

# ---- Source block 27 ----
labelTopics(m3, topic=8) # Displays the most representative words for a specified topic

# ---- Source block 28 ----
# Visualizing model results 
cloud(m3, topic=8) # Creates a word cloud for a specified topic 

# ---- Source block 29 ----
plot(m3, type="perspectives", topics=c(7,8)) # Compares two topics to highlight differences in their associated words

# ---- Source block 30 ----
corr3 = topicCorr(m3) # Computes the correlation between topics in the model
plot(corr2)

# ---- Source block 31 ----
# Load additional libraries required for the LLM classification step
library(tidyllm)
library(glue)
library(lubridate)    # For date-time conversions
library(ggplot2)
library(textclean)

# Read updated CSV files 
# Here, we read the combined or updated CSV files for the three groupchats, in this case we rename it because we labelled them across group member's notebooks different
main_chat_data <- csv_data_main
health_fitness_data <- csv_data_fitness
admin_chat_data <- csv_data_admin

# Convert timestamps so that we have a uniform format, as we did in the course exercises
convert_timestamp <- function(df) {
  if ("timestamp" %in% names(df)) {
    if (is.numeric(df$timestamp)) {
      df$timestamp <- as.POSIXct(df$timestamp, origin = "1970-01-01", tz = "UTC")
    } else if (is.character(df$timestamp)) {
      # Adjust the parsing function based on your timestamp format
      df$timestamp <- ymd_hms(df$timestamp, tz = "UTC")
    }
  }
  return(df)
}

main_chat_data <- convert_timestamp(main_chat_data)
health_fitness_data <- convert_timestamp(health_fitness_data)
admin_chat_data <- convert_timestamp(admin_chat_data)

main_chat_data <- main_chat_data |> mutate(source = "Main Groupchat")
health_fitness_data <- health_fitness_data |> mutate(source = "Health and Fitness Groupchat")
admin_chat_data <- admin_chat_data |> mutate(source = "Admin Groupchat")

# Function to run classification with random sampling we chose 5000 here, and 1000 for the poster due to token worries, but with a local model we thought 5000 would be reasonable (10k take 3h (depending on the model) so thats a bit time exhaustive)
run_classification <- function(data, limit = 5000) {
  data <- as_tibble(data)
  
  if (!"content" %in% names(data)) {
    stop("The 'content' column is missing from the dataset.")
  }
  
  sample_size <- min(nrow(data), limit)
  set.seed(123)  # For reproducibility, as recommended in the course for consistent results
  limited_text_df <- data |>
    slice_sample(n = sample_size) |>
    mutate(text = as.character(content)) |>
    select(text)
  
  limited_text_data <- limited_text_df$text
  
  # As we did in the course, we provide a clear codebook for the LLM:
  codebook_multi_class <- glue(
    "You are an expert in linguistics and hate speech detection. The user will provide text, and you must determine which category it falls into.

Text: \"{description}\"

Respond ONLY with the number:

0 = Not hateful
1 = Misogynistic
2 = Racist
3 = Homophobic
4 = Other hateful content",
    description = limited_text_data
  )
  
  # Here, we replicate the preprocessing steps (like cleaning tags, etc. 
  # removing extra whitespace, tokenizing, stopwords removal, stemming, and tf-idf).
  # As done in the course, this ensures the input to the LLM is as clean as possible.
  recipe <- recipe(~ text, data = limited_text_df) %>%
    step_mutate(text = str_replace_all(text, "<@role:[^>]+>", "")) %>%
    step_mutate(text = str_squish(text)) |>
    step_tokenize(text) |>
    step_stopwords(text) |>
    step_stem(text) |>
    step_tfidf(text)
  
  prepped_recipe <- prep(recipe)
  preprocessed_text <- bake(prepped_recipe, new_data = limited_text_df)
  
  # Classification function using tidyllm with a chosen LLM model.
  classify_sequential_llama8b <- function(texts, message, temperature = 0.1) {
    raw_output <- message |>
      tidyllm::chat(ollama(.model = "llama3.1:8b", .temperature = temperature)) |>
      get_reply()
    raw_code <- as.numeric(parse_number(raw_output))
    tibble(text = texts, label = raw_code)
  }
  
  classification_task_multi_class <- purrr::map(codebook_multi_class, llm_message)
  
  results_multi_class <- tibble(
    texts = limited_text_data,
    message = classification_task_multi_class
  ) |>
    purrr::pmap_dfr(classify_sequential_llama8b, .progress = TRUE)
  
  prepare_prediction_multi_class <- function(results) {
    results %>%
      mutate(
        predicted = factor(case_when(
          label == 0 ~ "not hateful",
          label == 1 ~ "misogynistic",
          label == 2 ~ "racist",
          label == 3 ~ "homophobic",
          label == 4 ~ "other hateful content"
        ), levels = c("not hateful", "misogynistic", "racist", "homophobic", "other hateful content"))
      )
  }
  
  results_multi_class <- prepare_prediction_multi_class(results_multi_class)
  return(results_multi_class)
}

# Now we apply the classification to the admin chat data. 
results_admin <- run_classification(admin_chat_data)
print(results_admin)

# ---- Source block 32 ----
# Combine main and health data
combined_main_health_data <- bind_rows(main_chat_data, health_fitness_data)

# Run classification on combined main and health data
results_main_health <- run_classification(combined_main_health_data)
print(results_main_health)

# ---- Source block 33 ----
# Combine results from admin chat and main/health data
combined_results <- bind_rows(results_admin, results_main_health, .id = "source")
print(combined_results)

# ---- Source block 34 ----
# we can now filter the classified texts into different categories and inspect them separately.
misogynistic_texts <- combined_results |>
  filter(predicted == "misogynistic")

racist_texts <- combined_results |>
  filter(predicted == "racist")

homophobic_texts <- combined_results |>
  filter(predicted == "homophobic")

other_hateful_texts <- combined_results |>
  filter(predicted == "other hateful content")

# Flatten and export data if for later use
flattened_data <- combined_results |>
  mutate(across(where(is.list), ~ sapply(., toString)))

write.csv(flattened_data, file = "combined_results.csv", row.names = FALSE)

category_counts <- combined_results |>
  count(predicted)

# Define a custom color palette suitable for our categories
custom_colors <- c(
  "not hateful" = "#c22421",
  "misogynistic" = "#d95f02",
  "racist" = "#7570b3",
  "homophobic" = "#2b2b28",
  "other hateful content" = "#fbdc6a"
)

ggplot(category_counts, aes(x = predicted, y = n, fill = predicted)) +
  geom_col(show.legend = FALSE) +
  scale_fill_manual(values = custom_colors) +
  coord_flip() +
  labs(
    title = "Distribution of Classified Texts by Category",
    x = "",
    y = "Count of Texts"
  ) +
  theme_minimal(base_size = 18) +
  theme(
    plot.title = element_text(face = "bold", size = 18),
    axis.text = element_text(size = 14),
    axis.title.y = element_blank()
  )

# ---- Source block 35 ----
# Exporting the filtered texts by category as separate CSV files, 
# a step that aligns with what we did previously in the course for data archival.
write.csv(misogynistic_texts, file = "misogynistic_texts.csv", row.names = FALSE)
write.csv(racist_texts, file = "racist_texts.csv", row.names = FALSE)
write.csv(homophobic_texts, file = "homophobic_texts.csv", row.names = FALSE)
write.csv(other_hateful_texts, file = "other_hateful_texts.csv", row.names = FALSE)

# Exercise 1: reading and querying a web API

# Load the httr and jsonlite libraries for accessing data
# You can also load `dplyr` if you wish to use it
library(httr)
library(jsonlite)
library(dplyr)

# Create a variable for the API's base URI (https://api.github.com)
base_uri <- "https://api.github.com"

# Under the "Repositories" category of the API, 
# find the endpoint that will list repos in an organization. Then, 
# Create a variable `resource` that stores the endpoint for the "info201"
# organization repos (this is the PATH to the resource of interest).
# (FYI: this is where we keep the book code and master exercise sets!)
resource <- "/orgs/info201/repos"
full_uri <- paste0(base_uri, resource)
# Send a GET request to this endpoint (the `base_uri`` followed by `resource`)
response <- GET(full_uri)

# Extract the "text" of the response usin the `content` function
content <- content(response, type = "text")

# Convert the body from JSON into a data frame
body_content <- fromJSON(content)
body_content <- as.data.frame(body_content)
# How many (public) repositories does the organization have?
nrow(body_content)

##### New query ######

# Use a "Search" endpoint to search for repositories about "graphics"
# (bonus: limit language to only "R" -- which requires a different syntax)
# (hint: https://developer.github.com/v3/search/#search-repositories)
# Reassign the `resource` variable to refer to the appropriate resource.
resource <- "/search/repositories"

# You will need to specify some query parameters. Create a `query_params` list 
# variable that specifies an appropriate key and value for the search term and
# the language
query_params <- list(q = "graphics+languages:R")

# Send a GET request to this endpoint--including your params list as the `query`
get_back <- GET(full_uri, query = query_params)
content <- content(get_back, type = "text")
# Extract the response body and convert it from JSON.
convert_get_back <- fromJSON(content)
convert_data <- as.data.frame(convert_get_back)
# How many search repos did your search find? (Hint: check the list names)
nrow(convert_get_back)
flatten(convert_data)
# What are the full names of the top 5 results?
top_5 <- convert_data %>% flatten() %>%  arrange(-forks_count) %>% select(full_name)
top_5

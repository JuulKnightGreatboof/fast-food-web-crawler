library(tidyverse)
library(Rcrawler)
library(rvest)
library(rlist)
library(dplyr)

# url = 'https://en.wikipedia.org/wiki/World_Happiness_Report'
# 
# testrun = read_html(url) %>%
#   html_element('table.wikitable') %>%
#   html_table()
# df <- data.frame(matrix(ncol=5, nrow=0))
# colnames(df) <- c('Food', 'Size','Size & Price', 'Price', 'Place')

url = 'https://www.fastfoodmenuprices.com/all-restaurants/'

url1 = 'https://www.fastfoodmenuprices.com/and-pizza-prices/'

urls = read_html(url) %>%
  html_element('.menu-all-restaurants-left-container') %>%
  html_elements('a') %>%
  html_attr('href')
urls2 = read_html(url) %>%
  html_element('.menu-all-restaurants-middle-container') %>%
  html_elements('a') %>%
  html_attr('href')
urls3 = read_html(url) %>%
  html_element('.menu-all-restaurants-right-container') %>%
  html_elements('a') %>%
  html_attr('href')

urls = append(urls, urls2)
urls = append(urls, urls3)

df = read_html(url1) %>%
  html_element('table.tablepress') %>%
  html_table()

df['Place'] <- read_html(url1) %>%
  html_element('h1.entry-title') %>%
  html_text()

get_table = function(food_link){
  food_page = read_html(food_link)
  food_prices = food_page %>% html_element('table') %>%
    html_table()
  food_prices['Place'] <- read_html(food_link) %>%
    html_element('h1.entry-title') %>%
    html_text()
  return(food_prices)
}

for(value in urls){
  df <- bind_rows(df, get_table(value))
}


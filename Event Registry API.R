#set the directory


#loading packages
library(jsonlite)  

keyword <- "[\"government\",\"directs\",\"school\"]"
#date_start <- "2017-10-01"
date_start <- "2017-10-01"
#date_end <- "2018-09-30"
date_end <- "2018-09-30"
language <- "eng"  

######################### DO NOT EDIT ANYTHING BELOW THIS LINE #################################################3
df <- NULL
searched_keywords <- sort(unique(c(searched_keywords, keyword)))
write.csv(as.data.frame(searched_keywords), file = "searched_keywords.csv")
url_source <- paste("http://eventregistry.org/api/v1/article?query={\"$query\":{\"$and\":[{\"keyword\":{\"$and\":", 
                    keyword, "}},{\"$or\":[{\"sourceLocationUri\":\"http://en.wikipedia.org/wiki/India\"}]},{\"dateStart\":\"", 
                    date_start, "\",\"dateEnd\":\"",
                    date_end, "\",\"lang\":\"",
                    language,"\"}]}}&action=getArticles&resultType=articles&articlesSortBy=date&articlesCount=100&includeArticleLocation=true&articleBodyLen=-1&apiKey=YOUR_API_KEY", sep="")

news <- fromJSON(url_source)
pages <- news$articles$pages
for(i in 1:pages){
        url_page <- paste("http://eventregistry.org/api/v1/article?query={\"$query\":{\"$and\":[{\"keyword\":{\"$and\":", 
                            keyword, "}},{\"$or\":[{\"sourceLocationUri\":\"http://en.wikipedia.org/wiki/India\"}]},{\"dateStart\":\"", 
                            date_start, "\",\"dateEnd\":\"",
                            date_end, "\",\"lang\":\"",
                            language,"\"}]}}&action=getArticles&resultType=articles&articlesSortBy=date&articlesCount=100&includeArticleLocation=true&articleBodyLen=-1&articlesPage=",
                            i, "&apiKey=YOUR_API_KEY", sep="")
        y <- fromJSON(url_page)
        df <- rbind(df, data.frame(date = y$articles$results$date, 
                                   url = y$articles$results$url, 
                                   title = y$articles$results$title, 
                                   source = y$articles$results$source$title,
                                   duplicate = y$articles$results$isDuplicate,
                                   body = y$articles$results$body))
}
df <- subset(df, df$duplicate == FALSE)
filename <- paste(keyword, ".csv", sep = "")
write.csv(df, paste("collection_articles/", filename, sep = ""))


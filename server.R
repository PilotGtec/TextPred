# author: Pilot Gtec
# created: 23 April 2015

library(shiny)
#source('utility.R')

##Load data files
indices <- readRDS("indexedterms.RDS")
twogram <- readRDS("twogram.RDS")
threegram <- readRDS("threegram.RDS")
fourgram <- readRDS("fourgram.RDS")
profaneWords <- read.table("badwords.txt")

shinyServer(function(input, output) {
    inputInfo <- eventReactive(input$predictButton, {input$myStatement})
    #meanwhile <- reactive(getwords(inputInfo()))
    meanwhile <- eventReactive(input$predictButton, {getwords(inputInfo())})
    output$predictions <- renderText({paste(meanwhile()$predictions, collapse=", ")}) 
    output$singleword <- renderText({meanwhile()$predictions[1]})
    output$predstatement <- renderText({meanwhile()$mystatement})
    output$comment <- renderText({meanwhile()$comment})
})

process <- function(statement){
    ## convert all to lower
    statement <- tolower(statement)
    
    ## replace
    statement <- gsub("'s", "xxss", statement)
    statement <- gsub("'t", "xxtt", statement)
    statement <- gsub("'m", "xxmm", statement)
    statement <- gsub("'ll", "xxll", statement)
    statement <- gsub("'ve", "xxve", statement)
    statement <- gsub("'re", "xxre", statement)
    
    ##remove punctuations and leading and trailing spaces
    statement <- gsub('[[:punct:]]','',statement) 
    statement <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", statement)
    
    return(statement)
}

getwords <- function(statement){
    statement <- process(statement)
    #words <- strsplit(statement, "\\s+")
    words <- strsplit(statement, " ")
    nwords <- sapply(words, length)
    predictions <- predict(nwords, statement, words, indices, fourgram, 
                           threegram, twogram)
    predictions <- as.character(predictions)
    predictions <- clean(predictions)
    
    mypredictedstatement <- paste(statement, predictions[1], collapse="")
    if ("puppy*" %in% predictions){
        comment <- "- puppy* is used as a placeholder for predicted 
        profane words."
    } else{
        comment <- ""
    }
    
    statement <- paste(words[[1]], collapse=" ")
#     results <- list( "statement" = statement, "words" = words, 
#                      "wordsize" = nwords, 
#                      "predictions"=predictions, "comment" = comment)
    results <- list("predictions"=predictions, "comment" = comment, 
                    "mystatement" = mypredictedstatement)
    return(results)
}


clean <- function(predictions){
    for (p in predictions){
        if(length(profaneWords[profaneWords$V1 == p,]) != 0){
        #if( length(grep( paste("^", p, "$", sep=""), profaneWords$V1 )) != 0 ){
            predictions <- gsub(p, "puppy*", predictions)
        }
    }
    return (predictions)
}

predict <- function(nwords, statement, words, indices, fourgram, threegram, twogram){
    if (nwords >= 3){
        findme <- paste(as.character(tail(words[[1]], 3)), collapse=" ") 
        #matchIndices <- grep(findme, fourgram$Input)[1:5]
        matchIndices <- as.numeric(rownames(fourgram[fourgram$Input == findme,]))
        if (length(matchIndices)>4){
            matchIndices <- matchIndices[1:5]
        }
        predictions <- indices$Term[fourgram$NextID[matchIndices]]
        if (length(predictions) == 0){
        #if (sum(is.na(predictions))==5){
            findme <- paste(as.character(tail(words[[1]], 2)), collapse=" ")
            #matchIndices <- grep(findme, threegram$Input)[1:5]
            matchIndices <- as.numeric(rownames(threegram[threegram$Input == findme,]))
            if (length(matchIndices)>4){
                matchIndices <- matchIndices[1:5]
            }
            predictions <- indices$Term[threegram$NextID[matchIndices]]
            if (length(predictions) == 0){
            #if (sum(is.na(predictions))==5){
                findme <- paste(as.character(tail(words[[1]], 1)), collapse=" ")
                #matchIndices <- grep(findme, twogram$Input)[1:5]
                matchIndices <- as.numeric(rownames(twogram[twogram$Input == findme,]))
                if (length(matchIndices)>4){
                    matchIndices <- matchIndices[1:5]
                }
                predictions <- indices$Term[twogram$NextID[matchIndices]]
                if (length(predictions) == 0){
                #if (sum(is.na(predictions))==5){
                    predictions <- indices$Term[1:5]
                }
            }
        }
    } else if (nwords == 2){
        findme <- statement
        matchIndices <- as.numeric(rownames(threegram[threegram$Input == findme,]))
        if (length(matchIndices)>4){
            matchIndices <- matchIndices[1:5]
        }
        predictions <- indices$Term[threegram$NextID[matchIndices]]
        if (length(predictions) == 0){
            findme <- paste(as.character(tail(words[[1]], 1)), collapse=" ")
            matchIndices <- as.numeric(rownames(twogram[twogram$Input == findme,]))
            if (length(matchIndices)>4){
                matchIndices <- matchIndices[1:5]
            }
            predictions <- indices$Term[twogram$NextID[matchIndices]]
            if (length(predictions) == 0){
                predictions <- indices$Term[1:5]
            }
        }
    } else{
        findme <- statement
        matchIndices <- as.numeric(rownames(twogram[twogram$Input == findme,]))
        if (length(matchIndices)>4){
            matchIndices <- matchIndices[1:5]
        }
        predictions <- indices$Term[twogram$NextID[matchIndices]]  
        if (length(predictions) == 0){
            predictions <- indices$Term[1:5]
        }
    }
    
    predictions <- predictions[!is.na(predictions)]
    predictions
}


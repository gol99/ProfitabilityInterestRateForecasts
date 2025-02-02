rm(list=ls())

library(PeerPerformance)
library(dplyr)
library(writexl)

#import risk-free rate
relative_path<-file.path('..', '..',"..","Data","Consolidated","TreasuryYield","TreasuryBill.csv")
r_f<-read.csv(relative_path)

#create lists to more easily access all dataframes
trading_strategies=c("StrategyA","StrategyB","StrategyC")
instruments=c("ETF","Futures")
files=c("returnsA2Y3M.csv","returnsA2Y6M.csv","returnsA2Y12M.csv","returnsA10Y3M.csv","returnsA10Y6M.csv","returnsA10Y12M.csv")





#function to only keep columns with return
forecast_rates<-function(forecast_df){
  n<-floor(length(forecast_df)/2)
  row.names(forecast_df)<-forecast_df[,1]
  forecast_df<-forecast_df[,-1]
  forecasts<-forecast_df[,c((n+1):length(forecast_df))]
  return(forecasts)
}

SharpeDif<-function(forecasts,rf,forecast_horizon){
  #only keep return data
  forecasts<-forecast_rates(forecasts)
  # Match the dates of returns and risk-free rate
  r_f_subset <- rf %>%
    filter(X %in% row.names(forecasts))
  #remove date column
  row.names(r_f_subset)<-r_f_subset[,1]
  r_f_subset<-r_f_subset[,-1]
  #turn annaul returns to quarterly returns
  r_f_subset<-(r_f_subset/100+1)**0.25-1
  #create empty dataframe to save data in
  df <- data.frame(matrix(nrow = length(colnames(forecasts)), ncol = length(colnames(forecasts))))
  rownames(df)<-colnames(forecasts)
  colnames(df)<-colnames(forecasts)
  #iterate throug rownames to make tests
  for (col1 in colnames(forecasts)){
    for (col2 in colnames(forecasts)){
      return1<-exp(forecasts[col1])-1
      excess1<-return1-r_f_subset[,forecast_horizon]
      return2<-exp(forecasts[col2])-1
      excess2<-return2-r_f_subset[,forecast_horizon]
      ctr = list(type = 2)
      df[col1,col2]=sharpeTesting(excess1,excess2,control = ctr)$pval
    }
  }
  
  # Convert dataframe to matrix for easier indexing
  mat <- as.matrix(df)
  # Set values above the diagonal to NA
  mat[!lower.tri(mat, diag = FALSE)] <- NA
  # Convert back to dataframe if needed
  df_new <- as.data.frame(mat)
  return(df_new)
}

#create funtion to print Dataframe Name
printDataFrameName <- function(df) {
  dfName <- deparse(substitute(df))
  print(dfName)
}

#iterate through all files
for (strategy in trading_strategies){
  for (instrument in instruments){
    for (file in files){
      relative_path <- file.path("..", "..", "..","Data", "Results", "TradingStrategies","Alternative", strategy, instrument, file)
      forecast_data<-read.csv(relative_path)
      #get forecast horizon
      forecast_horizon<-substring(file,first=nchar(file)-5,last=nchar(file)-4)
      instrument_code<-substring(file,first=9,last=nchar(file)-4)
      if (forecast_horizon=="2M"){
        forecast_horizon="1Y"
      }
      #get forecast horizon for risk-free rate
      forecast_horizon=paste0("X",forecast_horizon)
      #set name for dataframe where I store results
      new_df_name=paste0(strategy,instrument,instrument_code)
      #run the code based on the dataframe name
      full_code=paste0(new_df_name," <- SharpeDif(forecast_data,r_f,forecast_horizon)")
      code_expression=parse(text=full_code)
      eval(code_expression)
      #Check wheter any values are significant
      full_code=paste0("indices=(which(",new_df_name,"< 0.05, arr.ind = TRUE))")
      code_expression=parse(text=full_code)
      eval(code_expression)
      if (length(indices)>0){
        full_code=paste0("printDataFrameName(",new_df_name,")")
        code_expression=parse(text=full_code)
        eval(code_expression)
        print(indices)
      }
      #add coulmn with rownames
      full_code=paste0(new_df_name," <-cbind(' '=rownames(",new_df_name,"), ",new_df_name,")")
      code_expression=parse(text=full_code)
      eval(code_expression)
      mtcars1 <- cbind(" "=rownames(mtcars), mtcars)
      #save Dataframe
      new_filename=paste0(new_df_name,".xlsx")
      relative_path <- file.path("..", "..", "..","Data", "Results", "StatisticalTests", "Sharpe","Alternative",strategy, instrument, new_filename)
      full_code=paste0("write_xlsx(",new_df_name,", relative_path)")
      code_expression=parse(text=full_code)
      eval(code_expression)
    }
  }
}

#indices=(which(StrategyCFutures2Y12M < 0.1, arr.ind = TRUE))
#length(indices)

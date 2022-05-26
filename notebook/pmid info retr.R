library(dplyr)
library(RISmed)
library(rentrez)
library(data.table)
library(tidyr)
data <-read.delim('/data/pubmed-data.tsv', header=TRUE, sep="\t")

#filter data by query term and sort algorithm 
data_sh=data%>% filter(grepl('cancer', query_term)|grepl('neoplasm', query_term),sort_algorithm=="date" |sort_algorithm=='relevance')
data_sh=dplyr::filter(data_sh, page_num=='1')

#randomly sample rows if sort_algorithm is relevance. # of rows by date is 7465
#keep the first 10 PMIDs for each row
set.seed(52522)
sample=data_sh%>% group_by(sort_algorithm) %>% sample_n(7465)%>% mutate(uPMID = strsplit(as.character(PMID), ","))%>%unnest(uPMID)%>%group_by(search_id)%>% top_n(10)
sample=split(sample, sample$sort_algorithm)

####different loops created for each sort_algorithm because pmids from different files don't match at the end. 
####run loop for sort_algorithm = date####
sort_group_date=split(sample[[1]], seq(nrow(sample[[1]])) %/% 200) #split data into junks to override PMIDs
#extract PMID's for the filtered data
pmIDs_date<-list()
for (i in 1:length(sort_group_date)){
  pmIDs_date[[i]] <- paste(sort_group_date[[i]]$uPMID, collapse = ",")
}


#use rentrez package to retrieve info by pmid. This is alternative to RISmed package
set_entrez_key("debe10da1ec3306e9dd4a5f07a700d818208")
Sys.getenv("debe10da1ec3306e9dd4a5f07a700d818208")
pubmed_date<-list()
records_date<-list()
for (i in 1:length(pmIDs_date)){
  records_date[[i]]<-entrez_summary(pmIDs_date[[i]],type="efetch",db="pubmed", api_key="debe10da1ec3306e9dd4a5f07a700d818208") #retrieve the info for each PMID
  Sys.sleep(0.3)
}


#use different loops to easily add new columns from the search files
for (i in 1:length(pmIDs_date)){
  pubmed_date[[i]]<- t(extract_from_esummary(records_date[[i]], c("fulljournalname", "pubdate","lang", "pubtype", "title","uid")))
}

results_date=do.call(rbind.data.frame, pubmed_date)%>%filter(fulljournalname!="")
results_date$pubdate=substring(results_date$pubdate, 1,4) #keep the Pub year only
results_date$uPMID <- row.names(results_date)
results_date$sort_algorithm='date'


####different loops created for each sort_algorithm because pmids from different files don't match at the end. 
####run loop for sort_algorithm = date####
sort_group_rel=split(sample[[2]], seq(nrow(sample[[2]])) %/% 200) #split data into junks to override PMIDs
#extract PMID's for the filtered data
pmIDs_rel<-list()
for (i in 1:length(sort_group_rel)){
  pmIDs_rel[[i]] <- paste(sort_group_rel[[i]]$uPMID, collapse = ",")
}


#use rentrez package to retrieve info by pmid. This is alternative to RISmed package
set_entrez_key("debe10da1ec3306e9dd4a5f07a700d818208")
Sys.getenv("debe10da1ec3306e9dd4a5f07a700d818208")
pubmed_rel<-list()
records_rel<-list()
for (i in 1:length(pmIDs_rel)){
  records_rel[[i]]<-entrez_summary(pmIDs_rel[[i]],type="efetch",db="pubmed", api_key="debe10da1ec3306e9dd4a5f07a700d818208") #retrieve the info for each PMID
  Sys.sleep(0.3)
}


#use different loops to easily add new columns from the search files
for (i in 1:length(pmIDs_rel)){
  pubmed_rel[[i]]<- t(extract_from_esummary(records_rel[[i]], c("fulljournalname", "pubdate",  "lang", "pubtype", "title","uid")))
}

results_rel=do.call(rbind.data.frame, pubmed_rel)%>%filter(fulljournalname!="") #remove rows if journame is missing
results_rel$pubdate=substring(results_rel$pubdate, 1,4) #keep the Pub year only
results_rel$uPMID <- row.names(results_rel) #convert rownames to column
results_rel$sort_algorithm='relevance'

#merge and write
results=rbind(results_date, results_rel)
openxlsx::write.xlsx(results, file='results.xlsx')

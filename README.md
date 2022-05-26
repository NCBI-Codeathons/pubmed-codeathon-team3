# pubmed-codeathon-team3

## What is the project trying to achieve?
The goal of Team 3 is to test equitable representation of journals and publication years using Best Match Order versus Most Recent Order in PubMed results. The project tests the theory that Best Match increases the prominence of familiar journals by increasing the frequency of some journals over others in users' first page of results compared to using a date sort order. 

## Can I use it?
You can use our methodology to study citation and MeSH indexing factors in the PubMed results display in date sorted vs. relevance sorted results.

## If so, how?
You’ll want to follow the workflow listed under the Methods section below.

## Project description (no more than 3 sentences):
The null hypothesis is that, in comparing a random sample of searches using Best Match sort to a random sample of searches using Date Order sort, the difference in the frequency distribution of unique journal titles is insignificant.

## Methods:
- Data workflow for NCBI data
  - Filter the data  file provided by NCBI with regards to 
    - query_term:  “cancer” or “neoplasm”
    - sort_algorithm : “date” or “relevance”
    - Randomly select rows to have equal number of rows from each category
    - page_num: 1
    - PMID: if there is more than 10 PMIDs per search_id, use only the first 10
  - Use rentrez R package to retrieve information (Publication year, journal, language, title) for each the PMIDs of interest.
  - Summarize the data by sort_algorithm, publication year, and journal
  - Visualize the results
- Data workflow for live query
  - MeSH/Query conducted the following search “neoplasm OR cancer” to review granular data within the live PubMed environment
    - first 20 results of the Best Match and the first 20 results of the Most Recent were exported 

## Outcomes:
There appears to be a significant difference in frequency distribution of journal titles between Best Match and Date sort order. The frequency distribution of journal titles in date order is significantly skewed, where a Best Match sort order seems to favor a set of journals. The relevance sort may represent a higher diversity of journal titles in the first ten results than the date sort.

## Future work:
Determine if the skewed distribution represents:
A trend in publishing, where fewer journals are published for this content area currently than in the past.
An artifact of issue frequency: A subset of titles issuing more citations than others in recent years.
Click through rate satisfaction by combining good reputable publishers and traffic engagement as percentage of impression.
The next step would be to weight using the total number of citations per journal.

## Team
- Vasileios Alevizos
- Helen-Ann Epstein
- Hacer Karamese
- Kate Majewski
- Sarah Nabulsi
- Brandon Patterson
- Susan Schmidt
- Erin Ware
- Aidy Weeks

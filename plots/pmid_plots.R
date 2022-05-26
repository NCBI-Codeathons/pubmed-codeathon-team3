library(readxl)
library(ggplot2)
library(dplyr)
results <- read_excel("results.xlsx") #see pmid info retr.R
#calculate the frequency of each journal and pick the top 50 journals by frequency
journal=results%>%group_by(sort_algorithm, fulljournalname) %>%summarise(Frequency=n(),.groups = 'drop')%>%arrange(desc(Frequency)) %>%
  group_by(sort_algorithm)%>%mutate(order=row_number(),.groups = 'drop')%>%ungroup()%>%filter(order<51)%>%data.frame()

#plot
ggplot(data = journal,aes(x = reorder(order, -Frequency), y = Frequency)) +theme_bw()+
  geom_col(aes(fill = sort_algorithm),position = position_dodge(),width = 0.75) +
  scale_fill_discrete(name = "Sort Algorithm", labels = c("Most Recent", "Best Match"))
  labs(fill="Sort Algorithm", x= 'Journal Order', y='Frequency')+theme(legend.position="right",legend.key=element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                                                               panel.background = element_blank())
ggsave("journal.png", bg = "transparent",width = 210, height = 260/2, units = "mm")

#calculate the frequencies per year
date=results%>%group_by(sort_algorithm, pubdate) %>%summarise(Freq=n(),.groups = 'drop') %>%filter(Freq>300)
ggplot(data = date,
       aes(x = pubdate, y = Freq,group=sort_algorithm)) +geom_point(aes(colour=sort_algorithm))+
  geom_line(aes(colour=sort_algorithm))+ labs( x= 'Publication Date', y='Frequency')+theme_bw()+
  scale_color_discrete(name="Sort Algorithm",labels=c("Most Recent", "Best Match"))+theme(legend.position="right",legend.key=element_blank(),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                                                                                  panel.background = element_blank())
ggsave("date.png", bg = "transparent",width = 210, height = 260/2, units = "mm")

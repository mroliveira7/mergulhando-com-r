library(dplyr)

ibge <- read.csv("ibge.csv")
roubos <- read.csv("roubos.csv")

head(ibge)
head(roubos)
table(roubos$categoria)

#' # Cidades com mais ocorrências

dados <- roubos %>%
	inner_join(ibge) %>%
	group_by(cidade, populacao) %>%
	summarise(roubos_abs = n()) %>%
	mutate(roubos_per_capita = 1e6*roubos_abs / populacao)

dados %>% arrange(desc(roubos_abs))
dados %>% arrange(desc(roubos_per_capita))

#' # Cidades com mais assaltos

dados <- roubos %>%
	inner_join(ibge) %>%
	filter(grepl("Assalto", categoria)) %>%
	group_by(cidade, populacao) %>%
	summarise(roubos_abs = n()) %>%
	mutate(roubos_per_capita = 1e6*roubos_abs / populacao)

dados %>% arrange(desc(roubos_abs))
dados %>% arrange(desc(roubos_per_capita))

#' Palavras mais frequentes nas descrições de ocorrências

library(wordcloud)
wordcloud(roubos$titulo, max.words=50)
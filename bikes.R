library(dplyr)

bikes <- read.csv("estacoes.csv")
head(bikes)

ondina <- bikes %>%
	filter(name == 'Estação Adhemar de Barros (UFBA)') %>%
	mutate(hour = substring(time, 12, 13) %>% as.integer()) %>%
	select(hour, available)

head(ondina)

#' Que horas tenho mais chances de pegar uma bike na estação da UFBA?

x <- ondina %>%
	group_by(hour) %>%
	summarise(available = mean(available))
barplot(x$available, names=x$hour)

#' As diferenças são significativas?

wilcox.test(
	subset(ondina, hour == 8)$available,
	subset(ondina, hour == 10)$available)

wilcox.test(
	subset(ondina, hour == 14)$available,
	subset(ondina, hour == 20)$available)
#- echo=F, warning=F, error=F, message=F
options(width=45)
#- echo=T, warning=F, error=F, message=F

#'
#' O que veremos:
#'
#' * entrada/saída de dados
#' * transformação de dados
#' * visualização de dados
#' * inferência
#'
#' # Entrada/saída de dados

ratings <- read.csv("u.data", sep="\t")
head(ratings)

users <- read.csv("u.user", sep="|")
head(users)

movies = read.csv('u.item', sep='|')[, 1:3]
head(movies, 5)

#' Funções nativas:
#' 
#' * `read.csv`, `read.table`, `readLines`, `scan`, `readRDS`...
#' * Parâmetro pode ser arquivo local ou URL
#' * `write.csv`, `write.table`...
#'
#' Pacotes: 
#'
#' * XLConnect (Excel)
#' * RMySQL, RSQLite...
#' * XML
#' * rjson
#' * yaml
#' * foreign (Weka, Stata, SPSS...)
#'
#' Para instalar um pacote: `install.packages("nomedopacote")`.
#' Para carregar um pacote instalado: `library(nomedopacote)`
#' 
#' # Crawling/Scraping (download de dados da web)
#'
#' Pacotes `RCurl`, `httr`, `XML` (função readHTMLTable)... Ver <http://cos.name/wp-content/uploads/2013/05/Web-Scraping-with-R-XiaoNan.pdf>
#'
#' * Para grandes volumes, use o [scrapy](http://scrapy.org/), em Python
#' * ... e rode perto de onde os dados estão
#'
#' Para trabalhar com expressões regulares e com XML eu prefiro usar Ruby (mais familiar)
#'

#' # Transformação de dados
#' 
#' Usaremos o pacote `dplyr` -- `install.packages("dplyr")`
#'

library(dplyr)

#'
#' O `dplyr` usa o operador `%>%` do pacote `magrittr`.
#'

x <- c(3,NA,4,8,5)
head(x, 4)
sqrt(head(x, 4))
sum(sqrt(head(x, 4)), na.rm = TRUE)

#' Vamos reescrever usando o `%>%`:

x %>% head(4) %>% sqrt() %>% sum(na.rm = TRUE)

#' ## Padrão split-apply-combine

#'
#' ![split-apply-combine](sac.png)
#'

df <- read.csv("sac.csv")
df
res <- df %>%
	group_by(x) %>%
	summarise(y = mean(y))
res

#' # Análise

head(ratings)
head(users)
head(movies, 5)

df <- ratings %>%
	inner_join(users) %>%
	inner_join(movies) %>%
	select(user_id, rating, age, sex, occupation, movie_title, release_date)

head(df, 5)

#' Vamos extrair o ano de lançamento a partir da data de lançamento.
#' Usaremos a biblioteca stringr.

library(stringr)
exemplo_data <- "24-Jan-1997"
str_sub(exemplo_data, start=-4)

df <- df %>%
	mutate(year = str_sub(release_date, start=-4) %>%
		as.integer())
head(df, 5)

#' Quais os anos de ouro do cinema? Vamos obter a nota média dos filmes por ano

medias_ano <- df %>%
	group_by(year) %>%
	summarise(mean_rating = mean(rating),
		n_ratings = n(),
		n_movies = n_distinct(movie_title)) %>%
	filter(!is.na(year)) %>%
	arrange(year)

#' Primeiro: vamos visualizar o top 10

medias_ano %>%
	arrange(desc(mean_rating)) %>%
	head(10)

#' Na verdade esses anos possuem pontuação alta porque apenas os clássicos lançados esse ano estão na base de dados.

#' # Visualização de dados (gráficos)

#' Função nativa do R
plot(mean_rating ~ year, data=medias_ano, type="l")

#' rCharts
library(rCharts)
rPlot(mean_rating ~ year, data=medias_ano, type="line")
nPlot(mean_rating ~ year, data=medias_ano, type="multiBarChart")
xPlot(mean_rating ~ year, data=medias_ano, type="line-dotted")
hPlot(mean_rating ~ year, data=medias_ano, type="line")

#' ggplot2 (gramática de gráficos)
library(ggplot2)
ggplot(data=medias_ano, aes(x=year, y=mean_rating)) + geom_line()
ggplot(data=medias_ano, aes(x=year, y=mean_rating)) + geom_line() + geom_point()

#' ggvis (sucessor do ggplot2)
library(ggvis)
medias_ano %>% ggvis(~year, ~mean_rating) %>% layer_lines()
medias_ano %>% ggvis(~year, ~mean_rating) %>% layer_lines() %>% layer_points()

#' # Outros gráficos

head(df, 0)
table(df$occupation)
pie(table(df$occupation))
hist(df$age)
medias_ano$decade <- as.integer(medias_ano$year / 10)
boxplot(mean_rating ~ decade, data=medias_ano)

#' # Mais transformação de dados: reshape

#' Filmes mais masculinos/femininos

movies_sex <- df %>%
	group_by(movie_title, sex) %>%
	summarise(mean_rating = mean(rating))

head(movies_sex)

#' Cada filme aparece em duas linhas: um com a média das notas das mulheres e uma com a média da nota dos homens.

#' Como calcular a diferença entre essas notas?

#' Precisamos reestruturar o data.frame para ficar com as colunas title, M, F.

#' Para isso usaremos a biblioteca reshape2 e a função dcast.
library(reshape2)

x <- movies_sex %>% dcast(movie_title ~ sex, value.var="mean_rating")
head(x)

#' Operação inversa: melt

y <- x %>%
	melt(id.vars = "movie_title", variable.name = "sex") %>%
	arrange(movie_title, sex)
head(y)

#' ![cast/melt](castmelt.png)

movies_sex <- df %>%
	group_by(movie_title, sex) %>%
	summarise(mean_rating = mean(rating),
		num_ratings = n()) %>%
	filter(num_ratings >= 30) %>%
	dcast(movie_title ~ sex, value.var="mean_rating") %>%
	filter(!is.na(M) & !is.na(F)) %>%
	mutate(dif = M - F) %>%
	select(movie_title, dif) %>%
	arrange(dif)	
nrow(movies_sex)
head(movies_sex)
tail(movies_sex)

## x <- df %>%
## 	group_by(movie_title, sex) %>%
## 	summarise(mean_rating = mean(rating))
## head(x)
## 
## boxplot(mean_rating ~ sex, data=x)
## shapiro.test(x$mean_rating)
## t.test(mean_rating ~ sex, data=x)
## wilcox.test(mean_rating ~ sex, data=x)
## 
## boxplot(age ~ sex, data=df)

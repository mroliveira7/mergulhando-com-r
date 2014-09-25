#- echo=F, warning=F, error=F, message=F
options(width=45)
#- echo=T, warning=F, error=F, message=F

#'
#' # Vetores
#'
#' ## Criação
#'

c(1, 2, 3, 4)
1:4
5

#' 5 é um vetor de um elemento

c("a", "b", "c", "a")
c(T, F, T, T)

#' ## Atribuição: <-

nome <- "Fulano"
# O ponto faz parte do nome da variável
temperaturas.maximas <- c(27, 31, 28)
x <- 1:10

#' ## Indexação

x <- c("a", "b", "c", "d")
x[1]
x[c(1, 3)]
x[1:3]
x[c(T, F, T, F)]

#' ## Modificação do vetor

x[1] <- "A"
x
x[1:3] <- "Z"
x

#' ## Estatística básica

notas <- c(9, 8, 9, 10, 7, 5, 7, 8)
length(notas)
sum(notas)
mean(notas)
sd(notas)

#' Ajuda sobre uma função: `?sd`, `?mean`...

#' ## NA: valor faltando

notas[10] <- 9
notas
mean(notas)
mean(notas, na.rm = T)

#' `na.rm` é um parâmetro da função `mean`.

#' ## Operações vetorizadas (1)

a <- c(1, 2, 3)
b <- c(3, 2, 1)
a + b
a * b
a / b
a == b

#' ## Reciclagem de elementos

notas <- c(9, 8, 9, 10, 7, 5, 7, 8, 9, 9)
notas * 2
sqrt(notas)
notas > 7
notas < 10
notas > 7 & notas < 10
notas %in% c(8, 9)

#' Funções entre %% recebem dois parâmetros: `a %f% b`.

#' ## Misturando

notas[c(T, T, T, F, F, F, F, T, T, T)]
notas < 7
notas[notas < 7]

#' # Data frame

#' Tabela. Cada coluna é um vetor com nome.

#' ## Carregando

x <- read.csv("pessoas.csv")
x

#' ## Indexação: $ e []

x$idade

#' x[linhas, colunas]

x[, 2]
x[1, ]
x[, "idade"]
x[1:3, c("nome", "idade")]

#' ## Filtros

x[x$idade > 40, ]
subset(x, idade > 40)
head(x)
head(x, 2)
tail(x)

#' ## Estatística básica

summary(x)
nrow(x)
ncol(x)

#' ## Modificando colunas

x$nasc <- 2014 - x$idade
x
x$nasc <- NULL
x
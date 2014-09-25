library(Rook)

server <- Rhttpd$new()
server$start(listen='127.0.0.1', port=9000)

app <- function(env){
	params <- Request$new(env)$params()
	x = as.integer(params$x)
	y = as.integer(params$y)
	res = x + y
	list(
	    status = 200L,
	    headers = list('Content-Type' = 'text/html'),
	    body = paste('Sum:', res)
	)
}

server$add(app=app, name='semcomp2014')
server$browse('semcomp2014')
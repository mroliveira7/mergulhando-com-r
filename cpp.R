library(Rcpp)

cppFunction('
NumericVector dobro(NumericVector vec) {
  int n = vec.size();
  NumericVector res(n);

  for (int i = 0; i < n; i++) {
  	res[i] = vec[i] * 2;
  }
  return res;
}
')

dobro(c(1, 2, 3))
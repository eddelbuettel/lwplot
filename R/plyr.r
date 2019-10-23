defaults <- function(x, y)  {
  c(
    x,
    if (length(x)+length(y)) unique(y[match(names(y), names(x), 0L) == 0L])
  )
}

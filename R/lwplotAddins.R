## from reshape2

#' Figure out margining variables.
#'
#' Given the variables that form the rows and columns, and a set of desired
#' margins, works out which ones are possible. Variables that can't be
#' margined over are dropped silently.
#'
#' @param vars a list of character vectors giving the variables in each
#'   dimension
#' @param margins a character vector of variable names to compute margins for.
#'   \code{TRUE} will compute all possible margins.
#' @keywords manip internal
#' @return list of margining combinations, or \code{NULL} if none. These are
#'   the combinations of variables that should have their values set to
#'   \code{(all)}
margins <- function(vars, margins = NULL) {
    if (is.null(margins) || identical(margins, FALSE)) return(NULL)

    all_vars <- unlist(vars)
    if (isTRUE(margins)) {
        margins <- all_vars
    }

    ## Start by grouping margins by dimension
    dims <- lapply(vars, intersect, margins)

    ## Next, ensure high-level margins include lower-levels
    dims <- mapply(function(vars, margin) {
        lapply(margin, downto, vars)
    }, vars, dims, SIMPLIFY = FALSE, USE.NAMES = FALSE)

    ## Finally, find intersections across all dimensions
    seq_0 <- function(x) c(0, seq_along(x))
    indices <- expand.grid(lapply(dims, seq_0), KEEP.OUT.ATTRS = FALSE)
    ## indices <- indices[rowSums(indices) > 0, ]

    lapply(seq_len(nrow(indices)), function(i){
        unlist(mapply("[", dims, indices[i, ], SIMPLIFY = FALSE))
    })
}

upto <- function(a, b) {
    b[seq_len(match(a, b, nomatch = 0))]
}
downto <- function(a, b) {
    rev(upto(a, rev(b)))
}

#' Add margins to a data frame.
#'
#' Rownames are silently stripped. All margining variables will be converted
#' to factors.
#'
#' @param df input data frame
#' @param vars a list of character vectors giving the variables in each
#'   dimension
#' @param margins a character vector of variable names to compute margins for.
#'   \code{TRUE} will compute all possible margins.
#' @export
#' @importFrom data.table rbindlist
add_margins <- function(df, vars, margins = TRUE) {
    margin_vars <- margins(vars, margins)

    ## Return data frame if no margining necessary
    if (length(margin_vars) == 0) return(df)

    ## Prepare data frame for addition of margins
    addAll <- function(x) {
        x <- addNA(x, TRUE)
        factor(x, levels = c(levels(x), "(all)"), exclude = NULL)
    }
    vars <- unique(unlist(margin_vars))
    df[vars] <- lapply(df[vars], addAll)

    rownames(df) <- NULL

    ## Loop through all combinations of margin variables, setting
    ## those variables to (all)
    #margin_dfs <- llply(margin_vars, function(vars) {
    margin_dfs <- lapply(margin_vars, function(vars) {  # DEdd changed to base R
        df[vars] <- rep(list(factor("(all)")), length(vars))
        df
    })

    ##rbind.fill(margin_dfs)
    as.data.frame(rbindlist(margin_dfs))  # DEdd change to data.table::rbindlist
}

#' Use data.table::melt
#'
#' @param df a data.frame
#'   dimension
#' @param ... remaining arguments
#' @return A melted data.frame
#' @export
#' @importFrom data.table setDT melt
dtmelt <- function(df, ...) {
    if (!inherits(df, "data.frame")) df <- as.data.frame(df)
    data.table::setDT(df)
    v <- data.table::melt(df, ...)
    as.data.frame(v)
}

#' Replacement for reshape on outer
#'
#' @param N dimension
#' @return A data.frame corresponding to `melt` on `outer(1:N,1:N)`
#' @export
dtouter <- function(N) {
    ##as.data.frame(data.table(X1=rep(1:N,N), X2=rep(1:N, each=N))[,value:=X1*X2])
    ## simpler:
    df <- data.frame(X1=rep(1:N,N), X2=rep(1:N, each=N))
    df$value <- df$X1 * df$X1
    df
}


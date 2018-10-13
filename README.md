
## lwplot

This is an *experimental* fork of [ggplot2](README-ggplot2.md) which aims to explore if we 
can make it part of the [tinyverse](http://www.tinyverse.org).

### What's with the name?

LW can stand for _lighter-weight_ but also Leland Wilkinson of _Grammar of Graphics_ fame.

### Which Version ?

We started off ggplot2 2.1.0 which still had somewhat moderate dependencies:

```
Depends: R (>= 3.1)
Imports: digest, grid, gtable (>= 0.1.1), MASS, plyr (>= 1.7.1),
        reshape2, scales (>= 0.3.0), stats
```

Version 2.2.0 introduced the `tibble`:

```
Depends: R (>= 3.1)
Imports: digest, grid, gtable (>= 0.1.1), MASS, plyr (>= 1.7.1),
        reshape2, scales (>= 0.4.1), stats, tibble, lazyeval
```

Version 3.0.0 is all NSE:

```
Depends: R (>= 3.1)
Imports: digest, grid, gtable (>= 0.1.1), lazyeval, MASS, mgcv, plyr
        (>= 1.7.1), reshape2, rlang, scales (>= 0.5.0), stats, tibble,
        viridisLite, withr (>= 2.0.0)
```

Maybe we can stay at what 2.1.0 and even remove `plyr` and `reshape2` 
by introducing `data.table`.

### Status ?

Not bad. After some minimal changes, it passes `R CMD check` as `lwplot`

### Who ?

Dirk Eddelbuettel for this.

Hadley Wickham and many collaborators for the underlying ggplot2 2.1.0.

### License

GPL-2 as before

### Anything else ?

Please don't distribute this yet.

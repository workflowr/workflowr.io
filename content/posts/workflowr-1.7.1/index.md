---
title: Release of workflowr 1.7.1
date: 2023-08-23T10:00:00-04:00
author: John Blischak
authorLink: https://jdblischak.com/
description: ""
toc: true
---

The latest release of workflowr, [1.7.1][], is now on [CRAN][]. Many thanks to
the developers that contributed to this version: Yongqi Wang
([@wyq977][wyq977]), Xiongbing Jin ([@warmdev][warmdev]), and Yihui Xie
([@yihui][yihui]).

[1.7.1]: https://github.com/workflowr/workflowr/releases/tag/v1.7.1
[CRAN]: https://cran.r-project.org/package=workflowr
[wyq977]: https://github.com/wyq977
[warmdev]: https://github.com/giocomai
[yihui]: https://github.com/yihui

# Changelog

This patch release includes improved documentation, bug fixes, and a reduction
in the number of Suggested dependencies.

## Updated documentation

* Update single-page FAQ to explain how to remove navbar

* Update badge links (implemented by @wyq977 in #276)

* Explicitly label internal functions with roxygen2

* Build online docs via GitHub Actions and push to gh-pages

* Improve guidance on rendering a standalone HTML file in FAQ vignette
(idea from @fkgruber in #283)

* Add the appropriate PKGNAME-package \alias to the package overview help file
as per "Documenting packages" in _Writing R Extensions_

* Modernize `CITATION`. Replace `citEntry()` with `bibentry()`, replace
`personList()` with `c()`, format as R code, and simplify.

## Bug fixes

* Fix missing figure version table on Windows (implemented by @warmdev in #275)

* Use `conditionMessage()` to extract error message from callr subprocess
  [r-lib/callr#228](https://github.com/r-lib/callr/issues/228)

* Remove warning from `sprintf()` in `print.wflow_start()` when `git = FALSE`

## Dependencies

* Removed from Imports: xfun
* Removed from Suggests: covr, devtools, spelling
* Added to Suggests: sessioninfo

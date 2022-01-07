---
title: Release of workflowr 1.7.0
date: 2022-01-07T14:00:00-05:00
author: John Blischak
authorLink: https://jdblischak.com/
description: ""
toc: true
---

The latest release of workflowr, [1.7.0][], is now on [CRAN][]. Many
thanks to the developers that contributed to this version: Zaynaib
(Ola) Giwa ([@zaynaib][zaynaib]), Giorgio Comai
([@giocomai][giocomai]), and Yihui Xie ([@yihui][yihui]).

[1.7.0]: https://github.com/workflowr/workflowr/releases/tag/v1.7.0
[CRAN]: https://cran.r-project.org/package=workflowr
[zaynaib]: https://github.com/zaynaib
[giocomai]: https://github.com/giocomai
[yihui]: https://github.com/yihui

# Changelog

This minor release includes some new features, improved documentation, and bug
fixes.

## Minor improvements

* New argument `combine` for `wflow_build()` and `wflow_publish()`. When Rmd
files are specified with the argument `files`, they are built in addition to any
Rmd files that are automatically built when setting arguments like `make = TRUE`
and `republish = TRUE`. If you would instead like to only build Rmd files that
are included in all the filters, you can set `combine = "and"` to take the
intersection. For example, if you ran `wflow_build("analysis/example*.Rmd", make
= TRUE, combine = "and")`, then this would only build those Rmd files matched by
the file glob `analysis/example*.Rmd` and had been modified more recently than
their corresponding HTML file. With the default, `combine = "or"`, this would
have built all the files that matched the file glob in addition to any files
that had been modified more recently than their corresponding HTML file, even if
they didn't match the file glob pattern (idea from @bfairkun in #221,
implementation by @zaynaib in #227, #228)

* If `wflow_publish()` is called, but was not instructed which files to publish,
it now throws an error. In other words, you must specify the files you wish to
publish or use one of the convenience arguments like `republish = TRUE` or
`update = TRUE`. It's previous behavior was to complete without having done
anything, which was misleading (idea from @stephens999)

* It is now easier to enter commit messages with a separate title and body. If
you pass a character vector to the argument `message` to any of the functions
that perform a commit, e.g. `wflow_publish()`, the first element will be used as
the title, and any subsequent elements will be separate paragraphs in the commit
body. Using a separate title and body will improve the display of your commit
messages on GitHub/GitLab and `git log --oneline` since these only show the
title (suggestion from @LearnUseZone in #222, implementation by @zaynaib in #225)

* New argument `only_published` for `wflow_toc()`. If set to `FALSE`, then the
table of contents will also include unpublished files (implemented by @giocomai
in #234)

## Updated documentation

* Improved organization of [reproducible research workshop
vignette][vig-workshop] (thanks to @stephens999)

[vig-workshop]: https://workflowr.github.io/workflowr/articles/wflow-09-workshop.html

* Added more documentation to `wflow_build()` to explain when it does and
doesn't load code defined in a `.Rprofile` file (idea from @pcarbo)

## Bug fixes

* Bug fix: Now workflowr will detect any problems with its dependencies when it
is attached. All dependencies must be installed, loadable, and meet the minimum
required version. Broken packages were causing cryptic, misleading errors
(reported by in @markellekelly in #216 and @LearnUseZone in #217)

* Bug fix: `wflow_quickstart()` can now handle relative paths to the Rmd files
when the working directory is changed (`change_wd = TRUE`, which is the default)

* Remove Rd warnings when installing package on Windows by explicitly specifying
the topic page when cross-referencing an exported function from another package.
Note that the links worked previously, so this change is just being proactive in
case this warning starts getting strongly enforced. If the authors of the other
package rearrange how they group functions into documentation topics, this will
break the cross-references and require an update. See this
[thread][rs-community-rd-warning] for more details

[rs-community-rd-warning]: https://community.rstudio.com/t/file-link-quasiquotation-in-package-rlang-does-not-exist-and-so-has-been-treated-as-a-topic/55774

* Bug fix: `wflow_use_github()` and `wflow_use_gitlab()` now use Font Awesome 5
syntax to insert icons into the navigation bar when a recent version of
rmarkdown is installed (>= 2.6) (bug report from @christianholland, #231)

* Bug fix: `wflow_open()` no longer sends a warning if you are using
`bookdown::html_document2` as your primary output format in `_site.yml` with
`base_format: workflowr::wflow_html` (bug report from @rgayler, #233)

## Miscellaneous

* Removed function `wflow_update()`. Its only purpose was to migrate projects
created with [workflowrBeta][], which is now over 3 years old

* Bump minimum required version of R from 3.2.5 to 3.3.0. While workflowr itself
should be able to continue to work fine with R 3.2.5, it was becoming too much
of a burden to regularly test workflowr with R 3.2.5 as the RStudio engineers
have started updating their packages to require a minimum of R 3.3.0

* Require minimum versions of callr 3.7.0, knitr 1.29, rmarkdown 1.18

* Switched to the workflowr repository itself to use the default branch "main"
and changed the owner to the workflowr organization. This has no effect on
workflowr projects (future or existing). It mainly affects contributors to
workflowr development. However, please update any links you might have
bookmarked (e.g. to documentation)

[workflowrBeta]: https://github.com/jdblischak/workflowrBeta

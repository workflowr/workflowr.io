#!/usr/bin/env Rscript

# Requires GH_APP_ID and GH_APP_KEY for GitHub App workflowr.io
#
# https://github.com/workflowr/wio
# https://docs.github.com/en/free-pro-team@latest/rest/reference/apps#list-installations-for-the-authenticated-app
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#get-a-repository
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#get-all-repository-topics
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#get-a-github-pages-site

# Setup -----------------------------------------------------------------------

suppressMessages({
  requireNamespace("gh")
  requireNamespace("wio")
  requireNamespace("yaml")
})

# Obtain projects -------------------------------------------------------------

projects <- wio::getProjectsOnGitHub()

# Remove any forks of the workflowr repository itself. It contains
# _workflowr.yml in the tests directory.
projects <- Filter(function(x) x[["repo"]] != "workflowr", projects)

# Gather project information --------------------------------------------------

output <- vector(mode = "list", length = length(projects))

for (i in seq_along(projects)) {
  p <- projects[[i]]
  message(paste(p$owner, p$repo, sep = "/"))
  repository <- gh::gh("/repos/:owner/:repo", owner = p$owner, repo = p$repo)

  # Only include projects that have websites hosted on GitHub Pages
  if (repository[["has_pages"]]) {
    pages <- gh::gh("/repos/:owner/:repo/pages", owner = p$owner, repo = p$repo)
  } else {
    next
  }

  topics <- gh::gh("/repos/:owner/:repo/topics", owner = p$owner, repo = p$repo,
                   .accept = "application/vnd.github.mercy-preview+json")
  if (length(topics$names) > 0) {
    topics <- topics$names
  } else {
    topics <- list()
  }

  if (is.null(repository$description)) {
    description <- sprintf("The workflowr project %s by %s",
                           repository$name, repository$owner$login)
  } else {
    description <- repository$description
  }

  output[[i]] <- list(
    # Default Hugo page variables
    # https://gohugo.io/content-management/front-matter/#predefined
    date = repository$created_at,
    description = description,
    lastmod = repository$pushed_at,
    title = repository$name,
    # Taxonomies
    topics = topics,
    # User-defined
    account = repository$owner$login,
    website = pages$html_url
  )
  Sys.sleep(0.25)
}

# Remove the repositories without a GitHub Pages website
output <- Filter(function(x) !is.null(x), output)

# Export projects -------------------------------------------------------------

dirContent <- "content/projects"
dirGitHub <- file.path(dirContent, "github")
unlink(dirGitHub, recursive = TRUE)
dir.create(dirGitHub, showWarnings = FALSE, recursive = TRUE)
sectionFileGitHub <- file.path(dirGitHub, "_index.md")
writeLines(c("---",
             "title: GitHub",
             "description: Workflowr projects hosted on GitHub",
             "---",
             ""),
           con = sectionFileGitHub)

for (i in seq_along(output)) {
  dirAccount <- file.path(dirContent, "github", output[[i]]$account)
  dir.create(dirAccount, showWarnings = FALSE, recursive = TRUE)
  fileAccount <- file.path(dirAccount, "_index.md")
  writeLines(c("---",
               sprintf("title: %s", output[[i]]$account),
               sprintf("description: Workflowr projects by %s", output[[i]]$account),
               "---",
               ""),
               con = fileAccount)

  dirProject <- file.path(dirContent, "github", output[[i]]$account, output[[i]]$title)
  dir.create(dirProject, showWarnings = FALSE, recursive = TRUE)
  fileProject <- file.path(dirProject, "index.md")
  con <- file(fileProject, "w")
  cat("---\n", file = con)
  yaml::write_yaml(output[[i]], file = con)
  cat("---\n\n", file = con, append = TRUE)
  close(con)
}

# Take screenshots for thumbnail images ---------------------------------------

websites <- vapply(output, function(x) x[["website"]], character(1))
createThumbnailPath <- function(x) {
  file.path(dirContent, "github", x$account, x$title, "thumbnail.png")
}
thumbnails <- vapply(output, createThumbnailPath, character(1))
wio::screenshot(websites, thumbnails)

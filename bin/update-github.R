#!/usr/bin/env Rscript

# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#get-a-repository
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#get-all-repository-topics
# https://docs.github.com/en/free-pro-team@latest/rest/reference/repos#get-a-github-pages-site

# Setup -----------------------------------------------------------------------

suppressMessages({
  requireNamespace("gh")
  requireNamespace("yaml")
})

account <- gh::gh_whoami()
if (is.null(account)) {
  stop("No GitHub access token could be found", call. = FALSE)
}
message(sprintf("Using the GitHub account '%s'", account$login))
rate <- gh::gh("/rate_limit")
message(sprintf("Remaining API requests: %d", rate$rate$remaining))
if (rate$rate$remaining < 100) {
  stop("Insufficient remaining API requests available", call. = FALSE)
}

# Obtain projects -------------------------------------------------------------

# To do: Download list of GitHub repositories that have GitHub App installed

users <- c("jdblischak", "pcarbo", "stephens999", "stephenslab")
results <- list()
for (user in users) {
  query <- sprintf("filename%%3A_workflowr.yml+user%%3A%s", user)
  search <- gh::gh(paste0("/search/code?q=", query))
  results <- c(results, search$items)
}

projects <- vector(mode = "list", length = length(results))
for (i in seq_along(results)) {
  projects[[i]] <- list(owner = results[[i]]$repository$owner$login,
                        repo = results[[i]]$repository$name)
}

# Gather project information --------------------------------------------------

output <- vector(mode = "list", length = length(projects))

for (i in seq_along(projects)) {
  p <- projects[[i]]
  message(paste(p$owner, p$repo, sep = "/"))
  repository <- gh::gh("/repos/:owner/:repo", owner = p$owner, repo = p$repo)
  topics <- gh::gh("/repos/:owner/:repo/topics", owner = p$owner, repo = p$repo,
                   .accept = "application/vnd.github.mercy-preview+json")
  if (length(topics$names) > 0) {
    topics <- topics$names
  } else {
    topics <- list()
  }
  pages <- tryCatch(
    gh::gh("/repos/:owner/:repo/pages", owner = p$owner, repo = p$repo),
    error = function(e) list()
  )

  output[[i]] <- list(
    # Default Hugo page variables
    # https://gohugo.io/content-management/front-matter/#predefined
    date = repository$created_at,
    description = repository$description,
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

# Export projects -------------------------------------------------------------

dirContent <- "content/projects"
dirGitHub <- file.path(dirContent, "github")
dir.create(dirGitHub, showWarnings = FALSE, recursive = TRUE)
sectionFileGitHub <- file.path(dirGitHub, "_index.md")
writeLines(c("---",
             "title: GitHub",
             "---",
             "",
             "Workflowr projects hosted on GitHub.",
             ""),
           con = sectionFileGitHub)

for (i in seq_along(output)) {
  dirAccount <- file.path(dirContent, "github", output[[i]]$account)
  dir.create(dirAccount, showWarnings = FALSE, recursive = TRUE)
  fileAccount <- file.path(dirAccount, "_index.md")
  writeLines(c("---",
               sprintf("title: %s", output[[i]]$account),
               "---",
               "",
               sprintf("Workflowr projects by %s", output[[i]]$account),
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

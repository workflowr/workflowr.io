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

projects <- list(
  list(owner = "jdblischak", repo = "fucci-seq"),
  list(owner = "jdblischak", repo = "singlecell-qtl"),
  list(owner = "stephenslab", repo = "wflow-divvy")
)

# Gather project information --------------------------------------------------

output <- vector(mode = "list", length = length(projects))

for (i in seq_along(projects)) {
  p <- projects[[i]]
  message(paste(p$owner, p$repo, sep = "/"))
  repository <- gh::gh("/repos/:owner/:repo", owner = p$owner, repo = p$repo)
  topics <- gh::gh("/repos/:owner/:repo/topics", owner = p$owner, repo = p$repo,
                   .accept = "application/vnd.github.mercy-preview+json")
  if (length(topics$names) > 0) {
    topics <- unlist(topics$names)
  } else {
    topics <- character()
  }
  pages <- gh::gh("/repos/:owner/:repo/pages", owner = p$owner, repo = p$repo)

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

for (i in seq_along(output)) {
  dirExport <- file.path(dirContent, "github", output[[i]]$account, output[[i]]$title)
  dir.create(dirExport, showWarnings = FALSE, recursive = TRUE)
  fileExport <- file.path(dirExport, "index.md")
  con <- file(fileExport, "w")
  cat("---\n", file = con)
  yaml::write_yaml(output[[i]], file = con)
  cat("---\n\n", file = con, append = TRUE)
  close(con)
}

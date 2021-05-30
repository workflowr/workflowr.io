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
    platform = "github",
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
dir.create(dirGitHub, showWarnings = FALSE, recursive = TRUE)
sectionFileGitHub <- file.path(dirGitHub, "_index.md")
writeLines(c("---",
             "title: GitHub",
             "description: Workflowr projects hosted on GitHub",
             "---",
             ""),
           con = sectionFileGitHub)

# Existing projects
existing <- list.files(
  path = dirContent,
  pattern = "^index.md$",
  recursive = TRUE,
  full.names = TRUE
)
existing <- dirname(existing)

lastmodPrevious <- character(length = length(output))

for (i in seq_along(output)) {
  dirAccount <- file.path(dirContent, "github", output[[i]]$account)
  dir.create(dirAccount, showWarnings = FALSE, recursive = TRUE)
  fileAccount <- file.path(dirAccount, "_index.md")
  writeLines(c("---",
               sprintf("title: %s", output[[i]]$account),
               sprintf("description: Workflowr projects by %s", output[[i]]$account),
               "platform: github",
               "---",
               ""),
               con = fileAccount)

  dirProject <- file.path(dirContent, "github", output[[i]]$account, output[[i]]$title)
  dir.create(dirProject, showWarnings = FALSE, recursive = TRUE)
  fileProject <- file.path(dirProject, "index.md")
  if (file.exists(fileProject)) {
    lastmodPrevious[i] <- yaml::read_yaml(fileProject)[["lastmod"]]
  } else {
    # Choose an arbitrarily old date, prior to the existence of GitHub
    lastmodPrevious[i] <- "1900-01-01T01:01:01Z"
  }
  wio::exportYamlHeader(output[[i]], fileProject)
}

# Take screenshots for thumbnail images ---------------------------------------

# Only take a screenshot of the site has been modified since the last screenshot

message("Taking screenshots...")
lastmodCurrent <- vapply(output, function(x) x[["lastmod"]], character(1))
lastmodCurrent <- strptime(lastmodCurrent, "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
lastmodPrevious <- strptime(lastmodPrevious, "%Y-%m-%dT%H:%M:%OSZ", tz = "UTC")
newScreenshot <- lastmodCurrent > lastmodPrevious
websites <- vapply(output[newScreenshot], function(x) x[["website"]], character(1))
createThumbnailPath <- function(x) {
  file.path(dirContent, "github", x$account, x$title, "thumbnail.png")
}
thumbnails <- vapply(output[newScreenshot], createThumbnailPath, character(1))
wio::screenshot(websites, thumbnails)

# Publications ----------------------------------------------------------------

message("Creating publications...")
dirPublication <- "content/publications"
unlink(dirPublication, recursive = TRUE)
dir.create(dirPublication, showWarnings = FALSE, recursive = TRUE)
# `publications` is a triply-nested list of character vectors.
#   - platform (github)
#     - account
#       - repository
#         - DOIs
publications <- yaml::read_yaml("data/publications.yml")
for (i in seq_along(publications)) { # platforms
  platform <- names(publications)[i]
  for (j in seq_along(publications[[i]])) { # accounts
    account <- names(publications[[i]])[j]
    for (k in seq_along(publications[[i]][[j]])) { # repositories
      repository <- names(publications[[i]][[j]])[k]
      dois <- publications[[i]][[j]][[k]]
      stopifnot(is.character(dois), length(dois) > 0)
      metadata <- wio::getPublicationMetadata(dois)
      authors <- vapply(metadata, function(x) x[["author"]], character(1))
      years <- vapply(metadata, function(x) x[["year"]], numeric(1))
      publicationIds <- paste0(tolower(authors), years)
      if (any(duplicated(publicationIds))) {
        warning("Duplicated publication IDs. Need to add month and day")
      }
      for (l in seq_along(metadata)) {
        dirPublicationTerm <- file.path(dirPublication, publicationIds[l])
        dir.create(dirPublicationTerm, showWarnings = FALSE, recursive = TRUE)
        filePublication <- file.path(dirPublicationTerm, "_index.md")
        # Repair title that contains HTML
        metadata[[l]][["title"]] <- gsub("&lt;", "<", metadata[[l]][["title"]])
        metadata[[l]][["title"]] <- gsub("&gt;", ">", metadata[[l]][["title"]])
        metadata[[l]][["citation"]] <- gsub("&lt;", "<", metadata[[l]][["citation"]])
        metadata[[l]][["citation"]] <- gsub("&gt;", ">", metadata[[l]][["citation"]])
        wio::exportYamlHeader(metadata[[l]], filePublication)
      }
      fileProject <- file.path(dirContent, platform, account, repository, "index.md")
      # I have to specify the handler because yaml auto-unboxes arrays of length
      # 1, and there is no argument to prevent this behavior. This breaks the
      # "topics" field when there is only when topic.
      # https://github.com/viking/r-yaml/issues/69
      # https://github.com/rstudio/plumber/issues/390#issuecomment-477551810
      ymlProject <- yaml::read_yaml(fileProject, handlers = list(seq = function(x) x))
      ymlProject[["publications"]] <- as.list(publicationIds)
      wio::exportYamlHeader(ymlProject, fileProject)
    }
  }
}

# Cleanup ---------------------------------------------------------------------

# Remove projects not in output list
# Nuclear option: unlink(dirGitHub, recursive = TRUE)

current <- file.path(
  dirGitHub,
  vapply(output, function(x) x[["account"]], character(1)),
  vapply(output, function(x) x[["title"]], character(1))
)

remove <- existing[!existing %in% current]
if (length(remove) > 0) {
  message("Removing projects: ", paste(basename(remove), collapse = ", "))
  unlink(remove, recursive = TRUE)
}

# Remove accounts with no projects
accountsExisting <- list.files(
  path = dirGitHub,
  pattern = "^[^_]", # Don't include section index file _index.md
  include.dirs = TRUE,
  full.names = TRUE
)
accountsCurrent <- file.path(
  dirGitHub,
  vapply(output, function(x) x[["account"]], character(1))
)
accountsRemove <- accountsExisting[!accountsExisting %in% accountsCurrent]
if (length(accountsRemove) > 0) {
  message("Removing accounts: ", paste(basename(accountsRemove), collapse = ", "))
  unlink(accountsRemove, recursive = TRUE)
}

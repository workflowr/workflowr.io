---
title: Documentation
description: How to use this site
---

## Search for projects

### Organization

The projects are organized by the hosting platform, user name, and project name.
The organization is hierarchical, so each section lists the available projects
nested below it. Some concrete examples:

* [/projects/](/projects/) -
    Lists all workflowr projects available on workflowr.io
* [/projects/github/](/projects/github/) -
    Lists the workflowr projects hosted on [GitHub][]
* [/projects/github/jdblischak/](/projects/github/jdblischak/) -
    Lists the workflowr projects by [GitHub][] user [jdblischak][]
* [/projects/github/jdblischak/fucci-seq](/projects/github/jdblischak/fucci-seq) -
    Main page for workflowr project [fucci-seq][]

[GitHub]: https://github.com/
[jdblischak]: https://github.com/jdblischak/
[fucci-seq]: https://github.com/jdblischak/fucci-seq

### By topic

Some users have added topics to categorize their workflowr projects. This makes
it easier to find projects you are interested in. The most popular topics are
listed on the home page, but you can view all available topics at
[/topics/](/topics/). Clicking on a topic will take you to a page that lists all
the projects labeled with this topic, e.g. [single-cell](/topics/single-cell/).

### By publication

Some workflowr projects on workflowr.io are associated with published research.
Go to [Publications](/publications/) to view the publications with results that
are supported by a reproducible and transparent workflowr project.

### Search bar

The navigation bar contains a search bar powered by [DuckDuckGo][]. When you use
the search bar, you will be redirected to DuckDuckGo's website with the results
of your query limited to workflowr.io.

[DuckDuckGo]: https://duckduckgo.com/

## Add a project

### Install GitHub App

In order to add your workflowr project to workflowr.io, you need to install the
[workflowr.io GitHub App][github-app] for the specific repositories that you
want to share. Installing the GitHub App is quick and convenient.

[github-app]: https://github.com/apps/workflowr-io

1. Go to https://github.com/apps/workflowr-io and click Install

   {{< figure
     src="/img/docs/github-app-install.jpg"
     alt="Screenshot of GitHub App installation page"
   >}}

1. Choose the GitHub account that contains your workflowr repository

1. Do **not** install the app on all of your repositories. Instead choose "Only
   select repositories" and click on the workflowr projects you want to share on
   workflowr.io. Then click Install.

   {{< figure
     src="/img/docs/github-app-select.jpg"
     alt="Screenshot of selecting repositories to install GitHub App"
   >}}

   The permissions requested by the app are minimal. It requests read access to
   publicly available data about your repository (see the section
   [Privacy](#privacy) below for more details). It requests write access to your
   GitHub Issues. This will only be used to notify you of any problems with your
   workflowr project.

### Edit description

The description of your workflowr project is obtained from the Description section on GitHub. Whatever you type there will be reflected on workflowr.io. If your repository doesn't have a Description on GitHub, then workflowr.io creates the description using the following pattern:

> The workflowr project \<project name\> by \<user name\>

### Add topics

The topics assigned to workflowr projects on workflowr.io are obtained directly from the topics you assigned to your GitHub repository. We highly encourage you to add topics to make it easier for others to find your project both on workflowr.io and GitHub.

* [GitHub Help: Classifying your repository with topics](https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/classifying-your-repository-with-topics)

### Add a publication

The workflowr projects shared on workflowr.io are **not** required to be
associated with a publication. However, if your workflowr project did result in
a publication, please share! All you need to provide is the [DOI][].

[DOI]: https://en.wikipedia.org/wiki/Digital_object_identifier

Please [open an Issue on GitHub][issue-publication] to provide the DOI for the
publication and the associated project(s).

[issue-publication]: https://github.com/workflowr/workflowr.io/issues/new/choose

### Remove a project

To remove one of your projects from workflowr.io, you can uninstall the
[workflowr.io GitHub App][github-app] from the repository.

There are two ways you can access the configuration for the GitHub App:

* Go the the Settings for the repository and then navigate to the menu for Integrations

* From your user home page, go to Settings and then navigate to Applications

Regardless of which method you used, next click Configure for the workflowr.io
GitHub App. You can choose to uninstall the app for one or more repositories by
clicking on the `X` next to their name. To remove the app from all the your
repositories it was installed on, click the button at the very bottom to
uninstall the app from your account.

## About this site

### Purpose

The goal of the [workflowr][] R package is to make your data analysis projects
more organized, reproducible, and shareable. The purpose of workflowr.io is to
increase the discoverability of workflowr projects. Currently, most readers will
find your workflowr website only if you directly send them the URL or if you
include the URL in your published manuscript. By curating workflowr projects,
workflowr.io makes it easier for other interested readers to find your
reproducible results. In essence, it is promoting transparency and openness.

[workflowr]: https://jdblischak.github.io/workflowr/

None of the workflowr projects are actually hosted on workflowr.io. Instead, it
is a centralized directory of available projects to explore. The individual
project pages provide links to the website and source Git repository.

### Update frequency

This site is updated every X hours. If you (un)install the GitHub app or make
any changes to your project, please check back in a few hours to see the update
take effect.

### Technology

This site was made possible by many different technologies. Highlighting a few
of them:

* [Bulma](https://bulma.io/) - CSS framework
* [DuckDuckGo](https://duckduckgo.com/) - Search bar
* [GitHub API](https://docs.github.com/v3/) - Obtain metadata on workflowr projects hosted on GitHub
* [Hugo](https://gohugo.io/) - Static site generator
* [Netlify][] - Deploy and host site
* [R](https://www.r-project.org/) - Data management
* [TinyPNG](https://tinypng.com/) - Image compression

[Netlify]: https://www.netlify.com/

### Funding

The [workflowr][] project is grateful for support from the [Moore
Foundation][moore] and the [University of Chicago][uchicago].

[moore]: https://www.moore.org/
[uchicago]: https://www.uchicago.edu/

### Privacy

> **tl;dr** We don't collect any data on you.

#### For site visitors

We don't collect any data on you. We don't store any cookies. In fact, there
isn't even any JavaScript running on this site.

If you use the search bar, you will be taken to
[duckduckgo.com](https://duckduckgo.com/). However, they are a
[privacy-conscious company](https://duckduckgo.com/about), and they do not store
your search queries or track you.

The website is hosted on [Netlify][] servers. We have no reason to believe they
collect any personal information from you. See their [Terms of Use
Agreement][netlify-toc] for more details.

[netlify-toc]: https://www.netlify.com/legal/terms-of-use/

#### For workflowr users

The [workflowr.io GitHub App][github-app] only accesses publicly available data
for your GitHub repository. In other words, any data displayed on workflowr.io
is also easily accessible by browsing GitHub or querying publicly accessible
endpoints of their API.

## Miscellaneous

### Getting started with workflowr

To start using workflowr, the best place to start is to go through the [Getting
started vignette][getting-started]. This will take you from zero to deploying a
website. Once you are comfortable with the basics of the workflowr framework,
you can read through the other [vignettes][]. For example, if you already have
an existing project that you would like to migrate to use workflowr, read
[Migrating an existing project to use workflowr][migrating].

[getting-started]: https://jdblischak.github.io/workflowr/articles/wflow-01-getting-started.html
[vignettes]: https://jdblischak.github.io/workflowr/articles/index.html
[migrating]: https://jdblischak.github.io/workflowr/articles/wflow-03-migrating.html

### Support for GitLab

Not yet. The initial launch of workflowr.io only supports GitHub because it is
the most popular service for hosting workflowr projects. However, since
workflowr also supports [hosting projects on GitLab][hosting-with-gitlab], we
plan to add support for public repositories hosted on [GitLab][].

[GitLab]: https://about.gitlab.com/
[hosting-with-gitlab]: https://jdblischak.github.io/workflowr/articles/wflow-06-gitlab.html

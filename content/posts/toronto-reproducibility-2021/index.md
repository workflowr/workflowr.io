---
title: 2021 Toronto Workshop on Reproducibility
date: 2021-03-07T22:00:00-05:00
author: John Blischak
authorLink: https://jdblischak.com/
description: "First public presentation on workflowr.io"
toc: false
---

A little over a week ago I had the opportunity to attend and present at the
[Toronto Workshop on Reproducibility][toronto]. It was a full 2 days packed with
talks on various aspects of reproducbility: metascience, case studies, software
tools, etc. [Rohan Alexander][rohan] and his colleagues at the University of
Toronto did a great job organizing the ambitious online event. Not only did the
event go smoothly (despite the attempts of my web cam to sabotage my
presentation, as you'll see below), but the recordings were edited and posted to
YouTube almost immediately!

[rohan]: https://twitter.com/RohanAlexander
[toronto]: https://rohanalexander.com/reproducibility

In my talk I explained how the R package [workflowr][] helps you make your data
analysis projects more organized, reproducible, and shareable. Most exciting for
me was that this was the first time I was able to include [workflowr.io][] in a
public presentation.

[workflowr]: https://github.com/workflowr/workflowr
[workflowr.io]: https://workflowr.io

{{< youtube id="RrcaGukYDyE" title="Facilitating reproducible and open research with workflowr and workflowr.io" >}}

As always, my slides are available for reuse and remixing with attribution under
the [CC-BY][] license. Check out the repository [workflowr-presentations][] to
access the slides for this and past presentations.

[CC-BY]: https://creativecommons.org/licenses/by/4.0/
[workflowr-presentations]: https://github.com/workflowr/workflowr-presentations

I also want to highlight a few of the other talks that I found interesting, with
a focus on software tools for reproduciblity:

* [Meghan Hoyer](https://twitter.com/meghanhoyer) and [Larry
  Fenn](https://apnews.com/article/1382560004) presented [Project organization
  with DataKit](https://youtu.be/FFwMfNk83rc).
  [DataKit](https://datakit.ap.org/) provides project templates for data
  analysis projects and also provides functionality to integrate version
  control.

* [Julia Schulte-Cloos](https://jschultecloos.github.io/) presented on her new R
  package [reproducr](https://github.com/jschultecloos/reproducr), which
  provides an extensive custom R Markdown output format makes it easier for
  researchers to write their manuscripts reproducibly.

* [Simeon Carstens](http://simeon-carstens.com/) presented [Reproducible
  software environments for data analysis with
  Nix](https://youtu.be/fpoFzDvrJAA). [Nix](https://nixos.org/) is a purely
  functional package manager, which is a different approach than other package
  managers you may be familiar with (e.g. APT, conda, renv). It provides lots of
  reprocibility guarantees, a large collection of packages ready to install,
  integration with Docker, and more. Check out his [demo
  project](https://github.com/tweag/toronto_reproducibility_workshop) to learn
  more.

# workflowr.io

workflowr.io curates reproducible research projects supported by the R package
[workflowr][]

[workflowr]: https://github.com/workflowr/workflowr/

## Setup

```sh
# install hugo (requires extended version)
sudo apt install hugo

# clone
git clone https://github.com/workflowr/workflowr.io.git
cd workflowr.io/

# pull the bulma submodule
git submodule update --init

# build and serve site
hugo serve

# open in browser
firefox http://localhost:1313/
```

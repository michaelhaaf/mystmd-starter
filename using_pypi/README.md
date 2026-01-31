# using pypi mystmd instructions

## Setup

If using nix:

```shell
$ nix develop
```

Otherwise, install `mystmd` using a python virtual environment, and `typst` however you see fit.

## `myst build --pdf` from project root

```
$ myst build --pdf
building myst-cli session with API URL: https://api.mystmd.org
...<logs redacted>...
🖨  Rendering typst pdf to subdirectory/example_project_path.pdf
🖨  Rendering typst pdf to subdirectory/example_relative_path.pdf
```

## `myst build --pdf` from subdirectory

```
$ cd subdirectory
$ myst build --pdf
building myst-cli session with API URL: https://api.mystmd.org
...<logs redacted>...
🖨  Rendering typst pdf to example_relative_path.pdf
Error: Problem with template link "https://api.mystmd.org/templates/typst/_template/local-lapreprint-typst": 404 Not Found

To list valid templates, try the command "myst templates list"
```

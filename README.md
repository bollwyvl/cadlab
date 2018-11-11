# cadlab: Building a portable, interactive, computational geometry environment

## Build It
Get [Miniconda][]. Install [anaconda-project][].

On OSX/Linux, run:
```bash
anaconda-project run build
anaconda-project run test
```

On Windows, run:
```bash
anaconda-project run build:win
anaconda-project run test:win
```

### cadlab
While still pre-`1.0`, JupyterLab's build chain has some negative externalities
for end users, namely an install- or run-time dependency on NodeJS and npmjs.org
when using any labextensions other than the built in set (e.g. Notebook, Terminal,
Console, Editor, etc.). Because, we want to get to the Good Stuff of running
CAD notebooks and not spend a bunch of time debugging `nodejs` and `webpack`,
we've added a few choice JupyterLab extensions:

- `@jupyterlab/toc`: a table of contents pane for Markdown headers
- `@jupyter-widgets/jupyterlab-manager`: because widgets are always good
- `bqplot`: for interactive 2d visualizations
- `jupyter-threejs`: for interactive 3d geometry

...and wrapped them into a conda package which exposes some command, which can
do most of the things `jupyter lab` can do.

`cadlab` works like `jupyter lab`, while `cadlab-extension` works like
`jupyter labextension`. This isn't a toy installation: with the bundled `nodejs`,
an intrepid user can still install any of the [labextensions][] that are
compatible with the version `cadlab` was built with: as of writing, `0.35.x`.

## [constructor][]
All of the dependencies are captured in [construct.yaml.in][]. In addition to
everything mentioned above, you'll also find:

In addition, to support the workshop, a number of libraries are included:
- `SeleniumLibrary` for controlling browsers
  - `geckodriver` for interacting with Firefox
  - `python-chromedriver-binary` for interacting with Chrome & Chromium
  - > Note: it's pretty easy to get `webdriver` for Edge, but can't be redistributed
- `opencv` for doing image-driven testing
- `robotframework-lint` for normalizing your robot syntax


[anaconda-project]: https://github.com/anaconda-platform/anaconda-project
[conda-forge]: https://github.com/conda-forge
[conda]: https://github.com/conda/conda
[constructor]: https://github.com/conda/constructor
[construct.yaml.in]: ./constructor/construct.yaml.in
[labextensions]: https://www.npmjs.com/search?q=keywords:jupyterlab-extension
[Miniconda]: https://conda.io/miniconda.html

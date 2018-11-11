import sys

from . import (
    CONDA_OUT,
    RECIPE_DIR,
    CONSTRUCT_IN,
    CONSTRUCT,
    CONSTRUCT_OUT,
    CONSTRUCT_CACHE,
    CONSTRUCT_DIR,
    PY_MIN,
    PY_MAX,
    NODE_MIN,
    NODE_MAX,
    RF_VERSION,
    VERSION,
    run,
)


def build_conda(packages=None):
    """ Build some packages (mostly re-arching conda-forge `noarch: python`)
    """

    if not packages:
        packages = ["."]

    for package in packages:
        rc = run(
            [
                "conda-build",
                package,
                "--output-folder",
                CONDA_OUT,
                "-c",
                "https://repo.anaconda.com/pkgs/main",
                "-c",
                "https://repo.anaconda.com/pkgs/free",
                "-c",
                "https://conda.anaconda.org/conda-forge",
                "--skip-existing",
                "--python",
                PY_MIN,
            ],
            cwd=str(RECIPE_DIR),
        )
        if rc:
            return rc

    return 0


def build_constructor():
    """ Use the local build artifacts in constructor

        Care should be taken to avoid `noarch: python` packages
    """
    construct = CONSTRUCT_IN.render(
        build_channel=CONDA_OUT.as_uri(),
        py_min=PY_MIN,
        py_max=PY_MAX,
        node_min=NODE_MIN,
        node_max=NODE_MAX,
        rf_version=RF_VERSION,
        version=VERSION,
    )

    CONSTRUCT.write_text(construct)

    CONSTRUCT_OUT.mkdir(exist_ok=True)

    return run(
        [
            "constructor",
            ".",
            "--output-dir",
            str(CONSTRUCT_OUT),
            "--cache-dir",
            str(CONSTRUCT_CACHE),
            "--verbose",
        ],
        cwd=str(CONSTRUCT_DIR),
    )


if __name__ == "__main__":
    if len(sys.argv) > 1:
        if sys.argv[1] == "conda":
            sys.exit(build_conda(sys.argv[2:]))
        elif sys.argv[1] == "constructor":
            sys.exit(build_constructor())

    if build_conda() == 0:
        sys.exit(build_constructor())
    sys.exit(1)

import sys
import os
from pathlib import Path

from ._version import __version__  # noqa


CADLAB_PATH = Path(sys.prefix) / "share" / "jupyter" / "cadlab"


def patch_app_dir(app_klass):
    app_klass.app_dir = os.environ["JUPYTERLAB_DIR"] = str(CADLAB_PATH)
    return os.environ["JUPYTERLAB_DIR"]

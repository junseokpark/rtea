project = "rTea"
author = "Junseok Park"
copyright = "2024, Junseok Park"
release = "1.0.0"

extensions = [
    "myst_parser",
    "sphinx_copybutton",
]

templates_path = ["_templates"]
exclude_patterns = ["_build"]

html_theme = "sphinx_rtd_theme"
myst_enable_extensions = ["colon_fence"]
source_suffix = [".md", ".rst"]

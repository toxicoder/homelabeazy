"""Utility functions."""

import re


def to_snake_case(name: str) -> str:
    """Converts a string to snake_case."""
    if name is None:
        return ""
    name = re.sub(r"([A-Z])", r"_\1", name).lower()
    if name.startswith("_"):
        name = name[1:]
    return name.replace("-", "_").replace("__", "_")

load("//3rdparty/python:pip.bzl", "pip_import")

def pip_requirements(name, requirements):
    """Shortcut for `pip_import`"""
    pip_import(
        name = name,
        python_runtime = "@python_runtime//:python3/bin/python3",
        python_libs = "@python_runtime//:python3/lib/python3.6",
        requirements = requirements,
    )

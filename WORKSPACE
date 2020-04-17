workspace_name = "WayveCode"

workspace(name = workspace_name)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load(
    "//3rdparty/python:python.bzl",
    "pip_requirements",
)

http_archive(
    name = "python_runtime",
    build_file = "//3rdparty/python:python_runtime.BUILD",
    sha256 = "7d56dadf6c7d92a238702389e80cfe66fbfae73e584189ed6f89c75bbf3eda58",
    strip_prefix = "Python-3.6.6",
    urls = ["https://www.python.org/ftp/python/3.6.6/Python-3.6.6.tgz"],
)

register_toolchains("//3rdparty/python:python3_toolchain_noopt_default")
# Core python dependencies are in `@pip-core`
pip_requirements(
    name = "pip-core",
    requirements = "//:requirements.txt",
)

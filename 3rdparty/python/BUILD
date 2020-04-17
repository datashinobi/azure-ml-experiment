py_runtime(
    name = "python3",
    files = [
        "@python_runtime//:python3/bin/python3",
        "@python_runtime//:python3/lib/python3.6",
    ],
    interpreter = "@python_runtime//:python3/bin/python3",
    python_version = "PY3",
    visibility = ["//visibility:public"],
)

load("@bazel_tools//tools/python:toolchain.bzl", "py_runtime_pair")

py_runtime_pair(
    name = "python3_runtime",
    py3_runtime = ":python3",
)

alias(
    name = "py3",
    actual = ":python3",
    visibility = ["//visibility:public"],
)

alias(
    name = "p3",
    actual = ":python3",
    visibility = ["//visibility:public"],
)

toolchain(
    name = "python3_toolchain_noopt_default",
    toolchain = ":python3_runtime",
    toolchain_type = "@bazel_tools//tools/python:toolchain_type",
)

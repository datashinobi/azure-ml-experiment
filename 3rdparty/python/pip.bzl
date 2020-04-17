"""Import pip requirements at build time"""

def _pip_import_impl(repository_ctx):
    repository_ctx.file("util.bzl", """
def clean_python_envs(pythonpath = ""):
    return ("PYTHONSTARTUP= " +
            "PYTHONPATH={} ".format(pythonpath) +
            "PYTHONCASEOK= " +
            "PYTHONIOENCODING= " +
            "PYTHONFAILUREHANDLER= " +
            "PYTHONHASHSEED= ")
""")

    result = repository_ctx.execute([
        "cat",
        repository_ctx.path(repository_ctx.attr.requirements),
    ])

    requirements = {
        _get_package_name(spec): spec
        for spec in result.stdout.split("\n")
        if spec.strip() and not spec.startswith("#")
    }

    rules = [
        '''
genrule(
    name = "{name}--pip-install",
    srcs = {deps},
    cmd = """
export CC="$$(realpath --no-symlinks $(CC)) -pthread"
export CXX="$$(realpath --no-symlinks $(CC))++ -pthread"
export LD=$$CC
export LDSHARED="$$CC -shared"

# We want to clean the dummy home regardless of whether the install fails
set +e
""" + clean_python_envs("$(location {python_libs})") + """ \
  $$(realpath $(location {python})) -m \
  pip install \
  --no-cache-dir \
  --disable-pip-version-check \
  --no-build-isolation \
  --target=$@ \
  {spec}
EXIT_CODE=$$?

set -e

exit $$EXIT_CODE
""",
    outs = ["pip__{name}"],
    tools = ["{python}", "{python_libs}"],
    toolchains = [
        "@bazel_tools//tools/cpp:current_cc_toolchain",
        ":cc_flags",
    ],
)
py_library(
    name = "{name}",
    data = {deps} + ["pip__{name}"],
    imports = ["pip__{name}"],
    visibility = ["//visibility:public"],
)
'''.format(
            spec = spec,
            name = name,
            python = repository_ctx.attr.python_runtime,
            python_libs = repository_ctx.attr.python_libs,
            deps = [],
        )
        for name, spec in requirements.items()
    ]

    all_requirements = [
        name
        for name, spec in requirements.items()
        if 'exclude-from-all' not in spec
    ]

    rules.append("""
filegroup(
    name = "all_pip_installs",
    srcs = {},
    visibility = ["//visibility:public"],
)
""".format(["pip__" + name for name in all_requirements]))

    rules.append("""
py_library(
    name = "all_requirements",
    deps = {},
    visibility = ["//visibility:public"],
)
""".format(all_requirements))

    build_file_content = """
load("//:util.bzl", "clean_python_envs")

# Target that can provide the CC_FLAGS variable based on the current
# cc_toolchain.
load("@bazel_tools//tools/cpp:cc_flags_supplier.bzl", "cc_flags_supplier")
cc_flags_supplier(name = "cc_flags")


{rules}
""".format(rules = "\n".join(rules))

    repository_ctx.file("BUILD", build_file_content)

pip_import = repository_rule(
    attrs = {
        # pip `requirements.txt` file describing requirements
        "requirements": attr.label(
            allow_single_file = [".txt"],
            mandatory = True,
        ),
        # Python runtime
        "python_runtime": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "target",
        ),
        # Python runtime
        "python_libs": attr.label(
            mandatory = True,
        ),
    },
    implementation = _pip_import_impl,
)

def _get_package_name(spec):
    """
    Given a line from a requirements.txt file, return the name of the desired
    python package
    """
    return spec.split("==")[0]

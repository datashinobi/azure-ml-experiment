"""BUILD file for external python_runtime repository"""

# Target that can provide the CC_FLAGS variable based on the current
# cc_toolchain.
load("@bazel_tools//tools/cpp:cc_flags_supplier.bzl", "cc_flags_supplier")
cc_flags_supplier(name = "cc_flags")

genrule(
    name = "build_python",
    srcs = glob(["**"]),
    outs = [
        "python3/include",
        "python3/lib/python3.6",
        "python3/lib/libpython3.6m.a",
        "python3/bin/python3",
    ],
    cmd = """
PREFIX=$(@D)/python3
mkdir -p $$PREFIX

# C build options
# N.B. `realpath` is necessary here
export CC=$$(realpath --no-symlinks $(CC))

# PIC is required to link when building shared libraries
export CFLAGS="$(CC_FLAGS) -fPIC -Wno-unreachable-code -Wno-null-pointer-arithmetic -Wno-macro-redefined"

# --enable-optimizations (which is worth it), requires `llvm-profdata` to be on
# PATH, we should be able to find it in the same directory as `clang` itself
export PATH=$$(realpath $$(dirname $(CC)))$${PATH+":"}$${PATH-}

sh $(location :configure) \
  --prefix=$$(realpath $$PREFIX) \
  --with-lto \
  --enable-optimizations > /dev/null
make install -s -j8 > /dev/null

# Bazel doesn't like symlinks here, so just copy the executable over the symlink
rm -f $(location python3/bin/python3)
cp -L $$PREFIX/bin/python3.6 $(location python3/bin/python3)

LOCAL_PYTHON="$(location python3/bin/python3)"

""",
    visibility = ["//visibility:public"],
    toolchains = [
        "@bazel_tools//tools/cpp:current_cc_toolchain",
        ":cc_flags",
    ],
)

# This is the only generated header file. It is necessary to specify it
# separately for the `dev` library below
genrule(
    name = "config_python",
    srcs = [":python3/include"],
    outs = ["pyconfig.h"],
    cmd = "cp $(location :python3/include)/python3.6m/pyconfig.h $@",
)

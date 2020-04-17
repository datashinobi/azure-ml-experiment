py_binary(
    name = "training",
    srcs = ["training.py"],
    data = [
        ":configs",
    ],
    main = "training.py",
    deps = [
        "@pip-core//:numpy",
        "@pip-core//:pandas",
        "@pip-core//:pyyaml",
    ],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "configs",
    srcs = glob(["config/*.yaml"]),
    visibility = ["//visibility:public"],
)
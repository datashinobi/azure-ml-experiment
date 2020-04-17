# azure-ml-experiment
This is me playing around with Azure ML

# How to run 

## Requisite

The following utils need to be installed
- docker
- make
- bazelisk

# Run in docker

## Build

`make build`

## Run
`make run`

# Run from workstation

`bazel build //...`
`bazel run //:training`
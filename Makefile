build:
	docker build -t azure-test .

run: 
	docker run azure-test bazel run //:training

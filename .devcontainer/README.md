To rebuild the Docker image, use the following command from the top source directory:

docker.exe build -t jetturney/code-dev:latest -f .\.devcontainer\base.Dockerfile .

or

docker build -t jetturney/code-dev:latest -f .devcontainer/base.Dockerfile .

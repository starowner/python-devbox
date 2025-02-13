# Docker of Python Devlopment Box

This repository contains the configuration and code to build and publish a Docker image for a Python development environment.

## Docker Image

The Docker image is built and published using GitHub Actions. The image is hosted on GitHub Container Registry.

### Build and Publish

The Docker image is automatically built and published when changes are pushed to the `main` branch.

### Workflow

The workflow is defined in the `.github/workflows/docker-build.yml` file.

## Dockerfile

The Dockerfile is used to create the Docker image. It is based on `python:3.10-slim` and includes the following features:

- Installs `openssh-server`, `git`, and `sudo`.
- Configures SSH server.
- Copies an entrypoint script to the container.
- Exposes SSH port 22.
- Sets environment variables for user configuration.

### Environment Variables in Dockerfile

- `USER_NAME`: New user's username (required).
- `USER_PASSWORD`: New user's password (required).
- `GIT_NAME`: Git user's name (required).
- `GIT_EMAIL`: Git user's email (required).
- `SSH_PUB`: New user's SSH public key (optional).
- `APT_PACKAGES`: Optional APT packages to install, space-separated (optional).
- `PYTHON_PACKAGES`: Python modules to install, space-separated (optional).

## Usage

To use the Docker image, pull it from the GitHub Container Registry:

```sh
docker pull ghcr.io/starowner/python-devbox:latest
```

### Running the Container

To run the container with the necessary environment variables:

```sh
docker run -d \
  -p 22:22 \
  -e USER_NAME=<username> \
  -e USER_PASSWORD=<password> \
  -e SSH_PUB=<ssh-public-key> \
  -e GIT_NAME=<git-name> \
  -e GIT_EMAIL=<git-email> \
  -e APT_PACKAGES="<optional-APT-packages>" \
  -e PYTHON_PACKAGES="<optional-python-packages>" \
  ghcr.io/starowner/python-devbox:latest
```

## License

This project is licensed under the MIT License.
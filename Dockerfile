# Use python:3.10-slim as the base image
FROM python:3.10-slim

USER root

# Update package list and install openssh-server and git
RUN apt-get update && \
    apt-get install -y openssh-server git sudo && \
    rm -rf /var/lib/apt/lists/*

# Create directory needed for SSH service
RUN mkdir /var/run/sshd

# Disable root login via SSH
RUN echo 'PermitRootLogin no' >> /etc/ssh/sshd_config

# Copy entrypoint script to the container and set permissions
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose SSH port
EXPOSE 22

# Set environment variables, default values are empty
ENV USER_NAME=""
ENV USER_PASSWORD=""
ENV GIT_NAME=""
ENV GIT_EMAIL=""
# Optional, default values are empty
ENV SSH_PUB=""
ENV APT_PACKAGES=""
ENV PYTHON_PACKAGES=""

# Environment variable descriptions
# USER_NAME: New user's username (required)
# USER_PASSWORD: New user's password (required)
# GIT_NAME: Git user's name (required)
# GIT_EMAIL: Git user's email (required)
# SSH_PUB: New user's SSH public key (optional)
# APT_PACKAGES: APT packages to install, space-separated (optional)
# PYTHON_PACKAGES: Python modules to install, space-separated (optional)

# Set the command to run when the container starts
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
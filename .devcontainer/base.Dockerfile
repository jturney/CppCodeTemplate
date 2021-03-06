FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-21.04

# This Dockerfile's base image has a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container's GID/UIDs will be
# updated to match your local UID/GID (when using the dockerfile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    #
    # Install C++ tools
    && apt-get -y install \
    build-essential \
    git \
    ninja-build \
    ccache \
    zsh \
    libblas-dev \
    liblapack-dev \
    libhdf5-serial-dev \
    hdf5-tools \
    #
    # [Optional] Update UID/GID if needed
    && if [ "${USER_GID}" != "1000"] || [ "${USER_UID}" != "1000" ]; then \
    groupmod --gid ${USER_GID} ${USERNAME} \
    && usermod --uid ${USER_UID} --gid ${USER_GID} ${USERNAME} \
    && chown -R ${USER_UID}:${USER_GID} /home/${USERNAME}; \
    fi

# Obtain a newer version of CMake from kitware directly.
RUN apt-get update \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null \
    && echo "deb https://apt.kitware.com/ubuntu/ focal main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install cmake

# Obtain a newer version of LLVM and Clang from the LLVM developers directly.
RUN apt-get update \
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add - \
    && echo "deb http://apt.llvm.org/hirsute/ llvm-toolchain-hirsute main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install \
    clang-format clang-tidy clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 libllvm-ocaml-dev libomp-dev libomp5 lld llvm-dev llvm-runtime llvm

# Cleanup the image
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

USER vscode

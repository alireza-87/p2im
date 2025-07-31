# P2IM Docker Environment
# Based on Ubuntu 16.04 as specified in the README
FROM ubuntu:16.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update package lists and install essential dependencies
RUN apt-get update && apt-get install -y \
    # Build essentials for compiling AFL
    build-essential \
    gcc \
    g++ \
    make \
    # Python and related tools
    python3 \
    python3-pip \
    python3-dev \
    # Git for cloning submodules
    git \
    # Additional dependencies mentioned in QEMU build docs
    curl \
    automake \
    texinfo \
    unzip \
    # Common utilities
    wget \
    vim \
    nano \
    # Libraries that might be needed for QEMU
    libc6-dev \
    zlib1g-dev \
    libpixman-1-dev \
    libfdt-dev \
    libglib2.0-dev \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy the entire P2IM repository
COPY . .

# Make ARM toolchain executable and add to PATH
ENV PATH="/app/gcc-arm-none-eabi-10.3-2021.10/bin:${PATH}"

# Verify ARM toolchain installation
RUN arm-none-eabi-gcc --version

# Clean any existing AFL binaries and compile from source
RUN cd /app/afl && make clean && make


# Initialize git submodules (for external firmware and ground truth data)
RUN git submodule update --init

# Verify that all essential tools are working
RUN echo "=== Verification ===" && \
    echo "AFL compilation:" && ls -la /app/afl/afl-fuzz && \
    echo "QEMU binary:" && ls -la /app/qemu/precompiled_bin/qemu-system-gnuarmeclipse && \
    echo "ARM toolchain:" && arm-none-eabi-objdump --version | head -1 && \
    echo "Python scripts:" && ls -la /app/model_instantiation/*.py && \
    echo "=== Setup Complete ==="

# Default command
CMD ["/app/start_p2im.sh"]

# Expose any ports that might be needed for debugging (GDB default port)
EXPOSE 9000

# Add helpful labels
LABEL version="1.0"
LABEL description="P2IM - Scalable and Hardware-independent Firmware Testing"
LABEL maintainer="P2IM"

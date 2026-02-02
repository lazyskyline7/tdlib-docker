# Build stage
FROM debian:bookworm AS builder

ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        make zlib1g-dev libssl-dev gperf php-cli cmake clang libc++-dev libc++abi-dev libclang-rt-14-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy the source code
COPY . /td

# Set the working directory
WORKDIR /td/build

# Set environment variables for clang
ENV CXXFLAGS="-stdlib=libc++"
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++

# Configure and build the project. Use cache for build tools (CMake, compilers).
RUN --mount=type=cache,target=/root/.cache \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local ..
RUN --mount=type=cache,target=/root/.cache /bin/sh -lc '\
    PARALLEL=$(nproc) && \
    if [ "$PARALLEL" -gt 1 ]; then PARALLEL=$((PARALLEL-1)); fi && \
    # Extract major and minor from cmake version using sed to avoid complex awk quoting
    set -- $(cmake --version | head -n1 | sed -E '\''s/[^0-9]*([0-9]+)\.([0-9]+).*/\1 \2/'\'') && \
    MAJOR=$1 && MINOR=$2 && \
    if [ "$MAJOR" -gt 3 ] || { [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 12 ]; }; then \
      cmake --build . --parallel $PARALLEL --target install; \
    else \
      cmake --build . --target install -- -j$PARALLEL; \
    fi'

# Final stage
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl3 zlib1g libc++1 && \
    ldconfig && \
    rm -rf /var/lib/apt/lists/*

# Copy the built libraries/binaries from the builder stage
COPY --from=builder /usr/local /usr/local

# Create a non-root user for runtime and fix ownership
RUN groupadd -r app && useradd -r -g app app && chown -R app:app /usr/local

# Strip unneeded symbols to reduce image size (no-op if strip not present)
RUN find /usr/local/bin -type f -executable -exec strip --strip-unneeded {} + || true

# Ensure /usr/local/bin is in PATH and run as non-root
ENV PATH="/usr/local/bin:${PATH}"
USER app

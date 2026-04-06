# Build stage
FROM alpine:3.21 AS builder

# Install build dependencies
RUN apk add --no-cache \
    make zlib-dev openssl-dev gperf php83 cmake clang libc++-dev \
    compiler-rt linux-headers llvm-libunwind-dev

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
    cmake --build . --parallel $PARALLEL --target install'

# Strip debug symbols and remove static libs, headers, cmake files
RUN find /usr/local/lib -type f -name '*.so*' -exec strip --strip-unneeded {} + || true && \
    find /usr/local/lib -type f -name '*.a' -delete && \
    rm -rf /usr/local/include /usr/local/lib/cmake

# Final stage
FROM alpine:3.21

# Install only runtime dependencies
RUN apk add --no-cache libssl3 zlib libc++ libgcc llvm-libunwind

# Create a non-root user for runtime
RUN addgroup -S app && adduser -S app -G app

# Copy only the shared library from the builder stage
COPY --from=builder --chown=app:app /usr/local/lib/libtdjson.so* /usr/local/lib/

# Update linker cache with newly copied libraries
RUN ldconfig /usr/local/lib || true

# Ensure /usr/local/bin is in PATH and run as non-root
ENV PATH="/usr/local/bin:${PATH}"
USER app

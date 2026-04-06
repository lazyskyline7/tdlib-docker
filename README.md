# TDLib Docker Image

![TDLib Version](https://img.shields.io/badge/TDLib-1.8.63-blue)
[![Docker Pulls](https://img.shields.io/docker/pulls/lazyskyline/tdlib)](https://hub.docker.com/r/lazyskyline/tdlib)
[![Image Size](https://img.shields.io/docker/image-size/lazyskyline/tdlib/latest)](https://hub.docker.com/r/lazyskyline/tdlib)
[![Deployment](https://github.com/lazyskyline7/tdlib-docker/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/lazyskyline7/tdlib-docker/actions/workflows/build-and-push.yml)

Pre-built, multi-arch Docker image for [TDLib (Telegram Database Library)](https://core.telegram.org/tdlib) — ready to use as a base for Telegram client applications.

| | |
|---|---|
| **Image** | [`lazyskyline/tdlib`](https://hub.docker.com/r/lazyskyline/tdlib) |
| **Architectures** | `linux/amd64`, `linux/arm64` |
| **Base** | `debian:bookworm-slim` |
| **Compressed Size** | ~62 MB |

## Quick Start

```sh
docker pull lazyskyline/tdlib
```

Use as a base image for your TDLib application:

```dockerfile
FROM lazyskyline/tdlib:latest
COPY your-app /app
CMD ["/app/your-app"]
```

Or mount your project directly:

```sh
docker run --rm -v $(pwd):/src lazyskyline/tdlib
```

## Tags

- `latest` — latest stable build
- `1.8.x` — specific TDLib version (see [all tags](https://hub.docker.com/r/lazyskyline/tdlib/tags))

## What's Included

The image contains pre-built TDLib libraries and binaries installed to `/usr/local`, built with clang/libc++ and stripped for minimal size. Runtime dependencies only (libssl, zlib, libc++).

## Resources

- [TDLib Documentation](https://core.telegram.org/tdlib)
- [TDLib Examples](https://github.com/tdlib/td/tree/master/example)
- [Source & Issues](https://github.com/lazyskyline7/tdlib-docker)

## License

TDLib is licensed under the [Boost Software License](http://www.boost.org/LICENSE_1_0.txt).

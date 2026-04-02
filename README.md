# TDLib Docker Image

![TDLib Version](https://img.shields.io/badge/TDLib-1.8.62-blue)
[![Docker Pulls](https://img.shields.io/docker/pulls/lazyskyline/tdlib)](https://hub.docker.com/repository/docker/lazyskyline/tdlib)
[![Deployment](https://github.com/lazyskyline7/tdlib-docker/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/lazyskyline7/tdlib-docker/actions/workflows/build-and-push.yml)

This repository provides a Docker image for [TDLib (Telegram Database Library)](https://core.telegram.org/tdlib), enabling easy and reproducible builds and deployments of TDLib in containerized environments.

## DockerHub

- **Image:** [`lazyskyline/tdlib`](https://hub.docker.com/repository/docker/lazyskyline/tdlib)

## What is TDLib?

TDLib is a cross-platform library for building [Telegram](https://telegram.org) clients. It provides a high-performance, fully asynchronous, and well-documented API for interacting with Telegram.

For full documentation, see the [TDLib docs](https://core.telegram.org/tdlib).

## Features

- Cross-platform (Linux, macOS, Windows, Android, iOS, etc.)
- Multilanguage support (C++, Java, .NET, JSON interface for any language)
- High-performance and reliable
- Secure and fully asynchronous
- Well-documented API

## Usage

### Pull the Image

```sh
docker pull lazyskyline/tdlib
```

### Run TDLib in a Container

```sh
docker run --rm lazyskyline/tdlib
```

You can mount your source code or data as needed:

```sh
docker run --rm -v $(pwd):/src lazyskyline/tdlib
```

### Example: Build TDLib from Source

This image is designed for building and running TDLib. You can use it as a build environment or as a runtime for TDLib-based applications.

## Supported Tags

- `latest`: Latest stable build
- See DockerHub for more tags

## Documentation & Examples

- [TDLib Official Documentation](https://core.telegram.org/tdlib)
- [TDLib Examples](https://github.com/tdlib/td/tree/master/example)

## License

TDLib is licensed under the Boost Software License. See [LICENSE_1_0.txt](http://www.boost.org/LICENSE_1_0.txt) for details.

---

For questions or issues, please open an issue on GitHub or see the [TDLib documentation](https://core.telegram.org/tdlib).

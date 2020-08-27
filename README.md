# Ubuntu based Membrane Docker image

[![Docker Pulls](https://img.shields.io/docker/pulls/membrane/membrane)][docker-hub]
[![GitHub forks](https://img.shields.io/github/forks/membraneframework/docker-membrane?style=social)][github]

A Docker image based on Ubuntu, with Erlang, Elixir and libraries necessary to test and run the [Membrane Framework].

## Image variants

This image comes in many flavours, based on different Ubuntu releases and package versions:

- `latest`, `focal` - based on Ubuntu 20.04
- `bionic` - based on Ubuntu 18.04, **deprecated**

## Package versions

| Package   | bionic        | focal  |
| --------- | ------------- | ------ |
| Erlang    | 21.3 and 22.2 | 22.3   |
| Elixir    | 1.9.4         | 1.10.3 |
| FFmpeg    | 4.2.2         | 4.2.2  |
| SDL2      | ?             | ?      |
| FDK AAC   | 2.0           | 2.0    |
| Portaudio | 19.6.0        | 19.6.0 |
| MAD       | 0.15.1        | 0.15.1 |
| FLAC      | 1.3.2         | 1.3.2  |
| Opus      | 1.1.2         | 1.1.2  |
| libsrtp2  | -             | 2.3.0  |
| libnice   | -             | master |

### Version selection

These images contain multiple Erlang and Elixir versions, managed with [asdf]. You can specify which one should be selected by running: `asdf global erlang <version>` or `asdf global elixir <version>` in your script.

### Default versions:

| Image  | Erlang | Elixir |
| ------ | ------ | ------ |
| focal  | 22.3   | 1.10.3 |
| bionic | 22.2   | 1.9.4  |

## Building the image

To rebuild the image, run the following command:

```sh
make build
```

Optionally, one can add the following variables:
* `VERSION=string`, which adds the variant tag. Set to `latest` by default.
* `FLAVOR=string`, which selects the flavor (subdirectory of this repository) to build. Set to `focal` by default.
* `IMAGE=name`, which will override the default image name. If not specified, this is set to `membrane/membrane`

## Sample usage

Execute the following command while being in your application directory:

```sh
make run
```

or from anywhere:

```sh
DIR=/my/app/directory make run
```

This will start the container with the application directory mapped to `/app`. Inside the container, go to that directory:

```sh
cd /app
```

and execute your app's code (for example tests)
```sh
mix test
```

## Copyright and License

Copyright 2019, [Software Mansion]

[![Software Mansion](https://logo.swmansion.com/logo?color=white&variant=desktop&width=200&tag=membrane-github)][Software Mansion]

Licensed under the [Apache License, Version 2.0](LICENSE)

[Software Mansion]: https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=docker-membrane
[Membrane Framework]: https://membraneframework.org
[asdf]: https://asdf-vm.com/
[github]: https://github.com/membraneframework/docker-membrane
[docker-hub]: https://hub.docker.com/r/membrane/membrane

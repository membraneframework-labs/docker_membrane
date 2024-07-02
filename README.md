# Ubuntu based Membrane Docker image

[![Docker Pulls](https://img.shields.io/docker/pulls/membraneframeworklabs/docker_membrane)][membraneframeworklabs]
[![GitHub forks](https://img.shields.io/github/forks/membraneframework/docker-membrane?style=social)][github]

A Docker image based on Ubuntu, with Erlang, Elixir, Node.js and libraries necessary to test and run the [Membrane Framework].

Image has been moved to [membraneframeworklabs]

## Image variants

This image comes in many flavours, based on different Ubuntu releases and package versions:

- `latest`, `focal` - based on Ubuntu 20.04
- `bionic` - based on Ubuntu 18.04, **deprecated**

## Package versions

| Package   | bionic        | focal            | jammy            |
| --------- | ------------- | -----------------|------------------|
| Erlang    | 21.3 and 22.2 | 25.2.3           | 27.0             |
| Elixir    | 1.9.4         | 1.14.3           | 1.17.2           |
| Node.js   | -             | 14.16.1          | 16.17.0          |
| Rust      | -             | 1.65.0           | 1.70.0           |
| FFmpeg    | 4.2.2         | 4.2.2            | 4.4.2            |
| SDL2      | ?             | ?                | 2.0.20           |
| FDK AAC   | 2.0           | 2.0              | 2.0.0            |
| Portaudio | 19.6.0        | 19.6.0           | 19.6.0           |
| MAD       | 0.15.1        | 0.15.1           | 0.15.1           |
| FLAC      | 1.3.2         | 1.3.2            | 1.3.3            |
| Opus      | 1.1.2         | 1.1.2            | 1.3.1            |
| libsrtp2  | -             | 2.3.0  	         | 2.4.2            |
| libnice   | -             | master (833c1aa) | -                |
| libmp3lame| -             | 3.100            | 3.100            |


### Version selection

These images contain multiple (Erlang, Elixir, Node.js) versions, managed with [asdf]. You can specify which one should be selected by running: `asdf global erlang <version>` or `asdf global elixir <version>` in your script.

### Default versions:

| Image  | Erlang | Elixir | Node.js |  Rust  |
| ------ | -------| ------ | ------- | ------ |
| jammy  | 27.0   | 1.17.2 | 16.17.0 | 1.63.0 |
| focal  | 25.2.3 | 1.14.3 | 16.17.0 | 1.63.0 |
| bionic | 22.2   | 1.9.4  |    -    |    -   |

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
[membraneframeworklabs]: https://hub.docker.com/r/membraneframeworklabs/docker_membrane

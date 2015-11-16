# Josh Benner's Dotfiles

Dotfiles managed with [homemaker](https://github.com/FooSoft/homemaker).

## Install Homemaker

1. [Install go](https://golang.org/doc/install).
2. `$ go get github.com/FooSoft/homemaker`

## Initial Install

```sh
$ git clone git@github.com:joshbenner/dotfiles.git
$ cd dotfiles
$ homemaker -variant ubuntu -task install_base config.toml .
$ homemaker -variant ubuntu -task <machine> config.toml .
```

# Installation
* Install packages

```shell
    $ pacman -S --needed `grep -v "^#" packages/**/pacman`
```

* Install package configuration files

```shell
    $ mkdir $HOME/.config
    $ stow home -t $HOME
```

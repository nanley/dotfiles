# Arch Installation
* Install packages

```shell
    $ pacman -S --needed `grep -v "^#" packages/**/pacman`
```

* Install package configuration files

```shell
    $ mkdir $HOME/.config
    $ stow home -t $HOME
```

* Follow Arch wiki for system configuration tips

# NixOS Installation
* Install packages

```shell
    $ nix-env -i stow
```

* Install package configuration files

```shell
    $ mkdir $HOME/.config
    $ stow home -t $HOME
```

* Install system configuration files

```shell
    $ stow etc -t /etc
    $ nixos-rebuild boot
```

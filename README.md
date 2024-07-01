# Installation

### Clone the repository
```bash
git clone https://github.com/mattaschmann/dotfiles.git
cd dotfiles
```

### Install depandancy programs
1. [urlview](https://github.com/sigpipe/urlview)
1. [tpm for tmux plugins](https://github.com/tmux-plugins/tpm)
1. [antibody for zsh](https://getantibody.github.io/)
1. [oh-my-zsh](https://ohmyz.sh/)
1. [fnm](https://github.com/Schniz/fnm)
1. [pyenv](https://github.com/pyenv/pyenv)
1. [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)

### Run the install script
The installation is provided by [DotBot](https://github.com/anishathalye/dotbot).
```bash
./install
```

This will download the necessary files from the dotbot repo and install
all the links depending on how the `install.conf.yaml` file is setup.


# Attributions

## DotBot

[DotBot](https://github.com/anishathalye/dotbot) is the excellent bootstrap utility I used to automate the installation.

## Terminfo

I've pretty much copied the terminfo information from [here](https://github.com/wincent/wincent/tree/master/roles/terminfo),
provided by [Greg Hurrell](https://github.com/wincent)

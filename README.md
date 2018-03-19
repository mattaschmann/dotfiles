# Installation

### Clone the repository
```bash
git clone https://github.com/mattaschmann/dotfiles.git
cd dotfiles
```

### Install brew
[Homebrew](https://brew.sh/) is used to install many of the applications used by these configs.
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Run brew bundle
[Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle) is used to install a preset list of
homebrew packages.
```bash
brew bundle
```

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

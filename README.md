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
The installation is provided by [dotbot](https://github.com/anishathalye/dotbot).
```bash
./install
```

This will download the necessary files from the dotbot repo and install
all the links depending on how the `install.conf.yaml` file is setup.


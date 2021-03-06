# dotfiles

Files for configuring a terminal environment and other various system settings. Largely centered around macOS, as well as other Unix-like systems. See [Github does dotfiles](https://dotfiles.github.io) for more info

## Table of Contents
* [Installation](#installation)
  * [`curl` method](#curl-method-easiest)
  * [Manual method](#manual-method)
* [Makefile](#makefile)
  * [`make`](#make)
  * [`make link`](#make-link)
* [How it Works](#how-it-works)
  * [Symlinks with GNU Stow](#symlinks)
  * [Bash](#bash)
  * [Vim](#vim)
  * [Window Management](#window-management)

---

## Installation

### `curl` method (easiest)

```bash
$ curl get.darryl.sh | sh
$ cd ~/dotfiles
$ make
```

Source code for the script is [here](https://github.com/rootbeersoup/get.darryl.sh/blob/master/src/dotfiles.sh). Checksums can be found in the [tag notes](https://github.com/rootbeersoup/get.darryl.sh/tags).

The `curl` method will install everything automatically. This is really useful for quickly setting up a new machine. 

### Manual method

You can also manually clone the repository and invoke the `Makefile`

```bash
$ git clone --recursive https://github.com/rootbeersoup/dotfiles.git
$ cd dotfiles
$ make
```

The `--recursive` flag clones all included submodules. This option is not fully necessary; the `Makefile` will clone the submodules if they are missing.

## Makefile

### `make`

* Installs [Homebrew](https://brew.sh) on macOS and installs all packages defined in the [Brewfile](macos/.Brewfile).
* Sets Homebrew-installed Bash (4.4+) as the default shell
* Updates macOS and configures preferred system defaults defined in [`/macos/defaults.sh`](macos/defaults.sh)
* Configures [chunkwm](https://github.com/koekeishiya/chunkwm) and [skhd](https://github.com/koekeishiya/skhd) to run at system startup
* Creates necessary symlinks via [GNU Stow](https://www.gnu.org/software/stow/)
* Runs [`/macos/duti/set.sh`](macos/duti/set.sh), which sets defaults handlers/programs for file extensions via [duti](http://duti.org).

### `make link`

* Symlinks only Bash and Vim configuration files to the home directory using `ln` commands. Useful for temporarily configuring a shared computer. Nothing new is installed to the machine, but files *may* be overwritten since the Makefile recipe passes the `-f` flag for every `ln` command.
* Run `make unlink` to remove these symlinks.

## How it Works

### Symlinks

All necessary symlinks ( [`.bash_profile`](bash/.bash_profile), [`.vimrc`](vim/.vimrc), among others) are managed with GNU Stow (installed with Homebrew). Files you wish to be symlinked to the home directory need to be placed in a folder within `~/dotfiles`. Using the `stow` command from the `~/dotfiles` directory will symlink the contents of the folder you choose (`/bash`, `/vim`, etc) to the grandparent directory, which is wherever the `/dotfiles` folder is contained.

Assuming you clone the dotfiles repository in your home directory, executing the commands:

```bash
$ cd dotfiles
$ stow bash
```
will symlink the contents of [`/bash`](bash) to the home directory.

You can use the `stow` command anytime you add a new file to a folder you wish to symlink directly to the home directory. This can all be done without Stow using the `ln -s` command, but I find GNU Stow with folder management to be cleaner and easier to maintain.

### Bash

`.bash_profile` automatically sources configurations defined in the files contained in the [`/bash/dots`](bash/dots) folder. Any changes to any existing file, as well as any new files in `/bash/dots/` will be loaded into the shell upon opening a new Terminal window or [reloading](https://github.com/rootbeersoup/dotfiles/blob/db902b9ac0c466d09672f58549bff4107ba53861/dots/aliases#L4) the `.bash_profile`.

### Vim

My vim plugin manager of choice is [Pathogen](https://github.com/tpope/vim-pathogen). The `pathogen.vim` file is autoloaded and invokes the plugins in the `/vim/bundle` folder via a single line in my `.vimrc`:

```
execute pathogen#infect()
```

Vim plugins are currently contained as git submodules, to keep the remote repository slimmer. The extraneous `git submodule init` and `git submodule update` commands are handled by the `Makefile`.

### Window Management

chunkwm and skhd are configured via `.chunkwmrc` and `.skhdrc` respectively. Both are located in the `/macos` folder and symlinked to the home directory with `stow macos`.

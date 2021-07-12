# XFOIL_compilation
A repository for keeping track of compiling steps for XFOIL with gfortran on macOS and Ubuntu

Original file are downloaded from https://web.mit.edu/drela/Public/web/xfoil/.

## Prerequisites
- Downloading XFOIL source files from here (because make files are modified compared to original version).
- Having X11 installed. For macOS, you may do it manually from https://www.xquartz.org or with one of the methods below.
- Having gfortran installed. For macOS, you may pick one of the methods below.


### Getting X11 and gfortran with [Homebrew](https://brew.sh)
```bash
# Get X11
brew tap homebrew/cask
brew install xquartz

# Get gfortran
brew install gcc
```

### Getting X11 and gfortran with [MacPorts](https://www.macports.org)
```bash
# Get X11
sudo port install xorg

# Get gfortran
sudo port install gcc11
sudo port select --set gcc mp-gcc11
```


## What to do
Just run
```bash
./compile.sh
```

Executables will be added in `./bin` directory

## GitHub workflow
The compilation process, with the installation of requirements, is done in a GitHub workflow, that delivers executables as artifacts. 
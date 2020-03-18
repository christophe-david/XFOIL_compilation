# XFOIL_compilation
A repository for keeping track of compiling steps for XFOIL with gfortran on macOS and Ubuntu

Original file are downloaded from https://web.mit.edu/drela/Public/web/xfoil/.

## Prerequisites
- Downloading XFOIL source files from here (because make files are modified compared to original version)
- Having X11 installed. For macOS, it should be done from https://www.xquartz.org (using the package installer or the provided [MacPorts](https://www.macports.org)  method)
- Having gfortran installed. This can be done with several methods. On macOS, I used [MacPorts](https://www.macports.org):
```bash
sudo port install gcc9
sudo ln -s /opt/local/bin/gfortran-mp-9 /opt/local/bin/gfortran
```

## What to do
Just run
```bash
./compile.sh
```

Executables should be added in `./bin` directory

## GitHub workflow
The compilation process, with the installation of requirements, is done in a GitHub workflow, that delivers executables as artifacts. 
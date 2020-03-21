# XFOIL_macOS
A repository for keeping track of compiling steps for XFOIL with gfortran on macOS

Original file are downloaded from https://web.mit.edu/drela/Public/web/xfoil/.

## Prerequisites
- Downloading XFOIL source files from here (because make files are modified compared to original version)
- Having X11 installed, from https://www.xquartz.org 
- Having gfortran installed. This can be done with several methods. I used [MacPorts](https://www.macports.org):
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
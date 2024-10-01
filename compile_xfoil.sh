#!/bin/bash

cd Xfoil/bin || exit
make clean
make xfoil
make pplot
make pxplot

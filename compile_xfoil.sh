#!/bin/bash

cd Xfoil/bin || exit
make xfoil
make pplot
make pxplot

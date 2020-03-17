#!/bin/bash

cd Xfoil/orrs/bin || exit
make -f makefile_DP osgen

cd ..
bin/osgen osmaps_ns.lst
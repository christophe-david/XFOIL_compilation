#!/bin/bash

cd Xfoil/orrs/bin || exit
make clean
make osgen

cd ..
bin/osgen osmaps_ns.lst
#!/bin/bash

cd Xfoil/orrs/bin || exit
make osgen

cd ..
bin/osgen osmaps_ns.lst
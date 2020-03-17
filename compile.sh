#!/bin/bash

echo '# COMPILING ORR-SOMMERFELD DATABASE #####################################'
/bin/bash ./compile_orrs.sh || exit

echo '# COMPILING PLOT LIBRARY ################################################'
/bin/bash ./compile_plotlib.sh || exit

echo '# COMPILING EXECUTABLES #################################################'
/bin/bash ./compile_xfoil.sh || exit


SRC = ../src
PLTOBJ = /var/local/codes/Xplot/libPltDP.a

#========================================
#  Default compiler flags
FC = f77
FLG = -O -r8
PLTLIB = -lX11
FTNLIB =

#========================================
#  Uncomment for Intel Fortran Compiler
FC = ifort
FLG = -O -r8
PLTLIB = -L/usr/X11R6/lib -lX11
FTNLIB =

#========================================
# gfortran
FC = gfortran
FLG = -O -fdefault-real-8 -static -lgfortran -static-libgfortran -static-libgcc
PLTLIB = -L/usr/X11R6/lib -lX11
FTNLIB =


OS: osgen osmap.o


osgen: osgen.o io.o spline.o getarg0.o
	$(FC) -o osgen osgen.o io.o spline.o getarg0.o $(FTNLIB)
fscorr: fscorr.o fs.o
	$(FC) -o fscorr fscorr.o fs.o $(PLTOBJ) $(PLTLIB)
fsrun: fsrun.o fs.o
	$(FC) -o fsrun fsrun.o fs.o $(PLTOBJ) $(PLTLIB)
intai: intai.o osmap.o plutil.o
	$(FC) -o intai intai.o osmap.o plutil.o $(PLTOBJ) $(PLTLIB)
mappl1: mappl1.o ask1.o conlab.o io.o getarg0.o
	$(FC) -o mappl1 mappl1.o ask1.o conlab.o io.o getarg0.o $(PLTOBJ) $(PLTLIB)
ncorr: ncorr.o fs.o
	$(FC) -o ncorr ncorr.o fs.o $(PLTOBJ) $(PLTLIB)
osrun: osrun.o fs.o orrs.o ospres.o plutil.o userio.o
	$(FC) -o osrun osrun.o fs.o orrs.o ospres.o \
plutil.o userio.o $(PLTOBJ) $(PLTLIB) $(FTNLIB)
osseq: osseq.o fs.o orrs.o ospres.o plutil.o userio.o
	$(FC) -o osseq osseq.o fs.o orrs.o ospres.o \
plutil.o userio.o  $(PLTOBJ) $(PLTLIB) $(FTNLIB)
pfplot: pfplot.o fs.o ask1.o
	$(FC) -o pfplot pfplot.o fs.o ask1.o $(PLTOBJ) $(PLTLIB)
roll: roll.o
	$(FC) -o roll roll.o $(PLTOBJ) $(PLTLIB) $(FTNLIB)
as2bi: as2bi.o io.o getarg0.o
	$(FC) -o as2bi as2bi.o io.o getarg0.o $(FTNLIB)
bi2as: bi2as.o io.o getarg0.o
	$(FC) -o bi2as bi2as.o io.o getarg0.o $(FTNLIB)
bi2bi: bi2bi.o io.o getarg0.o
	$(FC) -o bi2bi bi2bi.o io.o getarg0.o $(FTNLIB)
otest: otest.o osmap.o
	$(FC) -o otest otest.o osmap.o
osweep: osweep.o osmap.o
	$(FC) -o osweep osweep.o osmap.o

osgen.o: $(SRC)/osgen.f
	$(FC) -c $(FLG) $(SRC)/osgen.f
orrs.o: $(SRC)/orrs.f $(SRC)/ORRS.INC
	$(FC) -c $(FLG) $(SRC)/orrs.f
ospres.o: $(SRC)/ospres.f $(SRC)/OSPRES.INC
	$(FC) -c $(FLG) $(SRC)/ospres.f
pfplot.o: $(SRC)/pfplot.f
	$(FC) -c $(FLG) $(SRC)/pfplot.f
fscorr.o: $(SRC)/fscorr.f
	$(FC) -c $(FLG) $(SRC)/fscorr.f
fsrun.o: $(SRC)/fsrun.f
	$(FC) -c $(FLG) $(SRC)/fsrun.f
fs.o: $(SRC)/fs.f
	$(FC) -c $(FLG) $(SRC)/fs.f
io.o: $(SRC)/io.f
	$(FC) -c $(FLG) $(SRC)/io.f
intai.o: $(SRC)/intai.f
	$(FC) -c $(FLG) $(SRC)/intai.f
mappl1.o: $(SRC)/mappl1.f
	$(FC) -c $(FLG) $(SRC)/mappl1.f
ncorr.o: $(SRC)/ncorr.f
	$(FC) -c $(FLG) $(SRC)/ncorr.f
osmap.o: $(SRC)/osmap.f
	$(FC) -c $(FLG) $(SRC)/osmap.f
osrun.o: $(SRC)/osrun.f
	$(FC) -c $(FLG) $(SRC)/osrun.f
osseq.o: $(SRC)/osseq.f
	$(FC) -c $(FLG) $(SRC)/osseq.f
roll.o: $(SRC)/roll.f
	$(FC) -c $(FLG) $(SRC)/roll.f
otest.o: $(SRC)/otest.f
	$(FC) -c $(FLG) $(SRC)/otest.f
osweep.o: $(SRC)/osweep.f
	$(FC) -c $(FLG) $(SRC)/osweep.f

spline.o: $(SRC)/spline.f
	$(FC) -c $(FLG) $(SRC)/spline.f
conlab.o: $(SRC)/conlab.f
	$(FC) -c $(FLG) $(SRC)/conlab.f
plutil.o: $(SRC)/plutil.f
	$(FC) -c $(FLG) $(SRC)/plutil.f
ask1.o: $(SRC)/ask1.f
	$(FC) -c $(FLG) $(SRC)/ask1.f
userio.o: $(SRC)/userio.f
	$(FC) -c $(FLG) $(SRC)/userio.f
getarg0.o: $(SRC)/getarg0.f
	$(FC) -c $(FLG) $(SRC)/getarg0.f


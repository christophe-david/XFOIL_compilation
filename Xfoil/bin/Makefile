#*********************************************************
# Makefile for XFOIL V6.93 programs
# H.Youngren 4/24/01
# M.Drela
#*********************************************************


SHELL = sh
BINDIR = ../../bin
#BINDIR = .

PROGS = xfoil pplot pxplot

SRC = ../src
OSRC = ../osrc

XFOILOBJ = xfoil.o xpanel.o xoper.o xtcam.o xgdes.o xqdes.o xmdes.o \
xsolve.o xbl.o xblsys.o xpol.o xplots.o pntops.o xgeom.o xutils.o modify.o \
blplot.o polplt.o aread.o naca.o spline.o plutil.o iopol.o gui.o sort.o \
dplot.o profil.o

PPLOTOBJ = pplot.o polplt.o sort.o iopol.o
PXPLOTOBJ = pxplot.o plutil.o gui.o

XUTILOBJ  = userio.o

FTNLIB = 

##----------------------------------------------------
OSOBJ = frplot0.o

# Use this for individual TS-wave frequency plotting
OSOBJ = frplot.o ntcalc.o osmap.o getosfile.o

##----------------------------------------------------
PLTOBJ = ../plotlib/libPlt.a

# Use this if you have a copy of the plotlib as a system library
#PLTOBJ = -lPlt

# The extra location arg here is for Linux which places X libs in /usr/X11R6
PLTLIB = -L/usr/X11R6/lib -lX11 -L/opt/local/lib

###================================================
###  Default compilers and flags
###  FFLOPT used for xsolve.f
FC = f77
FFLAGS  = -O
FFLOPT  = -O
INSTALLCMD = install -s

CC = cc
CFLAGS = -O -DUNDERSCORE

##--------------------------

# Uncomment flags for desired machine...

##--------------------------
### DEC Alpha with OSF and DEC f77/f90 compiler
#FC = f77
#FFLAGS = -fast -O4 -tune host
#FFLOPT = -fast -O4 -tune host
#FFLOPT = -fast -O5 -tune host -unroll 3
# Debug flags
#FFLAGS = -O0 -g
#FFLOPT = -fast -O4 -tune host
##--------------------------
### SGI setup
#FC = f77
#FFLAGS = -O2 -static
#FFLOPT = -O2 -static
##--------------------------
##  Uncomment for RS/6000
#FFLAGS = -O -qextname
#FFLOPT = -O -qextname
##--------------------------
##  Uncomment for HP-9000
#FFLAGS = -O +ppu
#FFLOPT = -O +ppu
#FTNLIB = -U77
##--------------------------
### Absoft Linux f77
#FC = f77
#FFLAGS = -O -f -s -W -B108 -N34
#FFLOPT = -O -f -s -W -B108 -N34
##--------------------------
### f2c/gcc compiler driver
#FC = fort77
#FFLAGS = -O2 -fomit-frame-pointer
#FFLOPT = -O2 -fomit-frame-pointer
##--------------------------
### GNU g77
#FC = g77
#FFLAGS = -O3 -fomit-frame-pointer
#FFLOPT = -O3 -fomit-frame-pointer
# Debug flags (symbols, array bounds)
#FC = g77
#FFLAGS = -g -O0 -C
##--------------------------
### GNU gfortran
#FC = gfortran
#FFLAGS = -O3 -fomit-frame-pointer
#FFLOPT = -O3 -fomit-frame-pointer
# Debug flags (symbols, array bounds)
#FFLAGS = -g -O0 -fbounds-check
#FFLOPT = -g -O0 -fbounds-check
#
### Double precision option
#FFLAGS = -O3 -fdefault-real-8
#FFLOPT = -O3 -fdefault-real-8
#FFLAGS = -O3 -fdefault-real-8 -fbounds-check
#FFLOPT = -O3 -fdefault-real-8 -fbounds-check
# Debug flags (symbols, array bounds)
#FFLAGS = -g -O0 -C
##--------------------------
### Gfortran
FC = gfortran
CHK =
#CHK = -fbounds-check -finit-real=inf -ffpe-trap=invalid,zero,denormal
DBL = -fdefault-real-8
LGC = -std=legacy -static -lgfortran -static-libgfortran -static-libgcc
FFLAGS = -O $(CHK) $(DBL) $(LGC)
FFLOPT = -O $(CHK) $(DBL) $(LGC)
FTNLIB =

PLTOBJ = ../plotlib/libPlt_gDP.a 



all:	 $(PROGS)

install: 
	$(INSTALLCMD) $(PROGS) $(BINDIR)

clean:
	-/bin/rm $(PROGS)
	-/bin/rm $(XFOILOBJ) $(XUTILOBJ) $(OSOBJ) $(PPLOTOBJ) $(PXPLOTOBJ)
#	-/bin/rm *.o



xfoil: $(XFOILOBJ) $(XUTILOBJ) $(OSOBJ)
	$(FC) -o xfoil $(XFOILOBJ) $(XUTILOBJ) $(OSOBJ) $(PLTOBJ) $(PLTLIB) $(FTNLIB)
	$(INSTALLCMD) xfoil $(BINDIR)

pxplot:	$(PXPLOTOBJ) $(XUTILOBJ)
	$(FC) -o pxplot $(PXPLOTOBJ) $(XUTILOBJ) $(PLTOBJ) $(PLTLIB) $(FTNLIB)
	$(INSTALLCMD) pxplot $(BINDIR)

pplot:	$(PPLOTOBJ) $(XUTILOBJ)
	$(FC) -o pplot $(PPLOTOBJ) $(XUTILOBJ)  $(PLTOBJ) $(PLTLIB) $(FTNLIB)
	$(INSTALLCMD) pplot $(BINDIR)

blu: blu.o profil.o
	$(FC) -o blu blu.o profil.o
	$(INSTALLCMD) blu $(BINDIR)


blu.o: $(SRC)/blu.f
	$(FC) -c $(FFLAGS) $(SRC)/blu.f

xfoil.o: $(SRC)/xfoil.f  $(SRC)/XFOIL.INC $(SRC)/XBL.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xfoil.f
xpanel.o: $(SRC)/xpanel.f  $(SRC)/XFOIL.INC
	$(FC) -c $(FFLOPT)  $(SRC)/xpanel.f
xoper.o: $(SRC)/xoper.f  $(SRC)/XFOIL.INC  $(SRC)/BLPAR.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xoper.f
xsolve.o: $(SRC)/xsolve.f  $(SRC)/XFOIL.INC
	$(FC) -c $(FFLOPT)  $(SRC)/xsolve.f
dplot.o: $(SRC)/dplot.f  $(SRC)/XFOIL.INC
	$(FC) -c $(FFLOPT)  $(SRC)/dplot.f
xtcam.o: $(SRC)/xtcam.f  $(SRC)/XFOIL.INC $(SRC)/XDES.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xtcam.f
xgdes.o: $(SRC)/xgdes.f  $(SRC)/XFOIL.INC $(SRC)/XDES.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xgdes.f
xqdes.o: $(SRC)/xqdes.f  $(SRC)/XFOIL.INC $(SRC)/XDES.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xqdes.f
xmdes.o: $(SRC)/xmdes.f  $(SRC)/XFOIL.INC $(SRC)/XDES.INC $(SRC)/CIRCLE.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xmdes.f
xbl.o:   $(SRC)/xbl.f    $(SRC)/XFOIL.INC $(SRC)/XBL.INC $(SRC)/BLPAR.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xbl.f
xblsys.o: $(SRC)/xblsys.f                  $(SRC)/XBL.INC $(SRC)/BLPAR.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xblsys.f
xplots.o: $(SRC)/xplots.f $(SRC)/XFOIL.INC $(SRC)/XDES.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xplots.f
pntops.o: $(SRC)/pntops.f $(SRC)/XFOIL.INC $(SRC)/XDES.INC
	$(FC) -c $(FFLAGS)  $(SRC)/pntops.f
blplot.o: $(SRC)/blplot.f $(SRC)/XFOIL.INC $(SRC)/BLPAR.INC
	$(FC) -c $(FFLAGS)  $(SRC)/blplot.f
xpol.o: $(SRC)/xpol.f     $(SRC)/XFOIL.INC $(SRC)/PINDEX.INC
	$(FC) -c $(FFLAGS)  $(SRC)/xpol.f
xgeom.o: $(SRC)/xgeom.f 
	$(FC) -c $(FFLAGS)  $(SRC)/xgeom.f
xutils.o: $(SRC)/xutils.f 
	$(FC) -c $(FFLAGS)  $(SRC)/xutils.f
modify.o: $(SRC)/modify.f 
	$(FC) -c $(FFLAGS)  $(SRC)/modify.f
aread.o: $(SRC)/aread.f 
	$(FC) -c $(FFLAGS)  $(SRC)/aread.f
naca.o: $(SRC)/naca.f 
	$(FC) -c $(FFLAGS)  $(SRC)/naca.f
plutil.o: $(SRC)/plutil.f 
	$(FC) -c $(FFLAGS)  $(SRC)/plutil.f
userio.o: $(SRC)/userio.f 
	$(FC) -c $(FFLAGS)  $(SRC)/userio.f
gui.o: $(SRC)/gui.f 
	$(FC) -c $(FFLAGS)  $(SRC)/gui.f
spline.o: $(SRC)/spline.f 
	$(FC) -c $(FFLAGS)  $(SRC)/spline.f
sort.o: $(SRC)/sort.f
	$(FC) -c $(FFLAGS)  $(SRC)/sort.f
profil.o: $(SRC)/profil.f
	$(FC) -c $(FFLAGS)  $(SRC)/profil.f

polplt.o: $(SRC)/polplt.f $(SRC)/PINDEX.INC
	$(FC) -c $(FFLAGS)  $(SRC)/polplt.f
iopol.o: $(SRC)/iopol.f $(SRC)/PINDEX.INC
	$(FC) -c $(FFLAGS)  $(SRC)/iopol.f

pplot.o:  $(SRC)/pplot.f  $(SRC)/PPLOT.INC $(SRC)/PINDEX.INC
	$(FC) -c $(FFLAGS)  $(SRC)/pplot.f
pxplot.o: $(SRC)/pxplot.f $(SRC)/PXPLOT.INC
	$(FC) -c $(FFLAGS)  $(SRC)/pxplot.f


frplot0.o: $(SRC)/frplot0.f
	$(FC) -c $(FFLAGS)  $(SRC)/frplot0.f
frplot.o: $(SRC)/frplot.f
	$(FC) -c $(FFLAGS)  $(SRC)/frplot.f
ntcalc.o: $(SRC)/ntcalc.f
	$(FC) -c $(FFLAGS)  $(SRC)/ntcalc.f

osmap.o: $(OSRC)/osmap.f
	$(FC) -c $(FFLAGS)  $(OSRC)/osmap.f

getosfile.o: $(OSRC)/getosfile.c
	$(CC) -c $(CFLAGS)  $(OSRC)/getosfile.c

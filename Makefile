all: nvtx_example

FC=pgf90
#FC=gfortran

nvtx_example:: main.f90 nvtx.f90
	$(FC) -o nvtx_example nvtx.f90 main.f90 -L/usr/local/cuda/lib64 -lnvToolsExt

clean:
	rm  nvtx_example main.o nvtx.o   nvtx.mod

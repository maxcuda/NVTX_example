all: nvtx_example

nvtx_example:: main.f90 nvtx.f90
	pgf90 -o nvtx_example nvtx.f90 main.f90 -L/usr/local/cuda/lib64 -lnvToolsExt

clean:
	rm  nvtx_example main.o nvtx.o   nvtx.mod

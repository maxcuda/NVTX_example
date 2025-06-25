#NVTX_example

**Recent versions of the NVIDIA HPC SDK provide a built-in module that is equivalent to the one
in this repro. You just need to  load the module nvtx in your source (use nvtx) and link with -cudalib=nvtx**


How to call NVTX from Fortran:

https://devblogs.nvidia.com/customize-cuda-fortran-profiling-nvtx/

Updated code, it will work with PGI, XLF and Gfortran compilers.

If you are using nvprof from CUDA 10.x  and you are getting an error:
======== Error: incompatible CUDA driver version.

you will need to add "--openmp-profiling off" to the command line.

NVTX markers from Fortran  work with the new Nsight tools shipped in CUDA 10.1 Update 2.

To capture a trace run:
nsys profile -o outputfile ./a.out

To visualize the trace:
nsight-sys full_path_to_outputfile

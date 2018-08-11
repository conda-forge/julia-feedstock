#!/bin/sh

export C_INCLUDE_PATH=${PREFIX}/include
export LD_LIBRARY_PATH=${PREFIX}/lib
export LIBRARY_PATH=${PREFIX}/lib
export CMAKE_PREFIX_PATH=${PREFIX}

# Hack to suppress building docs
cat > doc/Makefile << EOF
html :	
	mkdir -p _build/html
EOF

# Julia sets this to unix makefiles later on in its build process
export CMAKE_GENERATOR="make"

NO_GIT=1 make -C base version_git.jl.phony

make -j 4 prefix=${PREFIX} MARCH=core2 sysconfigdir=${PREFIX}/etc NO_GIT=1 \
 LIBBLAS=-lopenblas LIBBLASNAME=libopenblas LIBLAPACK=-lopenblas LIBLAPACKNAME=libopenblas \
 USE_LLVM_SHLIB=0 \
 USE_SYSTEM_ARPACK=1 \
 USE_SYSTEM_BLAS=1 \
 USE_SYSTEM_CURL=1 \
 USE_SYSTEM_FFTW=1 \
 USE_SYSTEM_GMP=1 \
 USE_SYSTEM_LAPACK=1 \
 USE_SYSTEM_LIBGIT2=1 \
 USE_SYSTEM_LIBSSH2=1 \
 USE_SYSTEM_LIBUNWIND=1 \
 USE_SYSTEM_LLVM=0 \
 USE_SYSTEM_MPFR=1 \
 USE_SYSTEM_OPENLIBM=1 \
 USE_SYSTEM_OPENSPECFUN=1 \
 USE_SYSTEM_PATCHELF=1 \
 USE_SYSTEM_PCRE=1 \
 USE_SYSTEM_SUITESPARSE=1 \
 TAGGED_RELEASE_BANNER="conda-forge-julia release" \
 install

# Configure juliarc to use conda environment
cat "${RECIPE_DIR}/juliarc.jl" >> "${PREFIX}/etc/julia/juliarc.jl"

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

make -j 4 prefix=${PREFIX} MARCH=core2 sysconfigdir=${PREFIX}/etc NO_GIT=1 \
 LIBBLAS=-lopenblas LIBBLASNAME=libopenblas${SHLIB_EXT} LIBLAPACK=-lopenblas LIBLAPACKNAME=libopenblas${SHLIB_EXT} \
 USE_SYSTEM_LIBGIT2=1 USE_LLVM_SHLIB=0 USE_SYSTEM_CURL=1 USE_SYSTEM_OPENLIBM=1 USE_SYSTEM_MPFR=1 \
 USE_SYSTEM_PATCHELF=1 USE_SYSTEM_LIBSSH2=1 USE_SYSTEM_LLVM=0 USE_SYSTEM_BLAS=1 USE_SYSTEM_PCRE=1 \
 USE_SYSTEM_FFTW=1 USE_SYSTEM_GMP=1 USE_SYSTEM_LAPACK=1 USE_SYSTEM_ARPACK=1 USE_SYSTEM_SUITESPARSE=1 \
 USE_SYSTEM_OPENSPECFUN=1 \
 VERBOSE=1 \
 TAGGED_RELEASE_BANNER="conda-forge-julia release" \
 install

# Configure juliarc to use conda environment
cat "${RECIPE_DIR}/juliarc.jl" >> "${PREFIX}/etc/julia/juliarc.jl"

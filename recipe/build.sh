#!/bin/sh

export C_INCLUDE_PATH=${PREFIX}/include
export LD_LIBRARY_PATH=${PREFIX}/lib
export LIBRARY_PATH=${PREFIX}/lib
export CMAKE_PREFIX_PATH=${PREFIX}
export PATH="${PREFIX}/bin:${PATH}"

# Hack to suppress building docs
cat > doc/Makefile << EOF
html :	
	mkdir -p _build/html
EOF


# Julia sets this to unix makefiles later on in its build process
export CMAKE_GENERATOR="make"

make -C base version_git.jl.phony CC=$CC CXX=$CXX FC=$FC

export EXTRA_MAKEFLAGS="" 
if [ "$(uname)" == "Darwin" ]
then
    export EXTRA_MAKEFLAGS="USE_SYSTEM_LIBGIT2=0"
elif [ "$(uname)" == "Linux" ]
then
    export EXTRA_MAKEFLAGS="USE_SYSTEM_LIBGIT2=1"
fi

make -j 4 prefix=${PREFIX} MARCH=core2 sysconfigdir=${PREFIX}/etc \
 LIBBLAS=-lopenblas64_ LIBBLASNAME=libopenblas64_ LIBLAPACK=-lopenblas64_ LIBLAPACKNAME=libopenblas64_ \
 USE_SYSTEM_ARPACK=1 \
 USE_SYSTEM_BLAS=1 \
 USE_BLAS64=1 \
 USE_SYSTEM_CURL=1 \
 USE_SYSTEM_GMP=1 \
 USE_SYSTEM_LAPACK=1 \
 USE_SYSTEM_LIBSSH2=1 \
 USE_SYSTEM_LLVM=0 \
 USE_SYSTEM_MPFR=1 \
 USE_SYSTEM_OPENLIBM=1 \
 USE_SYSTEM_PATCHELF=1 \
 USE_SYSTEM_PCRE=1 \
 USE_SYSTEM_SUITESPARSE=1 \
 USE_SYSTEM_CSL=0 \
 USE_SYSTEM_LIBUNWIND=1 \
 USE_SYSTEM_LIBUV=0 \
 USE_SYSTEM_UTF8PROC=1 \
 USE_SYSTEM_MBEDTLS=0 \
 USE_SYSTEM_NGHTTP2=1 \
 USE_SYSTEM_ZLIB=1 \
 USE_SYSTEM_P7ZIP=1 \
 ${EXTRA_MAKEFLAGS}	\
 TAGGED_RELEASE_BANNER="conda-forge-julia release" \
 CC=$CC CXX=$CXX FC=$FC \
 install

# Configure juliarc to use conda environment
cat "${RECIPE_DIR}/juliarc.jl" >> "${PREFIX}/etc/julia/juliarc.jl"

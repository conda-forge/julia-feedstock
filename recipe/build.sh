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

make -C base version_git.jl.phony CC=$CC CXX=$CXX FC=$FC

export EXTRA_MAKEFLAGS="" 
if [ "$(uname)" == "Darwin" ]
then
    export EXTRA_MAKEFLAGS="USE_SYSTEM_LIBUNWIND=1"
elif [ "$(uname)" == "Linux" ]
then
	# On linux the released version of libunwind has issues building julia
	# See: https://github.com/JuliaLang/julia/issues/23615
    export EXTRA_MAKEFLAGS="USE_SYSTEM_LIBUNWIND=0"
fi

make -j 4 prefix=${PREFIX} MARCH=core2 sysconfigdir=${PREFIX}/etc \
 LIBBLAS=-lopenblas LIBBLASNAME=libopenblas LIBLAPACK=-llapack LIBLAPACKNAME=liblapack \
 USE_SYSTEM_ARPACK=1 \
 USE_SYSTEM_BLAS=1 \
 USE_SYSTEM_CURL=0 \
 USE_SYSTEM_GMP=1 \
 USE_SYSTEM_LAPACK=1 \
 USE_SYSTEM_LIBGIT2=0 \
 USE_SYSTEM_LIBSSH2=0 \
 USE_SYSTEM_LLVM=0 \
 USE_SYSTEM_MPFR=1 \
 USE_SYSTEM_OPENLIBM=1 \
 USE_SYSTEM_PATCHELF=1 \
 USE_SYSTEM_PCRE=1 \
 USE_SYSTEM_SUITESPARSE=1 \
 ${EXTRA_MAKEFLAGS}	\
 TAGGED_RELEASE_BANNER="conda-forge-julia release" \
 CC=$CC CXX=$CXX FC=$FC \
 install

# Configure juliarc to use conda environment
cat "${RECIPE_DIR}/juliarc.jl" >> "${PREFIX}/etc/julia/juliarc.jl"

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
if [[ "${target_platform}" == osx-* ]]; then
    export EXTRA_MAKEFLAGS="USE_SYSTEM_LIBGIT2=0 USE_SYSTEM_MBEDTLS=0"
elif [[ "${target_platform}" == linux-* ]]; then
    export EXTRA_MAKEFLAGS="USE_SYSTEM_LIBGIT2=1 USE_SYSTEM_MBEDTLS=1"
fi
# See the following link for how official Julia sets JULIA_CPU_TARGET
# https://github.com/JuliaCI/julia-buildbot/blob/ba448c690935fe53d2b1fc5ce22bc60fd1e251a7/master/inventory.py
if [[ "${target_platform}" == *-64 ]]; then
    export JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1)"
elif [[ "${target_platform}" == linux-aarch64 ]]; then
    export JULIA_CPU_TARGET="generic;cortex-a57;thunderx2t99;armv8.2-a,crypto,fullfp16,lse,rdm"
elif [[ "${target_platform}" == osx-arm64 ]]; then
    export JULIA_CPU_TARGET="generic;armv8.2-a,crypto,fullfp16,lse,rdm"
elif [[ "${target_platform}" == linux-ppc64le ]]; then
    export JULIA_CPU_TARGET="pwr8"
else
    echo "Unknown target ${target_platform}"
    exit 1
fi    

if [[ "${target_platform}" == osx-arm64 ]]; then
	make -j${CPU_COUNT} prefix=${PREFIX} sysconfigdir=${PREFIX}/etc \
	 USE_SYSTEM_ARPACK=1 \
	 USE_SYSTEM_CURL=1 \
	 USE_SYSTEM_GMP=1 \
	 USE_SYSTEM_LIBSSH2=1 \
	 USE_SYSTEM_LLVM=0 \
	 USE_SYSTEM_MPFR=1 \
	 USE_SYSTEM_OPENLIBM=1 \
	 USE_SYSTEM_PATCHELF=1 \
	 USE_SYSTEM_PCRE=1 \
	 USE_SYSTEM_LIBSUITESPARSE=1 \
	 USE_SYSTEM_CSL=0 \
	 USE_SYSTEM_LIBUNWIND=1 \
	 USE_SYSTEM_LIBUV=0 \
	 USE_SYSTEM_UTF8PROC=1 \
	 USE_SYSTEM_NGHTTP2=1 \
	 USE_SYSTEM_ZLIB=1 \
	 USE_SYSTEM_P7ZIP=1 \
	 ${EXTRA_MAKEFLAGS} \
	 TAGGED_RELEASE_BANNER="https://github.com/conda-forge/julia-feedstock" \
	 CC=$CC CXX=$CXX FC=$FC \
	 install
else
	make -j${CPU_COUNT} prefix=${PREFIX} sysconfigdir=${PREFIX}/etc \
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
	 USE_SYSTEM_LIBSUITESPARSE=1 \
	 USE_SYSTEM_CSL=0 \
	 USE_SYSTEM_LIBUNWIND=1 \
	 USE_SYSTEM_LIBUV=0 \
	 USE_SYSTEM_UTF8PROC=1 \
	 USE_SYSTEM_NGHTTP2=1 \
	 USE_SYSTEM_ZLIB=1 \
	 USE_SYSTEM_P7ZIP=1 \
	 ${EXTRA_MAKEFLAGS} \
	 TAGGED_RELEASE_BANNER="https://github.com/conda-forge/julia-feedstock" \
	 CC=$CC CXX=$CXX FC=$FC \
	 install

# Copy the [de]activate scripts to $PREFIX/etc/conda/[de]activate.d.
# This will allow them to be run on environment activation.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/scripts/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}_${CHANGE}.sh"
done

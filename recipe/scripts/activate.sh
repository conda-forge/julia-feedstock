#!/bin/sh

export JULIA_DEPOT_PATH_BACKUP=${JULIA_DEPOT_PATH:-}
export JULIA_PROJECT_BACKUP=${JULIA_PROJECT:-}
export JULIA_LOAD_PATH_BACKUP=${JULIA_LOAD_PATH:-}

# Move ~/.julia to a conda environment specific location
export JULIA_DEPOT_PATH="$CONDA_PREFIX/share/julia:$JULIA_DEPOT_PATH"

# Create a named environment for each conda environment
# Use of @ to specify a shared named environment is new as of Julia 1.7
# https://github.com/JuliaLang/julia/pull/40025
# The name of the environment is the last directory of the CONDA_PREFIX
export JULIA_PROJECT="@${CONDA_PREFIX##*/}"
# Modify load path so that projects stack on the conda-named environment
export JULIA_LOAD_PATH="@:$JULIA_PROJECT:@stdlib"

# make julia use same cert
export JULIA_SSL_CA_ROOTS_PATH_BACKUP=${JULIA_SSL_CA_ROOTS_PATH:-}
if [[ $OSTYPE != 'darwin'* ]]; then
  export JULIA_SSL_CA_ROOTS_PATH=$CONDA_PREFIX/ssl/cacert.pem
fi
# Otherwise, do nothing since we get the following error on macos:
# Your Julia is built with a SSL/TLS engine that libgit2 doesn't know
# how to configure to use a file or directory of certificate authority
# roots.


# Setup variables for Conda.jl
export CONDA_JL_HOME_BACKUP=${CONDA_JL_HOME:-}
export CONDA_JL_HOME=$CONDA_PREFIX
export CONDA_JL_CONDA_EXE_BACKUP=${CONDA_JL_CONDA_EXE:-}
export CONDA_JL_CONDA_EXE=$CONDA_EXE

# Setup CondaPkg.jl, see:
# https://github.com/cjdoris/CondaPkg.jl/issues/19
export JULIA_CONDAPKG_BACKEND_BACKUP=${JULIA_CONDAPKG_BACKEND:-}
export JULIA_CONDAPKG_BACKEND="System"
export JULIA_CONDAPKG_EXE_BACKUP=${JULIA_CONDAPKG_EXE:-}
export JULIA_CONDAPKG_EXE=$CONDA_EXE

# Setup PythonCall.jl
# Use the current Python rather than trying to setup a new conda environment
# https://discourse.julialang.org/t/how-to-use-pythoncall-with-a-previous-conda-environment/87419/8?u=mkitti
export JULIA_PYTHONCALL_EXE_BACKUP=${JULIA_PYTHONCALL_EXE:-}
export JULIA_PYTHONCALL_EXE=`which python`

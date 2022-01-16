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
 export JULIA_SSL_CA_ROOTS_PATH=$CONDA_PREFIX/ssl/cacert.pem

# Setup variables for Conda.jl
conda_path=$(which conda)
export CONDA_JL_HOME_BACKUP=${CONDA_JL_HOME:-}
export CONDA_JL_HOME = $CONDA_PREFIX
export CONDA_JL_CONDA_EXE_BACKUP=${CONDA_JL_CONDA_EXE:-}
export CONDA_JL_CONDA_EXE = ${conda_path%/*/*}

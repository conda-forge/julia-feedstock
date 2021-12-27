export JULIA_DEPOT_PATH_BACKUP=${JULIA_DEPOT_PATH:-}
export JULIA_PROJECT_BACKUP=${JULIA_PROJECT:-}
export JULIA_DEPOT_PATH="$CONDA_PREFIX/share/julia:$JULIA_DEPOT_PATH"
# Use of @ to specify a shared named environment is new as of Julia 1.7
# https://github.com/JuliaLang/julia/pull/40025
export JULIA_PROJECT="@$CONDA_DEFAULT_ENV"

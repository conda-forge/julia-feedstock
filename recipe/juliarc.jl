JULIA_PREFIX = abspath(joinpath(Base.source_path(), "..", "..", ".."))

if !("JULIA_PKGDIR" in keys(ENV))
    ENV["JULIA_PKGDIR"] = joinpath(JULIA_PREFIX, "share", "julia", "site")
    Pkg.init()
    Pkg.__init__()
    pop!(Base.LOAD_CACHE_PATH)
end

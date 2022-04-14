function is_unsafe_usable(; out = stderr, stdout = out, stderr = out)
    script = joinpath(@__DIR__, "check_unsafe_impls.jl")
    cmd = `$(Base.julia_cmd()) --startup-file=no $script`
    return success(pipeline(cmd; stdin = devnull, stdout, stderr))
end

const USE_UNSAFE = is_unsafe_usable(; out = devnull)
@static if USE_UNSAFE
    PreludeDicts.modify!(f::F, dict::Dict, k) where {F} = modify_unsafe!(f, dict, k)
    PreludeDicts.trysetwith!(factory::F, dict::Dict, k) where {F} =
        trysetwith_unsafe!(factory, dict, k)
    PreludeDicts.tryinsert!(set::Set, x) = tryinsert_unsafe!(set, x)
end

function Base.show(io::IO, x::Keep{T}) where {T}
    @nospecialize x
    value = x.value
    if typeof(value) === T
        print(io, Keep)
    else
        print(io, Keep{T})
    end
    print(io, "(")
    show(IOContext(io, :typeinfo => T), value)
    print(io, ")")
end

function Base.show(io::IO, x::Delete{T}) where {T}
    @nospecialize x
    value = x.value
    if typeof(value) === T
        print(io, Delete)
    else
        print(io, Delete{T})
    end
    print(io, "(")
    show(IOContext(io, :typeinfo => T), value)
    print(io, ")")
end

function Base.show(io::IO, ex::TypedKeyError{Key}) where {Key}
    @nospecialize ex
    key = ex.key
    if typeof(key) === Key
        print(io, TypedKeyError)
    else
        print(io, TypedKeyError{Key})
    end
    print(io, "(")
    show(IOContext(io, :typeinfo => Key), key)
    print(io, ")")
end

function Base.showerror(io::IO, ex::TypedKeyError{Key}) where {Key}
    @nospecialize ex
    key = ex.key
    print(io, "TypedKeyError: key ")
    show(io, key)
    print(io, " not found")
end

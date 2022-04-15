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

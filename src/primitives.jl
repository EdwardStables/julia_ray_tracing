import Base: ==

abstract type primitive end

mutable struct sphere <: primitive
    id::Int64
    transform::Union{Matrix{Float64},identity}
    i_transform::Union{Matrix{Float64},identity}
    material::material
    sphere(id::Int64) = new(id, I, I, material())
    sphere() = new(0, I, I, material())
end

function set_transform(s::sphere, t::Matrix{Float64})
    s.transform = t
    s.i_transform = inv(t)
end

function ==(s::sphere, c::sphere)
    s.id != c.id && return false
    s.transform != c.transform && return false
    s.i_transform != c.i_transform && return false
    s.material != c.material && return false

    return true
end

abstract type primitive end

mutable struct sphere <: primitive
    id::Int64
    transform::Union{Matrix{Float64},identity}
    i_transform::Union{Matrix{Float64},identity}
    material::material
    sphere(id::Int64) = new(id, I, I, material())
end

function set_transform(s::sphere, t::Matrix{Float64})
    s.transform = t
    s.i_transform = inv(t)
end

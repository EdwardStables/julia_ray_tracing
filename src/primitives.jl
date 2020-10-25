import Base: ==

mutable struct primitive_fields
    transform::Union{Matrix{Float64},identity}
    i_transform::Union{Matrix{Float64},identity}
    material::material
    id::Int
    primitive_fields() = new(I,I,material(),0)
end

get_transform(p::primitive) = p.fields.transform
get_i_transform(p::primitive) = p.fields.i_transform
get_material(p::primitive) = p.fields.material

function set_transform(p::primitive, t::Matrix{Float64})
    p.fields.transform = t
    p.fields.i_transform = inv(t)
end

function set_material(p::primitive, m::material)
    p.fields.material = m
end

function modify_material(p::primitive, f::Symbol, v::Float64)
    !hasfield(material, f) && error("Invalid field symbol")
    setfield!(get_material(p), f, v)
end

function ==(s::primitive, c::primitive)
    s.fields.transform != c.fields.transform && return false
    s.fields.i_transform != c.fields.i_transform && return false
    s.fields.material != c.fields.material && return false

    return true
end

#===== test shape =====#

mutable struct test_shape <: primitive
    fields::primitive_fields
    saved_ray::ray
    test_shape() = new(primitive_fields())
end

local_normal_at(::test_shape, p::point) = p

function local_intersect(s::test_shape, r::ray)::Vector{intersection}
    s.saved_ray = r
    return intersection[]
end

#===== sphere =====#

mutable struct sphere <: primitive
    fields::primitive_fields
    sphere() = new(primitive_fields())
end

local_normal_at(::sphere, p::point) = p - point(0,0,0)

function local_intersect(s::sphere, r::ray)::Vector{intersection}
    sphere_to_ray = r.origin - point(0,0,0)
    a = dot(r.direction, r.direction)
    b = 2*dot(r.direction, sphere_to_ray)
    c = dot(sphere_to_ray, sphere_to_ray) - 1
    Δ = b^2 - 4*a*c

    Δ < 0 && return intersection[]
    rΔ = √Δ
    return [intersection((-b - rΔ)/(2*a), s), intersection((-b + rΔ)/(2*a), s)]
end


#===== plane =====#

mutable struct plane <: primitive
    fields::primitive_fields
    plane() = new(primitive_fields())
end

local_normal_at(::plane, ::point) = vector(0,1,0)

function local_intersect(p::plane, r::ray)::Vector{intersection}
    #Four cases
    #ray parallel to plane (never intersects)
    #ray coplanar (infinite hits, but count as miss)
    #(both are accounted for in this case)
    if abs(r.direction.y) < 1e-10
        return intersection[]
    end

    #ray origin is above the plane
    #ray origin is below the plane

    return [intersection(-r.origin.y/r.direction.y, p)]
end

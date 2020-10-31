import Base: ==

mutable struct material <: abstract_material
    color::Union{color,pattern}
    ambient::Float64
    diffuse::Float64
    specular::Float64
    shininess::Float64
    material() = new(color(1,1,1), 0.1, 0.9, 0.9, 200.0)
    material(c::color, a::Float64, d::Float64, sp::Float64, sh::Float64) = 
        new(c, a, d, sp, sh)
end

get_color(m::material, p::point, obj::primitive) = get_color(m.color, p, obj)
get_color(c::color, ::point, ::primitive) = c
get_color(pat::pattern, p::point, obj::primitive) = pattern_at_object(pat, obj, p)
set_color(m::material, c::color) = setfield!(m, :color, c)
set_color(m::material, p::pattern) = setfield!(m, :color, p)

function ==(m1::material, m2::material)
    return m1.color == m2.color &&
           m1.ambient == m2.ambient &&
           m1.diffuse == m2.diffuse &&
           m1.specular == m2.specular &&
           m1.shininess == m2.shininess
end

set_transform(m::material, t::Matrix) = set_transform(m.color, t)

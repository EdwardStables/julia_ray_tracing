const black = color(0,0,0)
const white = color(1,1,1)

mutable struct pattern_fields
    transform::Union{Matrix{Float64},identity}
    i_transform::Union{Matrix{Float64},identity}
    pattern_fields() = new(I,I)
end

get_transform(p::pattern) = p.fields.transform
get_i_transform(p::pattern) = p.fields.i_transform

function set_transform(p::pattern, t::Matrix{Float64})
    p.fields.transform = t
    p.fields.i_transform = inv(t)
end

modify_transform(p::pattern, t::Matrix{Float64}) = 
    set_transform(p,  p.fields.transform * t)

function pattern_at_object(p::pattern, o::primitive, po::point)
    return pattern_at(p, get_i_transform(p) * get_i_transform(o) * po)
end

mutable struct test_pattern <: pattern
    fields::pattern_fields
    test_pattern() = new(pattern_fields())
end

pattern_at(p::test_pattern, po::point) = color(po.x, po.y, po.z)

mutable struct stripe_pattern <: pattern
    fields::pattern_fields
    a::color
    b::color
    stripe_pattern(a::color, b::color) = new(pattern_fields(), a, b)
    stripe_pattern() = new(pattern_fields(), white, black)
end

pattern_at(p::stripe_pattern, po::point) = iseven(floor(Int, po.x)) ? p.a : p.b

mutable struct gradient_pattern <: pattern
    fields::pattern_fields
    a::color
    b::color
    gradient_pattern(a::color, b::color) = new(pattern_fields(), a, b)
    gradient_pattern() = new(pattern_fields(), white, black)
end

pattern_at(p::gradient_pattern, po::point) = p.a+(p.b-p.a)*(po.x-floor(po.x))

mutable struct ring_pattern <: pattern
    fields::pattern_fields
    a::color
    b::color
    ring_pattern(a::color, b::color) = new(pattern_fields(), a, b)
    ring_pattern() = new(pattern_fields(), white, black)
end

pattern_at(p::ring_pattern, po::point) = 
    iseven(floor(Int64,sqrt(po.x^2+po.z^2))) ? p.a : p.b

mutable struct checkers_pattern <: pattern
    fields::pattern_fields
    a::color
    b::color
    checkers_pattern(a::color, b::color) = new(pattern_fields(), a, b)
    checkers_pattern() = new(pattern_fields(), white, black)
end

pattern_at(p::checkers_pattern, po::point) = 
    iseven(mapreduce(x->floor(Int, x), +, po)) ? p.a : p.b

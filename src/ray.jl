struct ray
    origin::point
    direction::vector
end

position(r::ray, t::T) where T <: Number = position(r, cf(t))
position(r::ray, t::Float64)::point = r.origin + r.direction * t

function intersect(s::primitive, ri::ray)::Vector{intersection}
    r = transform(ri, get_i_transform(s))
    return local_intersect(s, r)
end

struct intersection
    t::Float64
    object::primitive
end

intersections(i::intersection...)::Vector{intersection} = collect(i)

function hit(i::Vector{intersection})::Union{intersection,Nothing}
    #TODO current sorts on demand
    #can make Vector{intersection} its own data structure that does
    #an ordered insert to avoid this
    sort!(i, by=x->x.t)
    arr = filter(x -> x.t>=(0), i)
    return length(arr) > 0 ? arr[1] : nothing
end

transform(r::ray, ::identity) = r
function transform(r::ray, m::Matrix{Float64})::ray
    return ray(m*r.origin, m*r.direction)
end

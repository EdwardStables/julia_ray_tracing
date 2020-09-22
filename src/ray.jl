struct ray
    origin::point
    direction::vector
    #ray(o::point, d::vector) = new(o, normalize(d))
end

position(r::ray, t::T) where T <: Number = position(r, cf(t))
position(r::ray, t::Float64)::point = r.origin + r.direction * t

function intersect(s::sphere, ri::ray)::Vector{intersection}
    r = transform(ri, s.i_transform)

    sphere_to_ray = r.origin - point(0,0,0)
    a = dot(r.direction, r.direction)
    b = 2*dot(r.direction, sphere_to_ray)
    c = dot(sphere_to_ray, sphere_to_ray) - 1
    Δ = b^2 - 4*a*c

    Δ < 0 && return intersection[]
    rΔ = √Δ
    return [intersection((-b - rΔ)/(2*a), s), intersection((-b + rΔ)/(2*a), s)]
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

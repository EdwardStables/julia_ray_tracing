import Base: ==, +, -, *, /

tuple(v::Vector{T}) where T <: Number = tuple(v...)
function tuple(x::T, y::T, z::T, w::T) where T <: Number
    w == 1.0 && return point(x, y, z)
    w == 0.0 && return vector(x, y, z)
    error("Tuple must have w=0 or w=1")
end

tovec(t::tuple) = [t.x, t.y, t.z, t.w]

Base.iterate(t::tuple) = (t.x, 2)
Base.iterate(t::tuple, s::Int64) = s==4 ? nothing : (s==3 ? (t.z,4) : (t.y,3))


mutable struct point <: tuple
    x::Float64
    y::Float64
    z::Float64
    w::Float64

    function point(x, y, z)
        c = i -> convert(Float64, i)
        point(c(x), c(y), c(z))
    end
    function point(x::Float64, y::Float64, z::Float64)
        p = new()
        p.x = x
        p.y = y
        p.z = z
        p.w = 1.0
        return p
    end
end

mutable struct vector <: tuple
    x::Float64
    y::Float64
    z::Float64
    w::Float64

    function vector(x, y, z)
        c = i -> convert(Float64, i)
        vector(c(x), c(y), c(z))
    end
    function vector(x::T, y::T, z::T) where T <: Number
        v = new()
        v.x = x
        v.y = y
        v.z = z
        v.w = 0.0
        return v
    end
end

#= Arithmetic =#
==(p1::point, p2::point)::Bool = 
    isapprox(p1.x, p2.x, atol=1e-10) &&
    isapprox(p1.y, p2.y, atol=1e-10) &&
    isapprox(p1.z, p2.z, atol=1e-10)

==(v1::vector, v2::vector)::Bool = 
    isapprox(v1.x, v2.x, atol=1e-10) &&
    isapprox(v1.y, v2.y, atol=1e-10) &&
    isapprox(v1.z, v2.z, atol=1e-10)

+(t1::point, t2::point) = throw(ErrorException("Adding points is invalid"))
+(t1::tuple, t2::tuple) = 
    tuple(t1.x+t2.x, t1.y+t2.y, t1.z+t2.z, t1.w+t2.w)

-(v::vector, p::point) = throw(ErrorException("can't subtract a point from a vector"))
-(t1::tuple, t2::tuple) = 
    tuple(t1.x-t2.x, t1.y-t2.y, t1.z-t2.z, t1.w-t2.w)
-(t::vector) = vector(-t.x, -t.y, -t.z)

*(t::Number, v::vector) = vector(t*v.x, t*v.y, t*v.z)
*(v::vector, t::Number) = *(t,v)

/(v::vector, t::Number) = vector(v.x/t, v.y/t, v.z/t)

#= Linear Algebra =#
magnitude(v::vector) = sqrt(mapreduce(x->x^2,+,[v.x, v.y, v.z]))

function normalize(v::vector)::vector
    m = magnitude(v)
    return vector(v.x/m, v.y/m, v.z/m)
end

dot(v1::vector, v2::vector) = 
    sum([v1.x*v2.x, v1.y*v2.y, v1.z*v2.z]) 

cross(v1::vector, v2::vector) = vector(
    v1.y * v2.z - v1.z * v2.y,
    v1.z * v2.x - v1.x * v2.z,
    v1.x * v2.y - v1.y * v2.x
   )


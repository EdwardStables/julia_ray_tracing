mutable struct color <: tuple
    r::Float64
    g::Float64
    b::Float64

    function color(r, g, b)
        c = i -> convert(Float64, i)
        color(c(r), c(g), c(b))
    end

    color(r::Float64, g::Float64, b::Float64) = new(r, g, b)
end

function ==(c1::color, c2::color) 
    return c1.r ≈ c2.r && c1.g ≈ c2.g && c1.b ≈ c2.b
end

#= Arithmetic =#

function +(c1::color, c2::color)
    return color(c1.r + c2.r,  c1.g + c2.g,  c1.b + c2.b)
end

function -(c1::color, c2::color)
    return color(c1.r - c2.r,  c1.g - c2.g,  c1.b - c2.b)
end

*(i::Number, c::color) = c * i
function *(c::color, i::Number)
    return color(c.r * i, c.g * i, c.b * i)
end

*(c1::color, c2::color) = hadamard_product(c1, c2)

function hadamard_product(c1::color, c2::color)
    return color(c1.r * c2.r, c1.g * c2.g, c1.b * c2.b)
end

abstract type light end

struct point_light <: light
    position::point
    intensity::color
end

function ==(m::light, n::light)
    return m.position == n.position && m.intensity == n.intensity
end

function lighting(m::T, obj::primitive, l::point_light, 
                  pos::point, eyev::vector, norm::vector,
                 )::color where T <: abstract_material
    lighting(m,obj,l,pos,eyev,norm,false)
end
function lighting(m::T, obj::primitive, l::point_light, 
                  pos::point, eyev::vector, norm::vector,
                  in_shadow::Bool
                 )::color where T <: abstract_material

    #the color we will see
    effective_color = get_color(m, pos, obj) * l.intensity
    #the ambient aspect
    ambient = effective_color * m.ambient
    in_shadow && return ambient

    #the direction to the light source
    lightv = normalize(l.position - pos)

    #the cosine of the angle between the light vector and the normal vector
    #-ve means light is on the other side of the surface
    light_dot_normal = dot(lightv, norm)
    black = color(0,0,0)

    if light_dot_normal < 0
        diffuse = black
        specular = black
    else
        #diffuse contribution
        diffuse = effective_color * m.diffuse * light_dot_normal

        #the cosine of the angle between the reflection vector and the eye
        #negative means the light reflects away from the eye
        reflect_dot_eye = dot(reflect(-lightv, norm), eyev)
        
        if reflect_dot_eye <= 0
            specular = black
        else
            factor = reflect_dot_eye^m.shininess
            specular = l.intensity * m.specular * factor
        end
    end

    return ambient + diffuse + specular
end

function is_shadowed(w::abstract_world, p::point)::Bool
    d = w.light.position - p
    dir = normalize(d)
    xs = intersect_world(w, ray(p,dir))
    h = hit(xs)
    h == nothing && return false
    h.t < magnitude(d) && return true
    return false
end

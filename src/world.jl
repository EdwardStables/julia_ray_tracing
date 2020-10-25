mutable struct world <: abstract_world
    #TODO make light a vector and support multiple lighting sources
    light::Union{light,Nothing}
    objects::Vector{primitive}
    world() = new(nothing, primitive[])
end

function default_world()
    w = world()
    w.light = point_light(point(-10, 10, -10), color(1,1,1))
    w.objects = [sphere(), sphere()]
    set_material(w.objects[1], material(color(0.8, 1.0, 0.6), 0.1, 0.7, 0.2, 200.0))
   
    set_transform(w.objects[2], scaling(0.5, 0.5, 0.5))

    return w
end

function intersect_world(w::world, r::ray)::Vector{intersection}
    intersections = intersection[]
    for object in w.objects
        append!(intersections, intersect(object, r))
    end

    sort!(intersections, by=x->x.t)

    return intersections
end

#= TODO move this somewhere more appropriate =#

mutable struct computation
    t::Float64
    object::primitive
    point::point
    eyev::vector
    normalv::vector
    inside::Bool
    over_point::point

    computation() = new()
    function computation(i::intersection, r::ray)
        comps = new() 
        comps.t = i.t
        comps.object = i.object
        comps.point = position(r, comps.t)
        comps.eyev = -r.direction
        comps.normalv = normal_at(comps.object, comps.point)
        comps.over_point = comps.point + comps.normalv * 1e-10

        if dot(comps.normalv, comps.eyev) < 0
            comps.inside = true
            comps.normalv = -comps.normalv
        else
            comps.inside = false
        end

        return comps
    end
end

prepare_computations(i::intersection, r::ray)::computation = computation(i, r)

#= end TODO =#

function shade_hit(w::world, c::computation)::color
    shadowed = is_shadowed(w, c.over_point)
    return lighting(get_material(c.object),
                    w.light,
                    c.point,
                    c.eyev,
                    c.normalv,
                    shadowed)
end

function color_at(w::world, r::ray)::color
    i = intersect_world(w, r)
    h = hit(i)
    h == nothing && return color(0,0,0)
    pc = prepare_computations(h, r)
    return shade_hit(w, pc)
end

function view_transform(from::point, to::point, up::vector)::Matrix
    forward = normalize(to - from)
    left = cross(forward, normalize(up))
    true_up = cross(left, forward)

    orientation = [left.x      left.y     left.z    0;
                   true_up.x   true_up.y  true_up.z 0;
                  -forward.x  -forward.y -forward.z 0;
                   0           0          0         1]

    return orientation * translation(-from.x, -from.y, -from.z)
end


mutable struct camera
    hsize::Int64   
    vsize::Int64   
    fov::Float64
    transform::Union{identity,Matrix}
    pixel_size::Float64
    half_width::Float64
    half_height::Float64

    function camera(hsize::Int64, vsize::Int64, fov::Float64)
        c = new()
        c.hsize = hsize
        c.vsize = vsize
        c.fov = fov 
        c.transform = I
        
        aspect = c.hsize / c.vsize
        half_view = tan(c.fov/2)
        if aspect > 1
            c.half_width = half_view
            c.half_height = half_view / aspect
        else
            c.half_width = half_view * aspect
            c.half_height = half_view
        end

        c.pixel_size = c.half_width * 2 / hsize

        return c
    end
end

function ray_for_pixel(c::camera, px::Int64, py::Int64)::ray
    #offset from the pixel center to the edge of the canvas
    xoffset = (px + 0.5) * c.pixel_size
    yoffset = (py + 0.5) * c.pixel_size

    #the untransformed coordinates of the pixel in world space
    worldx = c.half_width - xoffset
    worldy = c.half_height - yoffset

    #transform the canvas point and the origin
    #z=-1 as the canvas is offset from the camera by 1 unit
    pixel = inv(c.transform) * point(worldx, worldy, -1)
    origin = inv(c.transform) * point(0,0,0)
    direction = normalize(pixel - origin)

    return ray(origin, direction)
end


function render(c::camera, w::world)
    image = canvas(c.hsize, c.vsize)    

    for y = 1:c.vsize
        for x = 1:c.hsize
            ray = ray_for_pixel(c, x, y)
            color = color_at(w, ray)
            write_pixel(image, x, y, color)
        end
    end

    return image
end

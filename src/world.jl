mutable struct world
    light::Union{light,Nothing}
    objects::Vector{primitive}
    world() = new(nothing, primitive[])
end

function default_world()
    w = world()
    w.light = point_light(point(-10, 10, -10), color(1,1,1))
    w.objects = [sphere(), sphere()]
    w.objects[1].material = material(color(0.8, 1.0, 0.6), 0.1, 0.7, 0.2, 200.0)
   
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

    computation() = new()
    function computation(i::intersection, r::ray)
        comps = new() 
        comps.t = i.t
        comps.object = i.object
        comps.point = position(r, comps.t)
        comps.eyev = -r.direction
        comps.normalv = normal_at(comps.object, comps.point)

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

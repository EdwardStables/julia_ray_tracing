function normal_at(s::sphere, p::point)
    #transform to object space
    object_point = s.i_transform * p
    #find the normal vector in object space (assuming unit sphere)
    object_normal = object_point - point(0,0,0)
    #transform back to world space
    #inverse multiplication isn't technically correct, it messes with the w
    #component. So hack around this by setting w to 0
    world_normal = *(Array(s.i_transform'), object_normal; force_w=0)
    #inverse also messes up the normalized property, so fix that
    return normalize(world_normal)
end

reflect(v::vector, n::vector) = v - n * 2 * dot(v,n)

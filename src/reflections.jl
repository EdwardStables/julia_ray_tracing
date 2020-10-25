function normal_at(s::primitive, p::point)
    #transform to object space
    object_point = get_i_transform(s) * p
    #find the normal vector in object space
    object_normal = local_normal_at(s, object_point)
    #transform back to world space
    #inverse multiplication isn't technically correct, it messes with the w
    #component. So hack around this by setting w to 0
    world_normal = *(Array(get_i_transform(s)'), object_normal; force_w=0)
    #inverse also messes up the normalized property, so fix that
    return normalize(world_normal)
end

reflect(v::vector, n::vector) = v - n * 2 * dot(v,n)



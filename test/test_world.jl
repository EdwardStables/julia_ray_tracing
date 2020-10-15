@testset "world" begin
    w = rt.world()
    @test w.objects == rt.primitive[]
    @test w.light == nothing

    #test that default world works
    l = rt.point_light(rt.point(-10, 10, -10), rt.color(1,1,1))
    s1 = rt.sphere()
    s1.material = rt.material(rt.color(0.8, 1.0, 0.6), 0.1, 0.7, 0.2, 200.0)
   
    s2 = rt.sphere()
    rt.set_transform(s2, rt.scaling(0.5, 0.5, 0.5))

    w = rt.default_world()
    @test w.light == l
    @test w.objects[1] == s1
    @test w.objects[2] == s2

    w = rt.default_world()
    r = rt.ray(rt.point(0, 0, -5), rt.vector(0,0,1))
    xs = rt.intersect_world(w, r)
    @test length(xs) == 4
    @test xs[1].t == 4
    @test xs[2].t == 4.5
    @test xs[3].t == 5.5
    @test xs[4].t == 6

    r = rt.ray(rt.point(0, 0, -5), rt.vector(0,0,1))
    shape = rt.sphere()
    i = rt.intersection(4, shape)
    
    comps = rt.prepare_computations(i, r)
    @test comps.t == i.t
    @test comps. object == i.object
    @test comps.point == rt.point(0,0,-1)
    @test comps.eyev == rt.vector(0,0,-1)
    @test comps.normalv == rt.vector(0,0,-1)


    #test intersection on the outside
    r = rt.ray(rt.point(0, 0, -5), rt.vector(0,0,1))
    shape = rt.sphere()
    i = rt.intersection(4, shape)
    comps = rt.prepare_computations(i,r)
    comps.inside = false
 
    #test intersection on the inside
    r = rt.ray(rt.point(0, 0, 0), rt.vector(0,0,1))
    shape = rt.sphere()
    i = rt.intersection(1, shape)
    comps = rt.prepare_computations(i,r)
    @test comps.point == rt.point(0,0,1)
    @test comps.eyev == rt.vector(0,0,-1)
    @test comps.inside == true
    #normal is inverted
    @test comps.normalv == rt.vector(0,0,-1)

    #shading an intersection
    w = rt.default_world()
    r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
    shape = w.objects[1]
    i = rt.intersection(4, shape)
    comps = rt.prepare_computations(i, r)
    c = rt.shade_hit(w, comps)
    @test c == rt.color(0.38066119308103435, 
                        0.47582649135129296, 
                        0.28549589481077575)

    #shading and intersection from the inside
    w = rt.default_world()
    w.light = rt.point_light(rt.point(0, 0.25, 0), rt.color(1,1,1))
    r = rt.ray(rt.point(0,0,0), rt.vector(0,0,1))
    shape = w.objects[2]
    i = rt.intersection(0.5, shape)
    comps = rt.prepare_computations(i, r)
    c = rt.shade_hit(w, comps)
    #@test c == rt.color(0.9049844720832575, 
    #                    0.9049844720832575, 
    #                    0.9049844720832575)
    #addition of shadows means that this sphere is 
    #shaded and only has ambient light
    @test c == rt.color(0.1, 0.1, 0.1)

    #wrapper function
    w = rt.default_world()
    r = rt.ray(rt.point(0,0,-5), rt.vector(0,1,0))
    c = rt.color_at(w,r)
    @test c == rt.color(0,0,0)
    
    w = rt.default_world()
    r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
    c = rt.color_at(w,r)
    @test c == rt.color(0.38066119308103435, 
                        0.47582649135129296, 
                        0.28549589481077575)

    w = rt.default_world()
    outer = w.objects[1]
    outer.material.ambient = 1
    inner = w.objects[2]
    inner.material.ambient = 1
    r = rt.ray(rt.point(0,0,0.75), rt.vector(0,0,-1))
    c = rt.color_at(w,r)
    @test c == inner.material.color

    @testset "view transform" begin
        from = rt.point(0,0,0)
        to = rt.point(0,0,-1)
        up = rt.vector(0,1,0)
        t = rt.view_transform(from, to, up)
        @test t == rt.I

        #looking in the opposite direction is the same as reflection
        from = rt.point(0,0,0)
        to = rt.point(0,0,1)
        up = rt.vector(0,1,0)
        t = rt.view_transform(from, to, up)
        @test t == rt.scaling(-1, 1, -1)

        #show that it is the world that is being moved
        from = rt.point(0,0,8)
        to = rt.point(0,0,0)
        up = rt.vector(0,1,0)
        t = rt.view_transform(from, to, up)
        @test t == rt.translation(0, 0, -8)

        #test for arbitrary direction
        from = rt.point(1,3,2)
        to = rt.point(4,-2,8)
        up = rt.vector(1,1,0)
        t = rt.view_transform(from, to, up)
        @test t == [-0.5070925528371099 0.5070925528371099 0.6761234037828132 -2.366431913239846; 
                     0.7677159338596801 0.6060915267313263 0.12121830534626524 -2.8284271247461894; 
                    -0.35856858280031806 0.5976143046671968 -0.7171371656006361 0.0; 
                     0.0 0.0 0.0 1.0]
    end

    @testset "camera" begin
        hsize = 160
        vsize = 120
        fov = π/2
        c = rt.camera(hsize, vsize, fov)
        @test c.hsize == 160
        @test c.vsize == 120
        @test c.fov == π/2
        @test c.transform == rt.I

        #pixel size for a horizontal canvas
        c = rt.camera(200, 125, π/2)
        @test c.pixel_size ≈ 0.01
        #pixel size for a vertical canvas
        c = rt.camera(125, 200, π/2)
        @test c.pixel_size ≈ 0.01

        c = rt.camera(201, 101, π/2)
        r = rt.ray_for_pixel(c, 100, 50)
        @test r.origin == rt.point(0,0,0)
        @test r.direction == rt.vector(0,0,-1)

        c = rt.camera(201, 101, π/2)
        r = rt.ray_for_pixel(c, 0, 0)
        @test r.origin == rt.point(0,0,0)
        @test r.direction == rt.vector(0.6651864261194508, 0.3325932130597254, -0.6685123582500481)

        c = rt.camera(201, 101, π/2)
        c.transform = rt.rotation_y(π/4) * rt.translation(0,-2,5)
        r = rt.ray_for_pixel(c, 100, 50)
        @test r.origin == rt.point(0,2,-5)
        @test r.direction == rt.vector(√2/2, 0, -√2/2)

        #test if the render function works
        w = rt.default_world()
        c = rt.camera(11, 11, π/2)
        from = rt.point(0,0,-5)
        to = rt.point(0,0,0)
        up = rt.vector(0,1,0)
        c.transform = rt.view_transform(from, to, up)
        image = rt.render(c,w)
        @test rt.pixel_at(image, 5, 5) == rt.color(0.38066119308103435, 0.47582649135129296, 0.28549589481077575)
    end

    @testset "shadow shade" begin
        w = rt.world()
        w.light = rt.point_light(rt.point(0,0,-10), rt.color(1,1,1))
        s1 = rt.sphere()
        s2 = rt.sphere()
        rt.set_transform(s2, rt.translation(0,0,10))
        w.objects = [s1, s2]
        r = rt.ray(rt.point(0,0,5), rt.vector(0,0,1))
        i = rt.intersection(4, s2)
        comps = rt.prepare_computations(i, r)
        c = rt.shade_hit(w, comps)
        @test c == rt.color(0.1,0.1,0.1)

        #the hit should have a small offset
        r = rt.ray(rt.point(0,0,-5),rt.vector(0,0,1))
        shape = rt.sphere()
        rt.set_transform(shape, rt.translation(0,0,1))
        i = rt.intersection(5,shape)
        comps = rt.prepare_computations(i, r)
        @test comps.over_point.z < -1e-10/2
        @test comps.point.z > comps.over_point.z
    end
end


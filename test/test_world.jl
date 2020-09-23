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
end

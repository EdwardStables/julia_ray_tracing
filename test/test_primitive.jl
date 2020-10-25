@testset "primitives" begin
    @testset "test_shape" begin
        s = rt.test_shape()
        @test rt.get_transform(s) == rt.I

        s = rt.test_shape()
        rt.set_transform(s, rt.translation(2,3,4))
        @test rt.get_transform(s) == rt.translation(2,3,4)

        s = rt.test_shape()
        m = rt.get_material(s)
        @test m == rt.material()

        s = rt.test_shape()
        m = rt.material()
        m.ambient = 1.0
        rt.set_material(s, m)
        @test rt.get_material(s) == m

        r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
        s = rt.test_shape()
        rt.set_transform(s, rt.scaling(2,2,2))
        xs = rt.intersect(s,r)
        @test s.saved_ray.origin == rt.point(0,0,-2.5)
        @test s.saved_ray.direction == rt.vector(0,0,0.5)

        r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
        s = rt.test_shape()
        rt.set_transform(s, rt.translation(5,0,0))
        xs = rt.intersect(s,r)
        @test s.saved_ray.origin == rt.point(-5,0,-5)
        @test s.saved_ray.direction == rt.vector(0,0,1)
    end

    @testset "plane" begin
        #local normal
        p = rt.plane()
        n1 = rt.local_normal_at(p, rt.point(0,0,0))
        n2 = rt.local_normal_at(p, rt.point(10,0,-10))
        n3 = rt.local_normal_at(p, rt.point(-5,0,150))
        @test n1 == rt.vector(0,1,0)
        @test n2 == rt.vector(0,1,0)
        @test n3 == rt.vector(0,1,0)

        #test ray is parallel
        p = rt.plane()
        r = rt.ray(rt.point(0,10,0), rt.vector(0,0,1))
        xs = rt.local_intersect(p, r)
        @test xs == rt.intersection[]

        #test ray is coplanar
        p = rt.plane()
        r = rt.ray(rt.point(0,0,0), rt.vector(0,0,1))
        xs = rt.local_intersect(p, r)
        @test xs == rt.intersection[]
        
        #intersect from above
        p = rt.plane()
        r = rt.ray(rt.point(0,1,0), rt.vector(0,-1,0))
        xs = rt.local_intersect(p, r)
        @test length(xs) == 1
        @test xs[1].t == 1
        @test xs[1].object == p

        #intersect from below 
        p = rt.plane()
        r = rt.ray(rt.point(0,-1,0), rt.vector(0,1,0))
        xs = rt.local_intersect(p, r)
        @test length(xs) == 1
        @test xs[1].t == 1
    end
end

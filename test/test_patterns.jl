@testset "patterns" begin
    @testset "stripe" begin
        pattern = rt.stripe_pattern(rt.white, rt.black)
        @test pattern.a == rt.white
        @test pattern.b == rt.black

        #pattern is constant in y
        pattern = rt.stripe_pattern(rt.white, rt.black)
        @test rt.pattern_at(pattern, rt.point(0,0,0)) == rt.white
        @test rt.pattern_at(pattern, rt.point(0,1,0)) == rt.white
        @test rt.pattern_at(pattern, rt.point(0,2,0)) == rt.white
        
        #pattern is constant in z
        pattern = rt.stripe_pattern(rt.white, rt.black)
        @test rt.pattern_at(pattern, rt.point(0,0,0)) == rt.white
        @test rt.pattern_at(pattern, rt.point(0,0,1)) == rt.white
        @test rt.pattern_at(pattern, rt.point(0,0,2)) == rt.white

        #pattern alternates in x
        pattern = rt.stripe_pattern(rt.white, rt.black)
        @test rt.pattern_at(pattern, rt.point(0,0,0)) == rt.white
        @test rt.pattern_at(pattern, rt.point(0.9,0,0)) == rt.white
        @test rt.pattern_at(pattern, rt.point(1,0,0)) == rt.black
        @test rt.pattern_at(pattern, rt.point(-0.1,0,0)) == rt.black
        @test rt.pattern_at(pattern, rt.point(-1,0,0)) == rt.black
        @test rt.pattern_at(pattern, rt.point(-1.1,0,0)) == rt.white
       
        #transformations on stripes
        
        #object transformation
        object = rt.sphere()
        rt.set_transform(object, rt.scaling(2,2,2))
        pattern = rt.stripe_pattern(rt.white, rt.black)
        c = rt.pattern_at_object(pattern, object, rt.point(1.5, 0, 0))
        @test c == rt.white
        #pattern transformation
        object = rt.sphere()
        pattern = rt.stripe_pattern(rt.white, rt.black)
        rt.set_transform(pattern, rt.scaling(2,2,2))
        c = rt.pattern_at_object(pattern, object, rt.point(1.5, 0, 0))
        @test c == rt.white
        #object and pattern transformation
        object = rt.sphere()
        rt.set_transform(object, rt.scaling(2,2,2))
        pattern = rt.stripe_pattern(rt.white, rt.black)
        rt.set_transform(pattern, rt.translation(0.5,0.0,0.0))
        c = rt.pattern_at_object(pattern, object, rt.point(2.5, 0, 0))
        @test c == rt.white

        m = rt.material()
        m.color = rt.stripe_pattern(rt.white, rt.black)
        m.ambient = 1
        m.diffuse = 0
        m.specular = 0
        obj = rt.sphere()
        eyev = rt.vector(0,0,-1)
        normalv = rt.vector(0,0,-1)
        light = rt.point_light(rt.point(0,0,-1), rt.white)
        c1 = rt.lighting(m, obj, light, rt.point(0.9,0,0), eyev, normalv, false)
        c2 = rt.lighting(m, obj, light, rt.point(1.1,0,0), eyev, normalv, false)
        @test c1 == rt.white
        @test c2 == rt.black
    end

    @testset "general functionality" begin
        pattern = rt.test_pattern()
        @test rt.get_transform(pattern) == rt.I

        pattern = rt.test_pattern()
        rt.set_transform(pattern, rt.translation(1,2,3))
        @test rt.get_transform(pattern) == rt.translation(1,2,3)

        shape = rt.sphere() 
        rt.set_transform(shape, rt.scaling(2,2,2))
        pattern = rt.test_pattern()
        @test rt.pattern_at_object(pattern, shape, rt.point(2,3,4)) == rt.color(1, 1.5, 2)

        shape = rt.sphere() 
        pattern = rt.test_pattern()
        rt.set_transform(shape, rt.scaling(2,2,2))
        @test rt.pattern_at_object(pattern, shape, rt.point(2,3,4)) == rt.color(1, 1.5, 2)

        s = rt.sphere()
        p = rt.test_pattern()
        rt.set_transform(s, rt.scaling(2,2,2))
        rt.set_transform(p, rt.translation(0.5,1.0,1.5))
        @test rt.pattern_at_object(p, s, rt.point(2.5,3,3.5)) == rt.color(0.75, 0.5, 0.25)
    end    

    @testset "gradiant" begin
        p = rt.gradient_pattern(rt.white, rt.black)
        @test rt.pattern_at(p, rt.point(0,0,0)) == rt.white
        @test rt.pattern_at(p, rt.point(0.25,0.0,0.0)) == rt.color(0.75, 0.75, 0.75)
        @test rt.pattern_at(p, rt.point(0.5,0.0,0.0)) == rt.color(0.5, 0.5, 0.5)
        @test rt.pattern_at(p, rt.point(0.75,0.0,0.0)) == rt.color(0.25, 0.25, 0.25)
    end

    @testset "ring" begin
        p = rt.ring_pattern()
        @test rt.pattern_at(p, rt.point(0,0,0)) == rt.white 
        @test rt.pattern_at(p, rt.point(1,0,0)) == rt.black
        @test rt.pattern_at(p, rt.point(0,0,1)) == rt.black
        @test rt.pattern_at(p, rt.point(0.708,0.0,0.708)) == rt.black
    end

    @testset "checkers" begin
        p = rt.checkers_pattern()
        @test rt.pattern_at(p, rt.point( 0.0,0.0,0.0)) == rt.white
        @test rt.pattern_at(p, rt.point(0.99,0.0,0.0)) == rt.white
        @test rt.pattern_at(p, rt.point(1.01,0.0,0.0)) == rt.black
        p = rt.checkers_pattern()
        @test rt.pattern_at(p, rt.point(0.0,0.0,0.0)) == rt.white
        @test rt.pattern_at(p, rt.point(0.0,0.99,0.0)) == rt.white
        @test rt.pattern_at(p, rt.point(0.0,1.01,0.0)) == rt.black
        p = rt.checkers_pattern()
        @test rt.pattern_at(p, rt.point(0.0,0.0,0.0)) == rt.white
        @test rt.pattern_at(p, rt.point(0.0,0.0,0.99)) == rt.white
        @test rt.pattern_at(p, rt.point(0.0,0.0,1.01)) == rt.black
    end
end

@testset "reflections" begin
    @testset "sphere normal" begin
        s = rt.sphere()
        n = rt.normal_at(s, rt.point(1,0,0))
        @test n == rt.vector(1,0,0)

        s = rt.sphere()
        n = rt.normal_at(s, rt.point(0,1,0))
        @test n == rt.vector(0,1,0)

        s = rt.sphere()
        n = rt.normal_at(s, rt.point(0,0,1))
        @test n == rt.vector(0,0,1)

        s = rt.sphere()
        n = rt.normal_at(s, rt.point(√3/3,√3/3,√3/3))
        @test n == rt.vector(√3/3,√3/3,√3/3)

        s = rt.sphere()
        n = rt.normal_at(s, rt.point(√3/3,√3/3,√3/3))
        @test n == rt.normalize(n)

        s = rt.test_shape()
        rt.set_transform(s, rt.translation(0,1,0))
        n = rt.normal_at(s, rt.point(0, 1.70711, -0.70711))
        @test n == rt.vector(0, 0.7071067811865475, -0.7071067811865476)

        s = rt.test_shape()
        m = rt.scaling(1.0, 0.5, 1.0) * rt.rotation_z(π/5)
        rt.set_transform(s, m)
        n = rt.normal_at(s, rt.point(0, √2/2, -√2/2))
        @test n == rt.vector(0, 0.9701425001453319, -0.24253562503633305)
    end

    @testset "reflection" begin
        v = rt.vector(1, -1, 0)
        n = rt.vector(0, 1, 0)
        r = rt.reflect(v, n)
        @test r == rt.vector(1,1,0)

        v = rt.vector(0, -1, 0)
        n = rt.vector(√2/2, √2/2, 0)
        r = rt.reflect(v, n)
        @test r == rt.vector(1,0,0)

        
    end
end

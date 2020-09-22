@testset "transforms" begin 
    @testset "translation" begin
        transform = rt.translation(5, -3, 2)
        p = rt.point(-3, 4, 5)
        @test transform * p == rt.point(2, 1, 7)

        transform = rt.translation(5, -3, 2)
        inv = rt.inverse(transform)
        p = rt.point(-3, 4, 5)
        @test inv * p == rt.point(-8, 7, 3)

        transform = rt.translation(5, -3, 2)
        v = rt.vector(-3, 4, 5)
        @test transform * v == v
    end
    @testset "scale" begin
        t = rt.scaling(2, 3, 4)
        p = rt.point(-4, 6, 8)
        @test t * p == rt.point(-8, 18, 32)

        t = rt.scaling(2, 3, 4)
        v = rt.vector(-4, 6, 8)
        @test t * v == rt.vector(-8, 18, 32)

        t = rt.scaling(2, 3, 4)
        i = rt.inverse(t)
        v = rt.vector(-4, 6, 8)
        @test i * v == rt.vector(-2, 2, 2)

        t = rt.scaling(-1, 1, 1)
        p = rt.point(2, 3, 4)
        @test t * p == rt.point(-2, 3, 4)
    end

    @testset "rotation" begin 
        p = rt.point(0, 1, 0)
        half_quarter = rt.rotation_x(pi/4)
        full_quarter = rt.rotation_x(pi/2)
        @test half_quarter * p == rt.point(0, √2/2, √2/2)
        #broken, I think fp inaccuracy?
        #@test full_quarter * p == rt.point(0, 0, 1)
        @test full_quarter * p == rt.point(0, 0, 1)

        p = rt.point(0, 1, 0)
        half_quarter = rt.rotation_x(pi/4)
        i = rt.inverse(half_quarter)
        @test i * p == rt.point(0, √2/2, -√2/2)

        half_quarter = rt.rotation_y(π/4)
        full_quarter = rt.rotation_y(π/2)
        p = rt.point(0, 0, 1)
        @test half_quarter * p == rt.point(√2/2, 0, √2/2)
        @test full_quarter * p == rt.point(1, 0, 0)

        half_quarter = rt.rotation_z(π/4)
        full_quarter = rt.rotation_z(π/2)
        p = rt.point(0, 1, 0)
        @test half_quarter * p == rt.point(-√2/2, √2/2, 0)
        @test full_quarter * p == rt.point(-1, 0, 0)
    end

    @testset "shear" begin
        t = rt.shearing(1, 0, 0, 0, 0, 0)
        p = rt.point(2, 3, 4)
        @test t * p == rt.point(5, 3, 4)
        
        t = rt.shearing(0, 1, 0, 0, 0, 0)
        p = rt.point(2, 3, 4)
        @test t * p == rt.point(6, 3, 4)

        t = rt.shearing(0, 0, 1, 0, 0, 0)
        p = rt.point(2, 3, 4)
        @test t * p == rt.point(2, 5, 4)

        t = rt.shearing(0, 0, 0, 1, 0, 0)
        p = rt.point(2, 3, 4)
        @test t * p == rt.point(2, 7, 4)

        t = rt.shearing(0, 0, 0, 0, 1, 0)
        p = rt.point(2, 3, 4)
        @test t * p == rt.point(2, 3, 6)
        
        t = rt.shearing(0, 0, 0, 0, 0, 1)
        p = rt.point(2, 3, 4)
        @test t * p == rt.point(2, 3, 7)
    end

    @testset "chaining" begin
        p = rt.point(1, 0, 1)
        A = rt.rotation_x(pi/2)
        B = rt.scaling(5, 5, 5)
        C = rt.translation(10, 5, 7)

        p2 = A * p
        @test p2 == rt.point(1, -1, 0)

        p3 = B * p2
        @test p3 == rt.point(5, -5, 0)

        p4 = C * p3
        @test p4 == rt.point(15, 0, 7)

        T = C * B * A 
        @test T * p == rt.point(15, 0, 7)
    end
end

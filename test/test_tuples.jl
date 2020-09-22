@testset "tuple" begin
    @testset "basics" begin
        #A tuple with w=1 is a point
        t = rt.tuple(4.3, -4.2, 3.1, 1.0)
        @test t.x == 4.3
        @test t.y == -4.2
        @test t.z == 3.1
        @test t.w == 1.0
        @test typeof(t) == rt.point
        @test typeof(t) != rt.vector
    
        #A tuple with w=0 is a vector
        t = rt.tuple(4.3, -4.2, 3.1, 0.0)
        @test t.x == 4.3
        @test t.y == -4.2
        @test t.z == 3.1
        @test t.w == 0.0
        @test typeof(t) == rt.vector
        @test typeof(t) != rt.point
    
        #Points and vectors can be instantiated directly
        p = rt.point(4, -4, 3)
        @test p == rt.tuple(4, -4, 3, 1)
        v = rt.vector(4, -4, 3)
        @test v == rt.tuple(4, -4, 3, 0)
    end

    @testset "arithmetic" begin
        #Points and vectors can be added 
        p = rt.tuple(3, -2, 5, 1)
        v = rt.tuple(-2, 3, 1, 0)
        @test p + v == rt.tuple(1, 1, 6, 1)
        #Vectors and vectors can be added
        v1 = rt.tuple(3, -2, 5, 0)
        v2= rt.tuple(-2, 3, 1, 0)
        @test v1 + v2 == rt.tuple(1, 1, 6, 0)
        #Points and points can't
        p1 = rt.tuple(3, -2, 5, 1)
        p2 = rt.tuple(-2, 3, 1, 1)
        @test_throws ErrorException p1 + p2 
    
        #Subtracting two points gives a vector
        p1 = rt.point(3,2,1)
        p2 = rt.point(5,6,7)
        @test p1 - p2 == rt.vector(-2, -4, -6)
        #Subtracting a vector from a point gives a point
        p = rt.point(3,2,1)
        v = rt.vector(5,6,7)
        @test p - v == rt.point(-2, -4, -6)
        #Subtracting two vectors gives a vector
        v1 = rt.vector(3,2,1)
        v2 = rt.vector(5,6,7)
        @test v1 - v2 == rt.vector(-2, -4, -6)
        #Subtracting a point from a vector doesn't make sense
        p = rt.point(3,2,1)
        v = rt.vector(5,6,7)
        @test_throws ErrorException  v - p 

        #Negate a vector by subtracting it from a 0-tuple
        z = rt.vector(0,0,0)
        v = rt.vector(1,-2,3)
        @test z - v == rt.vector(-1,2,-3)
        #Test a negation operation
        v = rt.vector(1, 2, 3)
        @test -v == rt.vector(-1, -2, -3)

        #Scalar multiplication
        a = rt.vector(1, -2, 3)
        @test a * 3.5 == rt.tuple(3.5, -7.0, 10.5, 0.0)
        @test a * 0.5 == rt.tuple(0.5, -1.0, 1.5, 0.0)

        #Scalar division
        a = rt.vector(1, -2, 3)
        @test a / 2 == rt.tuple(0.5, -1.0, 1.5, 0.0)
    end

    @testset "basic lin alg" begin
        #Magnitude
        v = rt.vector(1, 0, 0)
        @test rt.magnitude(v) == 1
        v = rt.vector(0, 1, 0)
        @test rt.magnitude(v) == 1
        v = rt.vector(0, 0, 1)
        @test rt.magnitude(v) == 1
        v = rt.vector(1, 2, 3)
        @test rt.magnitude(v) == √14
        v = rt.vector(-1, -2, -3)
        @test rt.magnitude(v) == √14

        #Normalize
        v = rt.vector(4, 0, 0)
        @test rt.normalize(v) == rt.vector(1, 0, 0)
        v = rt.vector(1, 2, 3)
        @test rt.normalize(v) == rt.vector(0.2672612419124244, 
                                           0.5345224838248488, 
                                           0.8017837257372732)

        #Dot product
        v1 = rt.vector(1,2,3)
        v2 = rt.vector(2,3,4)
        @test rt.dot(v1, v2) == 20

        #Cross product
        v1 = rt.vector(1,2,3)
        v2 = rt.vector(2,3,4)
        @test rt.cross(v1, v2) == rt.vector(-1, 2, -1)
        @test rt.cross(v2, v1) == rt.vector(1, -2, 1)

    end
end



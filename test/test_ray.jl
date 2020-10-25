@testset "rays" begin
    origin = rt.point(1, 2, 3)
    direction = rt.vector(4,5,6)
    r = rt.ray(origin, direction)
    @test r.origin == origin
    @test r.direction == direction

    r = rt.ray(rt.point(2,3,4), rt.vector(1,0,0))
    @test rt.position(r, 0) == rt.point(2,3,4)
    @test rt.position(r, 1) == rt.point(3,3,4)
    @test rt.position(r, -1) == rt.point(1,3,4)
    @test rt.position(r, 2.5) == rt.point(4.5,3,4)

    r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
    s = rt.sphere()
    xs = rt.intersect(s, r)
    @test length(xs) == 2
    @test xs[1].t == 4.0
    @test xs[2].t == 6.0

    r = rt.ray(rt.point(0, 1, -5), rt.vector(0,0,1))
    s = rt.sphere()
    xs = rt.intersect(s, r)
    @test length(xs) == 2
    @test xs[1].t == 5.0
    @test xs[2].t == 5.0


    r = rt.ray(rt.point(0, 2, -5), rt.vector(0,0,1))
    s = rt.sphere()
    xs = rt.intersect(s,r)
    @test length(xs) == 0

    r = rt.ray(rt.point(0,0,0), rt.vector(0,0,1))
    s = rt.sphere()
    xs = rt.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].t == -1.0
    @test xs[2].t == 1.0

    r = rt.ray(rt.point(0, 0, 5), rt.vector(0,0,1))
    s = rt.sphere()
    xs = rt.intersect(s, r)
    @test length(xs) == 2
    @test xs[1].t == -6.0
    @test xs[2].t == -4.0


    s = rt.sphere()
    i = rt.intersection(3.5, s)
    @test i.t == 3.5
    @test i.object == s

    s = rt.sphere()
    i1 = rt.intersection(1, s)
    i2 = rt.intersection(2, s)
    xs = rt.intersections(i1, i2)
    @test length(xs) == 2
    @test xs[1].t == 1
    @test xs[2].t == 2

    r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
    s = rt.sphere()
    xs = rt.intersect(s, r)
    @test length(xs) == 2
    @test xs[1].object == s
    @test xs[2].object == s

    #hit when all intersections have +ve t
    s = rt.sphere()
    i1 = rt.intersection(1, s)
    i2 = rt.intersection(2, s)
    xs = rt.intersections(i1, i2)
    i = rt.hit(xs)
    @test i == i1
    
    #hit when some intersections have +ve t
    s = rt.sphere()
    i1 = rt.intersection(-1, s)
    i2 = rt.intersection(1, s)
    xs = rt.intersections(i1, i2)
    i = rt.hit(xs)
    @test i == i2
    
    #hit when all intersections have -ve t
    s = rt.sphere()
    i1 = rt.intersection(-2, s)
    i2 = rt.intersection(-1, s)
    xs = rt.intersections(i1, i2)
    i = rt.hit(xs)
    @test i == nothing
    
    #hit is the lowest +ve t value
    s = rt.sphere()
    i1 = rt.intersection(5, s)
    i2 = rt.intersection(7, s)
    i3 = rt.intersection(-3, s)
    i4 = rt.intersection(2, s)
    xs = rt.intersections(i1, i2, i3, i4)
    i = rt.hit(xs)
    @test i == i4

    #Translate a ray
    r = rt.ray(rt.point(1,2,3), rt.vector(0,1,0))
    m = rt.translation(3,4,5)
    r2 = rt.transform(r,m)
    @test r2.origin == rt.point(4,6,8)
    @test r2.direction == rt.vector(0,1,0)

    #Scale a ray
    r = rt.ray(rt.point(1,2,3), rt.vector(0,1,0))
    m = rt.scaling(2,3,4)
    r2 = rt.transform(r,m)
    @test r2.origin == rt.point(2, 6, 12)
    @test r2.direction == rt.vector(0,3,0)

    s = rt.sphere()
    @test rt.get_transform(s) == rt.I
    s = rt.sphere()
    t = rt.translation(2,3,4)
    rt.set_transform(s,t)
    @test rt.get_transform(s) == t

    r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
    s = rt.sphere()
    rt.set_transform(s, rt.scaling(2,2,2))
    xs = rt.intersect(s,r)
    @test length(xs) == 2
    @test xs[1].t == 3
    @test xs[2].t == 7

    r = rt.ray(rt.point(0,0,-5), rt.vector(0,0,1))
    s = rt.sphere()
    rt.set_transform(s, rt.translation(5,0,0))
    xs = rt.intersect(s,r)
    @test length(xs) == 0
end

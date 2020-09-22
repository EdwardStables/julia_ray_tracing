@testset "materials" begin
    m = rt.material()
    @test m.color == rt.color(1,1,1) 
    @test m.ambient == 0.1
    @test m.diffuse == 0.9
    @test m.specular == 0.9
    @test m.shininess == 200.0

    s = rt.sphere(0)
    m = s.material
    @test m == rt.material()

    s = rt.sphere(0)
    m = rt.material()
    m.ambient = 1
    s.material = m
    @test s.material == m
end

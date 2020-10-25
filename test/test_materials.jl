@testset "materials" begin
    m = rt.material()
    @test m.color == rt.color(1,1,1) 
    @test m.ambient == 0.1
    @test m.diffuse == 0.9
    @test m.specular == 0.9
    @test m.shininess == 200.0

    s = rt.sphere()
    m = rt.get_material(s)
    @test m == rt.material()

    s = rt.sphere()
    m = rt.material()
    m.ambient = 1
    rt.set_material(s, m)
    @test rt.get_material(s) == m
end

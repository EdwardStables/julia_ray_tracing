@testset "lights" begin
    @testset "point light" begin
        intensity = rt.color(1,1,1)
        position = rt.point(0,0,0)
        light = rt.point_light(position, intensity)
        @test light.position == position
        @test light.intensity == intensity
    end

    @testset "lighting" begin
        m = rt.material()
        p = rt.point(0,0,0)
        obj = rt.sphere()

        #eye is positioned between light and surface
        #intensity = ambient+diffuse+speculuar
        # = 0.1 + 0.9 + 0.9 = 1.9
        eyev = rt.vector(0,0,-1)
        normalv = rt.vector(0,0, -1)
        light = rt.point_light(rt.point(0,0,-10), rt.color(1,1,1))
        result = rt.lighting(m, obj, light, p, eyev, normalv)
        @test result == rt.color(1.9, 1.9, 1.9)
        
        #eye is positioned 45° off surface, light still normal
        # intensity = 0.1 + 0.9 + 0
        # as specular value should have fallen to ≈0
        eyev = rt.vector(0,√2/2,-√2/2)
        normalv = rt.vector(0,0, -1)
        light = rt.point_light(rt.point(0,0,-10), rt.color(1,1,1))
        result = rt.lighting(m, obj, light, p, eyev, normalv)
        @test result == rt.color(1.0, 1.0, 1.0)

        #eye is normal, light is 45° off
        # specular remains ≈0
        # angle between light and surface reduces diffuse by
        # √2/2 -> intensity ≈ 0.7364
        eyev = rt.vector(0,0,-1)
        normalv = rt.vector(0,0, -1)
        light = rt.point_light(rt.point(0,10,-10), rt.color(1,1,1))
        result = rt.lighting(m, obj, light, p, eyev, normalv)
        @test result == rt.color(0.7363961030678927,0.7363961030678927,0.7363961030678927)
        
        # eye and light are both 45° off center (90° between them)
        # specular is at full strength
        # angle between light and surface reduces diffuse by
        # √2/2 -> intensity ≈ 1.6364
        eyev = rt.vector(0,-√2/2,-√2/2)
        normalv = rt.vector(0,0, -1)
        light = rt.point_light(rt.point(0,10,-10), rt.color(1,1,1))
        result = rt.lighting(m, obj, light, p, eyev, normalv)
        @test result == rt.color(1.6363961030678928,1.6363961030678928,1.6363961030678928)

        #surface, eye, and light in line, but light is behind surface
        #the diffuse and specular components should be 0, just leaves
        #ambient component = 0.1
        eyev = rt.vector(0,0,-1)
        normalv = rt.vector(0,0, -1)
        light = rt.point_light(rt.point(0,0,10), rt.color(1,1,1))
        result = rt.lighting(m, obj, light, p, eyev, normalv)
        @test result == rt.color(0.1,0.1,0.1)
    end

    @testset "shadows" begin
        #lighting with the surface in shadow
        eyev = rt.vector(0,0,-1)
        obj = rt.sphere()
        normalv = rt.vector(0,0,-1)
        light = rt.point_light(rt.point(0,0,-10),rt.color(1,1,1))
        in_shadow = true
        result = rt.lighting(rt.material(), obj, light, rt.point(0,0,0), eyev, normalv, in_shadow)
        @test result == rt.color(0.1, 0.1, 0.1)

        #there is no shadow when nothing is colinear with light/sphere
        w = rt.default_world()
        p = rt.point(0,10,0)
        @test rt.is_shadowed(w, p) == false 
        #shadowed when object between light and point
        w = rt.default_world()
        p = rt.point(10, -10, 10)
        @test rt.is_shadowed(w, p) == true
        #no shadow when light between object and point
        w = rt.default_world()
        p = rt.point(-20, 20, -20)
        @test rt.is_shadowed(w, p) == false
        #no shadow when point between object and light
        w = rt.default_world()
        p = rt.point(-5, 5, -5)
        @test rt.is_shadowed(w, p) == false
    end
end

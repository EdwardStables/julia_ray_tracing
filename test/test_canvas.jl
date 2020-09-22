@testset "Colours" begin
    c = rt.color(-0.5, 0.4, 1.7)
    @test c.r == -0.5
    @test c.g == 0.4
    @test c.b == 1.7

    @testset "arithmetic" begin
        c1 = rt.color(0.9, 0.6, 0.75)
        c2 = rt.color(0.7, 0.1, 0.25)
        @test c1 + c2 == rt.color(1.6, 0.7, 1.0)

        c1 = rt.color(0.9, 0.6, 0.75)
        c2 = rt.color(0.7, 0.1, 0.25)
        @test c1 - c2 == rt.color(0.2, 0.5, 0.5)

        c = rt.color(0.2, 0.3, 0.4)
        @test c * 2 == rt.color(0.4, 0.6, 0.8)

        c1 = rt.color(1, 0.2, 0.4)
        c2 = rt.color(0.9, 1, 0.1)
        @test c1 * c2 == rt.color(0.9, 0.2, 0.04)
    end
end

@testset "canvas" begin 
    c = rt.canvas(10, 20)
    @test c.width == 10
    @test c.height == 20
    @test all(==(rt.color(0, 0, 0)), c.pixels)

    c = rt.canvas(10, 20)
    red = rt.color(1, 0, 0)
    rt.write_pixel(c, 2, 3, red)
    @test rt.pixel_at(c, 2, 3) == red
end

@testset "PPM" begin
    c = rt.canvas(5, 3)
    ppm = rt.canvas_to_ppm_arr(c)
    @test ppm[1] == "P3"
    @test ppm[2] == "5 3"
    @test ppm[3] == "255"

    c = rt.canvas(5, 3)
    c1 = rt.color(1.5, 0, 0)
    c2 = rt.color(0, 0.5, 0)
    c3 = rt.color(-0.5, 0, 1)
    rt.write_pixel(c, 1, 1, c1)
    rt.write_pixel(c, 3, 2, c2)
    rt.write_pixel(c, 5, 3, c3)
    ppm = rt.canvas_to_ppm_arr(c)
    @test ppm[4] == "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0" 
    @test ppm[5] == "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0" 
    @test ppm[6] == "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255" 

    c = rt.canvas(10, 2)
    for x in 1:10, y in 1:2
        rt.write_pixel(c, x, y, rt.color(1, 0.8, 0.6))
    end
    ppm = rt.canvas_to_ppm_arr(c)
    @test ppm[4] == "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
    @test ppm[5] == "153 255 204 153 255 204 153 255 204 153 255 204 153" 
    @test ppm[6] == "255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204"
    @test ppm[7] == "153 255 204 153 255 204 153 255 204 153 255 204 153" 
    
    cs = rt.ppm_arr_to_str(ppm)
    @test cs[end] == '\n'
end

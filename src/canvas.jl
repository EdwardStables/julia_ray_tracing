import Base: +, -, *, ==
mutable struct canvas
    width::Int
    height::Int
    pixels::Matrix{color}

    function canvas(w::Int, h::Int)
        c = new()
        c.width = w
        c.height = h
        c.pixels = Matrix{color}(undef, w, h)
        for x in 1:w, y in 1:h
            c.pixels[x,y] = color(0.0, 0.0, 0.0)
        end

        return c
    end
end

function write_pixel(c::canvas, x::Int, y::Int, co::color)
    c.pixels[x, y] = co
end

function pixel_at(c::canvas, x::Int, y::Int)
    return c.pixels[x, y]
end

function canvas_to_ppm_arr(c::canvas; 
                       format::String="P3",
                       max_color::Int=255
                      )::Vector{String}
    p = String[format, "$(c.width) $(c.height)", "$max_color"]
    conv = x -> ceil(Int64, clamp(max_color * x, 0, max_color))
    for y in 1:c.height
        line = ""
        for x in 1:c.width
            q = c.pixels[x,y]
            line *= "$(conv(q.r)) $(conv(q.g)) $(conv(q.b))"
            x != c.width && (line *= " ")
        end

        while length(line) > 70
            end_index = (findlast(" ", line[1:70])...)-1
            push!(p, line[1:end_index])
            line = line[end_index+2:end]
        end

        push!(p, line)
    end

    return p
end

ppm_arr_to_str(arr::Vector{String}) = join(arr, '\n')*'\n'

function save_canvas(c::canvas; 
                     name::String="out.ppm", path::String=".")
    ppm = canvas_to_ppm_arr(c)
    str = ppm_arr_to_str(ppm)
    open(joinpath(path, name), "w") do f
        write(f, str)
    end
end

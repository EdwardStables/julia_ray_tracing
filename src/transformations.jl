cf(x) = convert(Float64, x)

translation(x::T, y::T, z::T) where T <: Number = 
    translation(cf(x), cf(y), cf(z))

function translation(x::Float64,y::Float64,z::Float64
                    )::Matrix{Float64}
    return [1 0 0 x; 0 1 0 y; 0 0 1 z; 0 0 0 1]
end

scaling(x::T, y::T, z::T) where T <: Number = 
    scaling(cf(x), cf(y), cf(z))

function scaling(x::Float64, y::Float64, z::Float64
                )::Matrix{Float64}
    return [x 0 0 0; 0 y 0 0; 0 0 z 0; 0 0 0 1]
end

rotation_x(r::T) where T <: Number = rotation_x(cf(r))
function rotation_x(r::Float64)::Matrix{Float64}
    return [1 0 0 0; 0 cos(r) -sin(r) 0;
            0 sin(r) cos(r) 0; 0 0 0 1]
end

rotation_y(r::T) where T <: Number = rotation_y(cf(r))
function rotation_y(r::Float64)::Matrix{Float64}
    return [cos(r) 0 sin(r) 0; 0 1 0 0;
            -sin(r) 0 cos(r) 0; 0 0 0 1]
end

rotation_z(r::T) where T <: Number = rotation_z(cf(r))
function rotation_z(r::Float64)::Matrix{Float64}
    return [cos(r) -sin(r) 0 0; sin(r) cos(r) 0 0;
           0 0 1 0; 0 0 0 1]
end

shearing(xy::T, xz::T, yx::T, yz::T, zx::T, zy::T) where T <: Number = 
    shearing(cf(xy), cf(xz), cf(yx), cf(yz), cf(zx), cf(zy))
function shearing(xy::Float64, xz::Float64, yx::Float64, 
                  yz::Float64, zx::Float64, zy::Float64)
    return [1 xy xz 0; yx 1 yz 0;
            zx zy 1 0; 0 0 0 1]
end

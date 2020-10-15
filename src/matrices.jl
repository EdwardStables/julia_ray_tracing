import LinearAlgebra
import Base: *, adjoint, Array, ==, inv

struct identity end
const I = identity()
adjoint(::identity) = I
Array(::identity) = I

==(::identity, A::Matrix) = A == LinearAlgebra.I
==(A::Matrix, ::identity) = A == LinearAlgebra.I

inv(::identity) = I 


function *(A::Matrix, b::tuple; force_w::Union{Nothing,Int64}=nothing)
    if force_w != nothing
        t = A * tovec(b)
        t[4] = force_w
        return tuple(t)
    else
        return tuple(A * tovec(b))
    end
end

*(::identity, A::Matrix) = A
*(A::Matrix, ::identity) = A
*(::identity, t::tuple;force_w::Union{Nothing,Int64}=nothing) = t

function determinant(A::Matrix)
    size(A, 1) != size(A, 2) && error("Must be square")
    if size(A, 1) == 2
        return A[1,1]A[2,2] - A[1,2]A[2,1]
    else
        sum = 0
        for (i,v) in enumerate(A[1,:])
            sum += v * cofactor(A, 1, i)
        end
        return sum
    end
end

submatrix(A::Matrix, r::Int, c::Int)::Matrix = 
    A[1:size(A,1) .!= r,1:size(A,2) .!= c]

minor(A::Matrix, r::Int, c::Int) = determinant(submatrix(A, r, c))

cofactor(A::Matrix, r::Int, c::Int) = 
    minor(A, r, c) * (iseven(r+c) ? 1 : -1) 

is_singular(A::Matrix)::Bool = determinant(A) != 0


#= Don't use this, just here for completeness's sake =#
#= the inbuilt inverse function is much, much, much, faster =#
inverse(::identity) = I
inverse(A::Matrix) = inverse(convert(Matrix{Float64},A))
function inverse(A::Matrix{Float64})::Matrix{Float64}
    det = determinant(A)
    det == 0 && error("Singular matrix")
    n = size(A)[1]
    B = Matrix(undef, n, n)

    for x in 1:n, y in 1:n
        B[y,x] = cofactor(A, x, y)/det
    end

    return B
end

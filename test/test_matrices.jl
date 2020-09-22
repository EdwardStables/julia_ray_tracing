@testset "matrix" begin
    M = [1    2    3    4;
         5.5  6.5  7.5  8.5;
         9   10   11   12;
         13.5 14.5 15.5 16.5]
    @test M[1,1] == 1
    @test M[1,4] == 4
    @test M[2,1] == 5.5
    @test M[2,3] == 7.5
    @test M[3,3] == 11
    @test M[4,1] == 13.5
    @test M[4,3] == 15.5

    M = [-3 5; 1 -2]
    @test M[1,1] == -3
    @test M[1,2] == 5
    @test M[2,1] == 1
    @test M[2,2] == -2

    M = [-3 5 0; 1 -2 -7; 0 1 1]
    @test M[1, 1] == -3
    @test M[2, 2] == -2
    @test M[3, 3] == 1

    A = [1 2 3 4; 5 6 7 8;
         9 8 7 6; 5 4 3 2]
    B = [1 2 3 4; 5 6 7 8;
         9 8 7 6; 5 4 3 2]
    C = [2 3 4 5; 6 7 8 9;
         8 7 6 5; 4 3 2 1]
    @test A == B
    @test A != C
    
    A = [1 2 3 4; 5 6 7 8;
         9 8 7 6; 5 4 3 2]
    B = [-2 1 2 3; 3 2 1 -1;
         4 3 6 5; 1 2 7 8]
    @test A * B == [20 22 50 48;  44 54 114 108;
                    40 58 110 102; 16 26 46 42]
    
    A = [1 2 3 4; 2 4 4 2;
         8 6 4 1; 0 0 0 1]
    b = rt.tuple(1, 2, 3, 1)
    @test A * b == rt.tuple(18, 24, 33 ,1)

    A = [0 1 2 4; 1 2 4 8;
         2 4 8 16; 4 8 16 32]
    @test A * rt.I == A
    a = rt.tuple(1, 2, 3, 1)
    @test rt.I * a == a

    A = [0 9 3 0; 9 8 0 8;
         1 8 5 3; 0 0 5 8]
    B = [0 9 1 0; 9 8 8 0;
         3 0 5 5; 0 8 3 8]
    @test A' == B

    A = rt.I'
    @test A == rt.I

    @testset "linalg" begin
        A = [1 5; -3 2]
        @test rt.determinant(A) == 17

        A = [1 5 0; -3 2 7; 0 6 -3]
        @test rt.submatrix(A, 1, 3) == [-3 2; 0 6]

        A = [-6 1 1 6; -8 5 8 6;
             -1 0 8 2; -7 1 -1 1]
        @test rt.submatrix(A, 3, 2) == [-6 1 6; -8 8 6
                                        -7 -1 1]
        A = [3 5 0; 2 -1 -7; 6 -1 5]
        B = rt.submatrix(A, 2, 1)
        @test rt.determinant(B) == 25
        @test rt.minor(A, 2, 1) == 25

        A = [3 5 0; 2 -1 -7; 6 -1 5]
        @test rt.minor(A, 1, 1) == -12
        @test rt.cofactor(A, 1, 1) == -12
        @test rt.minor(A, 2, 1) == 25
        @test rt.cofactor(A, 2, 1) == -25

        A = [1 2 6; -5 8 -4; 2 6 4]
        @test rt.cofactor(A, 1, 1) == 56
        @test rt.cofactor(A, 1, 2) == 12
        @test rt.cofactor(A, 1, 3) == -46
        @test rt.determinant(A) == -196

        A = [-2 -8 3 5; -3 1 7 3;
             1 2 -9 6; -6 7 7 -9]
        @test rt.cofactor(A, 1, 1) == 690
        @test rt.cofactor(A, 1, 2) == 447
        @test rt.cofactor(A, 1, 3) == 210
        @test rt.cofactor(A, 1, 4) == 51
        @test rt.determinant(A) == -4071
        

        A = [6 4 4 4; 5 5 7 6;
             4 -9 3 -7; 9 1 7 -6]
        @test rt.determinant(A) == -2120
        @test rt.is_singular(A) == true

        A = [-4 2 -2 -3; 9 6 2 6;
             0 -5 1 -5; 0 0 0 0]
        @test rt.determinant(A) == 0
        @test rt.is_singular(A) == false

        A = [-5 2 6 -8; 1 -5 1 8;
             7 7 -6 -7; 1 -3 7 4]
        B = rt.inverse(A)
        @test rt.determinant(A) == 532
        @test B[4,3] == -160/532
        @test rt.cofactor(A, 4, 3) == 105
        @test B[3,4] == 105/532
        @test isapprox(B, [0.21805 0.45112 0.24060 -0.04511;
                           -0.80827 -1.45677 -0.44361 0.52068;
                           -0.07895 -0.22368 -0.05263 0.19737;
                           -0.52256 -0.81391 -0.30075 0.30639],
                       atol=5)

        A = [8 -5 9 2; 7 5 6 1;
             -6 0 9 6; -3 0 -9 -4]
        B = [-0.15384615384615385 -0.15384615384615385 -0.28205128205128205 -0.5384615384615384; 
         -0.07692307692307693 0.12307692307692308 0.02564102564102564 0.03076923076923077; 
         0.358974358974359 0.358974358974359 0.4358974358974359 0.9230769230769231; 
         -0.6923076923076923 -0.6923076923076923 -0.7692307692307693 -1.9230769230769231]
        @test rt.inverse(A) == B

        A = [9 3 0 9; -5 -2 -6 -3;
             -4 9 6 4; -7 6 6 2]
        B = [-0.040740740740740744 -0.07777777777777778 0.14444444444444443 -0.2222222222222222; 
             -0.07777777777777778 0.03333333333333333 0.36666666666666664 -0.3333333333333333; 
             -0.029012345679012345 -0.14629629629629629 -0.10925925925925926 0.12962962962962962; 
              0.17777777777777778 0.06666666666666667 -0.26666666666666666 0.3333333333333333]
        @test rt.inverse(A) == B

        A = [3 -9 7 3; 3 -9 2 -9; -4 4 4 1; -6 5 -1 1]
        B = [8 2 2 2; 3 -1 7 0; 7 0 5 4; 6 -2 0 5]
        C = A * B
        @test C * rt.inverse(B) ≈ A
    end
end
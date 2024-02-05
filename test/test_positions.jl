@testset "Positions" begin
    v = 51.7
    i = Cash(:USD)
    p = Position(i, v)
    @testset "Constructors" begin
        @test p.amount == v
    end
    @testset "Interface" begin
        @test currency(p) == Currency{:USD}
    end
end
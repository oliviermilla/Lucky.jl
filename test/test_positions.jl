@testset "Positions" begin
    v = 51.7
    i = Cash(:USD)
    t = Date(2021,1,1)
    p = Position(i, v,t)
    @testset "Constructors" begin
        @test p.size == v
    end
    @testset "Interface" begin
        @test PositionType(p) === Position{InstrumentType(i), Float64, Date}
        @test TimestampType(p) === Date
        @test currency(p) === Currency{:USD}
    end
end
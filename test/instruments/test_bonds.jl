@testset "Bonds" begin
    ticker = :WHATEVER
    USD = Currency(:USD)
    mat = today()
    @testset "Constructors" begin
        @test Bond(ticker, :USD, mat) isa Bond{:WHATEVER, Currency{:USD}}
    end
    @testset "Interfaces" begin
        bond = Bond(ticker, :USD, mat)
        @test InstrumentType(bond) === Bond{:WHATEVER, Currency{:USD}}
        @test currency(bond) == Currency{:USD}
    end
end

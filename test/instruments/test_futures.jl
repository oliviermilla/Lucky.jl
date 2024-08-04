@testset "Futures" begin
    ticker = :WHATEVER
    USD = Currency(:USD)
    exp = today()
    @testset "Constructors" begin
        @test Future(ticker, :USD, exp) isa Future{:WHATEVER, Currency{:USD}}
    end
    @testset "Interfaces" begin
        fut = Future(ticker, :USD, exp)
        @test InstrumentType(fut) === Future{:WHATEVER, Currency{:USD}}
        @test currency(fut) == Currency{:USD}
    end
end

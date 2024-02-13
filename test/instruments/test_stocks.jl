@testset "Stocks" begin
    ticker = :AAPL
    USD = Currency(:USD)
    @testset "Constructors" begin
        @test Stock(ticker, :USD) isa Stock{:AAPL, Currency{:USD}}
    end
    @testset "Interfaces" begin
        stock = Stock(ticker, :USD)
        @test InstrumentType(stock) === Stock{:AAPL, Currency{:USD}}
        @test currency(stock) == Currency{:USD}
    end
end

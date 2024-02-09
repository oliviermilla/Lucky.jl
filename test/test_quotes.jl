@testset "Quotes" begin
    stock = Stock(:AAPL, :USD)
    @testset "Number" begin
        price = 51.7
        stamp = Date(2021, 1, 1)
        q = Quote(stock, price, stamp)
        @testset "Constructors" begin
            @test q isa Lucky.Quotes.NumberQuote
            @test q.instrument == stock
            @test q.price == price
        end
        @testset "Interface" begin
            currency(q) == Currency{:USD}
            timestamp(q) == timestamp
        end
    end
    @testset "Ohlc" begin
        ohlc = rand(Ohlc{Date})
        q = Quote(stock, ohlc)
        @testset "Constructors" begin
            @test q isa Lucky.Quotes.OhlcQuote
            @test q.instrument == stock
            @test q.price == ohlc
        end
        @testset "Interface" begin
            currency(q) == Currency{:USD}
            timestamp(q) == ohlc.timestamp
        end
    end
end
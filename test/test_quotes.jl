@testset "Quotes" begin
    stock = Stock(:AAPL, :USD)
    @testset "Number" begin
        price = 51.7
        stamp = Date(2021, 1, 1)
        q1 = Quote(stock, price, stamp)
        @testset "Constructors" begin
            @test q1 isa Lucky.Quotes.PriceQuote
            @test q1.instrument == stock
            @test q1.price == price
        end
        @testset "Interfaces" begin
            currency(q1) == Currency{:USD}
            timestamp(q1) == timestamp
        end
        @testset "Operators" begin
            p2 = 8.3
            t2 = Date(2021, 2, 1)
            q2 = Quote(stock, p2, t2)

            # Valid ops
            @test q1 + q2 == Quote(stock, price + p2, t2)
            @test q2 - q1 == Quote(stock, p2 - price, t2)

            # Ops with missing
            @test q1 + missing === missing
            @test missing - q1 === missing

            # Different instruments
            cash = Cash(:USD)
            q3 = Quote(cash, p2, t2)
            @test_throws MethodError q1 + q3
            @test_throws MethodError q3 - q1
        end
    end
    @testset "Ohlc" begin
        ohlc = rand(Ohlc{Date})
        q = Quote(stock, ohlc)
        @testset "Constructors" begin
            @test q isa Lucky.Quotes.OhlcQuote
            @test q.instrument == stock
            @test q.ohlc == ohlc
        end
        @testset "Interface" begin
            currency(q) == Currency{:USD}
            timestamp(q) == ohlc.timestamp
        end
    end
end
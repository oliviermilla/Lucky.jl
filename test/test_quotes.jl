@testset "Quotes" begin
    @testset "Abstract Interfaces" begin        
        struct TestQuote <: AbstractQuote end
        @test QuoteType(TestQuote) === TestQuote
        @test_throws ErrorException TimestampType(TestQuote)
    end
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
            QuoteType(stock, Float64, Date) === Lucky.Quotes.PriceQuote{InstrumentType(stock),Float64,Date}
            QuoteType(stock) === Lucky.Quotes.PriceQuote{InstrumentType(stock),Float64,DateTime}
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
            @test q2 * 2 == Quote(stock, p2 * 2, t2)
            @test q2 / 2 == Quote(stock, p2 / 2, t2)
            @test q2 < q1

            # Ops with missing
            @test q1 + missing === missing
            @test missing - q1 === missing

            # Different instruments
            cash = Cash(:USD)
            q3 = Quote(cash, p2, t2)
            @test_throws MethodError q1 + q3
            @test_throws MethodError q3 - q1

            # Convert
            @test convert(Float64, q3) == Float64(p2)
        end
    end
    @testset "Ohlc" begin
        ohlc1 = rand(Ohlc{Date})
        q1 = Quote(stock, ohlc1)
        @testset "Constructors" begin
            @test q1 isa Lucky.Quotes.OhlcQuote
            @test q1.instrument == stock
            @test q1.ohlc == ohlc1
        end
        @testset "Interface" begin
            QuoteType(stock, Ohlc{Date}) === Lucky.Quotes.PriceQuote{InstrumentType(stock),Ohlc{Date}}
            currency(q1) == Currency{:USD}
            timestamp(q1) == ohlc1.timestamp
        end
        @testset "Operators" begin
            ohlc2 = rand(Ohlc{Date})
            #println("1: $(ohlc1)")
            #println("2: $(ohlc2)")
            q2 = Quote(stock, ohlc2)

            # Valid ops
            @test q1 + q2 == Quote(stock, ohlc1 + ohlc2)
            @test_throws MethodError q2 - q1
            @test q2 * 2 == Quote(stock, ohlc2 * 2)
            @test q2 / 2 == Quote(stock, ohlc2 / 2)
            @test_broken q2 < q1 == ohlc2.close < ohlc1.close

            # Ops with missing
            @test q1 + missing === missing
            @test missing - q1 === missing

            # Different instruments
            cash = Cash(:USD)
            q3 = Quote(cash, ohlc2)
            @test_throws MethodError q1 + q3
            @test_throws MethodError q3 - q1

            # Convert
            @test convert(Float64, q3) == Float64(ohlc2.close)
        end
    end
end
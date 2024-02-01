@testset "Quotes" begin
    ohlc = rand(Ohlc{Date})
        stock = Stock(:AAPL, :USD)
        q = Quote(stock, ohlc)
    @testset "Constructors" begin        
        @test q.instrument == stock
        @test q.price == ohlc
    end
    @testset "Interface" begin        
        currency(q) == Currency{:USD}
        # timestamp(q) == ohlc.timestamp
    end
end
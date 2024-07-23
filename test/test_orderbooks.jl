@testset "InMemoryOrderBook" begin
    @testset "Lucky.match()" begin
        today = Dates.today()
        i = Stock(:AAPL, :USD)
        @testset "with limit orders" begin
            @testset "buy orders" begin
                l = LimitOrder(i, 5, 101.1) # Buy 5            
                p = PriceQuote(i, 100.0, today)
                fill = Lucky.match(l, p)
                @test fill isa Fill
                @test fill.id isa String
                @test isempty(fill.id) == false
                @test fill.order == l
                @test fill.price == 100.0
                @test fill.size == 5
                @test fill.timestamp == today

                l2 = LimitOrder(i, 5, 90.1)
                fill2 = Lucky.match(l2, p)
                @test fill2 === nothing
            end
            @testset "sell orders" begin
                l = LimitOrder(i, -5, 90.1) # Sell 5            
                p = PriceQuote(i, 100.0, today)
                fill = Lucky.match(l, p)
                @test fill isa Fill
                @test fill.id isa String
                @test isempty(fill.id) == false
                @test fill.order == l
                @test fill.price == 100.0
                @test fill.size == -5
                @test fill.timestamp == today

                l2 = LimitOrder(i, -5, 110.1)
                fill2 = Lucky.match(l2, p)
                @test fill2 === nothing
            end
        end
    end
end

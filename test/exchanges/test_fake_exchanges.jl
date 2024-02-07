@testset "FakeExchange" begin
    @testset "matching with MarketOrder" begin
        # TODO Test matching of limit order by fake exchange
        ohlcsSubject = Subject(Ohlc{DateTime})
        ordersSubject = Subject(MarketOrder)

        ohlc = rand(Ohlc{DateTime})
        ohlcs = Rocket.of(ohlc) |> multicast(ohlcsSubject)

        order = MarketOrder(Cash(:USD), rand(-10:0.1:10))
        orders = Rocket.of(order) |> multicast(ordersSubject)

        fills = Subject(Lucky.Fill)
        exchange = FakeExchange(fills)

        subscribe!(ohlcsSubject, exchange)
        subscribe!(ordersSubject, exchange)

        function testNextMarketOrder(pos::Fill)
            @test (pos.id isa String) && length(pos.id) > 0
            @test pos.order == order
            @test pos.size == order.size
            @test pos.price == ohlc.open
            @test pos.createdAt == ohlc.timestamp
            @test length(exchange.pendingOrders) == 0
        end

        function testCompleteMarketOrder()
        end
        testActor = lambda(on_next=testNextMarketOrder, on_complete=testCompleteMarketOrder)
        subscribe!(fills, testActor)

        connect(orders)
        connect(ohlcs)
    end

    @testset "matching with Limit Order" begin
        ohlc = rand(Ohlc{DateTime})

        instr = Cash(:USD)
        above = LimitOrder(instr, 1.0, ohlc.high + 1)
        below = LimitOrder(instr, 1.0, ohlc.low - 1)
        inside = LimitOrder(instr, 1.0, ohlc.open)

        @test Lucky.Exchanges.FakeExchanges.match(above, ohlc) === nothing
        @test Lucky.Exchanges.FakeExchanges.match(below, ohlc) === nothing

        pos = Lucky.Exchanges.FakeExchanges.match(inside, ohlc)
                                
        @test pos isa Fill
        @test (pos.id isa String) && length(pos.id) > 0
        @test pos.order == inside
        @test pos.size == inside.size
        @test pos.price == ohlc.open
        @test pos.fee == 0
        @test pos.createdAt == ohlc.timestamp
    end
end
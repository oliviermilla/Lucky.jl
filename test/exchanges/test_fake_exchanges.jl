@testset "FakeExchange" begin
    @testset "matching with MarketOrder" begin
        quotesSubject = Subject(AbstractQuote)
        ordersSubject = Subject(AbstractOrder)

        instr = Cash(:USD)
        ohlc = rand(Ohlc{DateTime})
        qte = Quote(instr, ohlc)
        qtes = Rocket.of(qte) |> multicast(quotesSubject)

        order = MarketOrder(instr, rand(-10:0.1:10))
        orders = Rocket.of(order) |> multicast(ordersSubject)

        fills = Subject(Lucky.Fill)
        exchange = FakeExchange(fills)

        subscribe!(quotesSubject, exchange)
        subscribe!(ordersSubject, exchange)

        function testNextMarketOrder(pos::Fill)
            @test (pos.id isa String) && length(pos.id) > 0
            @test pos.order == order
            @test pos.size == order.size
            @test pos.price == ohlc.open
            @test pos.timestamp == ohlc.timestamp
            @test length(exchange.pendingOrders) == 0
        end

        function testCompleteMarketOrder()
        end
        testActor = lambda(on_next=testNextMarketOrder, on_complete=testCompleteMarketOrder)
        subscribe!(fills, testActor)

        connect(orders)
        connect(qtes)
    end

    @testset "matching with LimitOrder" begin
        ohlc = rand(Ohlc{DateTime})

        instr = Cash(:USD)
        above = LimitOrder(instr, 1.0, ohlc.high + 1)
        below = LimitOrder(instr, 1.0, ohlc.low - 1)
        inside = LimitOrder(instr, 1.0, ohlc.open)

        @test Lucky.Exchanges.FakeExchanges.match(above, Quote(instr,ohlc)) === nothing
        @test Lucky.Exchanges.FakeExchanges.match(below, Quote(instr, ohlc)) === nothing

        pos = Lucky.Exchanges.FakeExchanges.match(inside, Quote(instr, ohlc))
                                
        @test pos isa Fill
        @test (pos.id isa String) && length(pos.id) > 0
        @test pos.order == inside
        @test pos.size == inside.size
        @test pos.price == ohlc.open
        @test pos.fee == 0
        @test pos.timestamp == ohlc.timestamp
    end

    # TODO Test LimitOrder signs
    # TODO Test instrument matching
end
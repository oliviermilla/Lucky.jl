#exchange = Lucky.FakeExchange()

@testset "matching" begin
    # TODO Test matching of limit order by fake exchange
    ohlcsSubject = Subject(Ohlc{DateTime})
    ordersSubject = Subject(MarketOrder)

    ohlc = rand(Ohlc{DateTime})
    ohlcs = Rocket.of(ohlc) |> multicast(ohlcsSubject)
    
    order = rand(MarketOrder)
    orders = Rocket.of(order) |> multicast(ordersSubject)

    positions = Subject(Lucky.FakePosition)
    exchange = FakeExchange(positions)

    subscribe!(ohlcsSubject, exchange)
    subscribe!(ordersSubject, exchange)    

    function testNextMarketOrder(pos::FakePosition)        
        @test pos.size == order.size
        @test pos.avgPrice == ohlc.open
        @test pos.createdAt == ohlc.timestamp
        @test length(exchange.pendingOrders) == 0
    end

    function testCompleteMarketOrder()        
    end
    testActor = lambda(on_next = testNextMarketOrder, on_complete = testCompleteMarketOrder)
    subscribe!(positions, testActor)

    connect(orders)
    connect(ohlcs)
end
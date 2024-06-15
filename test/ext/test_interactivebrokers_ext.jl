@testset "InteractiveBrokersExt" begin
    @testset "Interfaces" begin
        @testset "service()" begin
            client = Lucky.service(:interactivebrokers)
            @test client isa Rocket.Subscribable
                        
            reqMarketDataType(client, InteractiveBrokers.DELAYED)

            stock = Stock(:AAPL,:USD)

            qt = Lucky.feed(client, stock, ns) # reqMktData should return a Subject
            subscribe!(qt, logger())
            # InteractiveBrokers.reqMktData(ib, 1, contract, "100,101,104,106,165,221,225,236", false)
            #TODO Test if a subject
            # ex = Lucky.exchange(client)

            # bl = Lucky.blotter(client)

            # # Do the wiring
            connect(client)
            sleep(1000)
            disconnect(client)
        end
        @testset "Contract" begin
            stock = Stock(:AAPL, :USD)
            @test_broken InteractiveBrokers.Contract(stock) == InteractiveBrokers.Contract(
                symbol="AAPL",
                secType="STK",
                exchange="SMART",
                currency="USD"
                );
        end
    end
end
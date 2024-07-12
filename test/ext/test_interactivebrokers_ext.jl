using InteractiveBrokers

@testset "InteractiveBrokersExt" begin
    @testset "Interfaces" begin
        @testset "service()" begin
            client = Lucky.service(:interactivebrokers)
            @test client isa Rocket.Subscribable

            InteractiveBrokers.reqMarketDataType(client, InteractiveBrokers.DELAYED)

            stock = Stock(:AAPL, :USD)

            qt = Lucky.feed(client, stock) # reqMktData should return a Subscribable
            @test Rocket.as_subscribable(qt) isa SimpleSubscribableTrait # or ScheduledSubscribableTrait                        
            
            # Test wrapper
            # wrap = InteractiveBrokersExt.wrapper(client)
            # @test getproperty(wrap, :error) isa Function
            # @test getproperty(wrap, :managedAccounts) isa Function
            # @test getproperty(wrap, :nextValidId) isa Function

       end
        @testset "Contract" begin
            stock = Stock(:AAPL, :USD)
            # TODO Requires a definition for == in InteractiveBrokers
            @test_broken InteractiveBrokers.Contract(stock) == InteractiveBrokers.Contract(
                symbol="AAPL",
                secType="STK",
                exchange="SMART",
                currency="USD"
            )
        end
    end
end
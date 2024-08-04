using InteractiveBrokers

@testset "InteractiveBrokersExt" begin
    @testset "Interfaces" begin
        @testset "service()" begin
            client = Lucky.service(:interactivebrokers)
            @test client isa Rocket.Subscribable

            InteractiveBrokers.reqMarketDataType(client, InteractiveBrokers.DELAYED)

            stock = Stock(:AAPL, :USD)

            qt = Lucky.trades(client, stock) # reqMktData should return a Subscribable
            @test Rocket.as_subscribable(qt) isa SimpleSubscribableTrait # or ScheduledSubscribableTrait                        

            # Test wrapper
            # wrap = InteractiveBrokersExt.wrapper(client)
            # @test getproperty(wrap, :error) isa Function
            # @test getproperty(wrap, :managedAccounts) isa Function
            # @test getproperty(wrap, :nextValidId) isa Function

        end
        @testset "InteractiveBrokers.Contract" begin
            stock = Stock(:AAPL, :USD)
            # TODO Requires a definition for == in InteractiveBrokers
            @test_broken InteractiveBrokers.Contract(stock) == InteractiveBrokers.Contract(
                symbol="AAPL",
                secType="STK",
                exchange="SMART",
                currency="USD"
            )
            # TODO Test all other contract types (Cash, Bond, Fut, etc.)
        end
        @testset "Lucky.Instrument" begin
            future = InteractiveBrokers.Contract(691439932, "M6E", "FUT", "20240916", 0.0, "", "12500", "", "", "USD", "M6EU4", "M6E", false, "", "", "", "", "", "", InteractiveBrokers.ComboLeg[], nothing)
            bond = InteractiveBrokers.Contract(573330472, "US-T", "BOND", "20250715", 0.0, "", "", "", "", "USD", "IBCID573330472", "US-T", false, "", "", "", "", "", "", InteractiveBrokers.ComboLeg[], nothing)

            # TODO test Lucky.Instrument() for each instrument
        end
    end
end
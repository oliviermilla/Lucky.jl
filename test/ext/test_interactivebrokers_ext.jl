@testset "InteractiveBrokersExt" begin
    @testset "Interfaces" begin        
        serv = Lucky.service(:interactivebrokers) # I want an observable + share(): TODO copy connectable & ref_count code to InteractiveBrokersObservable
        # Or as a proxy that would be: 
        # Create a proxy class with feed method.
        btc = Lucky.feed(serv, :tickPrice) # That I can pass here so we can count the subscriptions
        subscribe!(btc,logger("TADA"))
    end
end
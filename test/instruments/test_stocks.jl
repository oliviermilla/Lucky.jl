@testset "Stocks" begin

    @test Stock(:AAPL, :USD) isa Stock{:AAPL, Currency{:USD}}
        
end

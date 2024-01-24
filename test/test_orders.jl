
@testset "Market Orders" begin
    @test rand(Lucky.MarketOrder) isa Lucky.MarketOrder
end
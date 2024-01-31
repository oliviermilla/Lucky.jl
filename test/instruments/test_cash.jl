
@testset "Cash" begin
    usd = Currency{:USD}
    @testset "Constructors" begin        
        @test Cash(:USD) isa Cash{usd}
        @test Cash("USD") isa Cash{usd}
    end
    @testset "Interface" begin
        @test currency(Cash(:USD)) == usd
    end
end
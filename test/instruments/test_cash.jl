@testset "Cash" begin
    USD = Currency{:USD}
    @testset "Constructors" begin        
        @test Cash(:USD) isa Cash{USD}
        @test Cash("USD") isa Cash{USD}
    end
    @testset "Interface" begin
        @test InstrumentType(Cash(:USD)) === Cash{USD}
        @test currency(Cash(:USD)) == USD
    end
end
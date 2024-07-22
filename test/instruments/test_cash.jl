@testset "Cash" begin
    USD = Currency{:USD}
    @testset "Constructors" begin        
        @test Cash(:USD) isa Cash{USD}
        @test Cash("USD") isa Cash{USD}
    end
    @testset "Interface" begin
        instr = Cash(:USD)
        @test InstrumentType(instr) === Cash{USD}
        @test currency(instr) == USD
    end
end
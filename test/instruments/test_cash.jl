
@testset "Cash" begin
    @testset "Constructors" begin
        usd = Currency("USD")

        @test Cash(:USD) isa Cash{typeof(usd)}
        @test Cash("USD") isa Cash{typeof(usd)}
    end
end
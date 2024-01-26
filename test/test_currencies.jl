
@testset "Currencies" begin
    @testset "Construtors" begin
        @test Currency(:USD) isa Currency{:USD}
        @test Currency("USD") isa Currency{:USD}
    end
    @testset "interface" begin
        sym = :USD
        type = Currency{sym}
        @test symbol(type) == sym
        @test currency(type) == type
    end
end
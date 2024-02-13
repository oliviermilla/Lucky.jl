
@testset "Currencies" begin
    @testset "Construtors" begin
        @test Currency(:USD) isa Currency{:USD}
        @test Currency("USD") isa Currency{:USD}
    end
    @testset "interface" begin
        sym = :USD
        type = Currency{sym}

        @test UnitType(type) === type
        @test CurrencyType(type) === type
        @test CurrencyType(sym) === type
        @test CurrencyType("USD") === type

        @test symbol(type) == sym
        @test currency(type) == type

        io = IOBuffer()
        Base.show(io, type)
        @test String(take!(io)) == "USD"
    end    
end
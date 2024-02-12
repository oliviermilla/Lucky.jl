@testset "Indicators" begin
    @testset "SMAIndicator" begin
        @testset "Constructors" begin
        ind = SMAIndicator(3)
        @test ind isa SMAIndicator{Val(3),Missing}
        @test ind.value === missing

        ind = SMAIndicator(5, one(Float16))
        @test ind isa SMAIndicator{Val(5),Float16}
        @test ind.value == one(Float16)
        end
    end
end
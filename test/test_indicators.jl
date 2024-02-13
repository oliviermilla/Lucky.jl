@testset "Indicators" begin
    @testset "SMAIndicator" begin
        @testset "Constructors" begin
            ind = SMAIndicator(3)
            @test ind isa SMAIndicator{Val(3),Missing}
            @test ind.value === missing

            ind = SMAIndicator(5, one(Float16))
            @test ind isa SMAIndicator{Val(5),Float16}
            @test ind.value == one(Float16)

            @test_throws ErrorException SMAIndicator(0)
        end
        @testset "Operators" begin
            ind = SMAIndicator(3, 57.4)
            ind2 = SMAIndicator(6, 65.2)
            @test ind < ind2
        end
    end
end
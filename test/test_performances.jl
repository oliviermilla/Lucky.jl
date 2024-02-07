@testset "Performances" begin
    @testset "drawdown" begin
        equity = [100.0, 101.1, 103.5, 102.1, 104.8, 103.1, 101.9, 102.6]
        dd = drawdown(equity; rounded=4)
        @test length(equity) == length(dd)
        @test dd[1] == zero(Float64)
        @test dd[2] == zero(Float64)
        @test dd[7] == round((104.8 - 101.9) / 104.8; digits=4)
    end
end
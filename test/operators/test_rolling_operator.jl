using Lucky.Indicators
@testset "rolling()" begin
    op = rolling(3)
    @testset "Interface" begin
        @test operator_right(op, Int64) == IndicatorType(RollingIndicator, 3, Int64)
        @test_throws ErrorException rolling(0)
    end    
end
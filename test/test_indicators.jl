@testset "Indicators" begin
    @testset "Abstract" begin
        @test_throws ErrorException IndicatorType(AbstractIndicator)
    end
    include("indicators/test_ema_indicator.jl")
    include("indicators/test_rolling_indicator.jl")
    include("indicators/test_sma_indicator.jl")
end
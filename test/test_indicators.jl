@testset "Indicators" begin
    @testset "Abstract" begin
        @test_throws ErrorException IndicatorType(AbstractIndicator)        

        # Operations
        struct Indic <: AbstractIndicator
            value::Float64
        end

        a = Indic(3.5)
        b = Indic(5.5)

        c = a + b
        @test c isa Indic
        @test c.value == 3.5 + 5.5

        d = a - b
        @test d isa Indic
        @test d.value == 3.5 - 5.5

        # value()
        @test Lucky.Indicators.value(a) == 3.5
    end
    include("indicators/test_ema_indicator.jl")
    include("indicators/test_rolling_indicator.jl")
    include("indicators/test_sma_indicator.jl")
end
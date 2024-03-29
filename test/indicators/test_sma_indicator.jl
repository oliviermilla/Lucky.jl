@testset "SMAIndicator" begin
    @testset "Constructors" begin
        ind = SMAIndicator(5, one(Float64))
        @test ind isa SMAIndicator{5,Union{Missing,Float64}}
        @test ind.value == one(Float64)

        @test_throws ErrorException SMAIndicator(0, one(Float64))
    end
    @testset "Interface" begin
        ind = SMAIndicator(3, one(Float64))
        @test IndicatorType(ind) == SMAIndicator{3,Union{Missing,Float64},Float64}

        instr = Cash(:USD)
        quoteType = QuoteType(instr, Float64, Date)
        indicType = IndicatorType(SMAIndicator, 5, quoteType)
        @test indicType == SMAIndicator{5,Union{Missing,quoteType},quoteType}

        indic = indicType(missing)
        @test indic isa SMAIndicator{5,Union{Missing,quoteType},quoteType}
        @test indic.value === missing
        @test Lucky.Indicators.period(indic) == 5
    end
    @testset "Operators" begin
        ind = SMAIndicator(3, 57.4)
        ind2 = SMAIndicator(6, 65.2)
        @test ind < ind2
    end
end
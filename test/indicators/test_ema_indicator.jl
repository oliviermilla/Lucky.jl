@testset "EMAIndicator" begin
    @testset "Constructors" begin
        ind = EMAIndicator(5, one(Float64))
        @test ind isa EMAIndicator{Val(5),Union{Missing,Float64}}
        @test ind.value == one(Float64)

        @test_throws ErrorException EMAIndicator(0, one(Float64))
    end
    @testset "Interface" begin
        ind = EMAIndicator(3, one(Float64))
        @test IndicatorType(ind) == EMAIndicator{Val(3),Union{Missing,Float64},Float64}

        instr = Cash(:USD)
        quoteType = QuoteType(instr, Float64, Date)
        indicType = IndicatorType(EMAIndicator, 5, quoteType)
        @test indicType == EMAIndicator{Val(5),Union{Missing,quoteType},quoteType}

        @test_broken indic = indicType(missing)
        # @test indic isa EMAIndicator{Val(5),Union{Missing,quoteType},quoteType}
        # @test indic.value === missing

        @test_throws ErrorException IndicatorType(AbstractIndicator)
    end
    @testset "Operators" begin
        ind = EMAIndicator(3, 57.4)
        ind2 = EMAIndicator(6, 65.2)
        @test ind < ind2
    end
end
@testset "RollingIndicator" begin
    ind = RollingIndicator(3, Vector{Int}())
    @testset "Constructors" begin
        ind isa RollingIndicator{Val(3), Union{Missing, Int}, Int}
    end
    @testset "Interface" begin        
        @test IndicatorType(ind) === RollingIndicator{Val(3), Vector{Int}, Int}

        instr = Cash(:USD)
        quoteType = QuoteType(instr, Float64, Date)
        indicType = IndicatorType(RollingIndicator, 5, quoteType)
        @test indicType == RollingIndicator{Val(5),Vector{Union{Missing,quoteType}},quoteType}

        indic = indicType(Vector{Int}())
        @test indic isa RollingIndicator{Val(5),Vector{Union{Missing,quoteType}},quoteType}
        @test indic.value == Vector{Union{Missing, Int}}()
    end
end
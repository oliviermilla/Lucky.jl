@testset "Units" begin
    @testset "TimestampType" begin
        @test_throws ErrorException TimestampType(Float64)
        @test TimestampType(Dates.DateTime) == Dates.DateTime
    end
    # @testset "percentage()" begin TODO Use Percent
    #     val = 0.375
    #     @test Lucky.Utils.percentage(val) ≈ val
        
    #     # Not rounded        
    #     @test Lucky.Utils.percentage(val;rounded=nothing, humanreadable=true) == "37.5%"

    #     # # Human readable
    #     @test Lucky.Utils.percentage(val;rounded=2) ≈ 0.38
    #     @test Lucky.Utils.percentage(val;rounded=2, humanreadable=true) == "38.0%"
    # end
end
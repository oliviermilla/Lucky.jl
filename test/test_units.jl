@testset "Units" begin
    @testset "TimestampType" begin
        @test_throws ErrorException TimestampType(Float64)
        @test TimestampType(Dates.DateTime) == Dates.DateTime
    end
end
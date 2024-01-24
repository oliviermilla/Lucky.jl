using TimeSeries

@testset "TimeSeries" begin
    timearray = TimeSeries.readtimearray("./ext/AAPL.csv")
    vector = Vector{Ohlc}(timearray)

    @testset "Constructors" begin
        @test isa(vector, Vector{Ohlc})
        @test length(vector) == 2
    end

end
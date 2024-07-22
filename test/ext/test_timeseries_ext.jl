@testset "TimeSeriesExt" begin
    import TimeSeries # Import to not interfer with Lucky.timestamp()
    timearray = TimeSeries.readtimearray("./ext/AAPL.csv")
    vector = Vector{Ohlc}(timearray)

    @testset "Constructors" begin
        @test isa(vector, Vector{Ohlc})
        @test length(vector) == 2
    end

end
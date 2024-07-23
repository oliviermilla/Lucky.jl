@testset "TimeSeriesExt" begin
    import TimeSeries # Import to not interfer with Lucky.timestamp()
    timearray = TimeSeries.readtimearray("./ext/AAPL.csv")
    vector = Vector{Ohlc}(timearray)

    @testset "Constructors" begin
        @test isa(vector, Vector{Ohlc})
        @test length(vector) == 2
    end

    @testset "Interfaces" begin
        instr = Stock(:AAPL, :USD)
        qt = quotes(instr, timearray)
        @test isa(qt, Rocket.ProxyObservable)
        subscribe!(qt |> take(1), x -> @test isa(x, AbstractQuote))
    end

end
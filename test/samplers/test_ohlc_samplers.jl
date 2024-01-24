using Dates

@testset "rand()" begin
    period = Minute(2)
    ohlcs = rand(Ohlc{DateTime}, period, 3)

    @test ohlcs[2].timestamp == ohlcs[1].timestamp + period
    @test ohlcs[3].timestamp == ohlcs[2].timestamp + period
end
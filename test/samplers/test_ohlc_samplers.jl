@testset "Ohlc samplers" begin
    @testset "for Date" begin
        @testset "Single (::Val{1})" begin
            ohlc = rand(Ohlc{Date})
            @test ohlc isa Ohlc{Date}
            @test ohlc.high >= ohlc.low
            
            ohlc2 = rand(Ohlc{Date})
            @test ohlc != ohlc2
        end
        @testset "Vector (::Val{+Inf})" begin
            period = Day(2)
            ohlcs = rand(Ohlc{Date}, period, 3)

            @test ohlcs[2].timestamp == ohlcs[1].timestamp + period
            @test ohlcs[3].timestamp == ohlcs[2].timestamp + period
        end
    end
    @testset "for DateTime" begin
        @testset "Single (::Val{1})" begin
            ohlc = rand(Ohlc{DateTime})
            @test ohlc isa Ohlc{DateTime}
            @test ohlc.high >= ohlc.low
        end
        @testset "Vector (::Val{+Inf})" begin
            period = Minute(2)
            ohlcs = rand(Ohlc{DateTime}, period, 3)

            @test ohlcs[2].timestamp == ohlcs[1].timestamp + period
            @test ohlcs[3].timestamp == ohlcs[2].timestamp + period
        end
    end
end
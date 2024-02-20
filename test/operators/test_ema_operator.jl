@testset "ema()" begin
    subject = Subject(EMAIndicator)
    source = Rocket.from(1:5) |> Lucky.ema(3) |> multicast(subject)

    counter = Int(0)
    prev = nothing
    function testNext(avg::EMAIndicator)        
        val = avg.value
        counter += 1
        if counter == 1
            @test ismissing(val)
        elseif counter == 2
            @test ismissing(val)
        elseif counter == 3            
            @test val == (1 + 2 + 3) / 3 # SMA(3)
        elseif counter == 4
            @test val == (4 - prev) * (2/(3+1)) + prev
        elseif counter == 5
            @test val == (5 - prev) * (2/(3+1)) + prev
        end
        prev = val
    end

    function testComplete()
        @test counter == 5
    end

    testActor = lambda(on_next=testNext, on_complete=testComplete)
    subscribe!(subject, testActor)
    connect(source)
end
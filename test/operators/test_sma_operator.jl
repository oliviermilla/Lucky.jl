@testset "sma()" begin
    subject = Subject(SMAIndicator)
    source = Rocket.from(1:5) |> Lucky.sma(3) |> multicast(subject)

    counter = Int(0)
    function testNext(avg::SMAIndicator)
        val = avg.value
        counter += 1
        if counter == 1
            @test ismissing(val)
        elseif counter == 2
            @test ismissing(val)
        elseif counter == 3
            @test val == (1 + 2 + 3) / 3
        elseif counter == 4
            @test val == (2 + 3 + 4) / 3
        elseif counter == 5
            @test val == (3 + 4 + 5) / 3
        end
    end

    function testComplete()
        @test counter == 5
    end

    testActor = lambda(on_next=testNext, on_complete=testComplete)
    subscribe!(subject, testActor)
    connect(source)
end
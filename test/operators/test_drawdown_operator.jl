@testset "drawdown()" begin
    subject = Subject(DrawdownIndicator)
    input = [100.0, 101.1, 103.5, 102.1, 104.8, 103.1, 101.9, 102.6]
    source = Rocket.from(input) |> drawdown() |> multicast(subject)

    res = [0.0, 0.0, 0.0, -103.5 + 102.1, 0.0, -104.8 + 103.1, -104.8 + 101.9, -104.8 + 102.6]

    counter = UInt8(0)
    function testNext(avg::DrawdownIndicator)        
        val = avg.value
        counter += 1
        @test val ≈ res[counter]
    end

    function testComplete()
        @test counter == length(input)
    end

    testActor = lambda(on_next=testNext, on_complete=testComplete)
    subscribe!(subject, testActor)
    connect(source)

end
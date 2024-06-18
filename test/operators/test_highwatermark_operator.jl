@testset "highwatermark()" begin
    subject = Subject(HighWaterMarkIndicator)
    source = Rocket.from([100.0, 101.1, 103.5, 102.1, 104.8, 103.1, 101.9, 102.6]) |> highwatermark() |> multicast(subject)

    res = [100.0, 101.1, 103.5, 103.5, 104.8, 104.8, 104.8, 104.8]

    counter = UInt8(0)
    function testNext(avg::HighWaterMarkIndicator)
        val = avg.value
        counter += 1
        @test val == res[counter]
    end

    function testComplete()
        @test counter == UInt8(8)
    end

    testActor = lambda(on_next=testNext, on_complete=testComplete)
    subscribe!(subject, testActor)
    connect(source)

end
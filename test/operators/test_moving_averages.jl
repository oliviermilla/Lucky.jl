@testset "Moving Averages" begin
    @testset "Simple Moving Averages" begin        
        subject = Subject(Union{Missing, Float64})
        source = Rocket.from(1:5) |> sma(3) |> multicast(subject)

        counter = Int(0)
        function testNext(avg::Union{Missing,Float64})
            counter += 1
            if counter == 1
                @test ismissing(avg)
            elseif counter == 2
                @test ismissing(avg)
            elseif counter == 3
                @test avg == (1+2+3)/3
            elseif counter == 4
                @test avg == (2+3+4)/3
            elseif counter == 5
                @test avg == (3+4+5)/3
            end
        end
    
        function testComplete()
            @test counter == 5
        end        
    
        testActor = lambda(on_next=testNext, on_complete=testComplete)
        subscribe!(subject, testActor)
        connect(source)
    end
end
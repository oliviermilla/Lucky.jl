@testset "DydxV3Ext" begin
    using Lucky.Operators

    using DydxV3
    using Rocket
    using Dates

    mutable struct OhlcOperatorTestActor <: Actor{Ohlc}
        trades::Vector{DydxV3.Trade}
        counter::Int
        cutoffs::Vector{Int}
        fromIdx::Int
        uptoIdx::Int
    end

    function OhlcOperatorTestActor(vec::Vector{DydxV3.Trade})
        ctf = findall((trade) -> second(trade.createdAt) == 59, vec)
        push!(ctf, lastindex(vec))
        return OhlcOperatorTestActor(vec, 0, ctf, 1, ctf[begin])
    end

    function testNext(actor::OhlcOperatorTestActor, ohlc::Ohlc)
        actor.counter += 1
        # println("$(actor.counter) - Open Trade: $(actor.trades[actor.fromIdx])")
        # println("$(actor.counter) - Close Trade: $(actor.trades[actor.uptoIdx])")
        priceRng = map((trade) -> trade.price, actor.trades[actor.fromIdx:actor.uptoIdx])
        # println("$(actor.counter) - Price Range: $(priceRng)")
        # println(ohlc)

        @test ohlc.open == actor.trades[actor.fromIdx].price
        @test ohlc.close == actor.trades[actor.uptoIdx].price
        @test ohlc.high == maximum(priceRng)
        @test ohlc.low == minimum(priceRng)
        actor.fromIdx = actor.uptoIdx + 1
        actor.uptoIdx = actor.cutoffs[actor.counter+1]
    end

    function testComplete(actor::OhlcOperatorTestActor)
        @test actor.counter == length(actor.cutoffs) - 1
    end

    Rocket.on_next!(actor::OhlcOperatorTestActor, data::Ohlc) = testNext(actor, data)
    Rocket.on_error!(actor::OhlcOperatorTestActor, error) = throw(actor, error)
    Rocket.on_complete!(actor::OhlcOperatorTestActor) = testComplete(actor)

    @testset "cutoff == true" begin
        trades = rand(DydxV3.Trade, Second(1), 120) # Generate sufficient data for 1 minute + cutoff = 2 mins
        obs = Rocket.from(trades) |> ohlc(Minute(1), true)

        testActor = OhlcOperatorTestActor(trades)
        # println("0 - $(length(trades)) trades : $(trades[begin].createdAt) - $(trades[end].createdAt)")
        # println("0 - $(length(testActor.cutoffs)) cutoffs : $(testActor.cutoffs)")
        Rocket.subscribe!(obs, testActor)
    end
end
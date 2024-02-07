@testset "Fills" begin
    instr = Cash(:USD)
    order = MarketOrder(instr, 1.0)
    @testset "Constructors" begin                
        fill = Fill("id", order, 12.45, 1.0, 0.0, Dates.now(Dates.UTC))
        @test fill isa Fill{MarketOrder{Cash{Currency{:USD}}}}
    end
end
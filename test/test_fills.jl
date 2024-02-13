@testset "Fills" begin
    instr = Cash(:USD)
    order = MarketOrder(instr, 1.0)
    @testset "Constructors" begin                
        fill = Fill("id", order, 12.45, 1.0, 0.0, Dates.now(Dates.UTC))
        @test fill isa Fill{OrderType(order), Float64, DateTime}
    end
    @testset "Interfaces" begin
        fill = Fill("id", order, 12.45, 1.0, 0.0, Date(2021,1,1))
        @test FillType(fill) == Fill{OrderType(order), Float64, Date}
        @test currency(fill) == Currency{:USD}
    end
end
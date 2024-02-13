
@testset "Orders" begin
    @testset "Market Orders" begin
        @testset "Constructors" begin
            instr = Cash(:USD)
            order = MarketOrder(instr, 13.4)
            @test order isa MarketOrder{InstrumentType(instr), Float64}
        end
        @testset "Interfaces" begin
            instr = Cash(:USD)
            order = MarketOrder(instr, 13.4)
            @test currency(order) == Currency{:USD}
            @test currency(OrderType(order)) == Currency{:USD}
        end
    end
    @testset "Limit Orders" begin
        @testset "Constructors" begin
            instr = Cash(:USD)
            order = LimitOrder(instr, 13.4, 1.0889)
            @test order isa LimitOrder{InstrumentType(instr), Float64}
        end
        @testset "Interfaces" begin
            instr = Cash(:USD)
            order = LimitOrder(instr, 13.4, 1.0889)
            @test currency(order) == Currency{:USD}
            @test currency(OrderType(order)) == Currency{:USD}
        end
    end    
end
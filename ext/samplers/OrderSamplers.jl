module OrderSamplers

using Lucky.Instruments
using Lucky.Orders
using Random

# Random.rand(rng::AbstractRNG, ::Random.SamplerType{MarketOrder}, instr::Instrument) = MarketOrder(instr, rand(rng, -10:0.1:10))
# Sampler(RNG::Type{<:AbstractRNG}, ord::MarketOrder, r::Random.Repetition) = SamplerSimple(ord, )

# struct SamplerMarketOrder{I} <: Random.Sampler{MarketOrder} # generates values of type Int
#     instr::I
#     RNG::AbstractRNG
# end

# Random.Sampler(RNG::Type{<:AbstractRNG}, instr::I, r::Random.Repetition) where {I<:Instrument} = SamplerMarketOrder{I}(instr, RNG)

# rand(rng::AbstractRNG, sp::SamplerMarketOrder) = MarketOrder(sp.instr, rand(rng, Sampler(sp.RNG, -10:0.1:10, r)))

end
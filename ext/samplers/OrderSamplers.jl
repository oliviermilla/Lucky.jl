module OrderSamplers

using Lucky.Orders
using Random

Random.rand(rng::AbstractRNG, ::Random.SamplerType{MarketOrder}) = MarketOrder(rand(rng, -10:0.1:10))

end
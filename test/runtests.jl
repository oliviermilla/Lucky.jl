using Test

using Lucky
using Rocket

using Dates
using Random

using InteractiveBrokers

wrap = InteractiveBrokers.Wrapper(
         # Customized methods go here
         error= (id, errorCode, errorString, advancedOrderRejectJson) ->
                  println("Error: $(something(id, "NA")) $errorCode $errorString $advancedOrderRejectJson"),

         nextValidId= (orderId) -> println("Next OrderId: $orderId"),

         managedAccounts= (accountsList) -> println("Managed Accounts: $accountsList")

         # more method overrides can go here...
       );

#wrap = InteractiveBrokers.simple_wrap()

# Connect to the server with clientId = 1
ib = InteractiveBrokers.connect(4001, 1);

# Start a background Task to process the server responses
InteractiveBrokers.start_reader(ib, wrap);

sleep(10000)
# Disconnect
InteractiveBrokers.disconnect(ib)

# Uncomment if you want to run examples
# include("../examples/goldencross.jl")

# Same order as in Lucky.jl

# include("test_units.jl")
# include("test_currencies.jl")
# include("test_instruments.jl")
# include("test_quotes.jl")
# include("test_positions.jl")
# include("test_orders.jl")
# include("test_fills.jl")
# include("test_indicators.jl")

# include("test_ohlcs.jl")
# include("samplers/test_ohlc_samplers.jl")
# include("operators/test_rolling_operator.jl")
# include("operators/test_ema_operator.jl")
# include("operators/test_sma_operator.jl")

# include("exchanges/test_fake_exchanges.jl")
# include("blotters/test_in_memory_blotters.jl")

# # Extensions
# include("ext/test_timeseries.jl")
# include("ext/test_dydxv3_ohlc_operators.jl")

# include("test_performances.jl")
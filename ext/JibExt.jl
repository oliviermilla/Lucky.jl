module InteractiveBrokersExt

# using InteractiveBrokers

# wrap = InteractiveBrokers.Wrapper(
#          # Customized methods go here
#          error= (id, errorCode, errorString, advancedOrderRejectJson) ->
#                   println("Error: $(something(id, "NA")) $errorCode $errorString $advancedOrderRejectJson"),

#          nextValidId= (orderId) -> println("Next OrderId: $orderId"),

#          managedAccounts= (accountsList) -> println("Managed Accounts: $accountsList")

#          # more method overrides can go here...
#        );

# # Connect to the server with clientId = 1
# ib = InteractiveBrokers.connect(4002, 1);

# # Start a background Task to process the server responses
# InteractiveBrokers.start_reader(ib, wrap);

# # Define contract
# contract = InteractiveBrokers.Contract(symbol="GOOG",
#                         secType="STK",
#                         exchange="SMART",
#                         currency="USD");

# # Define order
# order = InteractiveBrokers.Order();
# order.action        = "BUY"
# order.totalQuantity = 10
# order.orderType     = "LMT"
# order.lmtPrice      = 100

# orderId = 1    # Should match whatever is returned by the server

# # Send order
# InteractiveBrokers.placeOrder(ib, orderId, contract, order)

# # Disconnect
# InteractiveBrokers.disconnect(ib)

end
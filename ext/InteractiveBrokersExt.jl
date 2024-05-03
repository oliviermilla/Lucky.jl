module InteractiveBrokersExt

# using Lucky

# using InteractiveBrokers
# using Rocket

# struct InteractiveBrokersObservable <: Subscribable{Nothing}
#     events::Vector{Symbol}
#     targets::Vector{Rocket.Subject}
#     applys::Vector{Function}   

#     host::Union{Nothing, Any} # IPAddr (not typed to avoid having to add Sockets to Project.toml 1.10)
#     port::Int

#     clientId::Int

#     connectOptions::String
#     optionalCapabilities::String

#     function InteractiveBrokersObservable(host=nothing, port::Int=4002, clientId::Int=1, connectOptions::String="", optionalCapabilities::String="")
#         return new(Vector{Symbol}(), Vector{Rocket.Subject}(), Vector{Function}(), host, port, clientId, connectOptions, optionalCapabilities)
#     end
# end

# struct InteractiveBrokersObservableSubscription <: Teardown
#     connection::InteractiveBrokers.Connection
# end

# function Rocket.on_subscribe!(obs::InteractiveBrokersObservable, actor)
#     ib = InteractiveBrokers.connect(obs.host, obs.port, obs.clientId, obs.connectOptions, obs.optionalCapabilities)
#     InteractiveBrokers.start_reader(ib, wrapper(obs))
#     return InteractiveBrokersObservableSubscription(ib)
# end

# Rocket.as_teardown(::Type{<:InteractiveBrokersObservableSubscription}) = UnsubscribableTeardownLogic()

# function Rocket.on_unsubscribe!(subscription::InteractiveBrokersObservableSubscription)
#     disconnect(subscription.connection)
# end

# function Lucky.service(::Val{:interactivebrokers}, host=nothing, port::Int=4002, clientId::Int=1, connectOptions::String="", optionalCapabilities::String="")
#     obs = InteractiveBrokersObservable(host, port, clientId, connectOptions, optionalCapabilities)
#     refCounts[obs] = obs |> share()
#     return obs
# end

# defaultMapper = Dict{Symbol,Pair{Function,Type}}()
# refCounts = Dict{InteractiveBrokersObservable, Rocket.Observable}()

# function Lucky.feed(client::InteractiveBrokersObservable, event::Symbol, applyFunction::Function, outputType::Type)
#     subject = Subject(outputType)

#     push!(client.events, event)
#     push!(client.targets, subject)
#     push!(client.applys, applyFunction)

#     return subject
# end

# function Lucky.feed(client::InteractiveBrokersObservable, event::Symbol)
#     haskey(defaultMapper, event) && return feed(client, event, defaultMapper[event][1], defaultMapper[event][2])
#     return faulted("No default mapping function for $(event). Provide one or contribute a default implementation.")
# end

# function wrapper(client::InteractiveBrokersObservable)
#     wrap = InteractiveBrokers.Wrapper()
#     for idx in client.events
#         setproperty!(wrap, client.events[idx], x -> next!(targets[idx], applys[idx](x)))
#     end
#     return wrap
# end

end
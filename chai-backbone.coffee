
((chaiBackbone) ->
  # Module systems magic dance.
  if (typeof require == "function" && typeof exports == "object" && typeof module == "object")
    # NodeJS
    module.exports = chaiBackbone
  else if (typeof define == "function" && define.amd)
    # AMD
    define -> chaiBackbone
  else
    # Other environment (usually <script> tag): plug in to global chai instance directly.
    chai.use chaiBackbone

)((chai, utils) ->
  inspect = utils.inspect
  flag = utils.flag

  # Verifies if the subject fires a trigger 'when' events happen
  #
  # Examples:
  #   model.should.trigger("change", with: [model]).when -> model.set attribute: "value"
  #   model.should.not.trigger("change:thing").when -> model.set attribute: "value"
  #   model.should.trigger("change").and.not.trigger("change:thing").when -> model.set attribute: "value"
  #
  # @param trigger the trigger expected to be fired
  chai.Assertion.addMethod 'trigger', (trigger, options = {}) ->
    definedActions = flag(this, 'whenActions') || []

    # Add a around filter to the when actions
    definedActions.push
      negate: flag(this, 'negate')

      # set up the callback to trigger
      before: (context) ->
        @callback = sinon.spy()
        flag(context, 'object').on trigger, @callback

      # verify if our callback is triggered
      after: (context) ->
        negate = flag(context, 'negate')
        flag(context, 'negate', @negate)
        context.assert @callback.called,
          "expected to trigger #{trigger}",
          "expected not to trigger #{trigger}"

        if options.with?
          context.assert @callback.calledWith(options.with...),
            "expected trigger to be called with #{inspect options.with}, but was called with #{inspect @callback.args[0]}.",
            "expected trigger not to be called with #{inspect options.with}, but was"
        flag(context, 'negate', negate)
    flag(this, 'whenActions', definedActions)

  # Verify if a url fragment is routed to a certain method on the router
  # Options:
  # - you can consider multiple routers to test routing priorities
  # - you can indicate expected arguments to test url extractions
  #
  # Examples:
  #
  #   class MyRouter extends Backbone.Router
  #     routes:
  #       "home/:page/:other": "homeAction"
  #
  #   myRouter = new MyRouter
  #
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction")
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction", arguments: ["stuff", "thing"])
  #   "home/stuff/thing".should.route_to(myRouter, "homeAction", consider: [otherRouterWithPossiblyConflictingRoute])
  #
  chai.Assertion.addProperty 'route', ->
    flag(this, 'routing', true)

  routeTo = (router, methodName, options = {}) ->
    unless (typeof router is 'object') and (router instanceof Backbone.Router)
      throw new TypeError('provided router is not a Backbone.Router')

    # move possible active Backbone history out of the way temporary
    current_history = Backbone.history

    # reset history to clear active routes
    Backbone.history = new Backbone.History

    stub = sinon.stub router, methodName # stub on our expected method call

    router._bindRoutes() # inject router routes into our history
    if options.considering? # if multiple routers are provided load their routes aswell
      consideredRouter._bindRoutes() for consideredRouter in options.considering

    # manually set the root option to prevent calling Backbone.history.start() which is global
    Backbone.history.options =
      root: '/'

    route = flag(this, 'object')
    # fire our route to test
    Backbone.history.loadUrl route

    # set back our history. The stub should have our collected info now
    Backbone.history = current_history
    # restore the router method
    router[methodName].restore()

    # now assert if everything went according to spec
    @assert stub.calledOnce,
      "expected `#{route}` to route to #{methodName}",
      "expected `#{route}` not to route to #{methodName}"

    # verify arguments if they were provided
    if options.arguments?
      @assert stub.calledWith(options.arguments...),
        "expected `#{methodName}` to be called with #{inspect options.arguments}, but was called with #{inspect stub.args[0]} instead",
        "expected `#{methodName}` not to be called with #{inspect options.arguments}, but was"

  chai.Assertion.overwriteProperty 'to', (_super) ->
    ->
      if flag(this, 'routing')
        routeTo
      else
        _super.apply(this, arguments)

  chai.Assertion.addMethod 'call', (methodName) ->
    object = flag(this, 'object')
    definedActions = flag(this, 'whenActions') || []
    definedActions.push
      negate: flag(this, 'negate')
      before: (context) ->
        @originalMethod = object[methodName]
        @spy = sinon.spy()
        object[methodName] = @spy
        object.delegateEvents?()
      after: (context) ->
        object[methodName] = @originalMethod
        object.delegateEvents?()

        context.assert @spy.callCount > 0,
          @spy.printf("expected %n to have been called at least once"),
          @spy.printf("expected %n to not have been called")

    flag(this, 'whenActions', definedActions)

)


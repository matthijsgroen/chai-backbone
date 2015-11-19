
describe 'Chai-Backbone matchers', ->

  describe 'trigger / when', ->

    it 'asserts if a trigger is fired', ->
      m = new Backbone.Model
      m.should.trigger('change').when ->
        m.set fire: 'trigger'

    it 'asserts if a trigger is fired multiple times', ->
      m = new Backbone.Model
      m.should.trigger('change').when ->
        m.set fire: 'trigger'
        m.set other: 'trigger'

    it 'asserts if a trigger is not fired', ->
      m = new Backbone.Model
      m.should.not.trigger('change:not_fire').when ->
        m.set fire: 'trigger'

    it 'knows the negate state in the chain', ->
      m = new Backbone.Model
      m.should.trigger('change').and.not.trigger('change:not_fire').when ->
        m.set fire: 'trigger'

  describe 'assert backbone routes', ->
    routerClass = null
    router = null

    before ->
      routerClass = class extends Backbone.Router
        routes:
          'route1/sub': 'subRoute'
          'route2/:par1': 'routeWithArg'
        subRoute: ->
        routeWithArg: (arg) ->

    beforeEach ->
      router = new routerClass

    it 'validates if provided router is a Backbone.Router', ->
      expect(->
        "route1/ere".should.route.to { noRouter: 'check' }, 'subRoute'
      ).to.throw TypeError, 'provided router is not a Backbone.Router'

    it 'checks if a method is trigger by route', ->
      "route1/sub".should.route.to router, 'subRoute'
      expect(->
        "route1/ere".should.route.to router, 'subRoute'
      ).to.throw 'expected `route1/ere` to route to subRoute'

    it 'allows negation in route assertion', ->
      "route1/ere".should.not.route.to router, 'subRoute'
      expect(->
        "route1/sub".should.not.route.to router, 'subRoute'
      ).to.throw 'expected `route1/sub` not to route to subRoute'

    it 'verifies argument parsing', ->
      "route2/argVal".should.route.to router, 'routeWithArg', arguments: ['argVal']
      expect(->
        "route2/ere".should.route.to router, 'routeWithArg', arguments: ['argVal']
      ).to.throw 'expected `routeWithArg` to be called with [ \'argVal\' ], but was called with [ \'ere\', null ] instead'

    it 'leaves the `to` keyword working properly', ->
      expect('1').to.be.equal '1'

  describe 'call', ->

    it 'asserts if a method on provided object is called', ->
      obj =
        method: ->

      obj.should.call('method').when ->
        obj.method()

    it 'raises AssertionError if method was not called', ->
      obj =
        method: ->
      expect(->
        obj.should.call('method').when ->
          "noop"
      ).to.throw /been called/

   if Backbone? and jQuery?
     it 'can check event calls of Backbone.Views', ->
       viewClass = class extends Backbone.View
         events:
           'click': 'eventCall'
         eventCall: ->

       viewInstance = new viewClass
       viewInstance.should.call('eventCall').when ->
         viewInstance.$el.trigger('click')

  describe 'callSuper', ->

    PassClass = Backbone.View.extend
      render: ->
        return Backbone.View.prototype.render.call this, arguments

    FailCallThroughClass = Backbone.View.extend
      render: ->

    FailReturnClass = Backbone.View.extend
      render: ->
        Backbone.View.prototype.render.call this, arguments
        return

    it 'asserts a method calls through to the super', ->
      view = new PassClass
      view.should.callSuper 'render'

    it 'raises AssertionError if not called through to the super', ->
      view = new FailCallThroughClass
      expect(->
        view.should.callSuper 'render'
      ).to.throw /been called/

    it 'raises AssertionError if not super return not returned', ->
      view = new FailReturnClass
      expect(->
        view.should.callSuper 'render'
      ).to.throw /return/



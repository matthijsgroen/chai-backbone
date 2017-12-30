// Generated by CoffeeScript 1.12.7
(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  describe('Chai-Backbone matchers', function() {
    describe('trigger / when', function() {
      it('asserts if a trigger is fired', function() {
        var m;
        m = new Backbone.Model;
        return m.should.trigger('change').when(function() {
          return m.set({
            fire: 'trigger'
          });
        });
      });
      it('asserts if a trigger is fired multiple times', function() {
        var m;
        m = new Backbone.Model;
        return m.should.trigger('change').when(function() {
          m.set({
            fire: 'trigger'
          });
          return m.set({
            other: 'trigger'
          });
        });
      });
      it('asserts if a trigger is not fired', function() {
        var m;
        m = new Backbone.Model;
        return m.should.not.trigger('change:not_fire').when(function() {
          return m.set({
            fire: 'trigger'
          });
        });
      });
      return it('knows the negate state in the chain', function() {
        var m;
        m = new Backbone.Model;
        return m.should.trigger('change').and.not.trigger('change:not_fire').when(function() {
          return m.set({
            fire: 'trigger'
          });
        });
      });
    });
    describe('assert backbone routes', function() {
      var router, routerClass;
      routerClass = null;
      router = null;
      before(function() {
        return routerClass = (function(superClass) {
          extend(_Class, superClass);

          function _Class() {
            return _Class.__super__.constructor.apply(this, arguments);
          }

          _Class.prototype.routes = {
            'route1/sub': 'subRoute',
            'route2/:par1': 'routeWithArg'
          };

          _Class.prototype.subRoute = function() {};

          _Class.prototype.routeWithArg = function(arg) {};

          return _Class;

        })(Backbone.Router);
      });
      beforeEach(function() {
        return router = new routerClass;
      });
      it('validates if provided router is a Backbone.Router', function() {
        return expect(function() {
          return "route1/ere".should.route.to({
            noRouter: 'check'
          }, 'subRoute');
        }).to["throw"](TypeError, 'provided router is not a Backbone.Router');
      });
      it('checks if a method is trigger by route', function() {
        "route1/sub".should.route.to(router, 'subRoute');
        return expect(function() {
          return "route1/ere".should.route.to(router, 'subRoute');
        }).to["throw"]('expected `route1/ere` to route to subRoute');
      });
      it('allows negation in route assertion', function() {
        "route1/ere".should.not.route.to(router, 'subRoute');
        return expect(function() {
          return "route1/sub".should.not.route.to(router, 'subRoute');
        }).to["throw"]('expected `route1/sub` not to route to subRoute');
      });
      it('verifies argument parsing', function() {
        "route2/argVal".should.route.to(router, 'routeWithArg', {
          "arguments": ['argVal']
        });
        return expect(function() {
          return "route2/ere".should.route.to(router, 'routeWithArg', {
            "arguments": ['argVal']
          });
        }).to["throw"]('expected `routeWithArg` to be called with [ \'argVal\' ], but was called with [ \'ere\', null ] instead');
      });
      return it('leaves the `to` keyword working properly', function() {
        return expect('1').to.be.equal('1');
      });
    });
    describe('call', function() {
      it('asserts if a method on provided object is called', function() {
        var obj;
        obj = {
          method: function() {}
        };
        return obj.should.call('method').when(function() {
          return obj.method();
        });
      });
      return it('raises AssertionError if method was not called', function() {
        var obj;
        obj = {
          method: function() {}
        };
        return expect(function() {
          return obj.should.call('method').when(function() {
            return "noop";
          });
        }).to["throw"](/been called/);
      });
    });
    if ((typeof Backbone !== "undefined" && Backbone !== null) && (typeof jQuery !== "undefined" && jQuery !== null)) {
      return it('can check event calls of Backbone.Views', function() {
        var viewClass, viewInstance;
        viewClass = (function(superClass) {
          extend(_Class, superClass);

          function _Class() {
            return _Class.__super__.constructor.apply(this, arguments);
          }

          _Class.prototype.events = {
            'click': 'eventCall'
          };

          _Class.prototype.eventCall = function() {};

          return _Class;

        })(Backbone.View);
        viewInstance = new viewClass;
        return viewInstance.should.call('eventCall').when(function() {
          return viewInstance.$el.trigger('click');
        });
      });
    }
  });

}).call(this);

chai-backbone
============

chai-backbone is an extension to the [chai](http://chaijs.com/) assertion library that
provides a set of backbone specific assertions.

Usage
-----

Include `chai-backbone.js` in your test file, after `chai.js` (version 1.0.0-rc1 or later):

    <script src="chai-backbone.js"></script>

Also this extension depends on [sinon](http://sinonjs.org/) and [chai-changes](https://github.com/matthijsgroen/chai-changes) so include these too.

Use the assertions with chai's `expect` or `should` assertions.

Assertions
----------

### `trigger`

    model.should.trigger("change", with: [model]).when -> model.set attribute: "value"

this can also be chained further:

    model.should.trigger("change").and.trigger("change:attribute").when -> model.set attribute: "value"
    model.should.trigger("change").and.not.trigger("reset").when -> model.set attribute: "value"

### `route.to`

Tests if a route is delegated to the correct router and if the arguments
are extracted in the expected manner.

    "page/3".should.route.to myRouter, "openPage", arguments: ["3"]
    "page/3".should.route.to myRouter, "openPage", considering: [conflictingRouter]

### `call`

This assertion is ideal for testing view callbacks it will rebind view
events to test DOM events

    view.should.call('startAuthentication').when ->
      view.$('a.login').trigger 'click'

## License

Copyright (c) 2012 Matthijs Groen

MIT License (see the LICENSE file)


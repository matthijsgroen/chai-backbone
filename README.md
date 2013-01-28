chai-backbone
=============

[![Build Status](https://travis-ci.org/matthijsgroen/chai-backbone.png?branch=master)](https://travis-ci.org/matthijsgroen/chai-backbone)

chai-backbone is an extension to the [chai](http://chaijs.com/) assertion library that
provides a set of backbone specific assertions.

Use the assertions with chai's `expect` or `should` assertions.

Dependencies
------------

- [sinon](http://sinonjs.org/)
- [chai-changes](https://github.com/matthijsgroen/chai-changes)
- [underscore](http://underscorejs.org/)
- [backbone](http://backbonejs.org/)

Assertions
----------

### `trigger`

```coffeescript
model.should.trigger("change", with: [model]).when ->
  model.set attribute: "value"
```

this can also be chained further:

```coffeescript
model.should.trigger("change").and.trigger("change:attribute").when -> model.set attribute: "value"
model.should.trigger("change").and.not.trigger("reset").when -> model.set attribute: "value"
```

### `route.to`

Tests if a route is delegated to the correct router and if the arguments
are extracted in the expected manner.

```coffeescript
"page/3".should.route.to myRouter, "openPage", arguments: ["3"]
"page/3".should.route.to myRouter, "openPage", considering: [conflictingRouter]
```

### `call`

This assertion is ideal for testing view callbacks it will rebind view
events to test DOM events

```coffeescript
view.should.call('startAuthentication').when ->
  view.$('a.login').trigger 'click'
```

## Installation and Setup

### Node

Do an `npm install chai-changes` to get up and running. Then:

```javascript
var chai = require("chai");
var chaiChanges = require("chai-changes");

chai.use(chaiChanges);
```

You can of course put this code in a common test fixture file; for an example using [Mocha][mocha]

### AMD

Chai Changes supports being used as an [AMD][amd] module, registering itself anonymously (just like Chai). So,
assuming you have configured your loader to map the Chai and Chai Changes files to the respective module IDs
`"chai"` and `"chai-changes"`, you can use them as follows:

```javascript
define(function (require, exports, module) {
    var chai = require("chai");
    var chaiChanges = require("chai-changes");

    chai.use(chaiChanges);
});
```

### `<script>` tag

If you include Chai Changes directly with a `<script>` tag, after the one for Chai itself, then it will
automatically plug in to Chai and be ready for use:

```html
<script src="chai.js"></script>
<script src="chai-changes.js"></script>
```

## License

Copyright (c) 2012 Matthijs Groen

MIT License (see the LICENSE file)

[chai]: http://chaijs.com/
[mocha]: http://visionmedia.github.com/mocha/
[amd]: https://github.com/amdjs/amdjs-api/wiki/AMD


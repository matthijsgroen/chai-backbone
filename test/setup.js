var chai = require("chai");
var chaiChanges = require("chai-changes");
var chaiBackbone = require("..");

chai.should();
chai.use(chaiChanges);
chai.use(chaiBackbone);

global.expect = chai.expect;
global.Backbone = require("backbone");
global.sinon = require("sinon");


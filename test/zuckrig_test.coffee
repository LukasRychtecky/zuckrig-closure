{zuckrig} = require '../tasks/zuckrig_filter'

describe 'Zuckrig', ->

  it 'should append a constructor annotation', ->
    source = """
      goog.provide('app.Employee');

      app.Employee = (function(_super) {

        /**
          @param {string} name
        */


        function Employee(name) {
        }

        return Employee;

      })();

    """

    fixedSource = """
      (function(goog) {
      goog.provide('app.Employee');

      app.Employee = (function(_super) {
        /**
          @param {string} name
          @constructor
        */
        function Employee(name) {
        }
        return Employee;

      })();

      })(goog);

    """
    zuckrig(source).should.equal fixedSource


  it 'should add new code block', ->
    source = """
      goog.provide('app.Employee');

      app.Employee = (function() {

        function Employee() {
        }

        return Employee;

      })();

    """

    fixedSource = """
      (function(goog) {
      goog.provide('app.Employee');

      app.Employee = (function() {
        /**
          @constructor
        */
        function Employee() {
        }
        return Employee;

      })();

      })(goog);

    """
    zuckrig(source).should.equal fixedSource


  it 'should append a constructor annotation with extending', ->
    source = """
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

      goog.provide('app.Employee');

      goog.require('app.Person');

      app.Employee = (function(_super) {

        __extends(Employee, _super);

        /**
          @param {string} name
        */


        function Employee(name) {
          Employee.__super__.constructor.call(this, name);
        }

        return Employee;

      })(app.Person);

    """

    fixedSource = """
      (function(goog) {
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key];
       } function ctor() { this.constructor = child;
       } ctor.prototype = parent.prototype;
       child.prototype = new ctor();
       child.__super__ = parent.prototype;
       return child;
       };

      goog.provide('app.Employee');

      goog.require('app.Person');

      app.Employee = (function(_super) {
        __extends(Employee, _super);

        /**
          @param {string} name
          @constructor
          @extends {app.Person}
        */
        function Employee(name) {
          Employee.__super__.constructor.call(this, name);

        }
        return Employee;

      })(app.Person);

      })(goog);

    """
    zuckrig(source).should.equal fixedSource

  it 'should add new code block with extending', ->
    source = """
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

      goog.provide('app.Employee');

      goog.require('app.Person');

      app.Employee = (function(_super) {

        __extends(Employee, _super);

        function Employee() {
          Employee.__super__.constructor.call(this, name);
        }

        return Employee;

      })(app.Person);

    """

    fixedSource = """
      (function(goog) {
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key];
       } function ctor() { this.constructor = child;
       } ctor.prototype = parent.prototype;
       child.prototype = new ctor();
       child.__super__ = parent.prototype;
       return child;
       };

      goog.provide('app.Employee');

      goog.require('app.Person');

      app.Employee = (function(_super) {
        __extends(Employee, _super);

        /**
          @constructor
          @extends {app.Person}
        */
        function Employee() {
          Employee.__super__.constructor.call(this, name);

        }
        return Employee;

      })(app.Person);

      })(goog);

    """
    zuckrig(source).should.equal fixedSource

  it 'should add goog.require for a super class', ->
    source = """
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

      goog.provide('app.Employee');

      app.Employee = (function(_super) {

        __extends(Employee, _super);

        function Employee() {
          Employee.__super__.constructor.call(this);
        }

        return Employee;

      })(app.Person);

    """

    fixedSource = """
      (function(goog) {
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key];
       } function ctor() { this.constructor = child;
       } ctor.prototype = parent.prototype;
       child.prototype = new ctor();
       child.__super__ = parent.prototype;
       return child;
       };

      goog.provide('app.Employee');

      goog.require('app.Person');

      app.Employee = (function(_super) {
        __extends(Employee, _super);

        /**
          @constructor
          @extends {app.Person}
        */
        function Employee() {
          Employee.__super__.constructor.call(this);

        }
        return Employee;

      })(app.Person);

      })(goog);

    """
    zuckrig(source).should.equal fixedSource

  it 'should add goog.provide and goog.require for a super class', ->
    source = """
      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

      app.Employee = (function(_super) {

        __extends(Employee, _super);

        function Employee() {
          Employee.__super__.constructor.call(this);
        }

        return Employee;

      })(app.Person);

    """

    fixedSource = """
      (function(goog) {goog.provide('app.Employee');

      goog.require('app.Person');

      var __hasProp = {}.hasOwnProperty,
        __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key];
       } function ctor() { this.constructor = child;
       } ctor.prototype = parent.prototype;
       child.prototype = new ctor();
       child.__super__ = parent.prototype;
       return child;
       };

      app.Employee = (function(_super) {
        __extends(Employee, _super);

        /**
          @constructor
          @extends {app.Person}
        */
        function Employee() {
          Employee.__super__.constructor.call(this);

        }
        return Employee;

      })(app.Person);

      })(goog);

    """
    zuckrig(source).should.equal fixedSource

  it 'Should add goog.provide for a class', ->
    source = """
      app.Foo = (function() {
        function Foo() {
          var a;
          a = 2;
        }

        return Foo;

      })();
    """
    fixedSource = """
      (function(goog) {goog.provide('app.Foo');

      app.Foo = (function() {
        /**
          @constructor
        */
        function Foo() {
          var a;

          a = 2;

        }
        return Foo;

      })();

      })(goog);

    """
    zuckrig(source).should.equal fixedSource

  it 'should wrap a whole file into a closure', ->
    source = """
      goog.provide('app.Employee');

      goog.require('goog.dom');

      app.Employee = (function(_super) {

        /**
          @param {string} name
        */


        function Employee(name) {
        }

        return Employee;

      })();

    """

    fixedSource = """
      (function(goog) {
      goog.provide('app.Employee');

      goog.require('goog.dom');

      app.Employee = (function(_super) {
        /**
          @param {string} name
          @constructor
        */
        function Employee(name) {
        }
        return Employee;

      })();

      })(goog);

    """
    zuckrig(source).should.equal fixedSource

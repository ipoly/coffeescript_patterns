// Generated by CoffeeScript 1.4.0
(function() {
  var CarMaker, cherokee, corolla, solstice;

  CarMaker = (function() {

    function CarMaker() {}

    CarMaker.prototype.drive = function() {
      return "Vroom, I have " + this.doors + " doors";
    };

    CarMaker.factory = function(type) {
      var constr, error, newcar;
      constr = type;
      if (typeof CarMaker[constr] !== "function") {
        error = {
          name: "Error",
          message: "" + constr + " doesn't exist",
          toString: function() {
            return this.message;
          }
        };
        throw error;
      }
      if (typeof CarMaker[constr].prototype.drive !== "function") {
        CarMaker[constr].prototype = new CarMaker();
      }
      newcar = new CarMaker[constr]();
      return newcar;
    };

    CarMaker.Compact = function() {
      return this.doors = 4;
    };

    CarMaker.Convertible = function() {
      return this.doors = 2;
    };

    CarMaker.SUV = function() {
      return this.doors = 17;
    };

    return CarMaker;

  })();

  corolla = CarMaker.factory("Compact");

  solstice = CarMaker.factory("Convertible");

  cherokee = CarMaker.factory("SUV");

  test("异常捕获", function() {
    return throws(function() {
      return CarMaker.factory("Nobody");
    }, /doesn't exist/, "构造函数不存在");
  });

  test("生成实例", function() {
    equal(corolla.drive(), "Vroom, I have 4 doors", "Compact ok");
    equal(solstice.drive(), "Vroom, I have 2 doors", "Convertible ok");
    return equal(cherokee.drive(), "Vroom, I have 17 doors", "SUV ok");
  });

  test("所有子类都继承自父类", function() {
    ok(corolla instanceof CarMaker.Compact, "corolla 是 Compact 的实例");
    ok(corolla instanceof CarMaker, "corolla 也是 CarMaker 的实例");
    ok(solstice instanceof CarMaker.Convertible, "equal 是 Convertible 的实例");
    ok(solstice instanceof CarMaker, "equal 也是 CarMaker 的实例");
    ok(cherokee instanceof CarMaker.SUV, "cherokee 是 SUV 的实例");
    return ok(cherokee instanceof CarMaker, "cherokee 也是 CarMaker 的实例");
  });

}).call(this);
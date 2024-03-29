// Generated by CoffeeScript 1.4.0
(function() {
  var Universe1, Universe2;

  Universe1 = (function() {

    function Universe1() {
      if (typeof Universe1.instance === "object") {
        return Universe1.instance;
      }
      this.start_time = 0;
      this.bang = "Big";
      Universe1.instance = this;
    }

    return Universe1;

  })();

  test("模式1：静态属性中的实例", function() {
    var uni1, uni2;
    uni1 = new Universe1();
    uni2 = new Universe1();
    return equal(uni1, uni2, "uni1 应该等于 uni2");
  });

  Universe2 = null;

  (function() {
    var instance;
    instance = null;
    Universe2 = (function() {

      function Universe2() {
        if (instance) {
          return instance;
        }
        instance = this;
        this.start_time = 0;
        this.bang = "Big";
      }

      return Universe2;

    })();
    return null;
  })();

  test("模式2：闭包中的实例", function() {
    var uni1, uni2;
    uni1 = new Universe2();
    uni2 = new Universe2();
    window.a1 = uni1;
    window.a2 = uni2;
    equal(uni1, uni2, "uni1 应该等于 uni2");
    Universe2.prototype.nothing = true;
    uni1 = new Universe2();
    Universe2.prototype.everything = true;
    uni2 = new Universe2();
    ok(uni1.nothing, "uni1 有nothing属性");
    ok(uni1.everything, "uni1 有everything属性");
    ok(uni2.nothing, "uni2 有nothing属性");
    ok(uni2.everything, "uni2 有everything属性");
    equal(uni1.constructor.name, "Universe2", "uni1 的构造函数名为 Universe2 ");
    equal(uni2.constructor.name, "Universe2", "uni2 的构造函数名为 Universe2 ");
    equal(uni1.constructor, Universe2, "uni1 的构造函数等于 Universe2 ");
    return equal(uni2.constructor, Universe2, "uni2 的构造函数等于 Universe2 ");
  });

}).call(this);

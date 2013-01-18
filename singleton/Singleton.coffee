# Singleton

class Universe1
    constructor: ()->
        # 我们有一个现有的实例吗？
        if typeof Universe1.instance is "object"
            return Universe1.instance

        # 正常进行
        @start_time = 0
        @.bang = "Big"

        # 缓存
        Universe1.instance = @

        # 隐式返回
        # return @

# 该模式的缺点在于instance属性是公开的，有可能被覆盖掉。
test("模式1：静态属性中的实例", ->
    uni1 = new Universe1()
    uni2 = new Universe1()
    equal(uni1, uni2, "uni1 应该等于 uni2")
)


Universe2 = null
do ->
    instance = null
    class Universe2
        constructor: ->
            if instance then return instance
            instance = @

            # 所有功能
            @start_time = 0
            @bang= "Big"

    null


test("模式2：闭包中的实例", ->
    uni1 = new Universe2()
    uni2 = new Universe2()
    window.a1 = uni1
    window.a2 = uni2
    equal(uni1, uni2, "uni1 应该等于 uni2")

    # 更新原型并创建实例
    Universe2.prototype.nothing = true
    uni1 = new Universe2()
    Universe2.prototype.everything = true;
    uni2 = new Universe2()

    ok(uni1.nothing, "uni1 有nothing属性")
    ok(uni1.everything, "uni1 有everything属性")
    ok(uni2.nothing, "uni2 有nothing属性")
    ok(uni2.everything, "uni2 有everything属性")

    equal(uni1.constructor.name, "Universe2", "uni1 的构造函数名为 Universe2 ")
    equal(uni2.constructor.name, "Universe2", "uni2 的构造函数名为 Universe2 ")
    equal(uni1.constructor, Universe2, "uni1 的构造函数等于 Universe2 ")
    equal(uni2.constructor, Universe2, "uni2 的构造函数等于 Universe2 ")

)






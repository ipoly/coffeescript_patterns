# factory

class CarMaker
    drive: ->
        "Vroom, I have #{@doors} doors"
    @factory: (type)->
        constr = type

        # 如果构造函数不存在，则发生错误
        if typeof CarMaker[constr] != "function"
            error = {
                name: "Error"
                message: "#{constr} doesn't exist"
                toString: -> return @message
            }
            throw error

        # 原型继承父类
        if typeof CarMaker[constr].prototype.drive != "function"
            CarMaker[constr].prototype = new CarMaker()

        # 创建一个新的实例
        newcar = new CarMaker[constr]()

        # 进行其他处理并返回
        return newcar

    # 定义子类
    @Compact: ->
        @doors = 4

    @Convertible: ->
        @doors = 2

    @SUV: ->
        @doors = 17


corolla = CarMaker.factory("Compact")
solstice = CarMaker.factory("Convertible")
cherokee = CarMaker.factory("SUV")


test("异常捕获", ->
    throws(->
        CarMaker.factory("Nobody")
    , /doesn't exist/
    , "构造函数不存在")
)

test("生成实例",->
    equal(corolla.drive(),"Vroom, I have 4 doors", "Compact ok")
    equal(solstice.drive(),"Vroom, I have 2 doors", "Convertible ok")
    equal(cherokee.drive(),"Vroom, I have 17 doors", "SUV ok")
)

test("所有子类都继承自父类",->
    ok(corolla instanceof CarMaker.Compact, "corolla 是 Compact 的实例")
    ok(corolla instanceof CarMaker, "corolla 也是 CarMaker 的实例")

    ok(solstice instanceof CarMaker.Convertible, "equal 是 Convertible 的实例")
    ok(solstice instanceof CarMaker, "equal 也是 CarMaker 的实例")

    ok(cherokee instanceof CarMaker.SUV, "cherokee 是 SUV 的实例")
    ok(cherokee instanceof CarMaker, "cherokee 也是 CarMaker 的实例")
)





# Decorator

# 第一种实现：继承
class Sale1
    constructor: (price)->
        @price = price or 100

    getPrice: ->
        @price

    # 装饰者方法
    decorate: (decorator)->
        # 用临时构造函数继承当前对象
        F = ->
        overrides = @constructor.decorators[decorator]
        F.prototype = @
        newobj = new F()
        newobj.uber = @

        # 复制属性
        for own i of overrides
            newobj[i] = overrides[i]
        newobj

    # 装饰者对象以构造函数属性的方式实现
    @decorators: {
        # 联邦税
        fedtax: {
            getPrice: ->
                price = @uber.getPrice()
                price += price * 5 / 100
        }

        # 省级税
        quebec: {
            getPrice: ->
                price = @uber.getPrice()
                price += price * 7.5 / 100
        }

        # 格式化为美元
        money: {
            getPrice: ->
                "$" + @uber.getPrice().toFixed(2)
        }

        # 格式化为CDN形式
        cdn: {
            getPrice: ->
                "CDN$ " + @uber.getPrice().toFixed(2)
        }

    }

# 第二种实现：列表
class Sale2
    constructor: (price)->
        @price = price or 100
        @decorators_list = []

    getPrice: ->
        price  = @price
        max = @decorators_list.length
        for i in [0..max-1]
            name = @decorators_list[i]
            price = Sale2.decorators[name].getPrice(price)
        price

    # 装饰者方法
    decorate: (decorator)->
        @decorators_list.push(decorator)

    # 反装饰方法
    undecorate: (decorator)->
        @decorators_list = (i for i in @decorators_list when i != decorator)


    # 装饰者对象以构造函数属性的方式实现
    @decorators: {
        # 联邦税
        fedtax: {
            getPrice: (price)->
                price + price * 5 / 100
        }

        # 省级税
        quebec: {
            getPrice: (price)->
                price + price * 7.5 / 100
        }

        # 格式化为美元
        money: {
            getPrice: (price)->
                "$" + price.toFixed(2)
        }

        # 格式化为CDN形式
        cdn: {
            getPrice: (price)->
                "CDN$ " + price.toFixed(2)
        }
    }

# 第二种实现的扩展：支持多个装饰方法
class Sale3
    constructor: (price)->
        @price = price or 100
        @decorators_list = []

    # 辅助方法,使一个方法成为"可装饰"的
    # 该辅助方法是私有的
    # 参数传递采用"配置对象模式"
    toBeDecorated = (methodName, args) ->
        max = @decorators_list.length
        for i in [0..max-1]
            name = @decorators_list[i]
            method = Sale3.decorators[name][methodName]
            args = method.call(@, args) if typeof method is "function"
        args


    getPrice: ->
        toBeDecorated.call(@, "getPrice", @price)

    getTaxName: ->
        toBeDecorated.call(@, "getTaxName")

    # 装饰者方法
    decorate: (decorator)->
        @decorators_list.push(decorator)

    # 反装饰方法
    undecorate: (decorator)->
        @decorators_list = (i for i in @decorators_list when i != decorator)


    # 装饰者对象以构造函数属性的方式实现
    @decorators: {
        # 联邦税
        fedtax: {
            getPrice: (price)->
                price + price * 5 / 100

            getTaxName: (taxName) ->
                taxName ?= ""
                (taxName + " 联邦税").replace(/^\s+|\s+$/g,"")
        }

        # 省级税
        quebec: {
            getPrice: (price)->
                price + price * 7.5 / 100

            getTaxName: (taxName) ->
                taxName ?= ""
                (taxName + " 省级税").replace(/^\s+|\s+$/g,"")
        }

        # 格式化为美元
        money: {
            getPrice: (price)->
                "$" + price.toFixed(2)
        }

        # 格式化为CDN形式
        cdn: {
            getPrice: (price)->
                "CDN$ " + price.toFixed(2)
        }

    }


####################################

test("第一种实现：继承", ->
    sale = new Sale1(100)
    # 增加联邦税
    sale = sale.decorate("fedtax")
    # 增加省级税
    sale = sale.decorate("quebec")
    # 格式化为美元
    sale = sale.decorate("money")
    equal(sale.getPrice(), "$112.88", "客户在加拿大魁北克:价格生成正确")

    sale = new Sale1(100)
    # 增加联邦税
    sale = sale.decorate("fedtax")
    # 格式化为CDN形式
    sale = sale.decorate("cdn")
    equal(sale.getPrice(), "CDN$ 105.00", "客户在没有省税的省份:价格生成正确")
)


test("第二种实现：列表", ->
    sale = new Sale2(100)
    # 增加联邦税
    sale.decorate("fedtax")
    # 增加省级税
    sale.decorate("quebec")
    # 格式化为美元
    sale.decorate("money")
    equal(sale.getPrice(), "$112.88", "客户在加拿大魁北克:价格生成正确")

    sale = new Sale2(100)
    # 增加联邦税
    sale.decorate("fedtax")
    # 格式化为CDN形式
    sale.decorate("cdn")
    equal(sale.getPrice(), "CDN$ 105.00", "客户在没有省税的省份:价格生成正确")

    sale.undecorate("cdn")
    equal(sale.getPrice(), "105.00", "反装饰：取消CDN的格式化")
    sale.decorate("money")
    equal(sale.getPrice(), "$105.00", "重新用美元格式化")
)

test("第二种实现扩展：支持多个装饰方法", ->
    sale = new Sale3(100)
    # 增加联邦税
    sale.decorate("fedtax")
    # 增加省级税
    sale.decorate("quebec")
    # 格式化为CDN形式
    sale.decorate("cdn")
    equal(sale.getPrice(), "CDN$ 112.88", "客户在没有省税的省份:价格生成正确")
    equal(sale.getTaxName(), "联邦税 省级税", "正确的税种")

)









# Observer
class Publisher
    publisher = {
        # 订阅者列表
        subscribers: {
            any: []
        }

        subscribe: (fn, type)->
            type = type || "any"
            if typeof @subscribers[type] == "undefined"
                @subscribers[type] = []
            @subscribers[type].push(fn)

        unsubscribe: (fn, type)->
            @visitSubscribers("unsubscribe", fn, type)

        publish: (publication, type)->
            @visitSubscribers("publish", publication, type)

        visitSubscribers: (action, arg, type)->
            pubtype = type || "any"
            subscribers = @subscribers[pubtype]
            max = subscribers.length
            for i in [0..--max]
                if action is "publish"
                    subscribers[i](arg)
                else
                    if subscribers[i] is arg
                        subscribers.splice(i, 1)
    }

    constructor: (o)->
        for own i of publisher
            if typeof publisher[i] is "function"
                o[i] = publisher[i]
        o.subscribers = {any:[]}
        return o


########################################################


test("订阅测试", ->
    log = ""

    # 发布者
    paper = {
        daily: ->
            @publish("big news today")
        monthly: ->
            @publish("interesting analysis", "monthly")
    }

    # 订阅者
    joe = {
        drinkCoffee: (paper)->
            log = "Just read #{paper}"
        sundayPreNap: (monthly)->
            log = "About to fall asleep reading this #{monthly}"
    }

    # 构造成发布者
    new Publisher(paper);
    ok(typeof paper.subscribe is "function" && typeof paper.unsubscribe is "function", "转换一个对象成为发布者")

    paper.subscribe(joe.drinkCoffee)
    paper.subscribe(joe.sundayPreNap, "monthly")

    paper.daily()
    equal(log, "Just read big news today", "joe 订阅成功")
    paper.daily()
    equal(log, "Just read big news today", "joe 订阅成功")
    paper.daily()
    equal(log, "Just read big news today", "joe 订阅成功")
    paper.monthly()
    equal(log, "About to fall asleep reading this interesting analysis", "joe 订阅成功")
)
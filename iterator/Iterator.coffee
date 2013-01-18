# Iterator

class window.Iterator
    constructor: (num)->
        error = {
            name: "error"
            message: "实例化需要一个整数"
            toString: -> "#{@name} :#{@message}"
        }

        num = parseInt(num)

        if not num then throw error

        index = 0
        data = ("object#{n}" for i,n in new Array(num))
        length = data.length

        # 返回数据长度
        @total = ->
            length

        # 返回当前元素
        @current = ->
            data[index]

        # 检查是否有下一项
        @hasNext = ->
            index < length

        # 返回下一项
        @next = ->
            if @hasNext()
                data[++index]
            else
                null

        # 重设指针
        @rewind = ->
            index = 0

agg = 0

test("初始化迭代器", ->

    throws(->
        agg = new Iterator("text")
    , /error/
    , "不以整数实例化时报错")

    agg = new Iterator(5)
    equal(agg.total(), 5, "生成有5个元素的迭代器")
)

test("迭代器操作",->
    agg = new Iterator(5)

    equal(typeof agg.hasNext, "function", "拥有hasNext方法")
    equal(typeof agg.next, "function", "拥有next方法")
    equal(typeof agg.rewind, "function", "拥有rewind方法")

    equal(agg.current(), "object0", "第1个元素为'object0'")
    equal(agg.next(), "object1", "返回到第2个元素")
    equal(agg.next(), "object2", "返回到第3个元素")
    equal(agg.next(), "object3", "返回到第4个元素")
    equal(agg.next(), "object4", "返回到第5个元素")
    equal(agg.next(), null, "最后返回null，迭代完成")

    agg.rewind()
    equal(agg.current(), "object0", "rewind() 工作正常")
)






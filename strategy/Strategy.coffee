# Strategy

validator = {
    # 所有可用的检查
    types: {}

    # 错误消息
    msg: []

    # 策略配置
    config: {}

    # 接口方法
    validate: (data)->
        # 重置所有消息
        @msg = []

        for own i of data
            type = @config[i]
            checker = @types[type]

            continue if !type

            if !checker
                throw {
                    name: "ValidationError"
                    message: "No handler to validate type: #{type}"
                    toString: -> @message
                }

            result_ok = checker.validate(data[i])

            if !result_ok
                msg = "Invalid value for *#{i}*"
                @msg.push(msg)

        return @hasErrors()

    # 帮助方法
    hasErrors: ->
        return @msg.length != 0

}

# 添加验证方法
validator.types = {
    isNonEmpty: {
        validate: (value)->
            value != ""
    }

    isNumber: {
        validate: (value)->
            if value is ""
                return true
            else
                return !isNaN(parseInt(value))
    }

    isAlphaNum: {
        validate: (value)->
            !/[^a-z0-9]/i.test(value)
    }
}



test("验证策略测试", ->
    # 策略配置
    validator.config = {
        first_name: "xxxx"
    }

    data = {first_name: "Super"}

    throws(->
        validator.validate(data)
    , /No handler to validate type: xxxx/
    , "没有验证方法存在时报错")
)


test("验证方法测试", ->

    # 策略配置
    validator.config = {
        first_name: "isNonEmpty"
        age: "isNumber"
        username: "isAlphaNum"
    }

    data = {first_name: "Super"}
    validator.validate(data)
    ok(!validator.hasErrors(), "first_name 不为空则正确")

    data = {first_name: ""}
    validator.validate(data)

    ok(validator.hasErrors(), "first_name 为空则报错")
    equal(validator.msg[0], "Invalid value for *first_name*", "first_name 报错信息正确")


    data = {age: ""}
    validator.validate(data)
    ok(!validator.hasErrors(), "age 可以为空")

    data = {age: "10n"}
    validator.validate(data)
    ok(!validator.hasErrors(), "age 可以转化为数字")

    data = {age: "twenty"}
    validator.validate(data)
    ok(validator.hasErrors(), "age 非数字报错")
    equal(validator.msg[0], "Invalid value for *age*", "age 报错信息正确")
)
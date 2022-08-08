1 触发器
    触发器是一种特殊类型的存储过程,他不同于我们前面介绍过的存储过程.
    触发器主要是通过事件进行触发而被执行的,
    而存储过程可以通过存储存储过程名字而被直接调用

    触发器: trigger,是一种非常接近于js中的事件的知识.提前给某张表的所有记录(行)
    绑定一行代码,如果改行的操作满足条件(触发),这段提前准备好的代码就会自动执行.

2 作用
    (1) 可以再写入数据表前,强制校验或者转换数据. (保证数据安全)
    (2) 触发器发生错误时,异动的结果会被撤销. (如果触发器执行错误,那么前用户执行成功的操作也会被撤销,事务安全)
    (3) 部分数据库管理系统可以针对数据定义语言(DDL)使用触发器,成为DDL触发器.()
    (4) 可依照特定的情况,替换异动的指令(instead of). (MySQL不支持)

3 触发器优缺点
    优点:
        (1) 触发器可以通过数据库中的相关表现实现级联更改(如果某张表的数据发生改变,可以利用触发器
            来实现其他表的无痕操作[用户不知道])
        (2) 保证数据安全,进行安全校验

    缺点:
        (1) 对触发器过分的依赖,势必影响数据库的结构,同时增加了维护的复杂程度
        (2) 造成数据在程序层面不可控.(PHP层)
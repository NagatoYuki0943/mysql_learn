1 表与表之间(实体)有什么样的关系,每种关系应该如何设计

2 一对一
    一张表中的一条记录与另外一张表中最多有一条明确的关系
    通常此设计方案保证两张表中使用同样的主键即可

    学生表
    学生id(pri)     姓名    年龄    性别        籍贯    婚否    住址

    使用过程中,常用的信息会经常查询,不常用信息会偶尔使用.
    解决方案:将一张表拆分成两张表,常见的放一张表,不常见的放另一张表

    学生id在两张表中是一致的
    常用表
    学生id(pri)     姓名    年龄    性别

    不常用表
    学生id(pri)     籍贯    婚否    住址
1 流程结构:代码的执行顺序

2 if 基本语法
    if在MySQL中有两种基本用法
    (1) 用在select 查询当中,当做条件进行判断
        语法 if(条件,为真结果,为假结果) as 别名
            select *,if(age>15,'符合','不符合') as judge
            测试
            select *,if(age>15,'符合','不符合') as judge from mb_students1;
            +----+----------+--------+-----+-------+-------+-------+
            | id | name     | sex    | age | class | score | judge |
            +----+----------+--------+-----+-------+-------+-------+
            |  2 | 钱二     | female |  16 |     2 |    55 | 符合  |
            |  3 | 孙三     | male   |  16 |     2 |    88 | 符合  |
            |  6 | 吴六     | male   |  16 |     1 |    75 | 符合  |
            |  7 | 郑七     | female |  16 |     1 |    87 | 符合  |
            |  8 | 王八     | male   |  16 |     3 |    88 | 符合  |
            | 11 | 褚十一   | female |  16 |     3 |    85 | 符合  |
            | 12 | 卫十二   | male   |  17 |     4 |    85 | 符合  |
            | 14 | 沈十四   | male   |  16 |     4 |    11 | 符合  |
            | 16 | 杨十六   | male   |  17 |     5 |    94 | 符合  |
            | 17 | 朱十七   | female |  19 |     5 |    60 | 符合  |
            | 18 | 秦十八   | male   |  17 |     4 |    11 | 符合  |
            | 20 | 许二十   | male   |  17 |     6 |    44 | 符合  |
            | 21 | 何二十一 | male   |  16 |     3 |    58 | 符合  |
            | 24 | 张二十四 | female |  18 |     6 |    88 | 符合  |
            +----+----------+--------+-----+-------+-------+-------+

            select *,if(age>15,'符合','不符合') as judge from mb_students1 ;
            +----+----------+---------+-----+-------+-------+--------+
            | id | name     | sex     | age | class | score | judge  |
            +----+----------+---------+-----+-------+-------+--------+
            |  1 | 赵一     | male    |  15 |     1 |    58 | 不符合 |
            |  2 | 钱二     | female  |  16 |     2 |    55 | 符合   |
            |  3 | 孙三     | male    |  16 |     2 |    88 | 符合   |
            | 88 | 李四     | male    |  11 |     1 |   100 | 不符合 |
            |  5 | 周五     | female  |  15 |     2 |    88 | 不符合 |
            |  6 | 吴六     | male    |  16 |     1 |    75 | 符合   |
            |  7 | 郑七     | female  |  16 |     1 |    87 | 符合   |
            |  8 | 王八     | male    |  16 |     3 |    88 | 符合   |
            |  9 | 冯九     | male    |  14 |     3 |    45 | 不符合 |
            | 10 | 陈十     | female  |  14 |     4 |    85 | 不符合 |
            | 11 | 褚十一   | female  |  16 |     3 |    85 | 符合   |
            | 12 | 卫十二   | male    |  17 |     4 |    85 | 符合   |
            | 13 | 蒋十三   | female  |  13 |     5 |    33 | 不符合 |
            | 14 | 沈十四   | male    |  16 |     4 |    11 | 符合   |
            | 15 | 韩十五   | female  |  14 |     3 |    49 | 不符合 |
            | 16 | 杨十六   | male    |  17 |     5 |    94 | 符合   |
            | 17 | 朱十七   | female  |  19 |     5 |    60 | 符合   |
            | 18 | 秦十八   | male    |  17 |     4 |    11 | 符合   |
            | 19 | 尤十九   | female  |  11 |     5 | NULL  | 不符合 |
            | 20 | 许二十   | male    |  17 |     6 |    44 | 符合   |
            | 21 | 何二十一 | male    |  16 |     3 |    58 | 符合   |
            | 22 | 吕二十二 | female  |  15 |     6 |    59 | 不符合 |
            | 23 | 施二十三 | male    |  14 |     5 |    86 | 不符合 |
            | 24 | 张二十四 | female  |  18 |     6 |    88 | 符合   |
            | 25 | 孔二十五 | male    |  14 |     6 |    80 | 不符合 |
            | 26 | 曹二十六 | female  |  15 |     5 |    55 | 不符合 |
            +----+----------+---------+-----+-------+-------+--------+

    (2) 用在复杂的语句块中(函数/存储过程/触发器)
        基本语法
        if 条件表达式 then      //条件表达式 没有()
            满足条件要执行的语句
        end if;                 //后面有 ;

        符合语法:代码的判断存在两面性,两面都执行
        基本语法:
        if 条件表达式 then
            满足条件要执行的语句
        else
            不满足条件要执行的语句

            //如果还有其他分支,可以在里面再使用 if,else
            if 条件表达式 then
                满足条件要执行的语句
            else
                不满足条件要执行的语句
            end if;

        end if;

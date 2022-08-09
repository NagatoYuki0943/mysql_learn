1 算数运算符
    + - * / %
    基本运算符,进行结果运算 (select字段中)

        测试
        create table mb_ysf1(
            int_1 int,
            int_2 int,
            int_3 int,
            int_4 int
        )charset utf8;
        insert into mb_ysf1 values(100,-100,0,default);

        +-------+-------+-------+-------+
        | int_1 | int_2 | int_3 | int_4 |
        +-------+-------+-------+-------+
        |   100 |  -100 |     0 | NULL  |
        +-------+-------+-------+-------+

            //算数运算
            select int_1 + int_2,int_1 - int_2,int_1 * int_2,int_1 / int_2,
            int_2 / int_3,int_2 % 6,int_4 % 4 from mb_ysf1;
            +---------------+---------------+---------------+---------------+---------------+-----------+-----------+
            | int_1 + int_2 | int_1 - int_2 | int_1 * int_2 | int_1 / int_2 | int_2 / int_3 | int_2 % 6 | int_4 % 4 |
            +---------------+---------------+---------------+---------------+---------------+-----------+-----------+
            |             0 |           200 |        -10000 | -1.0000       | NULL          |        -4 | NULL      |
            +---------------+---------------+---------------+---------------+---------------+-----------+-----------+
                                                            整数相除变为浮点数  除以0为null               null进行运算
                                                            MySQL中除法结果是浮点数                         结果为null

2 比较运算符
    >  >=  <   <=  =   <>
    用来在条件中进行限定结果
    (1) = MySQL中没有 == 比较,使用 = 进行相等判断  <=> 也是相等比较
        <> 不等于,相当于 !=

        测试
        mysql> select * from mb_students1 where age>=15;
        +----+----------+--------+-----+-------+-------+
        | id | name     | sex    | age | class | score |
        +----+----------+--------+-----+-------+-------+
        |  1 | 赵一     | male   |  15 |     1 |    58 |
        |  2 | 钱二     | female |  16 |     2 |    55 |
        |  3 | 孙三     | male   |  16 |     2 |    88 |
        +----+----------+--------+-----+-------+-------+

    (2) 特殊应用,在字段结果中进行判断
        注意在字段中使用 = 会变成真正的赋值符号,要用 <=>
        mysql中没有规定select必须有数据表
        select '1' <=> 1,0.02 <=> 0,0.02 <> 0;
        +-----------+------------+-----------+
        | '1' <=> 1 | 0.02 <=> 0 | 0.02 <> 0 |
        +-----------+------------+-----------+
        |         1 |          0 |         1 |
        +-----------+------------+-----------+
        在MySQL中,数据先会自动转换成相同类型,在比较
        在MySQL中,没有bool值,1为真,0为假

    (3) 在条件判断的时候,还有有对应的比较运算符,计算区间
        between 条件1 and 条件2
        not between and
        是闭区间查找,包括两端,
        条件1必须小于条件2,反过来不可以

            select * from mb_students1 where score between 60 and 100;
            +----+----------+--------+-----+-------+-------+
            | id | name     | sex    | age | class | score |
            +----+----------+--------+-----+-------+-------+
            |  3 | 孙三     | male   |  16 |     2 |    88 |
            |  4 | 李四     | male   |  11 |     1 |   100 |
            |  5 | 周五     | female |  15 |     2 |    88 |
            +----+----------+--------+-----+-------+-------+

3 逻辑运算符
    and   &&  与
    or    ||  或
    not    !  非

        测试
        select * from mb_students1 where score >= 60 and score <= 100; //和between 60 and 100一样
        +----+----------+--------+-----+-------+-------+
        | id | name     | sex    | age | class | score |
        +----+----------+--------+-----+-------+-------+
        |  3 | 孙三     | male   |  16 |     2 |    88 |
        |  4 | 李四     | male   |  11 |     1 |   100 |
        |  5 | 周五     | female |  15 |     2 |    88 |
        +----+----------+--------+-----+-------+-------+

        select * from mb_students1 where score < 40 or score > 80;
        +----+----------+---------+-----+-------+-------+
        | id | name     | sex     | age | class | score |
        +----+----------+---------+-----+-------+-------+
        |  3 | 孙三     | male    |  16 |     2 |    88 |
        | 16 | 杨十六   | male    |  17 |     5 |    94 |
        | 18 | 秦十八   | male    |  17 |     4 |    11 |
        | 19 | 尤十九   | female  |  11 |     5 |     0 |
        +----+----------+---------+-----+-------+-------+

4 in
    在什么什么里面,替代=,当结果不是一个值,而是一个结果集的时候
        语法:in(结果1,结果2...)

        select * from mb_students1 where class in (1,2);
        +----+------+--------+-----+-------+-------+
        | id | name | sex    | age | class | score |
        +----+------+--------+-----+-------+-------+
        |  1 | 赵一 | male   |  15 |     1 |    58 |
        |  2 | 钱二 | female |  16 |     2 |    55 |
        |  3 | 孙三 | male   |  16 |     2 |    88 |
        |  7 | 郑七 | female |  16 |     1 |    87 |
        +----+------+--------+-----+-------+-------+


5 is / is not
    is是专门判断结果是否为null的运算符
    语法: is null / is not null

        select * from mb_students2 where score is null;
        +----+--------+---------+-----+-------+-------+
        | id | name   | sex     | age | class | score |
        +----+--------+---------+-----+-------+-------+
        | 19 | 尤十九 | female  |  11 |     5 | NULL  |
        +----+--------+---------+-----+-------+-------+

6 like
    用来进行模糊匹配
    语法: like 匹配模式
    匹配模式中有两种占位符 _ 对应位置单个字符 % 匹配多个字符

        select * from mb_students1 where name like '李%';
        +----+------+------+-----+-------+-------+
        | id | name | sex  | age | class | score |
        +----+------+------+-----+-------+-------+
        |  4 | 李四 | male |  11 |     1 |   100 |
        +----+------+------+-----+-------+-------+
1 交叉连接
    将两张表的数据与另外一张表彼此交叉

2 原理
    (1) 从第一张表依次取出每一条记录
    (2) 取出一条记录之后与另外一张表的全部记录挨个匹配
    (3) 没有任何匹配调教,所有结果进行保留
    (4) 记录数 = 第一张表记录数 * 第二张表记录数 ;
        字段数 = 第一张表字段是 + 第二张表字段数(笛卡尔积)

3 语法
    表1 cross join 表2;

    select * from mb_students1 cross join mb_int1;
    select * from mb_students1,mb_int1; 和上一行相同
    +----+----------+---------+-----+-------+-------+----+-------+
    | id | name     | sex     | age | class | score | id | int_1 |
    +----+----------+---------+-----+-------+-------+----+-------+
    |  1 | 赵一     | male    |  15 |     1 |    58 |  1 |     1 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  2 |     2 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  3 |     4 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  4 |    55 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  5 |    51 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  6 |     3 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  7 |     3 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  8 |     5 |
    |  1 | 赵一     | male    |  15 |     1 |    58 |  9 |     8 |
    |  1 | 赵一     | male    |  15 |     1 |    58 | 10 |     0 |
    |  2 | 钱二     | female  |  16 |     2 |    55 |  1 |     1 |
    |  2 | 钱二     | female  |  16 |     2 |    55 |  2 |     2 |
    |  2 | 钱二     | female  |  16 |     2 |    55 |  3 |     4 |
    |  2 | 钱二     | female  |  16 |     2 |    55 |  4 |    55 |
    *
    *
    *
    +----+----------+---------+-----+-------+-------+----+-------+
    260 rows in set (0.52 sec)
    26*10=260

4 应用
    交叉连接产生的结果是笛卡尔积,没有实际应用

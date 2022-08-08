1 内连接
    inner join,从一张表中取出所有的记录去另外一张表中匹配
    利用匹配条件进行匹配,成功则保留,否则丢弃

2 原理
    (1) 从第一张表中取出一条记录,然后去另外一张表中进行匹配
    (2) 利用匹配条件进行匹配
        (2.1) 匹配到,保留,继续向下匹配
        (2.2) 匹配失败,相机继续,如果全表匹配失败,结束

3 语法
    (1) 表1 [inner] join 表2 on 匹配条件
        匹配条件通常是 =
        隐式写法:
        表1,表2 where 条件
    (2) 如果没有条件,结果是笛卡尔积
    (3) 因为表的设计通常容易产生同名字段,尤其是ID,所以为了避免出现同名错误,通常使用 表名.字段名 来确保唯一性
    (4) 如果条件中使用到表名,一般使用表别名使用简化 s1.id , s1.*
    (5) 内连接匹配的时候,必须匹配到才会保存
    (6) 内连接因为不强制使用匹配条件,因此可以再数据匹配完成后使用where来限制,和on一样(建议使用on,更节省资源)

        测试:
        select * from mb_students1 as s1 inner join mb_students2  as s2 on s1.id=s2.id;
        select * from mb_students1 s1,mb_students2 s2 where s1.id=s2.id; //隐式写法,和上面一行结果相同
        +----+--------+---------+-----+-------+-------+----+--------+---------+-----+-------+-------+
        | id | name   | sex     | age | class | score | id | name   | sex     | age | class | score |
        +----+--------+---------+-----+-------+-------+----+--------+---------+-----+-------+-------+
        |  1 | 赵一   | male    |  15 |     1 |    58 |  1 | 赵一   | male    |  15 |     1 |    58 |
        |  2 | 钱二   | female  |  16 |     2 |    55 |  2 | 钱二   | female  |  16 |     2 |    55 |
        |  3 | 孙三   | male    |  16 |     2 |    88 |  3 | 孙三   | male    |  16 |     2 |    88 |
        |  4 | 李四   | male    |  11 |     1 |   100 |  4 | 李四   | male    |  11 |     1 |   100 |
        |  5 | 周五   | female  |  15 |     2 |    88 |  5 | 周五   | female  |  15 |     2 |    88 |
        |  6 | 吴六   | male    |  16 |     1 |    75 |  6 | 吴六   | male    |  16 |     1 |    75 |
        |  7 | 郑七   | female  |  16 |     1 |    87 |  7 | 郑七   | female  |  16 |     1 |    87 |
        |  8 | 王八   | male    |  16 |     3 |    88 |  8 | 王八   | male    |  16 |     3 |    88 |
        |  9 | 冯九   | male    |  14 |     3 |    45 |  9 | 冯九   | male    |  14 |     3 |    45 |
        | 10 | 陈十   | female  |  14 |     4 |    85 | 10 | 陈十   | female  |  14 |     4 |    85 |
        | 11 | 褚十一 | female  |  16 |     3 |    85 | 11 | 褚十一 | female  |  16 |     3 |    85 |
        | 12 | 卫十二 | male    |  17 |     4 |    85 | 12 | 卫十二 | male    |  17 |     4 |    85 |
        | 13 | 蒋十三 | female  |  13 |     5 |    33 | 13 | 蒋十三 | female  |  13 |     5 |    33 |
        | 14 | 沈十四 | male    |  16 |     4 |    11 | 14 | 沈十四 | male    |  16 |     4 |    11 |
        | 15 | 韩十五 | female  |  14 |     3 |    49 | 15 | 韩十五 | female  |  14 |     3 |    49 |
        | 16 | 杨十六 | male    |  17 |     5 |    94 | 16 | 杨十六 | male    |  17 |     5 |    94 |
        | 17 | 朱十七 | female  |  19 |     5 |    60 | 17 | 朱十七 | female  |  19 |     5 |    60 |
        | 18 | 秦十八 | male    |  17 |     4 |    11 | 18 | 秦十八 | male    |  17 |     4 |    11 |
        | 19 | 尤十九 | female  |  11 |     5 | NULL  | 19 | 尤十九 | female  |  11 |     5 |     0 |
        +----+--------+---------+-----+-------+-------+----+--------+---------+-----+-------+-------+

        select s1.id,s1.name,s2.id,s2.name from mb_students1 as s1 inner join mb_students2  as s2 on s1.id=s2.id;
        select s1.id,s1.name,s2.id,s2.name from mb_students1 s1,mb_students2 s2 where s1.id=s2.id; //隐式写法,和上面一行结果相同
        +----+--------+----+--------+
        | id | name   | id | name   |
        +----+--------+----+--------+
        |  1 | 赵一   |  1 | 赵一   |
        |  2 | 钱二   |  2 | 钱二   |
        |  3 | 孙三   |  3 | 孙三   |
        |  4 | 李四   |  4 | 李四   |
        |  5 | 周五   |  5 | 周五   |
        |  6 | 吴六   |  6 | 吴六   |
        |  7 | 郑七   |  7 | 郑七   |
        |  8 | 王八   |  8 | 王八   |
        |  9 | 冯九   |  9 | 冯九   |
        | 10 | 陈十   | 10 | 陈十   |
        | 11 | 褚十一 | 11 | 褚十一 |
        | 12 | 卫十二 | 12 | 卫十二 |
        | 13 | 蒋十三 | 13 | 蒋十三 |
        | 14 | 沈十四 | 14 | 沈十四 |
        | 15 | 韩十五 | 15 | 韩十五 |
        | 16 | 杨十六 | 16 | 杨十六 |
        | 17 | 朱十七 | 17 | 朱十七 |
        | 18 | 秦十八 | 18 | 秦十八 |
        | 19 | 尤十九 | 19 | 尤十九 |
        +----+--------+----+--------+

4 应用
    通常是在对数据有精确要求的地方使用,两张表必须进行数据匹配


5 选择每个班的最高分
    select class,max(score) score from mb_students1 group by class;


6 查询班级中分数最高的女生数据
    select s1.* from mb_students1 s1 inner join
    (select class,max(score) as score from mb_students1 where sex="female" group by class) s2   //选择每个班级中女生分数最高的 class, score
    on s1.class=s2.class and s1.score=s2.score                                                  //用原表和结果进行inner join
    where sex="female"                                                                          //再次判断女生,防止一个班中男生和女生同分数
    order by s1.class;

    +-----+------------+--------+-----+-------+-------+-------------+-------------+-------------+
    | id  | name       | sex    | age | class | score | create_time | update_time | delete_time |
    +-----+------------+--------+-----+-------+-------+-------------+-------------+-------------+
    |   7 | 郑七       | female |  16 |     1 |   100 | NULL        | NULL        | NULL        |
    | 110 | 矢泽妮可   | female |  16 |     1 |   100 | NULL        | NULL        | NULL        |
    |   5 | 周五       | female |  15 |     2 |    90 | NULL        | NULL        | NULL        |
    | 100 | 黑果       | female |  15 |     3 |   101 | NULL        | NULL        | NULL        |
    |  10 | 陈十       | female |  14 |     4 |    96 | NULL        | NULL        | NULL        |
    | 113 | 高板奈利   | female |  15 |     5 |   500 | NULL        | NULL        | NULL        |
    | 108 | 黄前久美子 | female |  15 |     6 |    89 | NULL        | NULL        | NULL        |
    | 114 | 静凛       | female |  17 |     7 |   521 | NULL        | NULL        | NULL        |
    | 116 | 猫宫日向   | female |  17 |     8 |   526 | NULL        | NULL        | NULL        |
    +-----+------------+--------+-----+-------+-------+-------------+-------------+-------------+

    找每个班女生中最高分
    select class,max(score) as score from mb_students1 where sex="female" group by class;
    +-------+-------+
    | class | score |
    +-------+-------+
    |     2 |    90 |
    |     1 |   100 |
    |     4 |    96 |
    |     3 |   101 |
    |     5 |   500 |
    |     6 |    89 |
    |     7 |   521 |
    |     8 |   526 |
    +-------+-------+

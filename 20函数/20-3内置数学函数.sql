1 abs() 绝对值


2 ceiling() 向上取整


3 floor()   向下取整


4 round()   四舍五入函数


5 pow(m, n) 求指数,m的n  次方


6 mod(x, y)  返回x/y的余数


7 rand()    获取随机数,1~100

    select abs(-1),ceiling(5.1),floor(5.9),round(4.5),round(4.4),pow(2,3),mod(10, 3),rand();
    +---------+--------------+------------+------------+------------+----------+------------+--------------------+
    | abs(-1) | ceiling(5.1) | floor(5.9) | round(4.5) | round(4.4) | pow(2,3) | mod(10, 3) | rand()             |
    +---------+--------------+------------+------------+------------+----------+------------+--------------------+
    |       1 |            6 |          5 | 5          | 4          |        8 |          1 | 0.6739299396741483 |
    +---------+--------------+------------+------------+------------+----------+------------+--------------------+


    select lpad(round(rand()*1000000 , 0), 6, '0')
    +-----------------------------------------+
    | lpad(round(rand()*1000000 , 0), 6, '0') |
    +-----------------------------------------+
    | 330363                                  |
    +-----------------------------------------+

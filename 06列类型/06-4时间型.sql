时间日期类型
1 date
    日期 使用3个字节存储数据 YYYY-mm-dd  1000-01-01 ~ 9999-12-31
    初始值0000-00-00
2 time
    时间 能够表示某个时间,3个字节 HH:ii:ss 但是MySQL中time能够表示时间范围大得多
    -838:59:58 ~ 838:59:58  在MySQL中具体用处是表示时间段

3 datetime
    将日期时间格式合并表示时间  使用8个字节  YYYY-mm-dd HH:ii:ss
    区间 1000-01-01 00:00:00 ~ 9999-12-31 23:59:59
    初始值 0000-00-00 00:00:00

4 timestamp
    时间戳:MySQL中的时间戳只是表示从格林威治时间开始,但格式依然是 YYYY-mm-dd HH:ii:ss
    alter table mb_date modify d4 timestamp not null default current_timestamp on update current_timestamp;
    数据被修改时,时间戳会自动更新

5 year
    年类型,一个字节,只能表示1900 ~ 2155年,但是year有两种数据插入方式 0~99 四位数
    两位数 有一个区间划分 临界点是69和70 当输入69以下,系统匹配20+数字;70及以上,19+数字


6 创建时间类型数据表
    create table mb_date(
        d1 date,
        d2 time,
        d3 datetime,
        d4 timestamp not null default current_timestamp on update current_timestamp,
        d5 year
    )charset utf8;

    desc mb_date;
    +-------+-----------+------+-----+---------+-------+
    | Field | Type      | Null | Key | Default | Extra |
    +-------+-----------+------+-----+---------+-------+
    | d1    | date      | YES  |     | NULL    |       |
    | d2    | time      | YES  |     | NULL    |       |
    | d3    | datetime  | YES  |     | NULL    |       |
    | d4    | timestamp | YES  |     | NULL    |       |
    | d5    | year(4)   | YES  |     | NULL    |       |
    +-------+-----------+------+-----+---------+-------+
7 插入数据
    insert into mb_date values(
        '1900-01-01','14:14:14','1900-01-01 14:14:14','1999-01-01 14:14:14',69
    );

    select * from mb_date;
    +------------+----------+---------------------+---------------------+------+
    | d1         | d2       | d3                  | d4                  | d5   |
    +------------+----------+---------------------+---------------------+------+
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 2069 |
    +------------+----------+---------------------+---------------------+------+
    两位数 有一个区间划分 临界点是69和70 当输入69以下,系统匹配20+数字;70及以上,19+数字

    insert into mb_date values(
        '1900-01-01','14:14:14','1900-01-01 14:14:14','1999-01-01 14:14:14',2015
    );

    +------------+----------+---------------------+---------------------+------+
    | d1         | d2       | d3                  | d4                  | d5   |
    +------------+----------+---------------------+---------------------+------+
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 2069 |
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 2015 |
    +------------+----------+---------------------+---------------------+------+

    insert into mb_date values(
        '1900-01-01','14:14:14','1900-01-01 14:14:14','1999-01-01 14:14:14',70
    );

    +------------+----------+---------------------+---------------------+------+
    | d1         | d2       | d3                  | d4                  | d5   |
    +------------+----------+---------------------+---------------------+------+
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 2069 |
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 2015 |
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 1970 |
    +------------+----------+---------------------+---------------------+------+

8 数据被修改时,时间戳会自动更新
    update mb_date set d1='2000-01-01' where d5=2069;
    +------------+----------+---------------------+---------------------+------+
    | d1         | d2       | d3                  | d4                  | d5   |
    +------------+----------+---------------------+---------------------+------+
    | 2000-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 2020-09-29 19:55:19 | 2069 |  d4更改了
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 2015 |
    | 1900-01-01 | 14:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 1970 |
    +------------+----------+---------------------+---------------------+------+

9 time 本质上表示时间段,能表示的范围比较大
    insert into mb_date values(
        '1900-01-01','110:14:14','1900-01-01 14:14:14','1999-01-01 14:14:14',70
    );

    +------------+-----------+---------------------+---------------------+------+
    | d1         | d2        | d3                  | d4                  | d5   |
    +------------+-----------+---------------------+---------------------+------+
    | 2000-01-01 | 14:14:14  | 1900-01-01 14:14:14 | 2020-09-29 19:55:19 | 2069 |
    | 1900-01-01 | 14:14:14  | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 2015 |
    | 1900-01-01 | 14:14:14  | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 1970 |
    | 1900-01-01 | 110:14:14 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 1970 |
    +------------+-----------+---------------------+---------------------+------+
                    时间很大

   在进行时间录入的时候,可以使用简单的一个日期代替时间,
   在时间格式之前加一个空格 指定一个数字,系统会自动将该数字转换成天数*24小时,再加上后面的时间
    数字可以使负数
    insert into mb_date values(
        '1900-01-01','5 12:12:13','1900-01-01 14:14:14','1999-01-01 14:14:14',70
    );

    | 1900-01-01 | 132:12:13 | 1900-01-01 14:14:14 | 1999-01-01 14:14:14 | 1970 |
                 5*24+12=132

    PHP中有着非常强大的时间转换函数啊:
        date将时间戳转换成想要的时间格式,
        strtotime又可以将很多格式转换成对应的时间戳.
        所以php通常不需要数据库来帮助处理这么复杂的时间戳
        配合php,时间保存使用真正的时间戳,使用整形来保存

1 存储过程也允许提供参数(形参和实参),存储的参数也和参数一样,需要制定其类型
    但是存储过程中对参数还有额外的要求,自己的参数分类

2 in
    表示参数从外部传入到里面使用(过程内部使用),可以是直接数据也可以是保存数据的变量

3 out
    表示参数是从过程里面把数据保存到变量中,交给外部使用,传入的必须是变量
    如果说传入的out变量本身在外部有数据,那么在进入过程之后,第一件事就是被清空,设为null

4 inout
    数据可以从外部传入到过程内部使用,同时内部操作只有,又会将数据返回到外部

5 参数使用级别语法(形参)
    过程类型 变量名 数据类型;
    in int_1 int

        测试 创建三个外部变量
            set @n1 = 1;
            set @n2 = 2;
            set @n3 = 3;
        创建过程
            delimiter $$    //这一行单独执行

            create procedure mb_pro3(in int_1 int,out int_2 int,inout int_3 int)
            begin
                -- 查看三个传入的数据的值
                select int_1,int_2,int_3;

                -- 修改3个变量的值
                set int_1 = 10;
                set int_2 = 20;
                set int_3 = 30;
                select int_1,int_2,int_3;

                -- 查看会话变量
                select @n1,@n2,@n3;

                -- 修改会话变量
                set @n1 = 'a';
                set @n2 = 'b';
                set @n3 = 'c';
                select @n1,@n2,@n3;

            end
            $$

            delimiter ;    //这一行单独执行

            -- 调用过程
            call mb_pro3(@n1,@n2,@n3);
            +-------+-------+-------+
            | int_1 | int_2 | int_3 |
            +-------+-------+-------+
            |     1 | NULL  |     3 |   //int_2是out类型,传入进来就变成null
            +-------+-------+-------+
            1 row in set (0.03 sec)

            +-------+-------+-------+
            | int_1 | int_2 | int_3 |
            +-------+-------+-------+
            |    10 |    20 |    30 |
            +-------+-------+-------+
            1 row in set (0.06 sec)

            +-----+-----+-----+
            | @n1 | @n2 | @n3 |
            +-----+-----+-----+
            |   1 |   2 |   3 |      //外边的值没有变
            +-----+-----+-----+
            1 row in set (0.09 sec)

            +-----+-----+-----+
            | @n1 | @n2 | @n3 |
            +-----+-----+-----+
            | a   | b   | c   |      //直接更改
            +-----+-----+-----+

        结果分析:out类型会被清空,其余正常

            在外部查看,out和inout类型的值变为了形参的值
            select @n1,@n2,@n3;
            +-----+-----+-----+
            | @n1 | @n2 | @n3 |
            +-----+-----+-----+
            | a   |  20 |  30 |
            +-----+-----+-----+

        当过程走到end结束时,开始工作,判断变量是否为out或者inout类型,
        如果是,将内部代替out和inout变量的对应的形参的值重新赋值给外部
        变量,把外部变量的值覆盖
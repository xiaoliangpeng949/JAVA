#TCL
/*
Transaction Control Language 事务控制语言

事务：
一个或一组sql语句组成一个执行单元，这个执行单元要么全部执行，要么全部不执行。

案例：转账

张三丰  1000
郭襄	1000

update 表 set 张三丰的余额=500 where name='张三丰'
意外
update 表 set 郭襄的余额=1500 where name='郭襄'


事务的特性：
ACID
原子性atomicity：一个事务不可再分割，要么都执行要么都不执行
一致性consistency：一个事务执行会使数据从一个一致状态切换到另外一个一致状态
隔离性isolation：一个事务的执行不受其他事务的干扰,需设置隔离级别
持久性durability：一个事务一旦提交，则会永久的改变数据库的数据.



事务的创建
隐式事务：事务没有明显的开启和结束的标记
比如insert、update、delete语句

delete from 表 where id =1;

显式事务：事务具有明显的开启和结束的标记
前提：必须先设置自动提交功能为禁用

set autocommit=0;

步骤1：开启事务
set autocommit=0;
start transaction;可选的
步骤2：编写事务中的sql语句(select insert update delete)
语句1;
语句2;
...

步骤3：结束事务
commit;提交事务
或者rollback;回滚事务

savepoint 节点名;设置保存点

对于同时运行的多个事务，当这些事务访问数据库中相同的数据时，
如果没有采取必要的隔离机制，就会导致各种并发问题。
脏读：对于两个事务T1，T2，T1读取了已经被T2更新但还没有被提交的
      字段之后，若T2回滚，T1读取的内容就是临时且无效的。强调更新。
不可重复读：对于两个事务T1，T2，T1读取了一个字段，然后T2更新了该
      字段之后，T1再次读取同一个字段，值就不同了。
幻读：对于两个事务T1，T2，T1从一个表中读取了一个字段，然后T2在该
      表中插入了一些新的行之后，如果T1再次读取同一个表，就会多出几行
      强调插入。


事务的隔离级别：
		  脏读		不可重复读	幻读
read uncommitted：√		√		√
read committed：  ×		√		√
repeatable read： ×		×		√
serializable	  ×             ×               ×
serializable虽然级别高但性能低


mysql中默认 第三个隔离级别 repeatable read
oracle中默认第二个隔离级别 read committed，只有两个隔离级别，另外一个是serializable
查看隔离级别
select @@tx_isolation;
设置当前SQL/数据库的隔离级别
set session|global transaction isolation level 隔离级别;




开启事务的语句;
update 表 set 张三丰的余额=500 where name='张三丰'

update 表 set 郭襄的余额=1500 where name='郭襄' 
结束事务的语句;



*/

SHOW VARIABLES LIKE 'autocommit';
SHOW ENGINES;

#1.演示事务的使用步骤

#开启事务
SET autocommit=0;
START TRANSACTION;
#编写一组事务的语句
UPDATE account SET balance = 1000 WHERE username='张无忌';
UPDATE account SET balance = 1000 WHERE username='赵敏';

#结束事务
ROLLBACK;
#commit;

SELECT * FROM account;


#2.演示事务对于delete和truncate的处理的区别

SET autocommit=0;
START TRANSACTION;

DELETE FROM account;
ROLLBACK;#delete可以回滚，truncate不可以回滚---数据仍然会被删除



#3.演示savepoint 的使用
SET autocommit=0;
START TRANSACTION;
DELETE FROM account WHERE id=25;
SAVEPOINT a;#设置保存点
DELETE FROM account WHERE id=28;
ROLLBACK TO a;#回滚到保存点


SELECT * FROM account;










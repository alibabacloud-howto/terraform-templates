drop table if exists t_order;

create table t_order(
    order_id bigint,
    user_id smallint,
    info text,
    c1 smallint,
    crt_time timestamp,
PRIMARY KEY ( order_id ));

insert into t_order (order_id, user_id, info, c1, crt_time) values (0, 0,'a',1,now());  
insert into t_order (order_id, user_id, info, c1, crt_time) values (1, 1,'b',2,now());  
insert into t_order (order_id, user_id, info, c1, crt_time) values (2, 2,'c',3,now());  
insert into t_order (order_id, user_id, info, c1, crt_time) values (3, 3,'d',4,now());
insert into t_order (order_id, user_id, info, c1, crt_time) values (4, 4,'e',5,now());  
insert into t_order (order_id, user_id, info, c1, crt_time) values (5, 5,'f',6,now());  
insert into t_order (order_id, user_id, info, c1, crt_time) values (6, 6,'g',7,now());  
insert into t_order (order_id, user_id, info, c1, crt_time) values (7, 7,'h',8,now());

grant select on test_database.* to test_mysql_1@'%';
grant insert on test_database.* to test_mysql_1@'%';
grant update on test_database.* to test_mysql_1@'%';
grant delete on test_database.* to test_mysql_1@'%';

grant select on test_database.* to test_mysql_2@'%';
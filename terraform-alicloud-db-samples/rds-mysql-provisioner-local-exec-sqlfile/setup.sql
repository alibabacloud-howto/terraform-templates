DROP TABLE if exists t_order;

CREATE TABLE t_order(
    order_id bigint,
    user_id smallint,
    info text,
    c1 smallint,
    crt_time timestamp,
PRIMARY KEY ( order_id ));

INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (0, 0,'a',1,now());  
INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (1, 1,'b',2,now());  
INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (2, 2,'c',3,now());  
INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (3, 3,'d',4,now());
INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (4, 4,'e',5,now());  
INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (5, 5,'f',6,now());  
INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (6, 6,'g',7,now());  
INSERT INTO t_order (order_id, user_id, info, c1, crt_time) values (7, 7,'h',8,now());

GRANT select on test_database.* to test_mysql_1@'%';
GRANT insert on test_database.* to test_mysql_1@'%';
GRANT update on test_database.* to test_mysql_1@'%';
GRANT delete on test_database.* to test_mysql_1@'%';

GRANT select on test_database.* to test_mysql_2@'%';
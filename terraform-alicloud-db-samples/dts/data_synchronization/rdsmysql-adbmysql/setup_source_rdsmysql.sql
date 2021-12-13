DROP TABLE IF EXISTS t_order;

CREATE TABLE t_order(
    order_id bigint,
    user_id smallint,
    info text,
    c1 smallint,
    crt_time timestamp,
PRIMARY KEY ( order_id ));

INSERT INTO t_order (order_id, user_id, info, c1, crt_time) VALUES (0, 0,'a',1,now()); 
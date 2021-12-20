import pymysql
import time

db = pymysql.connect(host="rm-xxx.mysql.xxx.rds.aliyuncs.com",
                     user="test_mysql",
                     password="N1cetest",
                     port=3306,
                     database="test_database",
                     charset='utf8')

cursor = db.cursor()

for num in range(1, 10000):
    try:
        sql = "INSERT INTO t_order (order_id, user_id, info, c1, crt_time) VALUES (" + \
            str(num) + ", " + str(num) + ",'" + \
            str(num) + "', " + str(num) + ", now())"
        print(sql)
        cursor.execute(sql)
        db.commit()
        time.sleep(1)

    except Exception as e:
        db.rollback()
        print(e)

cursor.close()
db.close()

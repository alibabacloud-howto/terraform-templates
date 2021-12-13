import pymysql
import time

db = pymysql.connect(host="am-xxx.xxx.ads.aliyuncs.com",
                     user="test_adb",
                     password="N1cetest",
                     port=3306,
                     database="test_database",
                     charset='utf8')

cursor = db.cursor()

for num in range(10, 10000):
    try:
        sql = "SELECT count(*) FROM t_order"
        cursor.execute(sql)
        results = cursor.fetchall()
        for row in results:
            count = row[0]
            print("Total order count = {}".format(count))
        time.sleep(1)

    except Exception as e:
        print(e)

cursor.close()
db.close()

from flask import Flask, request
import pymysql
import pandas as pd

app = Flask(__name__)

# Student query
@app.route('/update_friends', methods=['POST'])
def student_query():
    request_json = request.get_json()
    cust_input = request_json['cust_id']
    conn = pymysql.connect(host='localhost', port=3306, user='root',
                           password='qwerty1234', db='kakaotalk')
    sql = """
   select c.name,ifnull(p.url,"images/0.png") url,p.update_time
from T_customer c
join T_friend f on c.cust_id = f.friend_id
left join T_picture_update pu on pu.cust_id = c.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where f.cust_id = %s and timestampdiff(month,p.update_time,'2023-10-28') < 2
order by p.update_time desc;
    """
    df = pd.read_sql_query(sql, conn, params=[cust_input])
    df_dict = {"name": df['name'].tolist(), "image": df['url'].tolist()}
    return df_dict

if __name__ == "__main__":
    app.run()
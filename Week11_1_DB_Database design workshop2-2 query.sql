use kakaotalk;
/*
create table T_customer (cust_id int, name varchar(10), birthday timestamp);
create table T_friend (cust_id int, friend_id int);
create table T_picture (pic_id int, cust_id int, url varchar(20), update_time timestamp);
create table T_chat (chat_id int, room_id int, cust_id int,chat varchar(300), chat_time timestamp);
create table T_chat_member (room_id int, cust_id int);
*/

-- Week11_1_DB_Database design workshop2-2.pdf

/*
-- 오늘 생일인 친구
select c.name,c.birthday,ifnull(p.url,"images/0.png") url
from T_customer c
join T_friend f on c.cust_id = f.friend_id
left join T_picture_update pu on pu.cust_id = c.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where f.cust_id = 3 and
month(c.birthday) = month(curdate()) and -- month() , curdate() 함수 잘 기억!
day(c.birthday) = day(curdate())
order by c.name;
*/

/*
-- 생일 지난 친구
select c.name,c.birthday,ifnull(p.url,"images/0.png") url
from T_customer c
join T_friend f on c.cust_id = f.friend_id
left join T_picture_update pu on pu.cust_id = c.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where f.cust_id = 3
and date_format(c.birthday,'2024-%m-%d') -- 년도 고정
between date_add(curdate(),interval -30 day) and curdate() -- 30일 전 ~ 현재 사이
order by date_format(c.birthday,'2024-%m-%d'),c.name; -- 년도 고정하고 날짜 순으로
*/

/*
-- 생일 다가오는 친구
select c.name,c.birthday,ifnull(p.url,"images/0.png") url
from T_customer c
join T_friend f on c.cust_id = f.friend_id
left join T_picture_update pu on pu.cust_id = c.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where f.cust_id = 3
and date_format(c.birthday,'2024-%m-%d') -- 년도 고정
between date_add(curdate(),interval 30 day) and curdate() -- 현재 ~ 30일 후 사이
order by date_format(c.birthday,'2024-%m-%d'),c.name; -- 년도 고정하고 날짜 순으로
*/

/*
-- 나를 친구추가했는데 , 나는 친구추가 하지 않은 사람 ***
select f.cust_id
from T_friend f
where f.friend_id = 3 and f.cust_id not in(select friend_id 
from T_friend f 
where f.cust_id = 3);

select c.name,ifnull(p.url,"images/0.png") url
from T_friend f
join T_customer c on c.cust_id = f.cust_id -- 여긴 왜 f.cust_id일까
left join T_picture_update pu on pu.cust_id = c.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where f.friend_id = 3 and f.cust_id not in(select friend_id
from T_friend
where cust_id = 3)
order by c.name;
*/

-- 나의 친구들이 친구추가했는데 , 나는 친구추가 하지 않은 사람
-- 1.내 친구들의 아이디
select friend_id
from T_friend
where cust_id = 3;

-- 2.내 친구들 중 10명 이상이 친구 추가한 사람들
select friend_id,count(*) cnt
from T_friend
where cust_id in(
select friend_id
from T_friend
where cust_id =3)
group by friend_id
having cnt >= 10;

select friend_id,count(*) cnt
from T_friend
where cust_id in(
select friend_id
from T_friend
where cust_id =3)
and friend_id not in(
select friend_id
from T_friend
where cust_id = 3)
group by friend_id
having cnt >= 10;









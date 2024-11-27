use kakaotalk;
/*
create table T_customer (cust_id int, name varchar(10), birthday timestamp);
create table T_friend (cust_id int, friend_id int);
create table T_picture (pic_id int, cust_id int, url varchar(20), update_time timestamp);
create table T_chat (chat_id int, room_id int, cust_id int,chat varchar(300), chat_time timestamp);
create table T_chat_member (room_id int, cust_id int);
*/

-- Week10_1_DB_Database design workshop2.pdf
/*
-- 친구들의 이름 찾기
select c.name
from T_customer c
join T_friend f on c.cust_id = f.friend_id
where f.cust_id = 3
order by c.name;
*/

/*
-- 최근 사진url view 생성
create view T_picture_update as
select cust_id,max(pic_id) max_pic_id
from T_picture
group by cust_id
order by cust_id;
*/

/*
-- 친구의 최근 사진
select c.name,ifnull(p.url,"images/0.png") url
from T_customer c
join T_friend f on c.cust_id = f.friend_id
left join T_picture_update pu on pu.cust_id = c.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where f.cust_id = 3
order by c.name;
*/

/*
--최근 두달 이내에 프사 바꾼 친구 띄우기
select c.name,ifnull(p.url,"images/0.png") url,p.update_time
from T_customer c
join T_friend f on c.cust_id = f.friend_id
left join T_picture_update pu on pu.cust_id = c.cust_id -- 가장 최근 사진의 url만 들은 view , left join 이유: 사진 없는 애는 view에 정보 없어서
left join T_picture p on pu.max_pic_id = p.pic_id -- url 출력용 , left join 이유: url 없는 애들 있어서 그런 애들은 null로 나오도록 그냥 조인하면 그런애들은 그냥 걸러짐
where f.cust_id = 3 and timestampdiff(month,p.update_time,'2023-10-28') < 2 -- timestampdiff 함수 : timestampdiff(단위 , 시작시간 , 끝나는 시간) 리턴 값은 시작부터종료까지 얼마나 차이나는지
order by p.update_time desc;
*/


-- 1) In order to reward most loyal users, find the 5 oldest users of the Instagram from the database provided.

SELECT 
    username, created_at
FROM
    users
ORDER BY created_at
LIMIT 5; 

-- 2) Find the users who have never posted a single photo on Instagram.

SELECT 
    u.username
FROM
    users u
LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    user_id IS NULL
ORDER BY u.username;

-- 3) Identify the winner of the contest by finding out which user gets the most likes on a single photoand provide their details to the team.

WITH likes as
(
SELECT l.photo_id,u.username, COUNT(l.user_id) AS most_likes
FROM likes l
JOIN photos p ON l.photo_id = p.id
JOIN users u ON p.user_id = u.id
GROUP BY l.photo_id,u.username
ORDER BY most_likes DESC
LIMIT 1
)
SELECT username FROM likes;

-- 4) Identify and suggest the top 5 most commonly used hashtags on the platform.

SELECT 
    t.tag_name, COUNT(p.photo_id) AS num_tags
FROM
    tags t
JOIN
    photo_tags p ON t.id = p.tag_id
GROUP BY t.tag_name
ORDER BY num_tags DESC
LIMIT 5;

-- 5) What day of the week do most users register on? Provide insights on when to schedule an ad campaign.

SELECT 
    WEEKDAY(created_at) AS weekday, COUNT(username) AS num_users
FROM
    users
GROUP BY 1
ORDER BY 2 DESC;

-- 6) Provide how many times does average user posts on Instagram. Also, provide the total number of photos on Instagram/total number of users.

-- Average_post_per_user
WITH post as
(
SELECT u.id AS user_id,
COUNT(p.id) AS photoid
FROM user u
JOIN photos p
ON u.id = p.user_id
GROUP BY u.id
)

SELECT SUM(photoid)/count(user_id) AS avg_post_per_user
FROM post
WHERE photoid > 0;

-- Average photo per user
WITH post as
(
SELECT u.id AS user_id,
COUNT(p.id) AS photoid
FROM users u
LEFT JOIN photos p
ON u.id = p.user_id
GROUP BY u.id
)

SELECT SUM(photoid) AS total_photos, 
count(user_id) AS total_users, 
SUM(photoid)/count(user_id) AS photos_per_usr
FROM post;

-- 7) Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).

WITH photo_count AS 
(
SELECT user_id, 
COUNT(photo_id) AS num_like
FROM likes
GROUP BY user_id 
ORDER BY num_like DESC
)

SELECT *FROM photo_count
WHERE 
num_like = ( SELECT count(*) FROM photos)




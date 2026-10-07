USE passwords;

SET @key_str = UNHEX(SHA2('some passphrase', 512));

-- CREATE NEW ENTRY

INSERT INTO website (website_name, url) VALUES
  ('Discord', 'http://discord.com');

INSERT INTO account (website_id, user_id, username, password, comment) VALUES
  (LAST_INSERT_ID(),3,'jillbilly',AES_ENCRYPT('password123456', @key_str), NULL);

-- GET PASSWORD

SELECT CAST(AES_DECRYPT(a.password, @key_str) AS CHAR) AS password
FROM account AS a
JOIN website AS w ON w.website_id = a.website_id
WHERE w.url = 'http://www.mysql.com';

-- GET PASSWORD DATA

SELECT
  w.website_name,
  w.url,
  u.first_name,
  u.last_name,
  u.email,
  a.username,
  CAST(AES_DECRYPT(a.password, @key_str) AS CHAR) AS password,
  a.comment,
  a.created_at
FROM account AS a
JOIN website AS w ON w.website_id = a.website_id
JOIN user AS u ON u.user_id = a.user_id
WHERE w.url LIKE 'https%';

-- CHANGE URL

UPDATE website
SET url = 'https://www.mysql.com'
WHERE url = 'http://www.mysql.com';

-- CHANGE PASSWORD

UPDATE account as a
JOIN website AS w ON w.website_id = a.website_id
SET a.password = AES_ENCRYPT('new password', @key_str)
WHERE w.url = 'http://www.netflix.com';

-- REMOVE BASED ON URL

DELETE FROM website
WHERE url = 'http://www.reddit.com';

-- REMOVE BASED ON PASSWORD

DELETE FROM account
WHERE AES_DECRYPT(password, @key_str) = 'weRq213ko9';
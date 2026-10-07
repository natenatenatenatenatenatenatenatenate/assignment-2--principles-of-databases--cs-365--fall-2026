CREATE DATABASE passwords;
use passwords;

SET @key_str = UNHEX(SHA2('some passphrase', 512));

-- TABLE CREATION

CREATE TABLE website (
  website_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  website_name VARCHAR(64) NOT NULL,
  url VARCHAR(255) NOT NULL,
  PRIMARY KEY (website_id),
  UNIQUE KEY uq_website_url (url)
);

CREATE TABLE user (
  user_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(64) NOT NULL,
  last_name VARCHAR(64) NOT NULL,
  email VARCHAR(255) NOT NULL,
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_user_email (email)
);

CREATE TABLE account (
  account_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  website_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED NOT NULL,
  username VARCHAR(64) NOT NULL,
  password VARBINARY(512) NOT NULL,
  comment VARCHAR(255),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (account_id),
  UNIQUE KEY uq_account_site_username (website_id, username),
  CONSTRAINT fk_account_website
    FOREIGN KEY (website_id) REFERENCES website (website_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_account_user
    FOREIGN KEY (user_id) REFERENCES user (user_id)
    ON DELETE CASCADE
);

-- TABLE POPULATION

INSERT INTO website (website_name, url) VALUES
  ('MySQL', 'http://www.mysql.com'),
  ('University of Hartford', 'https://www.hartford.edu'),
  ('GitHub', 'https://github.com'),
  ('Wikipedia', 'http://www.wikipedia.org'),
  ('Stack Overflow', 'http://stackoverflow.com'),
  ('Reddit', 'http://www.reddit.com'),
  ('Spotify', 'http://www.spotify.com'),
  ('Netflix', 'http://www.netflix.com'),
  ('Steam', 'http://store.steampowered.com'),
  ('Amazon', 'http://www.amazon.com');

INSERT INTO user (first_name, last_name, email) VALUES
  ('Joe', 'Schmoe', 'joe.schmoe@example.com'),
  ('Jim', 'Bean', 'jim.bean@example.com'),
  ('Jill', 'Jack', 'jill.jack@example.com');

INSERT INTO account (website_id, user_id, username, password, comment) VALUES
  (1,1,'joe', AES_ENCRYPT('joey1234', @key_str), NULL),
  (2,1,'joe', AES_ENCRYPT('joey1234', @key_str), NULL),
  (3,1,'joe', AES_ENCRYPT('joey1234', @key_str), NULL),
  (4,2,'jimjohn', AES_ENCRYPT('jimbobby', @key_str), NULL),
  (5,2,'jimjohn', AES_ENCRYPT('jimbobby', @key_str), NULL),
  (6,2,'jimjohn', AES_ENCRYPT('jimbobby', @key_str), NULL),
  (7,3,'jillbillbananafanafofill', AES_ENCRYPT('Jnp2lq!#kO', @key_str), NULL),
  (8,3,'jillgottawatchfixerupper', AES_ENCRYPT('2k3dvbjIl2', @key_str), NULL),
  (9,3,'jillplaysgames', AES_ENCRYPT('weRq213ko9', @key_str), NULL),
  (10,3,'idonthaveanamazonaddiction', AES_ENCRYPT('asdfdasdfoq', @key_str), NULL);
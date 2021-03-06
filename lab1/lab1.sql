--LAB1A

--create a new table named users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name varchar(40),
    last_name varchar(40),
    email varchar (40) NOT NULL,
    password varchar(20) NOT NULL,
    created_at timestamp,
    updated_at timestamp
);

--create a new table named status
CREATE TABLE status (
    id SERIAL PRIMARY KEY,
    description text NOT NULL,
    created_at timestamp,
    updated_at timestamp
);

--create a new table named inventory
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    status_id integer REFERENCES status (id),
    description text NOT NULL,
    created_at timestamp,
    updated_at timestamp
);

--create a new table named transactions
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id integer REFERENCES users (id),
    inventory_id integer REFERENCES inventory (id),
    checkout_time timestamp NOT NULL,
    scheduled_checkin_time timestamp,
    actual_checkin_time timestamp,
    created_at timestamp,
    updated_at timestamp
);

--insert 5 users into the users table
INSERT INTO users (first_name, last_name, email, password, created_at) VALUES
('Amos','Arnold','aa@somewhere.com','pass1','now');
INSERT INTO users (first_name, last_name, email, password, created_at) VALUES ('Bill','Bates','bb@somewhere.com','pass2','now');
INSERT INTO users (first_name, last_name, email, password, created_at) VALUES ('Carl','Carson','cc@somewhere.com','pass3','now');
INSERT INTO users (first_name, last_name, email, password, created_at) VALUES ('Dana','Dailey','dd@somewhere.com','pass4','now');
INSERT INTO users (first_name, last_name, email, password, created_at) VALUES
('Erin','Erikson','ee@somewhere.com','pass5','now');

--insert 5 records into the status table
INSERT INTO status (description, created_at) VALUES ('Available','now');
INSERT INTO status (description, created_at) VALUES ('Checked out','now');
INSERT INTO status (description, created_at) VALUES ('Overdue','now');
INSERT INTO status (description, created_at) VALUES ('Unavailable','now');
INSERT INTO status (description, created_at) VALUES ('Under Repair','now');

--insert 5 records into the inventory table
INSERT INTO inventory (status_id, description, created_at) VALUES
(1,'Laptop1','now');
INSERT INTO inventory (status_id, description, created_at) VALUES
(1,'Labtop2','now');
INSERT INTO inventory (status_id, description, created_at) VALUES
(1,'Webcam1','now');
INSERT INTO inventory (status_id, description, created_at) VALUES
(1,'TV1','now');
INSERT INTO inventory (status_id, description, created_at) VALUES
(1,'Microphone1','now');

/* insert 3 records into the transactions table, then update the status of the
 * items in the inventory table to 'Checked out'
 */
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, created_at) VALUES (1, 1,'2021-06-10 21:05:06','2021-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, created_at) VALUES (2, 2,'2021-06-11 21:05:00','2021-06-25 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, created_at) VALUES (3, 3,'2021-06-12 15:00:00','2021-07-12 18:00:00','now');
UPDATE inventory SET status_id = 2, updated_at = 'now' WHERE id < 4;

--alter the users table to add a column for 'signed_agreement' (bool def false)
ALTER TABLE users ADD COLUMN signed_agreement boolean DEFAULT FALSE;

/* write query return list of equipment and its scheduled_checkin_time that is
 * checked out ordered by scheduled_checkin_time desc
 */
SELECT i.description, t.scheduled_checkin_time
FROM inventory i JOIN transactions t ON i.id = t.inventory_id
WHERE i.status_id = 2
ORDER BY t.scheduled_checkin_time DESC;

--write query that returns all equip due after May 31, 2019
SELECT i.description, t.scheduled_checkin_time
FROM inventory i JOIN transactions t ON i.id = t.inventory_id
WHERE t.scheduled_checkin_time > '2019-05-31';

--write query return count of items with status Checked out by user_id 1
SELECT count(*) AS num_items_checked_out
FROM inventory i JOIN transactions t ON i.id = t.inventory_id
WHERE t.user_id = 1 AND i.status_id = 2;

--LAB1B

--insert 20 transactions
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (1, 2,'2018-06-10 21:05:06','2018-07-10 18:00:00','2018-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (1, 3,'2018-06-10 21:05:06','2018-07-10 18:00:00','2018-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (5, 1,'2018-06-10 21:05:06','2018-07-10 18:00:00','2018-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (2, 4,'2018-06-10 21:05:06','2018-07-10 18:00:00','2018-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (2, 1,'2017-06-10 21:05:06','2017-07-10 18:00:00','2017-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (2, 3,'2017-06-10 21:05:06','2017-07-10 18:00:00','2017-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (3, 3,'2016-06-10 21:05:06','2016-07-10 18:00:00','2016-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (5, 4,'2017-06-10 21:05:06','2017-07-10 18:00:00','2017-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (3, 5,'2018-06-10 21:05:06','2018-07-10 18:00:00','2018-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (4, 5,'2017-06-10 21:05:06','2017-07-10 18:00:00','2017-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (4, 1,'2016-06-10 21:05:06','2016-07-10 18:00:00','2016-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (4, 2,'2017-06-10 21:05:06','2017-07-10 18:00:00','2017-07-10 18:00:00','now');

--3 transactions where actual_checkin_time > scheduled_checkin_time
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (1, 5,'2016-06-10 21:05:06','2016-07-10 18:00:00','2016-07-11 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (2, 4,'2016-06-10 21:05:06','2016-07-10 18:00:00','2016-07-12 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (1, 3,'2015-06-10 21:05:06','2015-07-10 18:00:00','2015-07-13 18:00:00','now');

--5 transactions where checkout_time > '2018-09-03'
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (3, 1,'2021-06-10 21:05:06','2021-07-10 18:00:00','2021-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (4, 2,'2021-06-10 21:05:06','2021-07-10 18:00:00','2021-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (5, 3,'2021-06-10 21:05:06','2021-07-10 18:00:00','2021-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (5, 1,'2020-06-10 21:05:06','2020-07-10 18:00:00','2020-07-10 18:00:00','now');
INSERT INTO transactions (user_id, inventory_id, checkout_time, scheduled_checkin_time, actual_checkin_time, created_at) VALUES (5, 5,'2021-06-10 21:05:06','2021-07-10 18:00:00','2021-07-10 18:00:00','now');

--create a late checkins view
CREATE VIEW late_checkins AS
SELECT t.user_id, i.description, count(*) AS occurrences
FROM transactions t JOIN inventory i ON t.inventory_id = i.id
WHERE t.actual_checkin_time > t.scheduled_checkin_time
GROUP BY t.user_id, t.inventory_id, i.description;

--test the late checkins view
SELECT * FROM late_checkins;

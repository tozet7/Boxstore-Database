/*
 * Name: Antonio Teixeira
 * Date: 12/12/24
 * Type: at_0372995_boxstore
 * Asgn: SQL Final Project
 */


-- to drop and create a database
DROP DATABASE IF EXISTS at_0372995_boxstore;
CREATE DATABASE IF NOT EXISTS at_0372995_boxstore
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- to get into your newly created database
USE at_0372995_boxstore;

-- Table: people ----------------------------------------------------
DROP TABLE IF EXISTS people;
CREATE TABLE IF NOT EXISTS people (
     p_id      INT(11)      AUTO_INCREMENT #PK
   , full_name VARCHAR(100) NULL           #UK
   , PRIMARY KEY(p_id)
);

-- verify your table query works
SELECT * FROM people WHERE 1=1;

-- insert into people table
TRUNCATE TABLE people;
INSERT INTO people (full_name) VALUES ('Brad Vincelette');
INSERT INTO people (full_name) VALUES ('Antonio Teixeira');

-- bulk import 10000
SET GLOBAL local_infile=1;
LOAD DATA LOCAL INFILE 'C:/Users/TozeT/at_0372995_boxstore_people.csv'
INTO TABLE people
LINES TERMINATED BY '\r\n'
(full_name);

SELECT COUNT(*) FROM people;

-- Table: people ----------------------------------------------------
-- alter people table, add first and last names
ALTER TABLE people
  ADD COLUMN first_name VARCHAR(40) NULL 
, ADD COLUMN last_name VARCHAR(60) NULL;

-- verify
SELECT p_id, full_name, first_name, last_name
FROM people;

-- full_name: removed double with single spacing, trims end spaces
UPDATE people SET full_name=TRIM(REPLACE(full_name,'  ',' '));

-- updates first and last name columns
UPDATE people
SET     first_name = LEFT(full_name,INSTR(full_name,' ')-1)
       , last_name = SUBSTR(full_name
                        , INSTR(full_name,' ')+1
                        , LENGTH(full_name)- INSTR(full_name,' ')
                   )
WHERE 1=1;

SELECT p_id, full_name, first_name, last_name
FROM people;

-- drop people.full_name
ALTER TABLE people DROP COLUMN full_name;

-- verify drop
SELECT p_id, first_name, last_name -- , full_name
FROM people;

-- Table: people ----------------------------------------------------
ALTER TABLE people 
  ADD COLUMN suite_num      VARCHAR(10)# NULL
, ADD COLUMN addr           VARCHAR(75)# NULL
, ADD COLUMN addr_mailcode  VARCHAR(15)# NULL
, ADD COLUMN addr_type_id   SMALLINT# NULL             -- FK
, ADD COLUMN addr_info      TEXT# NULL
, ADD COLUMN tc_id          INT# NULL                  -- FK
, ADD COLUMN delivery_info  TEXT# NULL
, ADD COLUMN ph_home        VARCHAR(25)# NULL
, ADD COLUMN ph_cell        VARCHAR(25)# NULL
, ADD COLUMN ph_work        VARCHAR(25)# NULL
, ADD COLUMN ph_work_ext    VARCHAR(10)# NULL
, ADD COLUMN email          VARCHAR(50)# NULL
, ADD COLUMN password       VARCHAR(32)# NULL
, ADD COLUMN user_id        INT NOT NULL DEFAULT 2    -- FK
, ADD COLUMN date_mod       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
, ADD COLUMN active         BIT NOT NULL DEFAULT 1;

-- verify your table query works
SELECT p_id, first_name, last_name
     , suite_num, addr, addr_mailcode, addr_type_id, addr_info, tc_id
     , ph_home, ph_cell, ph_work, ph_work_ext, email, password
     , user_id, date_mod, active
FROM people;

SELECT p.p_id, p.first_name, p.last_name, p.suite_num
  , p.addr, p.addr_mailcode, p.addr_type_id, p.addr_info 
  , p.tc_id, p.ph_home, p.ph_cell, p.ph_work, p.ph_work_ext
  , p.email, p.password
  , gat.addr_type, gtc.tc_name, gr.r_name, gc.co_name 
FROM people p
  JOIN geo_address_type gat ON p.addr_type_id = gat.addr_type_id
  JOIN geo_towncity gtc ON p.tc_id = gtc.tc_id
  JOIN geo_region gr ON gtc.r_id = gr.r_id
  JOIN geo_country gc ON gr.co_id = gc.co_id;

-- Table: people_employee -------------------------------------------
DROP TABLE IF EXISTS people_employee;
CREATE TABLE IF NOT EXISTS people_employee (
    pe_id INT AUTO_INCREMENT 
  , p_id INT NOT NULL -- FK
  , p_id_mgr INT -- FK
  , p_uri VARCHAR(75)
  , pe_employee_id CHAR(10)
  , pe_hired DATETIME
  , pe_salary DECIMAL(7,2)
  , user_id INT NOT NULL DEFAULT 2
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (pe_id)
);

TRUNCATE TABLE people_employee;
INSERT INTO people_employee (p_id, p_id_mgr, p_uri, pe_employee_id
                            , pe_hired, pe_salary)
VALUES              (1, NULL, 'brad-vincelette', 'A134523454'
                    , '1999-02-04', 10000.00)
                  ,(2, 1, 'antonio-teixeira', 'A134523455'
                  , '1999-02-04', 5000.00);

SELECT pe_id, p_id, p_id_mgr, p_uri, pe_employee_id, pe_hired, pe_salary
     , user_id, date_mod, active
FROM people_employee;

-- Table: geo_address_type ------------------------------------------
DROP TABLE IF EXISTS geo_address_type;
CREATE TABLE IF NOT EXISTS geo_address_type (
    addr_type_id SMALLINT AUTO_INCREMENT 
  , addr_type VARCHAR(15)
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(addr_type_id)
);
  
TRUNCATE TABLE geo_address_type;
INSERT INTO geo_address_type (addr_type)
VALUES ('House');

SELECT addr_type_id, addr_type, active 
FROM geo_address_type;

-- Table: geo_country -----------------------------------------------
DROP TABLE IF EXISTS geo_country;
CREATE TABLE IF NOT EXISTS geo_country (
    co_id MEDIUMINT AUTO_INCREMENT 
  , co_name VARCHAR(100)
  , co_abbr CHAR(2)
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(co_id)
);
  
TRUNCATE TABLE geo_country;
INSERT INTO geo_country (co_name, co_abbr)
VALUES                  ('Canada','CA');

SELECT co_id, co_name, co_abbr, active
FROM geo_country;


-- Table: geo_region ------------------------------------------------
DROP TABLE IF EXISTS geo_region;
CREATE TABLE IF NOT EXISTS geo_region (
    r_id INT AUTO_INCREMENT
  , r_name VARCHAR(75)
  , r_abbr CHAR(2)
  , co_id MEDIUMINT -- FK
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(r_id)
);
  
TRUNCATE TABLE geo_region;
INSERT INTO geo_region (r_name, r_abbr, co_id)
VALUES             ('Manitoba', 'MB', "1");

SELECT r_id, r_name, r_abbr, co_id 
FROM geo_region; 


-- Table: geo_towncity ----------------------------------------------
DROP TABLE IF EXISTS geo_towncity;
CREATE TABLE IF NOT EXISTS geo_towncity (
    tc_id INT AUTO_INCREMENT
  , tc_name VARCHAR(50)
  , tc_abbr CHAR(2)
  , r_id INT -- FK
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(tc_id)
);
  
TRUNCATE TABLE geo_towncity;
INSERT INTO geo_towncity (tc_name, r_id)
VALUES ('Winnipeg', 1);

SELECT tc_id, tc_name, r_id, active 
FROM geo_towncity;

SELECT gc.co_id, gc.co_name, gr.r_id, gr.r_name
  , gtc.tc_id, gtc.tc_name
FROM geo_towncity gtc
  JOIN geo_region gr ON gtc.r_id = gr.r_id 
  JOIN geo_country gc ON gr.co_id = gc.co_id;

SELECT p.p_id, p.first_name, p.last_name, p.suite_num
  , p.addr, p.addr_mailcode, p.addr_type_id, p.addr_info 
  , p.tc_id, p.ph_home, p.ph_cell, p.ph_work, p.ph_work_ext
  , p.email, p.password
  , gat.addr_type, gtc.tc_name, gr.r_name, gc.co_name 
FROM people p
  JOIN geo_address_type gat ON p.addr_type_id = gat.addr_type_id
  JOIN geo_towncity gtc ON p.tc_id = gtc.tc_id
  JOIN geo_region gr ON gtc.r_id = gr.r_id
  JOIN geo_country gc ON gr.co_id = gc.co_id;

-- Table: category --------------------------------------------------
DROP TABLE IF EXISTS category;
CREATE TABLE IF NOT EXISTS category (
    cat_id MEDIUMINT AUTO_INCREMENT 
  , cat_name VARCHAR(60)
  , cat_id_parent MEDIUMINT -- FK
  , cat_uri VARCHAR(60)
  , cat_abbr VARCHAR(10)
  , hashtag VARCHAR(50)
  , taxonomy VARCHAR(15)
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(cat_id)
);
  
TRUNCATE TABLE category;
-- item
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr
                      , taxonomy)
VALUES ('Electronics', NULL, 'electronics', NULL, 'general');
-- people
INSERT INTO category (cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy)
VALUES ('Sales', NULL, 'sales', NULL, 'departements');

SELECT cat_name, cat_id_parent, cat_uri, cat_abbr, taxonomy
        , user_id, date_mod, active
FROM category;

SELECT p.p_id, p.first_name, p.last_name, p.ph_cell
  , pe.pe_id, pe.p_id, pe.pe_salary
  , pc.pc_id, pc.p_id, pc.pc_id, c.cat_id
  , c.cat_name
FROM people p
  LEFT JOIN people_employee pe ON p.p_id = pe.p_id 
  LEFT JOIN people_category pc ON p.p_id = pc.p_id
  LEFT JOIN category c ON c.cat_id = pc.cat_id;

-- Table: people_category -------------------------------------------
DROP TABLE IF EXISTS people_category;
CREATE TABLE IF NOT EXISTS people_category(
    pc_id INT AUTO_INCREMENT
  , p_id INT -- FK 
  , cat_id MEDIUMINT -- FK
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(pc_id)
);
  
TRUNCATE TABLE people_category;
INSERT INTO people_category (p_id, cat_id)
VALUES (1, 2),(2, 3);

SELECT pc_id, p_id, cat_id, user_id, date_mod, active 
FROM people_category;


-- Table: manufacturer ----------------------------------------------
DROP TABLE IF EXISTS manufacturer;
CREATE TABLE IF NOT EXISTS manufacturer(
    m_id MEDIUMINT AUTO_INCREMENT 
  , man_name VARCHAR(75)
  , addr VARCHAR(75)
  , addr_mailcode VARCHAR(15)
  , addr_type_id SMALLINT -- FK
  , addr_info TEXT
  , tc_id INT -- FK
  , ph_main VARCHAR(25)
  , ph_sales VARCHAR(25)
  , ph_sales_ext VARCHAR(10)
  , ph_inv VARCHAR(25)
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(m_id)
);
  
TRUNCATE TABLE manufacturer;
INSERT INTO manufacturer (man_name
                        , addr, addr_mailcode, addr_type_id, addr_info
                        , tc_id, ph_main, ph_sales, ph_sales_ext, ph_inv)
VALUES ('Ronaly Manufacturer'
      , '26 St. Mary Road', 'R2T5M2', 1, 'Close to Greenwood Avenue'
      , 25, '2049873232', '2045619999', '3456', '5679875544');

SELECT m_id, man_name, addr, addr_mailcode, addr_type_id, addr_info
      , tc_id, ph_main, ph_sales, ph_sales_ext, ph_inv
      , user_id, date_mod, active
FROM manufacturer;

SELECT m.man_name, gc.co_name, gr.r_name, gtc.tc_name, gat.addr_type
FROM manufacturer m
  JOIN geo_address_type gat ON m.addr_type_id = gat.addr_type_id
  JOIN geo_towncity gtc ON m.tc_id = gtc.tc_id
  JOIN geo_region gr ON gtc.r_id = gr.r_id
  JOIN geo_country gc ON gr.co_id = gc.co_id;

-- Table: item ------------------------------------------------------
DROP TABLE IF EXISTS item;
CREATE TABLE IF NOT EXISTS item (
    i_id BIGINT AUTO_INCREMENT 
  , item_type VARCHAR(20)
  , item_name VARCHAR(75) NOT NULL
  , item_modelno VARCHAR(25) NOT NULL
  , item_barcode VARCHAR(20) NULL
  , item_uri VARCHAR(75) NOT NULL
  , item_size decimal (9,4) NULL
  , item_uom VARCHAR(75) NULL
  , item_price  DECIMAL (9,2) NULL
  , image_uri VARCHAR(75) NULL
  , item_status VARCHAR(25)
  , m_id  MEDIUMINT -- FK
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(i_id)
);
  
TRUNCATE TABLE item;
INSERT INTO item (item_type, item_name, item_modelno, item_barcode
                , item_uri, item_size, item_uom, item_price
                , image_uri, item_status, m_id)
VALUES ('Product', 'Barista Express BES800', 'BES800', '34568' 
      , 'barista-express-bes800', 5.0218, 'Medium', 6.65
      , '/images/path/barista-express-bes800.png', 'backorder', 1);
      
SELECT i_id, item_type, item_name, item_modelno, item_barcode
      , item_size, item_uom, item_price, item_uri, item_status, m_id
      , user_id, date_mod, active
FROM item;

SELECT i.i_id, i.item_type, i.item_name
    , i.m_id, m.man_name
    , ip.ip_price, ip.ip_beg, 
    , im.im_desc
    , id.id_label, id.id_detail
    , ic.i_id, ic.cat_id
    , c.cat_name
FROM item i
  JOIN manufacturer m ON i.m_id = m.m_id
  JOIN item_price ip ON i.i_id = ip.ip_id
  LEFT JOIN item_meta im ON i.i_id = im.i_id 
  LEFT JOIN item_detail id ON i.i_id = id.i_id
  JOIN item_category ic ON i.i_id = ic.i_id
  JOIN category c ON c.cat_id = ic.cat_id;

DROP TABLE IF EXISTS `z__orders_items_csv`;

CREATE TABLE `z__orders_items_csv` (
  `m_id` INT(11) DEFAULT NULL,
  `order_num` INT(11) DEFAULT NULL,
  `order_date` DATE DEFAULT NULL,
  `item_type` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_modelno` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `item_barcode` INT(11) DEFAULT NULL,
  `cat_name` VARCHAR(16) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_id` INT(11) DEFAULT NULL,
  `item_name_new` VARCHAR(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_qty` INT(11) DEFAULT NULL,
  `item_price` DECIMAL(7,2) DEFAULT NULL,
  `extra` VARCHAR(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT  INTO `z__orders_items_csv`(`m_id`,`order_num`,`order_date`,`item_type`,`item_modelno`,`item_barcode`,`cat_name`,`cat_id`,`item_name_new`,`order_qty`,`item_price`,`extra`) VALUES 
(6,1160,'2021-05-18','product','6PRI0299999203',99999203,'55\" & Down',10,'50\" HDTV',3,2100.00,'6PRI02'),
(10,1026,'2021-01-13','product','2BRE1100066001',66001,'55\" & Down',10,'50\" HDTV',2,2100.00,'2BRE11'),
(10,1057,'2021-01-18','product','2BRE1000056014',56014,'55\" & Down',10,'50\" HDTV',2,2605.00,'2BRE10'),
(4,1091,'2021-02-17','product','3FPT0100051287',51287,'60\" - 69\"',9,'65\" HDTV',4,6065.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051281',51281,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(4,1091,'2021-02-17','product','3FPT0100051286',51286,'60\" - 69\"',9,'65\" HDTV',1,6665.33,'3FPT01'),
(5,1060,'2021-01-18','product','6LID0100051166',51166,'60\" - 69\"',9,'65\" HDTV',2,5502.67,'6LID01'),
(9,1174,'2021-05-19','product','2SUR1100056001',56001,'60\" - 69\"',9,'65\" HDTV',3,5000.00,'2SUR11'),
(6,1160,'2021-05-18','product','6PRI0299999197',99999197,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999198',99999198,'70\" & Up',8,'75\" HDTV',2,20013.33,'6PRI02'),
(4,1044,'2021-01-18','product','3SKY0111164009',11164009,'Blender',13,'20 ounce Blender',3,69.53,'3SKY01'),
(4,1044,'2021-01-18','product','3SKY0142542001',42542001,'Blender',13,'20 ounce Blender',3,89.41,'3SKY01'),
(5,1021,'2021-01-13','product','4MAR0120815001',20815001,'Blender',13,'20 ounce Blender',3,54.35,'4MAR01'),
(6,1254,'2022-01-28','product','4SOD0100001009',1009,'Blender',13,'20 ounce Blender',5,89.00,'4SOD01'),
(8,1040,'2021-01-18','product','2SUR1108413009',8413009,'Blender',13,'20 ounce Blender',3,50.75,'2SUR11'),
(1,1003,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',2,100.00,'1GQD02'),
(1,1180,'2021-05-20','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1239,'2021-01-13','product','1GQD0200001006',1006,'Coffee & Tea',14,'Barista Express',1,100.00,'1GQD02'),
(1,1030,'2021-01-13','product','1GQD0200001012',1012,'Coffee & Tea',14,'Barista Express',1,133.17,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0244563001',44563001,'Coffee & Tea',14,'Barista Express',4,199.80,'7BOC02'),
(3,1151,'2021-04-28','product','3BRI0300001012',1012,'Coffee & Tea',14,'Barista Express',3,133.17,'3BRI03'),
(5,1195,'2021-05-24','product','4HEL0141994001',41994001,'Coffee & Tea',14,'Barista Express',3,124.38,'4HEL01'),
(5,1054,'2021-01-18','product','4HEL0140182001',40182001,'Coffee & Tea',14,'Barista Express',3,172.63,'4HEL01'),
(7,1031,'2021-01-14','product','7SPP0105618009',5618009,'Coffee & Tea',14,'Barista Express',4,199.80,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1103820009',3820009,'Coffee & Tea',14,'Barista Express',1,104.50,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115323121',15323121,'Coffee & Tea',14,'Barista Express',1,144.18,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115384001',15384001,'Coffee & Tea',14,'Barista Express',3,152.74,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1115199001',15199001,'Coffee & Tea',14,'Barista Express',3,174.05,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1104929009',4929009,'Coffee & Tea',14,'Barista Express',2,184.80,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108718009',8718009,'Coffee & Tea',14,'Barista Express',3,189.61,'2SUR11'),
(8,1040,'2021-01-18','product','2SUR1108255009',8255009,'Coffee & Tea',14,'Barista Express',3,196.60,'2SUR11'),
(5,1049,'2021-01-18','product','7HAN0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HAN02'),
(5,1117,'2021-03-04','product','7HYU0200008359',8359,'Dryer',16,'Dryer',1,710.00,'7HYU02'),
(5,1119,'2021-03-04','product','7SMS0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SMS01'),
(5,1228,'2021-01-15','product','7SPP0100008359',8359,'Dryer',16,'Dryer',1,710.00,'7SPP01'),
(7,1229,'2021-02-23','product','7SPP0100041409',41409,'Dryer',16,'Dryer',4,716.67,'7SPP01'),
(10,1225,'2020-01-28','product','2BRE1500012590',12590,'Dryer',16,'Dryer',2,666.67,'2BRE15'),
(10,1225,'2020-01-28','product','2BRE1400012576',12576,'Dryer',16,'Dryer',2,783.33,'2BRE14'),
(1,1120,'2021-03-04','product','1GQD0240880001',40880001,'Smartphones',11,'Actually a Flipper',5,238.06,'1GQD02'),
(2,1173,'2021-05-18','product','7BOC0200002293',2293,'Smartphones',11,'Actually a Flipper',3,207.79,'7BOC02'),
(2,1168,'2021-05-18','product','4DAI0200002260',2260,'Smartphones',11,'Actually a Flipper',3,264.74,'4DAI02'),
(3,1137,'2021-04-06','product','3BRI0400002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'3BRI04'),
(3,1046,'2021-01-18','product','7DAE0400012490',12490,'Smartphones',11,'Really Smartphone',4,1250.00,'7DAE04'),
(4,1048,'2021-01-18','product','3TEC0350864001',50864001,'Smartphones',11,'Really Smartphone',1,1090.91,'3TEC03'),
(5,1054,'2021-01-18','product','4HEL0140184001',40184001,'Smartphones',11,'Actually a Flipper',5,226.07,'4HEL01'),
(5,1049,'2021-01-18','product','7HAN0200013563',13563,'Smartphones',11,'Really Smartphone',2,1170.00,'7HAN02'),
(6,1254,'2022-01-28','product','4SOD0100001011',1011,'Smartphones',11,'Actually a Flipper',2,299.70,'4SOD01'),
(6,1160,'2021-05-18','product','6PRI0299999177',99999177,'Smartphones',11,'Not-as Smartphone',3,332.97,'6PRI02'),
(6,1160,'2021-05-18','product','6PRI0299999178',99999178,'Smartphones',11,'Really Smartphone',2,1333.33,'6PRI02'),
(7,1031,'2021-01-14','product','7SPP0120983041',20983041,'Smartphones',11,'Not-as Smartphone',4,332.97,'7SPP01'),
(7,1031,'2021-01-14','product','7SPP0120983081',20983081,'Smartphones',11,'Not-as Smartphone',1,332.97,'7SPP01'),
(8,1040,'2021-01-18','product','2SUR1106484009',6484009,'Smartphones',11,'Not-as Smartphone',3,321.23,'2SUR11'),
(8,1201,'2021-05-24','product','2SUR1199999114',99999114,'Smartphones',11,'Not-as Smartphone',1,363.64,'2SUR11'),
(8,1043,'2021-01-18','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',3,1272.00,'2SUR11'),
(8,1178,'2021-05-20','product','2SUR1101100321',1100321,'Smartphones',11,'Really Smartphone',4,1272.00,'2SUR11'),
(9,1114,'2021-03-08','product','2SUR1100002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2SUR11'),
(9,1042,'2021-01-18','product','2SUR1151463001',51463001,'Smartphones',11,'Really Smartphone',1,1040.00,'2SUR11'),
(9,1111,'2021-02-26','product','2SUR1100041398',41398,'Smartphones',11,'Really Smartphone',5,1200.00,'2SUR11'),
(10,1089,'2021-02-24','product','2BRE1200002124',2124,'Smartphones',11,'Not-as Smartphone',3,358.74,'2BRE12'),
(10,1242,'2021-06-09','product','2BRE1600013212',13212,'Smartphones',11,'Really Smartphone',3,1000.00,'2BRE16'),
(10,1033,'2021-01-14','product','2BRE0100008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE01'),
(10,1036,'2021-01-18','product','2BRE0200008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE02'),
(10,1225,'2020-01-28','product','2BRE1300008427',8427,'Smartphones',11,'Really Smartphone',1,1010.00,'2BRE13'),
(10,1058,'2021-01-18','product','2BRE0600013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE06'),
(10,1157,'2021-05-17','product','2BRE0700013628',13628,'Smartphones',11,'Really Smartphone',5,1350.00,'2BRE07'),
(10,1177,'2021-05-20','product','2BRE0900013628',13628,'Smartphones',11,'Really Smartphone',3,1350.00,'2BRE09'),
(1,1046,'2021-01-18','product','1GQD0200008335',8335,'Tablets',12,'Super Tablet',4,1435.00,'1GQD02'),
(1,1090,'2021-02-24','product','3ADA0100008360',8360,'Tablets',12,'Super Tablet',4,2000.00,'3ADA01'),
(2,1170,'2021-05-18','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1211,'2021-05-26','product','4DAI0200002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'4DAI02'),
(2,1171,'2021-05-18','product','4DAI0200002123',2123,'Tablets',12,'Mini Tablet',3,424.58,'4DAI02'),
(3,1169,'2021-05-18','product','3BRI0400002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'3BRI04'),
(3,1111,'2021-02-26','product','7DAE0400008335',8335,'Tablets',12,'Super Tablet',1,1435.00,'7DAE04'),
(4,1105,'2021-02-26','product','3OCE0108211010',8211010,'Tablets',12,'Mini Tablet',3,499.50,'3OCE01'),
(4,1182,'2021-05-20','product','7UNI0400008355',8355,'Tablets',12,'Super Tablet',5,1435.00,'7UNI04'),
(5,1054,'2021-01-18','product','4HEL0105850009',5850009,'Tablets',12,'Mini Tablet',2,448.25,'4HEL01'),
(5,1031,'2021-01-14','product','7HYU0200041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7HYU02'),
(6,1052,'2021-01-18','product','7SAK0100008355',8355,'Tablets',12,'Super Tablet',3,1435.00,'7SAK01'),
(6,1117,'2021-03-04','product','7SMS0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SMS01'),
(7,1119,'2021-03-04','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(7,1228,'2021-01-15','product','7SPP0100041406',41406,'Tablets',12,'Super Tablet',4,1500.00,'7SPP01'),
(8,1150,'2021-04-27','product','2SUR1100008294',8294,'Tablets',12,'Super Tablet',3,1414.11,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002136',2136,'Tablets',12,'Mini Tablet',3,374.63,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002137',2137,'Tablets',12,'Mini Tablet',3,394.61,'2SUR11'),
(9,1102,'2021-02-26','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1107,'2021-03-05','product','2SUR1100002143',2143,'Tablets',12,'Mini Tablet',3,419.58,'2SUR11'),
(9,1064,'2021-01-19','product','2SUR1100008335',8335,'Tablets',12,'Super Tablet',5,1435.00,'2SUR11'),
(9,1056,'2021-01-18','product','2SUR1100011577',11577,'Tablets',12,'Super Tablet',1,1842.00,'2SUR11'),
(10,1056,'2021-01-18','product','2SUR1100041491',41491,'Tablets',12,'Super Tablet',1,1991.00,'2SUR11'),
(1,1090,'2021-02-24','product','3ADA0100004335',4335,'Washer',15,'Washer',5,500.00,'3ADA01'),
(3,1034,'2021-01-14','product','3BRI3505804084',5804084,'Washer',15,'Washer',3,504.69,'3BRI35'),
(3,1051,'2021-01-18','product','3DAE0106096009',6096009,'Washer',15,'Washer',3,553.95,'3DAE01');

INSERT INTO item  (item_type, item_name, item_modelno, item_barcode
                  , item_uri, item_size, item_uom, item_price
                  , image_uri, item_status, m_id)
SELECT item_type, CONCAT(m.man_name,' - ',item_name_new), item_modelno, item_barcode
       , NULL, 1, 'Unit', item_price
       , NULL, 'Available', z.m_id
FROM z__orders_items_csv z JOIN manufacturer m ON z.m_id=m.m_id
GROUP BY item_type, CONCAT(m.man_name,' - ',item_name_new), item_modelno, item_barcode, item_price, m_id;

SELECT i.i_id, i.item_type, i.item_name, i.item_modelno, i.item_barcode, i.item_uri
      , i.item_size, i.item_uom, i.item_price, i.item_uri, i.item_status, i.m_id
      , i.user_id, i.date_mod, i.active
FROM item i;

-- Table: item_price ------------------------------------------------
DROP TABLE IF EXISTS item_price;
CREATE TABLE IF NOT EXISTS item_price (
    ip_id BIGINT  AUTO_INCREMENT 
  , ip_beg  DATETIME NOT NULL
  , ip_end  DATETIME  
  , i_id  BIGINT  -- FK
  , ip_price  DECIMAL (9,2)
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (ip_id)
);
  
TRUNCATE TABLE item_price;
INSERT INTO item_price (ip_beg, ip_end, i_id, ip_price)
VALUES ('2022-01-05 10:11:35', NULL, 1, 5.22)
FROM item i
    LEFT JOIN item_price ON i.i_id = ip.i_id;

SELECT ip.ip_id, ip.ip_beg, ip.ip_end, ip.i_id, ip.ip_price
    , ip.user_id, ip.date_mod, ip.active
FROM item_price ip;


-- Table: item_meta -------------------------------------------------
DROP TABLE IF EXISTS item_meta;
CREATE TABLE IF NOT EXISTS item_meta (
    im_id BIGINT AUTO_INCREMENT 
  , i_id  BIGINT -- FK
  , im_desc TEXT
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (im_id)
);
  
TRUNCATE TABLE item_meta;
INSERT INTO item_meta (i_id, im_desc)
VALUES (1, 'Hair dryer with absoluteHeat Intellegent');

SELECT im_id, i_id, im_desc, user_id, date_mod, active
FROM item_meta;


-- Table: item_detail -----------------------------------------------
DROP TABLE IF EXISTS item_detail;
CREATE TABLE IF NOT EXISTS item_detail (
    id_id BIGINT AUTO_INCREMENT 
  , i_id  BIGINT -- FK
  , id_label  VARCHAR(50)
  , id_detail VARCHAR(50)
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (id_id)
);
  
TRUNCATE TABLE item_detail;
INSERT INTO item_detail (i_id, id_label, id_detail)
VALUES (1, 'Height', '30cm');

SELECT id_id, i_id, id_label, id_detail, user_id, date_mod, active
FROM item_detail;


-- Table: item_category ---------------------------------------------
DROP TABLE IF EXISTS item_category;
CREATE TABLE IF NOT EXISTS item_category (
    ic_id BIGINT AUTO_INCREMENT 
  , i_id BIGINT -- FK
  , cat_id MEDIUMINT 
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY(ic_id)
);
  
TRUNCATE TABLE item_category;
INSERT INTO item_category (i_id, cat_id)
VALUES (1, 1);

SELECT ic_id, i_id, cat_id, user_id, date_mod, active
FROM item_category;


-- Table: tax -------------------------------------------------------
DROP TABLE IF EXISTS tax;
CREATE TABLE IF NOT EXISTS tax (
    tax_id  SMALLINT AUTO_INCREMENT
  , tax_type  CHAR(3)
  , tax_beg DATE    
  , tax_end DATE    
  , tax_perc  DECIMAL (4,2)
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (tax_id)
);
  
TRUNCATE TABLE tax;
INSERT INTO tax (tax_type, tax_beg, tax_end, tax_perc)
VALUES ('GST', '2017-02-16', NULL, 5.00)
      ,('PST', '2016-02-16', NULL, 7.00);

SELECT tax_id, tax_type, tax_beg, tax_end, tax_perc 
      , user_id, date_mod, active
FROM tax;

-- Table: orders ----------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
    o_id  BIGINT  AUTO_INCREMENT 
  , order_num INT 
  , order_date  DATETIME  
  , order_notes TEXT  
  , order_credit  DECIMAL (7,2)
  , order_cr_uom  CHAR(1)
  , p_id  INT -- FK
  , t_id  BIGINT  
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (o_id)
);
  
TRUNCATE TABLE orders;
INSERT INTO orders (order_num, order_date, order_notes, order_credit
                  , order_cr_uom, p_id, t_id)
VALUES (6, '2022_01-14 11:11:11', 'Should be delivered on time'
      , 25.24, '$', 1, 1);

SELECT order_num, order_date, order_notes, order_credit
      , order_cr_uom, p_id, t_id 
      , user_id, date_mod, active
FROM orders;

SELECT p.p_id, p.first_name, p.last_name, p.ph_cell
  , o.order_num, o.order_date, o.order_notes
  , i.item_modelno, i.item_name, i.item_price, ip.ip_price
FROM people p
  JOIN orders o ON p.p_id = o.p_id
  JOIN orders_item oi ON o.o_id = oi.o_id
  JOIN item i ON oi.i_id = i.i_id
  JOIN item_price ip ON i.i_id = ip.i_id;

-- Table: orders_item -----------------------------------------------
DROP TABLE IF EXISTS orders_item;
CREATE TABLE IF NOT EXISTS orders_item (
    oi_id BIGINT  AUTO_INCREMENT 
  , o_id  BIGINT -- FK
  , i_id  BIGINT  -- FK
  , oi_return_date  DATETIME  
  , oi_status VARCHAR(25)
  , oi_qty  SMALLINT  
  , oi_override DECIMAL (9,2)
  , user_id INT NOT NULL DEFAULT 2
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (oi_id)
);
  
TRUNCATE TABLE orders_item;
INSERT INTO orders_item (o_id, i_id, oi_return_date, oi_status
                  , oi_qty, oi_override)
VALUES (1, 1, '2022_01-14 11:11:11', 'replacements'
      , 35, 22.90);

SELECT oi_id, o_id, i_id, oi_return_date, oi_status, oi_qty, oi_override
      , user_id, date_mod, active
FROM orders_item;

DROP TABLE z__orders_items_csv;


-- Table: transactions ----------------------------------------------
DROP TABLE IF EXISTS transactions;
CREATE TABLE IF NOT EXISTS transactions (
    t_id  BIGINT  AUTO_INCREMENT 
  , t_num CHAR(20)
  , t_date  DATETIME  
  , t_mid CHAR(15)
  , t_acct  BIGINT  
  , t_type  CHAR(2)
  , t_amount  DECIMAL (7,2)
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (t_id)
);
TRUNCATE TABLE transactions;
INSERT INTO transactions (t_num, t_date, t_mid
            , t_acct, t_type, t_amount)
VALUES ('T2045678965', '2022-02-22 09:45:45', 'Visa'
      , 2033456745674567, 'CR', 1000.14);

SELECT t_id, t_num, t_date, t_mid, t_acct, t_type, t_amount 
      , user_id, date_mod, active
FROM transactions;

SELECT o.order_num, o.order_date, i.item_name, i.item_price
    , oi.oi_qty * tax.tax_calc, tx.t_amount
FROM orders o
  JOIN orders_transaction otx ON o.o_id = otx.o_id
  JOIN transactions tx ON tx.t_id = otx.t_id
  JOIN orders_item oi ON o.o_id = oi.o_id
  JOIN item i ON i.i_id = oi.i_id
  JOIN (SELECT (SUM(tax_perc)/100)+1 AS tax_calc
    FROM tax t
    WHERE t.tax_end IS NULL AND tax_beg <= NOW()) tax;

-- Table: orders_transaction ----------------------------------------
DROP TABLE IF EXISTS orders_transaction;
CREATE TABLE IF NOT EXISTS orders_transaction (
    ot_id BIGINT AUTO_INCREMENT 
  , o_id  BIGINT -- FK
  , t_id  BIGINT -- FK
  , p_id  INT -- FK
  , user_id INT NOT NULL DEFAULT 2 -- FK
  , date_mod DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  , active BIT NOT NULL DEFAULT 1
  , PRIMARY KEY (ot_id)
);
  
TRUNCATE TABLE orders_transaction;
INSERT INTO orders_transaction (o_id, t_id, p_id)
VALUES (1, 1, 1);

SELECT o_id, t_id, p_id, user_id, date_mod, active
FROM orders_transaction;
--------------------------------------------------------------------- 

-- people_employee pe
ALTER TABLE people_employee DROP CONSTRAINT pe_p_id_FK;
ALTER TABLE people_employee
ADD CONSTRAINT pe_p_id_FK FOREIGN KEY (p_id) REFERENCES people(p_id);


-- Unique Key UK
ALTER TABLE people DROP CONSTRAINT p_email_UK;
ALTER TABLE people ADD CONSTRAINT p_email_UK UNIQUE (email);

-- Check Constraint
ALTER TABLE people DROP CONSTRAINT p_addr_ph_email_CK;
ALTER TABLE people ADD CONSTRAINT p_addr_ph_email_CK CHECK (
addr IS NOT NULL OR ph_cell IS NOT NULL OR email IS NOT NULL
);

    







































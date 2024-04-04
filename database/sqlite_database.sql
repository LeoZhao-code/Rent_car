CREATE TABLE IF NOT EXISTS UserAccounts (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    is_staff BOOLEAN NOT NULL DEFAULT 0,
    is_superuser BOOLEAN NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS Customers (
    customer_number INT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    address VARCHAR(255),
    phone_number VARCHAR(20),

    FOREIGN KEY (user_id) REFERENCES UserAccounts(user_id)
);


CREATE TABLE IF NOT EXISTS Staff (
    staff_number INT PRIMARY KEY,
    user_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    address VARCHAR(50),
    phone_number VARCHAR(20),

    FOREIGN KEY (user_id) REFERENCES UserAccounts(user_id)
);


CREATE TABLE IF NOT EXISTS Location (
    location_id INT PRIMARY KEY,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cars (
    car_id INT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    fuel_type VARCHAR(50) NOT NULL,
    transmission VARCHAR(50) NOT NULL,
    seating_capacity INT NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL,
    rental_price INT NOT NULL,
    registration_number VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
    location INT NOT NULL,
    image_url VARCHAR(255) NOT NULL DEFAULT " ",

    FOREIGN KEY (location) REFERENCES Location(location_id)
);


-- INSERT INTO UserAccounts (username, email, password, is_superuser)
--     VALUES('admin', 'admin@admin.com', '$2b$12$rZ/oMfPkT9q16IWgGJ9n6.e5xynS7f9elfPmPiR.TbEBo2yTkc2Dq', 1);
-- admin/adminpassword


INSERT INTO `Cars` VALUES (1,'KIA','EV-6',2023,'Electric','Automatic',5,'SUV',120,'10UVH0','Silver',3,'../static/image/slider-ev1.jpg'),(2,'Porsche','718',2023,'Gasoline','Automatic',4,'Convertible',210,'24SY00','White',3,'../static/image/718-spyder.jpg'),(3,'Mercedes-Benz','GLC',2023,'Gasoline','Automatic',5,'SUV',210,'WQ340','Blue',3,'../static/image/benz-GLC.png'),(4,'BMW','iX3',2023,'Electric','Automatic',5,'SUV',200,'12J4A','Black',3,'../static/image/BMW-iX3.png'),(5,'Audi','A8',2023,'Gasoline','Automatic',5,'Sedan',220,'134HG5','Silver',1,'../static/image/Audi-A8.png'),(6,'Chevrolet','Impala',2019,'Gasoline','Automatic',5,'Sedan',293,'7EH48','Black',13,'../static/image/2018-chevrolet-impala.jpg'),(7,'Toyota','Corolla',2012,'Electric','Manual',5,'Sedan',263,'9EG49H','Red',16,'../static/image/2012-Toyota-Corolla.png'),(8,'Nissan','Murano',2014,'Gasoline','Manual',4,'Convertible',157,'5HMRX','Silver',11,'../static/image/2014-Nissan-Murano.png'),(9,'Mercedes-Benz','C-Class',2017,'Gasoline','Manual',4,'Convertible',126,'25EIF1','Silver',14,'../static/image/2017-e-cabriolet.jpg'),(10,'Chevrolet','Camaro',2018,'Electric','Manual',4,'Convertible',262,'8QOPF','Orange',11,'../static/image/camaro22.jpeg'),(11,'Toyota','C-HR',2017,'Gasoline','Manual',5,'SUV',254,'8AYJ4','White',14,'../static/image/2017_Toyota_C-HR.jpg'),(12,'Honda','WR-V',2022,'Electric','Manual',5,'SUV',240,'17DQ8','White',13,'../static/image/Honda_SUV_RS.jpg'),(13,'BMW','X1',2016,'Gasoline','Automatic',5,'SUV',266,'AK866','Black',1,'../static/image/2018_BMW_X1.jpg'),(14,'Chevrolet','Camaro',2016,'Electric','Manual',5,'Convertible',135,'R6841','Blue',2,'../static/image/Chevrolet_Camaro.jpg'),(15,'KIA','Rio',2019,'Gasoline','Manual',5,'Convertible',291,'UIGH5','White',8,'../static/image/2019_Kia_Rio.jpg'),(16,'Chevrolet','Captiva',2011,'Electric','Automatic',5,'SUV',113,'70422','Silver',8,'../static/image/Chevrolet_Captiva.jpg'),(17,'Chevrolet','Cobalt',2017,'Electric','Manual',5,'Sedan',211,'4NY28','White',11,'../static/image/Chevrolet_Cobalt.jpg'),(18,'Honda','Accord',2021,'Gasoline','Automatic',5,'Sedan',142,'7H80Q','White',5,'../static/image/2021_Honda_Accord.jpg'),(19,'BMW','M4',2021,'Electric','Automatic',5,'Convertible',286,'1OH33','Blue',2,'../static/image/BMW_M4_CS.jpg'),(20,'Toyota','Highlander',2019,'Electric','Manual',5,'SUV',205,'GYU36','Silver',8,'../static/image/Toyota_Highlander.jpg');
INSERT INTO `Customers` VALUES (1,5,'Emily','Johnson','2023-08-01','Lincoln','0200000000'), (2,6,'Liam','Anderson','2023-07-31','Hornby','0200000000'), (3,7,'Olivia','Williams','2023-07-31','Yaldhurst','0200000000'),(4,8,'Noah','Martinez','2023-06-27','West Melton','0200000000'), (5,9,'Ava','Thompson','2023-06-09','Lyttelton','0200000000');
INSERT INTO `Location` VALUES (1,'Auckland'),(2,'Wellington'),(3,'Christchurch'),(4,'Hamilton'),(5,'Tauranga'),(6,'Dunedin'),(7,'Hastings'),(8,'Palmerston North'),(9,'Napier'),(10,'Gisborne'),(11,'Rotorua'),(12,'New Plymouth'),(13,'Nelson'),(14,'Taupo'),(15,'Blenheim'),(16,'Port Vila');
INSERT INTO `Staff` VALUES (1,2,'Ethan','Davis','2023-08-03','Rolleston','0200000000'), (2,3,'Mia','Clark','2023-07-31','Lincoln','0200000000'), (3,4,'Oliver','Wilson','2023-08-03','Prebbleton','0200000000');
INSERT INTO `UserAccounts` VALUES (1,'admin','admin@sample.com','$2b$12$Qv0F8LyPgXLHkEMk/FI9dO64h0cB2r.ldHlakiDGQyMU0PMsutO4K',0,1), (2,'staff1','staff1@sample.com','$2b$12$i4.By/Wxkh1m50/yhwnMOe.IydbXE7bXo2SyhCXTQTJTjrKtqbqpG',1,0),(3,'staff2','staff2@sample.com','$2b$12$lb3cditBsI55XN789H0s1eQyj8g50J3JrS5PxD288NoBzjU.MFr3O',1,0), (4,'staff3','staff3@sample.com','$2b$12$aMKH5ROQProYjhaUAXwv6uUP/cupJv6VBgDf2jTMkVs0AWChgnP6m',1,0), (5,'customer1','customer1@sample.com','$2b$12$wdXmsr/QRlrORe7JX3o8reUSO8bioOqpDdnbwtM69G/xFhTsjHqNe',0,0), (6,'customer2','customer2@sample.com','$2b$12$QGl9VMGNCHScIhHwDRZ/6.Qzed2IT4Ml0rYMdKKQ2ibMWr6uEsbNO',0,0), (7,'customer3','customer3@sample.com','$2b$12$qFeL8NbZ9ypTDZ98.lqWDOAO9k3ZVysGqurJTv5ZnujqcghYgohmK',0,0), (8,'customer4','customer4@sample.com','$2b$12$Fn04kY4pDR6Sd8i7nQk3LeD/gACTxriwRpCIrUWgfMuuInkoj0O/i',0,0), (9,'customer5','customer5@sample.com','$2b$12$RyMsroENCEjjsDGof1TG6uUKT8ZNhPiklFW2IFHrOFgjwx/bzft3C',0,0);

CREATE TABLE IF NOT EXISTS UserAccounts (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    is_staff BOOLEAN NOT NULL DEFAULT 0,
    is_superuser BOOLEAN NOT NULL DEFAULT 0
);


CREATE TABLE IF NOT EXISTS Customers (
    customer_number INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    address VARCHAR(255),
    phone_number VARCHAR(20),

    FOREIGN KEY (user_id) REFERENCES UserAccounts(user_id)


CREATE TABLE IF NOT EXISTS Staff (
    staff_number INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birthdate DATE,
    address VARCHAR(50),
    phone_number VARCHAR(20),

    FOREIGN KEY (user_id) REFERENCES UserAccounts(user_id)
);


CREATE TABLE IF NOT EXISTS Location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cars (
    car_id INT PRIMARY KEY AUTO_INCREMENT,
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


INSERT INTO UserAccounts (username, email, password, is_superuser)
    VALUES('admin', 'admin@admin.com', '$2b$12$rZ/oMfPkT9q16IWgGJ9n6.e5xynS7f9elfPmPiR.TbEBo2yTkc2Dq', 1);
-- admin/adminpassword

INSERT INTO Location (city) VALUES
("Auckland"),
("Wellington"),
("Christchurch"),
("Hamilton"),
("Tauranga"),
("Dunedin"),
("Hastings"),
("Palmerston North"),
("Napier"),
("Gisborne"),
("Rotorua"),
("New Plymouth"),
("Nelson"),
("Taupo"),
("Blenheim"),
("Port Vila");


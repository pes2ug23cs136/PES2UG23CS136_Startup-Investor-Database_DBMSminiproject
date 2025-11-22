CREATE DATABASE startup_investment_db;
USE startup_investment_db;

CREATE TABLE Founder (
    founder_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    founded_year INT,
    email VARCHAR(100),
    f_address VARCHAR(255)
);

CREATE TABLE Mentor (
    mentor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    expertise VARCHAR(100)
);

CREATE TABLE Startup (
    startup_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    valuation DECIMAL(15,2),
    founded_year INT,
    s_address VARCHAR(255),
    industry VARCHAR(100),
    founder_id INT,
    mentor_id INT,
    FOREIGN KEY (founder_id) REFERENCES Founder(founder_id),
    FOREIGN KEY (mentor_id) REFERENCES Mentor(mentor_id)
);

CREATE TABLE Accelerator (
    accelerator_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    focus_area VARCHAR(100),
    location VARCHAR(100),
    startup_id INT,
    FOREIGN KEY (startup_id) REFERENCES Startup(startup_id)
);

CREATE TABLE Funding_Round (
    round_id INT PRIMARY KEY AUTO_INCREMENT,
    round_type VARCHAR(50),
    amount DECIMAL(15,2),
    round_date DATE,
    startup_id INT,
    founder_id INT,
    FOREIGN KEY (startup_id) REFERENCES Startup(startup_id),
    FOREIGN KEY (founder_id) REFERENCES Founder(founder_id)
);


CREATE TABLE Investor (
    investor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    investor_focus VARCHAR(100),
    l_address VARCHAR(255),
    DOB DATE,
    investor_age INT AS (TIMESTAMPDIFF(YEAR, DOB, CURDATE())) VIRTUAL,
    startup_id INT,
    round_id INT,
    FOREIGN KEY (startup_id) REFERENCES Startup(startup_id),
    FOREIGN KEY (round_id) REFERENCES Funding_Round(round_id)
);

CREATE TABLE Investment (
    investment_id INT PRIMARY KEY AUTO_INCREMENT,
    amount_invested DECIMAL(15,2),
    equity_percent DECIMAL(5,2),
    round_id INT,
    investor_id INT,
    FOREIGN KEY (round_id) REFERENCES Funding_Round(round_id),
    FOREIGN KEY (investor_id) REFERENCES Investor(investor_id)
);

CREATE TABLE Invests_In (
    startup_id INT,
    investor_id INT,
    round_id INT,
    investment_id INT,
    PRIMARY KEY (startup_id, investor_id, round_id, investment_id),
    FOREIGN KEY (startup_id) REFERENCES Startup(startup_id),
    FOREIGN KEY (investor_id) REFERENCES Investor(investor_id),
    FOREIGN KEY (round_id) REFERENCES Funding_Round(round_id),
    FOREIGN KEY (investment_id) REFERENCES Investment(investment_id)
);
CREATE TABLE Founder_Phone (
    founder_id INT,
    phone_no VARCHAR(20),
    PRIMARY KEY (founder_id, phone_no),
    FOREIGN KEY (founder_id) REFERENCES Founder(founder_id)
);
CREATE TABLE Mentor_Phone (
    mentor_id INT,
    phone_no VARCHAR(20),
    PRIMARY KEY (mentor_id, phone_no),
    FOREIGN KEY (mentor_id) REFERENCES Mentor(mentor_id)
);

-- DML Statements --
INSERT INTO Founder (name, founded_year, email, f_address)
VALUES 
('Ramesh Kumar', 2015, 'ramesh.kumar@gmail.com', 'Bengaluru, Karnataka'),
('Anita Sharma', 2018, 'anita.sharma@gmail.com', 'Hyderabad, Telangana'),
('Kiran Patel', 2020, 'kiran.patel@gmail.com', 'Ahmedabad, Gujarat'),
('Priya Verma', 2019, 'priya.verma@gmail.com', 'Chennai, Tamil Nadu');

INSERT INTO Mentor (name, email, phone, expertise)
VALUES
('Dr. Rajesh Mehta', 'rajesh.mehta@gmail.com', '9876543210', 'AI & Machine Learning'),
('Sneha Kapoor', 'sneha.kapoor@gmail.com', '9876500011', 'Marketing & Branding'),
('Amit Tiwari', 'amit.tiwari@gmail.com', '9008765432', 'Finance & Investment');

INSERT INTO Startup (name, valuation, founded_year, s_address, industry, founder_id, mentor_id)
VALUES
('TechNova', 5000000, 2017, 'Koramangala, Bengaluru', 'Software', 1, 1),
('AgroLink', 3500000, 2019, 'Jubilee Hills, Hyderabad', 'Agritech', 2, 2),
('MediCarePlus', 4200000, 2018, 'Andheri, Mumbai', 'Healthcare', 3, 3),
('EduSmart', 2500000, 2020, 'T. Nagar, Chennai', 'EdTech', 4, 2);

INSERT INTO Funding_Round (round_type, amount, round_date, startup_id, founder_id)
VALUES
('Seed', 800000, '2021-03-15', 1, 1),
('Series A', 1500000, '2022-06-21', 2, 2),
('Series B', 2500000, '2023-04-05', 3, 3),
('Pre-Seed', 400000, '2020-09-10', 4, 4);

INSERT INTO Investor (name, investor_focus, l_address, DOB, startup_id, round_id)
VALUES
('VentureCraft Capital', 'Fintech & SaaS', 'Whitefield, Bengaluru', '1982-09-12', 1, 1),
('NextGen Ventures', 'Healthcare', 'Banjara Hills, Hyderabad', '1975-11-30', 2, 2),
('Skyline Partners', 'EdTech', 'Powai, Mumbai', '1988-02-22', 3, 3),
('Vision Growth Fund', 'Agritech', 'Anna Nagar, Chennai', '1980-07-15', 4, 4);

INSERT INTO Accelerator (name, focus_area, location, startup_id)
VALUES
('LaunchPad Labs', 'AI & Machine Learning', 'Bengaluru', 1),
('AgriBoost', 'Sustainable Agriculture', 'Hyderabad', 2),
('HealthXcelerate', 'HealthTech', 'Mumbai', 3),
('EduLift', 'Educational Technology', 'Chennai', 4);

INSERT INTO Investor_Phone (investor_id, phone_no)
VALUES
(1, '9876001234'),
(2, '9998801122'),
(3, '8887703344'),
(4, '7776612233');

-- PROCEDURES --
 
-- 1) --
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_startup_with_founder`(
  IN p_startup_name VARCHAR(100),
  IN p_industry VARCHAR(100),
  IN p_founded_year INT,
  IN p_valuation DECIMAL(15,2),
  IN p_address VARCHAR(255),
  IN p_founder_name VARCHAR(100),
  IN p_founder_email VARCHAR(100),
  IN p_founder_address VARCHAR(255)
)
BEGIN
  DECLARE new_founder_id INT;

  -- Insert Founder (your Founder table has: name, founded_year, email, f_address)
  INSERT INTO Founder(name, founded_year, email, f_address)
  VALUES (p_founder_name, p_founded_year, p_founder_email, p_founder_address);

  SET new_founder_id = LAST_INSERT_ID();

  -- Insert Startup (your Startup table has: name, industry, founded_year, valuation, s_address, founder_id)
  INSERT INTO Startup(name, industry, founded_year, valuation, s_address, founder_id)
  VALUES (p_startup_name, p_industry, p_founded_year, p_valuation, p_address, new_founder_id);

END

-- 2) --

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_total_funding`(IN p_startup_id INT)
BEGIN
  SELECT s.name AS startup_name, SUM(f.amount) AS total_funding
  FROM STARTUP s
  JOIN FUNDING_ROUND f ON s.startup_id = f.startup_id
  WHERE s.startup_id = p_startup_id
  GROUP BY s.startup_id;
END 

-- 3)--
CREATE DEFINER=`root`@`localhost` PROCEDURE `record_investment`(
  IN p_investor_id INT,
  IN p_startup_id INT,
  IN p_round_id INT,
  IN p_amount DECIMAL(15,2),
  IN p_equity DECIMAL(5,2)
)
BEGIN
  INSERT INTO INVESTMENT(investor_id, startup_id, round_id, amount_invested, equity_percent)
  VALUES (p_investor_id, p_startup_id, p_round_id, p_amount, p_equity);
  
  UPDATE FUNDING_ROUND
  SET amount = amount + p_amount
  WHERE round_id = p_round_id;
END

-- FUNCTIONS --

 -- 1) --
 CREATE DEFINER=`root`@`localhost` FUNCTION `get_investor_age`(dob DATE) RETURNS int
    DETERMINISTIC
BEGIN
  RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END

-- 2) --

CREATE DEFINER=`root`@`localhost` FUNCTION `get_startup_age`(founded_year INT) RETURNS int
    DETERMINISTIC
BEGIN
  RETURN YEAR(CURDATE()) - founded_year;
END

-- TRIGGERS --

-- 1) --
DELIMITER $$

CREATE TRIGGER trg_investor_age
BEFORE INSERT ON Investor
FOR EACH ROW
BEGIN
    -- Calculate age based on DOB
    IF NEW.DOB IS NOT NULL THEN
        SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.DOB, CURDATE());
    END IF;
END $$

DELIMITER ;

-- 2) --
DELIMITER $$

CREATE TRIGGER trg_update_startup_valuation
AFTER INSERT ON Funding_Round
FOR EACH ROW
BEGIN
    -- Update startup valuation by adding newly funded amount
    UPDATE Startup
    SET valuation = valuation + NEW.amount
    WHERE startup_id = NEW.startup_id;
END $$

DELIMITER ;

-- 3) --
DELIMITER $$

CREATE TRIGGER trg_check_valuation
BEFORE UPDATE ON Startup
FOR EACH ROW
BEGIN
    -- Prevent negative or zero valuation
    IF NEW.valuation <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Valuation must be greater than zero.';
    END IF;
END $$

DELIMITER ;

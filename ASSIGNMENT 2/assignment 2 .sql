CREATE TABLE Route (
    RouteNumber VARCHAR2(10) PRIMARY KEY,
    Origin VARCHAR2(50) NOT NULL,
    Destination VARCHAR2(50) NOT NULL,
    EstimatedDepartureTime TIMESTAMP,
    EstimatedArrivalTime TIMESTAMP
);
SELECT * FROM Route;

CREATE TABLE Bus (
    BusID VARCHAR(10) PRIMARY KEY,
    RegistrationNumber VARCHAR(20) NOT NULL,
    Make VARCHAR(50) NOT NULL,
    Model VARCHAR(50),
    Year INT,
    Capacity INT,
    ScheduledServiceDate DATE
);
SELECT * FROM Bus;

CREATE TABLE Staff (
    StaffID VARCHAR(10) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    ContactPhone VARCHAR(20) NOT NULL,
    Role VARCHAR(50)
);
SELECT * FROM Staff;

CREATE TABLE Journey (
    JourneyID VARCHAR2(10) PRIMARY KEY,
    JourneyDate DATE NOT NULL,
    RemainingCapacity INT,
    RouteNumber VARCHAR2(10),
    BusID VARCHAR2(10),
    ActualDepartureTime TIMESTAMP,
    ActualArrivalTime TIMESTAMP,
    FOREIGN KEY (RouteNumber) REFERENCES Route(RouteNumber),
    FOREIGN KEY (BusID) REFERENCES Bus(BusID)
);
SELECT * FROM Journey;

CREATE TABLE ServiceRecord (
    ServiceNumber VARCHAR(10) PRIMARY KEY,
    BusID VARCHAR(10),
    StaffID VARCHAR(10),
    ServiceRecordDate DATE NOT NULL,
    Description VARCHAR(100),
    Scheduled VARCHAR(10),
    Location VARCHAR(50),
    SupervisorFullName VARCHAR(100),
    SupervisorContactPhone VARCHAR(20),
    FOREIGN KEY (BusID) REFERENCES Bus(BusID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);
SELECT * FROM ServiceRecord;

CREATE TABLE Customer (
    CustomerID VARCHAR(10) PRIMARY KEY,
    ContactPhone VARCHAR(20) NOT NULL,
    Name VARCHAR(100)
);
SELECT * FROM Customer;

CREATE TABLE Booking (
    BookingID VARCHAR(10) PRIMARY KEY,
    JourneyID VARCHAR(10),
    CustomerID VARCHAR(10),
    BookingDate DATE,
    Fare FLOAT,
    PaymentMethod VARCHAR(20),
    CreditCardNo VARCHAR(16),
    ExpirationDate DATE,
    FOREIGN KEY (JourneyID) REFERENCES Journey(JourneyID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
SELECT * FROM Booking;

CREATE TABLE StaffAssign (
    StaffAssignID VARCHAR(10) PRIMARY KEY,
    JourneyID VARCHAR(10),
    StaffID VARCHAR(10),
    Role VARCHAR(50),
    FOREIGN KEY (JourneyID) REFERENCES Journey(JourneyID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);
SELECT * FROM StaffAssign;



---------------------------------------------------------------------------------------------------
-- Populate the Route table
INSERT INTO Route (RouteNumber, Origin, Destination, EstimatedDepartureTime, EstimatedArrivalTime)
VALUES ('OWE201', 'Perth', 'Albany', TIMESTAMP '2023-07-29 07:00:00', TIMESTAMP '2023-07-29 14:00:00');

SELECT * FROM Route;
-- Populate the Bus table
INSERT INTO Bus (BusID, RegistrationNumber, Make, Model, Year, Capacity, ScheduledServiceDate)
VALUES ('133-313', 'ABC123', 'Volvo', 'B11R', 2011, 55, DATE '2023-07-29');

SELECT * FROM Bus;
-- Populate the Staff table
INSERT INTO Staff (StaffID, FullName, ContactPhone, Role)
SELECT '1', 'Brock Lee', '1234567890', 'Driver' FROM DUAL UNION ALL
SELECT '2', 'Dinah Soares', '1234567891', 'Assistant' FROM DUAL UNION ALL
SELECT '3', 'Les Moore', '1234567892', 'Technician' FROM DUAL UNION ALL
SELECT '4', 'Anna Conda', '1234567893', 'Attendant' FROM DUAL UNION ALL
SELECT '5', 'Kerry Oki', '1234567894', 'Attendant' FROM DUAL;
SELECT * FROM Staff;

-- Populate the Customer table
INSERT INTO Customer (CustomerID, ContactPhone, Name)
SELECT '1', '9876543210', 'Jane Smith' FROM DUAL;
SELECT * FROM Customer;

-- Populate the Booking table
INSERT INTO Booking (BookingID, JourneyID, CustomerID, BookingDate, Fare, PaymentMethod)
VALUES ('1', '1', '1', DATE '2023-07-29', 50.00, 'Cash');
SELECT * FROM Booking;

-- Populate the Journey table
INSERT INTO Journey (JourneyID, JourneyDate, RemainingCapacity, RouteNumber, BusID, ActualDepartureTime, ActualArrivalTime)
VALUES ('1', DATE '2023-07-29', 55, 'OWE201', '133-313', TIMESTAMP '2023-07-29 07:15:00', TIMESTAMP '2023-07-29 15:00:00');
SELECT * FROM Journey;

-- Populate the ServiceRecord table
INSERT INTO ServiceRecord (ServiceNumber, BusID, StaffID, ServiceRecordDate, Description, Scheduled, Location, SupervisorFullName, SupervisorContactPhone)
VALUES ('1', '133-313', '3', DATE '2023-07-30', 'Scheduled service', 'Scheduled', 'Busselton depot', 'Clay Mann', '1234567895');
SELECT * FROM ServiceRecord;

-- Populate the StaffAssign table
INSERT INTO StaffAssign (StaffAssignID, JourneyID, StaffID, Role)
SELECT '1', '1', '1', 'Driver' FROM DUAL UNION ALL
SELECT '2', '1', '2', 'Assistant' FROM DUAL UNION ALL
SELECT '3', '1', '3', 'Technician' FROM DUAL UNION ALL
SELECT '4', '1', '4', 'Attendant' FROM DUAL UNION ALL
SELECT '5', '1', '5', 'Attendant' FROM DUAL;
SELECT * FROM StaffAssign;
COMMIT;
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
CREATE VIEW ViewA AS
SELECT B.JourneyID, B.CustomerID, C.Name, J.ActualDepartureTime, J.ActualArrivalTime,
       J.ActualArrivalTime - J.ActualDepartureTime AS JourneyDuration
FROM Booking B
JOIN Customer C ON B.CustomerID = C.CustomerID
JOIN Journey J ON B.JourneyID = J.JourneyID
WHERE C.Name = 'Jane Smith';

SELECT * FROM ViewA;


CREATE VIEW ViewB AS
SELECT J.RouteNumber, J.JourneyDate, J.RemainingCapacity
FROM Journey J
WHERE J.RouteNumber = 'OWE201' AND J.JourneyDate = DATE '2023-07-29';

SELECT * FROM ViewB;

CREATE VIEW ViewC AS
SELECT S.StaffID, S.FullName, SUM(EXTRACT(HOUR FROM J.ActualArrivalTime - J.ActualDepartureTime)) AS TotalHoursCovered
FROM StaffAssign SA
JOIN Staff S ON SA.StaffID = S.StaffID
JOIN Journey J ON SA.JourneyID = J.JourneyID
WHERE J.RouteNumber = 'OWE201' AND J.JourneyDate = DATE '2023-07-29'
GROUP BY S.StaffID, S.FullName;

SELECT * FROM ViewC;

CREATE VIEW ViewD AS
SELECT S.StaffID, S.FullName, SA.Role,
       SUM(EXTRACT(HOUR FROM J.ActualArrivalTime - J.ActualDepartureTime)) AS TotalHoursDriven
FROM StaffAssign SA
JOIN Staff S ON SA.StaffID = S.StaffID
JOIN Journey J ON SA.JourneyID = J.JourneyID
WHERE J.RouteNumber = 'OWE201' AND J.JourneyDate = DATE '2023-07-29'
GROUP BY S.StaffID, S.FullName, SA.Role;

SELECT * FROM ViewD;

CREATE VIEW ViewE AS
SELECT SR.ServiceRecordDate, SR.Location, SR.Scheduled, SR.SupervisorFullName, SR.SupervisorContactPhone
FROM ServiceRecord SR
JOIN Bus B ON SR.BusID = B.BusID
WHERE B.BusID = '133-313';

SELECT * FROM ViewE;

-- Table: Route
GRANT SELECT, UPDATE, DELETE ON Route TO MARKERTL;

-- Table: Bus
GRANT SELECT, UPDATE, DELETE ON Bus TO MARKERTL;

-- Table: Staff
GRANT SELECT, UPDATE, DELETE ON Staff TO MARKERTL;

-- Table: Journey
GRANT SELECT, UPDATE, DELETE ON Journey TO MARKERTL;

-- Table: ServiceRecord
GRANT SELECT, UPDATE, DELETE ON ServiceRecord TO MARKERTL;

-- Table: Customer
GRANT SELECT, UPDATE, DELETE ON Customer TO MARKERTL;

-- Table: Booking
GRANT SELECT, UPDATE, DELETE ON Booking TO MARKERTL;

-- Table: StaffAssign
GRANT SELECT, UPDATE, DELETE ON StaffAssign TO MARKERTL;

-- View: ViewA
GRANT SELECT ON ViewA TO MARKERTL;

-- View: ViewB
GRANT SELECT ON ViewB TO MARKERTL;

-- View: ViewC
GRANT SELECT ON ViewC TO MARKERTL;

-- View: ViewD
GRANT SELECT ON ViewD TO MARKERTL;

-- View: ViewE
GRANT SELECT ON ViewE TO MARKERTL;


Commit;
-------------------------------------------------------------------------------------
--DROP TABLE Route;
--DROP TABLE Bus;
--DROP TABLE Staff;
--DROP TABLE Journey;
--DROP TABLE ServiceRecord;
--DROP TABLE Customer;
--DROP TABLE Booking;
--DROP TABLE StaffAssign;
--เริ่มจาก Master สร้างฐานข้อมูล CSMimimart--
Create Database CSminimart
--ปรับให้ฐานข้อมูลสามารถเพิ่มข้อมูลที่เป็นภาษาไทยได้--
Alter Database CSMinimart collate Thai_CI_AS;
--สร้างตารางเก็บข้อมูลพนักงาน ชื่อ Employees
Create Table Employees (
EmployeeID int identity (1,1) Primary Key,
title varchar (20) null,
fristname varchar (50) not null,
lastname varchar (50) null,
position varchar (50) null,
username varchar (50) Unique,
passwordhash varchar (255) not null,
IsActive bit not null default 1
)


--ทดสอบข้อมูล
INSERT INTO Employees
(title, fristname, lastname, position, username, passwordhash)
VALUES
('นางสาว', 'กาญจนา', 'พวงแก้ว', 'Sale Maneger', 'user1', 'hashed1');
--ทดสอบเรียกข้อมูล
Select * From Employees
--ทดสอบเพิ่มข้อมูลชื่อตัวเอง
INSERT INTO Employees
(title, fristname, lastname, position, username, passwordhash)
VALUES
('นาย', 'รชต', 'หาญจริง', 'Sale Maneger', 'user2', 'hashed2');

--สร้างตาราง
CREATE TABLE Categories (
	CategoryID INT IDENTITY(1,1) PRIMARY KEY,
	CategoryName varchar(50) not null Unique,
	Description varchar(200) null
	);
INSERT INTO Categories(CategoryName, Description)
VALUES('เครื่องดื่ม', 'น้ำดื่ม น้ำผลไม้ ชาและกาแฟ');
INSERT INTO Categories(CategoryName, Description)
VALUES('เครื่องปรุง', 'น้ำตาล');
INSERT INTO Categories(CategoryName, Description)
VALUES('อาหารสำเร็จรูป', 'กะเพราหมูกรอบ');
INSERT INTO Categories(CategoryName, Description)
VALUES('เครื่องสำอาง', 'ครีมทาผิว');
INSERT INTO Categories(CategoryName, Description)
VALUES('เวชภัณฑ์', 'ยาแก้ปวด');

SELECT * From Categories;

Create Table Products (
	ProductID varchar(13) Primary Key,
	ProductName varchar(100) not null,
	UnitPrice decimal(10,2) not null default 0,
	UnitInStock int not null default 0,
	CategoryID int not null,
	Discontinued bit not null default 0,
	Constraint CK_Products_UnitPrice
		Check (UnitPrice >= 0),
	Constraint CK_Products_UnitInStock
		Check (UnitInStock >= 0),
	Constraint FK_Product_Categories
		Foreign Key (CategoryID)
		References Categories(CategoryID)
);

Insert Into Products
	(ProductID, ProductName, UnitPrice, UnitInStock, CategoryID)
Values
('8858757001948', 'โค้ก', 15.00, 290, 1);
Insert Into Products
	(ProductID, ProductName, UnitPrice, UnitInStock, CategoryID)
Values
('8850051019573', 'แก้วเปล่าใส่น้ำแข็ง', 10.00, 20, 1);
Insert Into Products
	(ProductID, ProductName, UnitPrice, UnitInStock, CategoryID)
Values
('8859126002458', 'หงษ์ไทย', 20.00, 10, 1);
Insert Into Products
	(ProductID, ProductName, UnitPrice, UnitInStock, CategoryID)
Values
('8858998581047', 'เป๊บซี่', 19.00, 10, 1);
Insert Into Products
	(ProductID, ProductName, UnitPrice, UnitInStock, CategoryID)
Values
('8858638009283', 'น้ำดื่มเซียโร่', 15.00, 10, 1);


Select * From Products

CREATE TABLE Receipts (
    ReceiptID INT IDENTITY(1,1) PRIMARY KEY,
    ReceiptDate DATETIME NOT NULL DEFAULT GETDATE(),
    EmployeeID INT NOT NULL,
    TotalCash DECIMAL(10,2) NOT NULL DEFAULT 0,
    CONSTRAINT CK_Receipts_TotalCash
        CHECK (TotalCash >= 0),

    CONSTRAINT FK_Receipts_Employees
        FOREIGN KEY (EmployeeID)
        REFERENCES Employees(EmployeeID)
);

--select getdate()

--เพิ่มข้อมูลใน Receipt

-- เพิ่มข้อมูลใบเสร็จ
INSERT INTO Receipts
    (EmployeeID, TotalCash)
VALUES
    (1, 115.00);
-- SQL ข้อมูลผิด (ไม่มี EmployeeID = 99)
INSERT INTO Receipts
    (EmployeeID, TotalCash)
VALUES
    (99, 100.00);
-- แสดงข้อมูลทั้งหมด
SELECT * FROM Receipts;

CREATE TABLE Details (
    ReceiptID INT NOT NULL,
    ProductID VARCHAR(13) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Quantity INT NOT NULL,

    CONSTRAINT PK_Details
        PRIMARY KEY (ReceiptID, ProductID),

    CONSTRAINT CK_Details_UnitPrice
        CHECK (UnitPrice >= 0),

    CONSTRAINT CK_Details_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT FK_Details_Receipts
        FOREIGN KEY (ReceiptID)
        REFERENCES Receipts(ReceiptID),

    CONSTRAINT FK_Details_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

--ข้อมูลถูก

INSERT INTO Details
    (ReceiptID, ProductID, UnitPrice, Quantity)
VALUES
    (1, '8858757001948', 15.00, 3);

--ข้อมูลผิด

INSERT INTO Details
    (ReceiptID, ProductID, UnitPrice, Quantity)
VALUES
    (1, '8858757001948', 15.00, 0);

--แสดงผล

select * From Details
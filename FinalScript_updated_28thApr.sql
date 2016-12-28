/* DDL Script*/
USE master;
GO

IF  DB_ID('PackageFinder') IS NOT NULL
DROP DATABASE PackageFinder;
GO
--Creating Database
CREATE DATABASE PackageFinder;
GO
--Creating Tables
Use PackageFinder;

--Creating table Employee Roles:
CREATE TABLE EmployeeRoles
(
	RoleID int IDENTITY(1,1),
	EmployeeRole NVARCHAR(30) NOT NULL,
 CONSTRAINT PK_RoleID PRIMARY KEY(RoleID)
)
GO

--Creating table States:
CREATE TABLE States
(
	StateID int IDENTITY(1,1),
	StateName NVARCHAR(30) NOT NULL,
 CONSTRAINT PK_StateID PRIMARY KEY(StateID)
)
GO

--Creating table Country:
CREATE TABLE Country
(
	CountryID int IDENTITY(1,1),
	Name NVARCHAR(MAX) NOT NULL,
	CountryRegionCode NVARCHAR(20),
 CONSTRAINT PK_CountryID PRIMARY KEY(CountryID)
)
GO

--Creating table Couriers:
CREATE TABLE Couriers
(
	CourierID int IDENTITY(1,1),
	CourierName NVARCHAR(30) NOT NULL,
	ContactName NVARCHAR(30) NULL,
	ContactPhone NVARCHAR(25) NULL,
	EmailID NVARCHAR(30) NULL,
	Fax VARCHAR(50) NULL,
 CONSTRAINT PK_CourierID PRIMARY KEY(CourierID)
)
GO

--Creating table Employee:
CREATE TABLE Employee
(
	EmployeeID int IDENTITY(1,1),
	CourierID INT NOT NULL,
	RoleID INT NOT NULL,
	FirstName NVARCHAR(30) NULL,
	LastName NVARCHAR(30) NOT NULL,
	AddressLine1 NVARCHAR(30) NOT NULL,
	AddressLine2 NVARCHAR(30) NULL,
	City NVARCHAR(30) NULL,
	StateID INT NOT NULL,
	CountryID INT NOT NULL,
	ZipCode int NOT NULL,
	PhoneNumber NVARCHAR(25),
	IsActive bit NULL DEFAULT 0,
	HiredDate Datetime NOT NULL,
	RelievedDate Datetime NULL,

 CONSTRAINT PK_EmployeeID PRIMARY KEY(EmployeeID),
 CONSTRAINT FK_CourierID FOREIGN KEY(CourierID) REFERENCES Couriers(CourierID),
 CONSTRAINT FK_RoleID FOREIGN KEY(RoleID) REFERENCES EmployeeRoles(RoleID),
 CONSTRAINT FK_StateID FOREIGN KEY(StateID) REFERENCES States(StateID),
 CONSTRAINT FK_CountryID FOREIGN KEY(CountryID) REFERENCES Country(CountryID)
)
GO

--Creating table TrackingDetails:
CREATE TABLE TrackingDetails
(
	TrackingID varchar(20),
	CourierID INT NOT NULL,
	OrderDate DATETIME NOT NULL,
	EmployeeID INT NOT NULL,
	ExpectedDeliveryDate DATETIME NULL,
	ShippedDate DATETIME DEFAULT NULL,
	ShippingAddress NVARCHAR(500) NOT NULL,
	IsPickupTracking BIT DEFAULT 0, -- added
	CustomerName NVARCHAR(30) NOT NULL,
	CustomerPhone NVARCHAR(25) NOT NULL,
	CustomerMailID NVARCHAR(50) NULL,
	ShippedState INT NOT NULL,
	OtherState NVARCHAR(50) NULL,
	ShippedCountry INT NOT NULL,
	OtherCountry NVARCHAR(30) NULL,
 CONSTRAINT PK_TrackingID PRIMARY KEY(TrackingID),
 CONSTRAINT FK_Courier FOREIGN KEY(CourierID) REFERENCES Couriers(CourierID),
 CONSTRAINT FK_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
 CONSTRAINT FK_ShippedState FOREIGN KEY(ShippedState) REFERENCES States(StateID),
 CONSTRAINT FK_ShippedCountry FOREIGN KEY(ShippedCountry) REFERENCES Country(CountryID)
)
GO

--Creating table TrackStatus:
CREATE TABLE TrackStatus
(
	TrackStatusID INT IDENTITY(1,1),
	TrackingID VARCHAR(20) CONSTRAINT PK_TrackingID1 FOREIGN KEY(TrackingID) REFERENCES TrackingDetails(TrackingID),
	EmployeeID INT NOT NULL CONSTRAINT FK_Employee FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID) ,
	StateID INT NOT NULL CONSTRAINT FK_StateID1 FOREIGN KEY(StateID) REFERENCES States(StateID) ,
	OtherState VARCHAR(20),
	[Status] NVARCHAR(50),
	CountryID INT NOT NULL CONSTRAINT FK_CountryID1 FOREIGN KEY(CountryID) REFERENCES Country(CountryID),
	CreatedTimestamp DATETIME,
	
 CONSTRAINT FK_TrackingID FOREIGN KEY(TrackingID) REFERENCES TrackingDetails(TrackingID)
 )
 GO

-- creating table for EmployeeAudit 
 CREATE TABLE EmployeeAudit
(
	EmployeeAuditID INT IDENTITY(1,1) CONSTRAINT PK_EmployeeAuditID PRIMARY KEY,
	EmployeeID INT NOT NULL,
	LoginTime DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Employee_Audit FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
)
GO

--creating table for LoginDetails
CREATE TABLE LoginDetails 
(
	EmployeeID INT CONSTRAINT PK_Login_EmployeeID PRIMARY KEY,
	UserName NVARCHAR(50)  NOT NULL,
	[Password] VARCHAR(20) NOT NULL CONSTRAINT Chk_PwdLenCheck CHECK (LEN([Password]) BETWEEN 8 AND 20 ),
	IsActive BIT DEFAULT 1, 
	CreatedDate DATETIME NULL DEFAULT GETDATE(),
	ModifiedDate DATETIME NULL
CONSTRAINT FK_EmployeeID_Login FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)	 
) 
GO

--Creating table for CustomerAudit
CREATE TABLE CustomerAudit
(
	CustomerAuditID INT IDENTITY(1,1) CONSTRAINT PK_CustomerAuditID PRIMARY KEY,
	TrackingID VARCHAR(20) CONSTRAINT
	 FK_TrackingID_CustomerAudit FOREIGN KEY(TrackingID) REFERENCES TrackingDetails(TrackingID),
	AuditTimeStamp DATETIME NULL DEFAULT GETDATE(),
	RequestedDate DATETIME NULL
)
GO

--creating table for PackageType
CREATE TABLE PackageType
(
	PackageTypeID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PackageTypeID PRIMARY KEY,
	PackageType VARCHAR(50)
)
GO

--creating table for Status
CREATE TABLE [Status]
(
	StatusID INT IDENTITY(1,1) CONSTRAINT PK_StatusID PRIMARY KEY,
	StatusName VARCHAR(80) 
)
GO

--creating table for PickupPackageRequest
CREATE TABLE PickupPackageRequest
(
	RequestID VARCHAR(20) NOT NULL CONSTRAINT PK_RequestID PRIMARY KEY,
	CourierID INT not null CONSTRAINT FK_Pickup_CourierID FOREIGN KEY(CourierID) REFERENCES Couriers(CourierID),
	CustomerName VARCHAR(50) NOT NULL,
	Address_Line1 VARCHAR(100),
	Address_Line2 VARCHAR(100),
	City VARCHAR(20),
	StateID INT,  
	PhoneNumber NVARCHAR(25),
	EmailID NVARCHAR(50),
	PickupAddress_Line1 VARCHAR(100) NOT NULL,
	PickupAddress_Line2 VARCHAR(100),
	PickupCity VARCHAR(20) NOT NULL,
	PickupStateID INT NOT NULL,
	PackageTypeID INT not null CONSTRAINT FK_PackageTypeID FOREIGN KEY(PackageTypeID) REFERENCES PackageType(PackageTypeID),
	PackageStatusID int not null CONSTRAINT FK_PackageStatusID FOREIGN KEY(PackageStatusID) REFERENCES [Status](StatusID),
	Comments VARCHAR(1000),
	CreatedTimeStamp DATETIME DEFAULT GETDATE(),
	ModifiedTimeStamp DATETIME,
	EmployeeID INT DEFAULT NULL,
	CONSTRAINT FK_Pickup_Customer_StateID FOREIGN KEY(StateID) REFERENCES States(StateID),
	CONSTRAINT FK_PickupLocation_PickupStateID FOREIGN KEY(PickupStateID) REFERENCES States(StateID)
)
GO

--creating table for PickupPackageDetails
CREATE TABLE PickupPackageDetails
(
	RequestID VARCHAR(20) CONSTRAINT PK_PickupPkgRequestID PRIMARY KEY,
	Height VARCHAR(5),
	[Weight] DECIMAL(5,2),
	[Description] NVARCHAR(200),
	CustomerName NVARCHAR(100),
	PhoneNumber NVARCHAR(25),
	PickupDateTime DATETIME not null,
	DropOffAddressLine1 NVARCHAR(100),
	DropOffAddressLine2 NVARCHAR(100),
	DropOffCity NVARCHAR(20),
	OtherCity NVARCHAR(20),
	DropOffStateID INT CONSTRAINT Fk_Pickup_StateID FOREIGN KEY(DropOffStateID) REFERENCES States(StateID),
	OtherState VARCHAR(20),
	DropOffCountryID INT CONSTRAINT FK_Pickup_CountryID FOREIGN KEY(DropOffCountryID) REFERENCES Country(CountryID),
	DropOffZipCode VARCHAR(20)
	Constraint FK_Pickup_RequestID Foreign Key(RequestID) References PickupPackageRequest(RequestID)	 
)
GO

--creating tables for ApprovedPickups
CREATE TABLE ApprovedPickups
( 
	RequestID VARCHAR(20) CONSTRAINT PK_ApprovedPickups_RequestID PRIMARY KEY,
	PickupTrackingID VARCHAR(20) CONSTRAINT PK_ApprvdPickups_TrackingID FOREIGN KEY(PickupTrackingID) REFERENCES TrackingDetails(TrackingID),
	ApprovedDate DATETIME,
	CONSTRAINT FK_ApprvdPickups_RequestID FOREIGN KEY(RequestID) REFERENCES PickupPackageRequest(RequestID)
)
GO

--creating table for CustomerSupportTracking
CREATE TABLE CustomerSupportTracking
(
	--TID INT IDENTITY(1,1) CONSTRAINT PK_TID PRIMARY KEY,
	TComplaintID VARCHAR(20) CONSTRAINT PK_CID_T PRIMARY KEY,
	TrackingID VARCHAR(20) NOT NULL CONSTRAINT FK_CSupoort_TrackingID FOREIGN KEY(TrackingID) REFERENCES TrackingDetails(TrackingID),
	CreatedDate DATETIME DEFAULT GETDATE(),
	ClosedDate DATETIME,
	ComplaintDesc VARCHAR(MAX),
	EmployeeID INT NOT NULL CONSTRAINT FK_CSupport_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)
)
GO

--Creating table for CustomerSupportPickup
CREATE TABLE CustomerSupportPickup
(
	--PID int IDENTITY(1,1) CONSTRAINT PK_PID PRIMARY KEY,
	PComplaintID VARCHAR(20) CONSTRAINT PK_CID_P PRIMARY KEY,
	RequestID VARCHAR(20) NOT NULL CONSTRAINT FK_CSupport_RequestID FOREIGN KEY(RequestID) REFERENCES PickupPackageRequest(RequestID),
	CreatedDate DATETIME DEFAULT GETDATE(),
	ClosedDate DATETIME,
	ComplaintDesc VARCHAR(MAX),
	EmployeeID INT NOT NULL CONSTRAINT FK_CSupportEmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID)	 
)
GO

--creating table for cusotmersupportstatus
CREATE TABLE CustomerSupportStatus
(
	SupportID INT IDENTITY(1,1) CONSTRAINT PK_SupportID PRIMARY KEY,
	ComplaintID VARCHAR(20) NOT NULL,
	StatusID INT NOT NULL CONSTRAINT FK_Csupport_StatusID FOREIGN KEY(StatusID) REFERENCES [Status](StatusID),
	Comments NVARCHAR(500) 
)
GO

--Creating table for Status Archive
CREATE TABLE TrackStatusArchive
(
	TrackStatusID [int] IDENTITY(1,1) NOT NULL,
	TrackingID varchar(20) NULL,
	EmployeeID int NOT NULL,
	StateID int NOT NULL,
	OtherState varchar(20) NULL,
	Status nvarchar(50) NULL,
	CountryID int NOT NULL,
	CreatedTimestamp datetime NULL,
	Event varchar(20) NULL,
	ArchivedDate datetime not null
)
GO

--Creating table for Complaint Status Archive
CREATE TABLE ComplaintStatusArchive
(
	SupportID INT CONSTRAINT PK_SupportArchID PRIMARY KEY,
	ComplaintID VARCHAR(20) NOT NULL,
	StatusID INT NOT NULL CONSTRAINT FK_CsupportArch_StatusID FOREIGN KEY(StatusID) REFERENCES [Status](StatusID),
	Comments NVARCHAR(MAX),
	LastModifiedDate DateTime NOT NULL
	--PackageType varchar(20) NOT NULL	
	 
)

GO

ALTER TABLE LoginDetails ADD CONSTRAINT AK_Username UNIQUE(UserName)
ALTER TABLE TrackStatus ADD Event varchar(20)
ALTER TABLE CustomerSupportPickup ADD CustomerName varchar(30)
ALTER TABLE CustomerSupportPickup ADD MailID varchar(30)
ALTER TABLE CustomerSupportTracking ADD CustomerName varchar(30)
ALTER TABLE CustomerSupportTracking ADD MailID varchar(30)
ALTER TABLE CustomerSupportStatus ADD LastModifiedDate Datetime;
ALTER TABLE CustomerSupportStatus ADD CONSTRAINT DF_DateTime DEFAULT GETDATE() FOR LastModifiedDate;
GO

--Inserting data in to table Employee Roles:
GO
INSERT INTO EmployeeRoles VALUES ('Associate'),
								 ('Supervisor')



--Inserting Values into States table
INSERT INTO States VALUES ('Alabama')
INSERT INTO States VALUES ('Alaska')
INSERT INTO States VALUES ('Arizona')
INSERT INTO States VALUES ('Arkansas')
INSERT INTO States VALUES ('California')
INSERT INTO States VALUES ('Colorado')
INSERT INTO States VALUES ('Connecticut')
INSERT INTO States VALUES ('Delaware')
INSERT INTO States VALUES ('Florida')
INSERT INTO States VALUES ('Georgia')
INSERT INTO States VALUES ('Hawaii')
INSERT INTO States VALUES ('Idaho')
INSERT INTO States VALUES ('Illinois')
INSERT INTO States VALUES ('Indiana')
INSERT INTO States VALUES ('Iowa')
INSERT INTO States VALUES ('Kansas')
INSERT INTO States VALUES ('Kentucky')
INSERT INTO States VALUES ('Louisiana')
INSERT INTO States VALUES ('Maine')
INSERT INTO States VALUES ('Maryland')
INSERT INTO States VALUES ('Massachusetts')
INSERT INTO States VALUES ('Michigan')
INSERT INTO States VALUES ('Minnesota')
INSERT INTO States VALUES ('Mississippi')
INSERT INTO States VALUES ('Missouri')
INSERT INTO States VALUES ('Montana')
INSERT INTO States VALUES ('Nebraska')
INSERT INTO States VALUES ('Nevada')
INSERT INTO States VALUES ('New Hampshire')
INSERT INTO States VALUES ('New Jersey')
INSERT INTO States VALUES ('New Mexico')
INSERT INTO States VALUES ('New York')
INSERT INTO States VALUES ('North Carolina')
INSERT INTO States VALUES ('North Dakota')
INSERT INTO States VALUES ('Ohio')
INSERT INTO States VALUES ('Oklahoma')
INSERT INTO States VALUES ('Oregon')
INSERT INTO States VALUES ('Pennsylvania')
INSERT INTO States VALUES ('Rhode Island')
INSERT INTO States VALUES ('South Carolina')
INSERT INTO States VALUES ('South Dakota')
INSERT INTO States VALUES ('Tennessee')
INSERT INTO States VALUES ('Texas')
INSERT INTO States VALUES ('Utah')
INSERT INTO States VALUES ('Vermont')
INSERT INTO States VALUES ('Virginia')
INSERT INTO States VALUES ('Washington')
INSERT INTO States VALUES ('West Virginia')
INSERT INTO States VALUES ('Wisconsin')
INSERT INTO States VALUES ('Wyoming')
INSERT INTO States VALUES ('Others')

GO

--Inserting data in to table Country:
INSERT INTO Country VALUES
( 'AFGHANISTAN', 'AF'),
( 'ALBANIA', 'AL'),
( 'ALGERIA', 'DZ'),
( 'AMERICAN SAMOA', 'AS'),
( 'ANDORRA', 'AD'),
( 'ANGOLA', 'AO'),
( 'ANGUILLA', 'AI'),
( 'ANTARCTICA', 'AQ'),
( 'ANTIGUA AND BARBUDA', 'AG'),
( 'ARGENTINA', 'AR'),
( 'ARMENIA', 'AM'),
( 'ARUBA', 'AW'),
( 'AUSTRALIA', 'AU'),
( 'AUSTRIA', 'AT'),
( 'AZERBAIJAN', 'AZ'),
( 'BAHAMAS', 'BS'),
( 'BAHRAIN', 'BH'),
( 'BANGLADESH', 'BD'),
( 'BARBADOS', 'BB'),
( 'BELARUS', 'BY'),
( 'BELGIUM', 'BE'),
( 'BELIZE', 'BZ'),
( 'BENIN', 'BJ'),
( 'BERMUDA', 'BM'),
( 'BHUTAN', 'BT'),
( 'BOLIVIA', 'BO'),
( 'BOSNIA AND HERZEGOVINA', 'BA'),
( 'BOTSWANA', 'BW'),
( 'BOUVET ISLAND', 'BV'),
( 'BRAZIL', 'BR'),
( 'BRITISH INDIAN OCEAN TERRITORY', 'IO'),
( 'BRUNEI DARUSSALAM', 'BN'),
( 'BULGARIA', 'BG'),
( 'BURKINA FASO', 'BF'),
( 'BURUNDI', 'BI'),
( 'CAMBODIA', 'KH'),
( 'CAMEROON', 'CM'),
( 'CANADA', 'CA'),
( 'CAPE VERDE', 'CV'),
( 'CAYMAN ISLANDS', 'KY'),
( 'CENTRAL AFRICAN REPUBLIC', 'CF'),
( 'CHAD', 'TD'),
( 'CHILE', 'CL'),
( 'CHINA', 'CN'),
( 'CHRISTMAS ISLAND', 'CX'),
( 'COCOS (KEELING) ISLANDS', 'CC'),
( 'COLOMBIA', 'CO'),
( 'COMOROS', 'KM'),
( 'CONGO', 'CG'),
( 'CONGO', 'CD'),
( 'COOK ISLANDS', 'CK'),
( 'COSTA RICA', 'CR'),
( 'COTE D''IVOIRE', 'CI'),
( 'CROATIA', 'HR'),
( 'CUBA', 'CU'),
( 'CYPRUS', 'CY'),
( 'CZECH REPUBLIC', 'CZ'),
( 'DENMARK', 'DK'),
( 'DJIBOUTI', 'DJ'),
( 'DOMINICA', 'DM'),
( 'DOMINICAN REPUBLIC', 'DO'),
( 'ECUADOR', 'EC'),
( 'EGYPT', 'EG'),
( 'EL SALVADOR', 'SV'),
( 'EQUATORIAL GUINEA', 'GQ'),
( 'ERITREA', 'ER'),
( 'ESTONIA', 'EE'),
( 'ETHIOPIA', 'ET'),
( 'FALKLAND ISLANDS (MALVINAS)', 'FK'),
( 'FAROE ISLANDS', 'FO'),
( 'FIJI', 'FJ'),
( 'FINLAND', 'FI'),
( 'FRANCE', 'FR'),
( 'FRENCH GUIANA', 'GF'),
( 'FRENCH POLYNESIA', 'PF'),
( 'FRENCH SOUTHERN TERRITORIES', 'TF'),
( 'GABON', 'GA'),
( 'GAMBIA', 'GM'),
( 'GEORGIA', 'GE'),
( 'GERMANY', 'DE'),
( 'GHANA', 'GH'),
( 'GIBRALTAR', 'GI'),
( 'GREECE', 'GR'),
( 'GREENLAND', 'GL'),
( 'GRENADA', 'GD'),
( 'GUADELOUPE', 'GP'),
( 'GUAM', 'GU'),
( 'GUATEMALA', 'GT'),
( 'GUINEA', 'GN'),
( 'GUINEA-BISSAU', 'GW'),
( 'GUYANA', 'GY'),
( 'HAITI', 'HT'),
( 'HEARD ISLAND AND MCDONALD ISLANDS', 'HM'),
( 'HOLY SEE (VATICAN CITY STATE)', 'VA'),
( 'HONDURAS', 'HN'),
( 'HONG KONG', 'HK'),
( 'HUNGARY', 'HU'),
( 'ICELAND', 'IS'),
( 'INDIA', 'IN'),
( 'INDONESIA', 'ID'),
( 'IRAN', 'IR'),
( 'IRAQ', 'IQ'),
( 'IRELAND', 'IE'),
( 'ISRAEL', 'IL'),
( 'ITALY', 'IT'),
( 'JAMAICA', 'JM'),
( 'JAPAN', 'JP'),
( 'JORDAN', 'JO'),
( 'KAZAKHSTAN', 'KZ'),
( 'KENYA', 'KE'),
( 'KIRIBATI', 'KI'),
( 'KOREA', 'KR'),
( 'KUWAIT', 'KW'),
( 'KYRGYZSTAN', 'KG'),
( 'LAO PEOPLE''S DEMOCRATIC REPUBLIC', 'LA'),
( 'LATVIA', 'LV'),
( 'LEBANON', 'LB'),
( 'LESOTHO', 'LS'),
( 'LIBERIA', 'LR'),
( 'LIBYAN ARAB JAMAHIRIYA', 'LY'),
( 'LIECHTENSTEIN', 'LI'),
( 'LITHUANIA', 'LT'),
( 'LUXEMBOURG', 'LU'),
( 'MACAO', 'MO'),
( 'MACEDONIA', 'MK'),
( 'MADAGASCAR', 'MG'),
( 'MALAWI', 'MW'),
( 'MALAYSIA', 'MY'),
( 'MALDIVES', 'MV'),
( 'MALI', 'ML'),
( 'MALTA', 'MT'),
( 'MARSHALL ISLANDS', 'MH'),
( 'MARTINIQUE', 'MQ'),
( 'MAURITANIA', 'MR'),
( 'MAURITIUS', 'MU'),
( 'MAYOTTE', 'YT'),
( 'MEXICO', 'MX'),
( 'MICRONESIA', 'FM'),
( 'MOLDOVA', 'MD'),
( 'MONACO', 'MC'),
( 'MONGOLIA', 'MN'),
( 'MONTSERRAT', 'MS'),
( 'MOROCCO', 'MA'),
( 'MOZAMBIQUE', 'MZ'),
( 'MYANMAR', 'MM'),
( 'NAMIBIA', 'NA'),
( 'NAURU', 'NR'),
( 'NEPAL', 'NP'),
( 'NETHERLANDS', 'NL'),
( 'NETHERLANDS ANTILLES', 'AN'),
( 'NEW CALEDONIA', 'NC'),
( 'NEW ZEALAND', 'NZ'),
( 'NICARAGUA', 'NI'),
( 'NIGER', 'NE'),
( 'NIGERIA', 'NG'),
( 'NIUE', 'NU'),
( 'NORFOLK ISLAND', 'NF'),
( 'NORTHERN MARIANA ISLANDS', 'MP'),
( 'NORWAY', 'NO'),
( 'OMAN', 'OM'),
( 'PAKISTAN', 'PK'),
( 'PALAU', 'PW'),
( 'PALESTINIAN TERRITORY', 'PS'),
( 'PANAMA', 'PA'),
( 'PAPUA NEW GUINEA', 'PG'),
( 'PARAGUAY', 'PY'),
( 'PERU', 'PE'),
( 'PHILIPPINES', 'PH'),
( 'PITCAIRN', 'PN'),
( 'POLAND', 'PL'),
( 'PORTUGAL', 'PT'),
( 'PUERTO RICO', 'PR'),
( 'QATAR', 'QA'),
( 'REUNION', 'RE'),
( 'ROMANIA', 'RO'),
( 'RUSSIAN FEDERATION', 'RU'),
( 'RWANDA', 'RW'),
( 'SAINT HELENA', 'SH'),
( 'SAINT KITTS AND NEVIS', 'KN'),
( 'SAINT LUCIA', 'LC'),
( 'SAINT PIERRE AND MIQUELON', 'PM'),
( 'SAINT VINCENT AND THE GRENADINES', 'VC'),
( 'SAMOA', 'WS'),
( 'SAN MARINO', 'SM'),
( 'SAO TOME AND PRINCIPE', 'ST'),
( 'SAUDI ARABIA', 'SA'),
( 'SENEGAL', 'SN'),
( 'SERBIA AND MONTENEGRO', 'CS'),
( 'SEYCHELLES', 'SC'),
( 'SIERRA LEONE', 'SL'),
( 'SINGAPORE', 'SG'),
( 'SLOVAKIA', 'SK'),
( 'SLOVENIA', 'SI'),
( 'SOLOMON ISLANDS', 'SB'),
( 'SOMALIA', 'SO'),
( 'SOUTH AFRICA', 'ZA'),
( 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'GS'),
( 'SPAIN', 'ES'),
( 'SRI LANKA', 'LK'),
( 'SUDAN', 'SD'),
( 'SURINAME', 'SR'),
( 'SVALBARD AND JAN MAYEN', 'SJ'),
( 'SWAZILAND', 'SZ'),
( 'SWEDEN', 'SE'),
( 'SWITZERLAND', 'CH'),
( 'SYRIAN ARAB REPUBLIC', 'SY'),
( 'TAIWAN', 'TW'),
( 'TAJIKISTAN', 'TJ'),
( 'TANZANIA', 'TZ'),
( 'THAILAND', 'TH'),
( 'TIMOR-LESTE', 'TL'),
( 'TOGO', 'TG'),
( 'TOKELAU', 'TK'),
( 'TONGA', 'TO'),
( 'TRINIDAD AND TOBAGO', 'TT'),
( 'TUNISIA', 'TN'),
( 'TURKEY', 'TR'),
( 'TURKMENISTAN', 'TM'),
( 'TURKS AND CAICOS ISLANDS', 'TC'),
( 'TUVALU', 'TV'),
( 'UGANDA', 'UG'),
( 'UKRAINE', 'UA'),
( 'UNITED ARAB EMIRATES', 'AE'),
( 'UNITED KINGDOM', 'GB'),
( 'UNITED STATES', 'US'),
( 'UNITED STATES MINOR OUTLYING ISLANDS', 'UM'),
( 'URUGUAY', 'UY'),
( 'UZBEKISTAN', 'UZ'),
( 'VANUATU', 'VU'),
( 'VENEZUELA', 'VE'),
( 'VIET NAM', 'VN'),
( 'VIRGIN ISLANDS', 'VI'),
( 'WALLIS AND FUTUNA', 'WF'),
( 'WESTERN SAHARA', 'EH'),
( 'YEMEN', 'YE'),
( 'ZAMBIA', 'ZM'),
( 'ZIMBABWE', 'ZW')

GO

--Inserting data in to table Couriers:
INSERT INTO Couriers VALUES
('DHL','Amit','443-994-5280','amitparsara@gmail.com','331-426-853'),
('FedEx','Murali','410-409-5395','muralikr@asu.edu','316-533-2521'),
('USPS','Sujit','480-570-8308','sujit.nadella@asu.edu','431-852-4912'),
('UPS','Tharani','480-570-8308','tharani.v@asu.edu','381-852-4912')
GO

--Inserting data in to table Employee:
INSERT INTO EMPLOYEE 
(CourierID,RoleID,FirstName,LastName,AddressLine1,AddressLine2,City,StateID,CountryID,ZipCode,PhoneNumber,IsActive,HiredDate,RelievedDate)
 VALUES (1,1,'Murali','SripathyRaju','Apt 317',NULL,'Scotsdale',3,225,85259,'410-409-5395',1,GETDATE(),NULL),
                            (2,2,'Amit','Samuel','Apt 3072','1255 E University','Tempe',3,225,85281,'443-994-5280',1,GETDATE(),NULL),
                            (3,2,'Sujit','Nadella','Apt 137',NULL,'Tempe',3,225,85281,'480-570-8308',1,GETDATE(),NULL),
                            (1,2,'Tharani','Venkatanarayanan','Apt 4202',NULL,'Tempe',3,225,85259,'310-920-3145',1,GETDATE(),NULL),
                            (1,1,'Usha','Jagannathan','Apt 135',NULL,'Scotsdale',3,225,85251,'111-111-1111',1,GETDATE()+2,NULL),
                            (1,1,'xyz','abc','Apt yyy',NULL,'mno',3,225,85251,'222-111-1111',1,GETDATE()+3,NULL),
                            (2,1,'jkl','bcb','Apt uuu',NULL,'iou',3,225,85251,'333-111-1111',1,GETDATE()+2,NULL),
                            (2,1,'George','King','Apt 222',NULL,'Washinggton',5,225,85267,'111-555-1111',1,GETDATE()+2,NULL),
                            (4,2,'Rahman','AR','Apt 444',NULL,'Glendale',7,225,85256,'111-111-6666',1,GETDATE()+4,NULL),
                            (3,1,'Jason','Volkman','Apt 111',NULL,'abcde',3,225,85257,'111-555-1111',1,GETDATE()+2,NULL),
                            (2,1,'MM','Keeravani','Apt 345',NULL,'fghjk',9,225,85258,'111-123-1111',1,GETDATE()+3,NULL),
                            (3,1,'MS','Dhoni','Apt 457',NULL,'Tempe',3,225,85251,'111-111-9999',1,GETDATE()+2,GETDATE()-7),
                            (4,1,'Kohli','Virat','Apt 4545',NULL,'George street',5,217,56789,'345-567-9087',0,GETDATE()+2,NULL),
                            (4,1,'Wahab','Riaz','Apt 666',NULL,'King George',4,225,85267,'999-888-7777',0,GETDATE()+2,GETDATE()-10),
                            (4,1,'Shane','Watson','Apt 569',NULL,'Asusual',2,100,78906,'444-555-6666',1,GETDATE()+24,NULL)
GO

--Inserting data in to table TrackingDetails:
INSERT INTO TrackingDetails VALUES
('DHL3456',1,'2016/02/25',1,NULL,NULL,'No 27 VOC 1st Main Street Kodabakam',0,'Rahul','408-639-1795','rahul.a@asu.edu',51,'TamilNadu',99,NULL),
('DHL3457',1,'2016/02/26',5,NULL,NULL,'University Pointe,E University Dr,Tempe',0,'Bose','408-639-1796','bose.e@asu.edu',1,NULL,225,NULL),
('DHL3458',1,'2016/02/27',6,NULL,NULL,'Apt.137,E Sahuaro Dr,Scottsdale',0,'Patel','408-639-1797','patel.p@asu.edu',3,NULL,225,NULL),
('DHL3459',1,'2016/02/28',6,NULL,NULL,'University Pointe,E University Dr,Tempe',0,'Gandhi','408-639-1798','gandhi.m@asu.edu',5,NULL,225,NULL),
('DHL3460',1,'2016/02/29',5,NULL,NULL,'Villa 123,INDU Fortune,KPHB Colony',0,'Ashwin','408-639-1799','ashwin.r@asu.edu',51,'AndhraPradesh',99,NULL),
('FED2312',2,'2016/03/01',7,NULL,NULL,'1255 Apartments,E University Dr,Tempe',0,'Raina','408-639-1800','raina.s@asu.edu',2,NULL,225,NULL),
('FED2313',2,'2016/03/02',7,NULL,NULL,'Apt.137,E Sahuaro Dr,Scottsdale',0,'Sachin','408-639-1801','sachin.t@asu.edu',7,NULL,225,NULL),
('FED2314',2,'2016/03/03',8,NULL,NULL,'University Pointe,E University Dr,Tempe',0,'Jadeja','408-639-1802','jadeja.r@asu.edu',14,NULL,225,NULL),
('FED2315',2,'2016/03/04',8,NULL,NULL,'1255 Apartments,E University Dr,Tempe',0,'Dhoni','408-639-1803','dhoni.m@asu.edu',19,NULL,225,NULL),
('FED2316',2,'2016/03/05',11,NULL,NULL,'Apt.137,E Sahuaro Dr,Scottsdale',0,'Khan','408-639-1804','khan.k@asu.edu',21,NULL,225,NULL),
('USPS8231',3,'2016/03/06',10,NULL,NULL,'1255 Apartments,E University Dr,Tempe',0,'Shruthi','408-639-1805','shruthi.s@asu.edu',41,NULL,225,NULL),
('USPS8232',3,'2016/03/07',10,NULL,NULL,'Apt.137,E Sahuaro Dr,Scottsdale',0,'Simbu','408-639-1806','simbu.s@asu.edu',5,NULL,225,NULL),
('USPS8233',3,'2016/03/08',12,NULL,NULL,'University Pointe,E University Auckland',0,'Kapoor','408-639-1807','kapoor.r@asu.edu',51,'Auckland',152,NULL),
('USPS8234',3,'2016/03/09',12,NULL,NULL,'1255 Apartments,E University Dr,Tempe',0,'Khan','408-639-1808','khan.s@asu.edu',21,NULL,225,NULL),
('USPS8235',3,'2016/03/10',10,NULL,NULL,'Apt.137,E Sahuaro Dr,Scottsdale',0,'Ranbir','408-639-1809','ranbir.k@asu.edu',2,NULL,225,NULL),
('UPS1673',4,'2016/03/11',13,NULL,NULL,'1255 Apartments,E University Dr,Tempe',0,'Allu Arjun','408-639-1810','allu.a@asu.edu',23,NULL,225,NULL),
('UPS1674',4,'2016/03/12',14,NULL,NULL,'University Pointe Sydney',0,'KamalHasan','408-639-1811','kamal.@asu.edu',51,'Sydney',13,NULL),
('UPS1675',4,'2016/03/13',15,NULL,NULL,'1255 Apartments,E University Dr,Tempe',0,'Dhanush','408-639-1812','dhanush.d@asu.edu',8,NULL,225,NULL),
('UPS1676',4,'2016/03/14',13,NULL,NULL,'University Pointe,E University Dr,Tempe',0,'Vijay','408-639-1813','vijay.v@asu.edu',3,NULL,225,NULL),
('UPS1677',4,'2016/03/15',14,NULL,NULL,'1255 Apartments,E University Dr,Tempe',0,'Ajith','408-639-1814','ajith.k@asu.edu',20,NULL,225,NULL),
('DHL3461',1,GETDATE()+5,1,NULL,NULL,'1001 E Marathan Road,5000,Fulton',1,'Jackquile Brady','310-235-9860','brady@gmail.com',3,NULL,225,NULL),															
('DHL3462',1,GETDATE()+5,1,NULL,NULL,'2060 SouthernAvenue,1665,Tempe',1,'John Ramsey','480-235-9860','john.ramsey@gmail.com',3,NULL,225,NULL),															
('FED2317',2,GETDATE()+5,7,NULL,NULL,'1094 Mill Ave,3025,Thunderbird',1,'Tom Bridgewater','602-679-8860','tom.bdgw@gmail.com',3,NULL,225,NULL),															
('USPS8236',3,GETDATE()+5,12,NULL,NULL,'1045 Peoria Ave,4545,Phoneix',1,'Thomas Peyton','310-568-8860','thomas.peyton@gmail.com',3,NULL,225,NULL),															
('USPS8237',3,GETDATE()+8,10,NULL,NULL,'1045 Spring Street,4545,Seattle',1,'Russel Wilson','310-500-8869','russel.wilson@gmail.com',47,NULL,225,NULL),															
('UPS1678',4,GETDATE()+5,15,NULL,NULL,'56 deer vally,6789,Peoria',1,'Jayshree Ram','3108699003','jayshree.ram@gmail.com',3,NULL,225,NULL),	
('USPS1680',3,GETDATE()+1,10,NULL,NULL,'200 Old Canyon road,1400',1,'John Friend II','3004457990','john.friend@gmail.com',1,NULL,225,NULL),														
('DHL3463',1,GETDATE()+5,1,NULL,NULL,'56 Nehru Street,101/89,Chennai',1,'Natesh Kumar','9878987890','natesh.kumar@gmail.com',51,'TamilNadu',99,NULL),															
('UPS1679',4,GETDATE()+6,14,NULL,NULL,'200 Old alabhama road',1,'Divya Shah','123-456-789','divyashah@gmail.com',51,'Columbia',99,NULL),															
('UPS1680',4,GETDATE()+1,13,NULL,NULL,'200 Old alabhama road,1400',0,'John Nichols','310-869-9006','john.nichols@gmail.com',1,NULL,225,NULL)
GO

--Inserting data in to table TrackStatus:
INSERT INTO TrackStatus VALUES
('DHL3456',1,5,NULL,'Scanned at California Airport',225, GETDATE(),'In Process'),
('DHL3456',1,9,NULL,'Received at Florida',225, GETDATE()+1,'In Process'),
('USPS8233',12,43,NULL,'Dispatched from Texas',225,GETDATE()+4,'In Process'),
('USPS8233',12,51,'Auckland','Arrived at Auckland Airport',152,GETDATE()+6,'In Process')
GO

--Insert data into 'LoginDetails' table
INSERT INTO LoginDetails(EmployeeID,UserName,[Password],IsActive,CreatedDate)
VALUES (1,'MuraliSR','murali@262011',1,GETDATE()),
(2,'AmitS','amit@262012',1,GETDATE()+1),
(3,'SujitN','sujit@262013',1,GETDATE()+2),
(4,'TharaniV','tharani@262014',1,GETDATE()+3),
(8,'GeorgeK','kgeorge@262015',1,GETDATE()+4),
(9,'ARahman','rahman@262016',1,GETDATE()+5),
(10,'JVolkman','jkolkman@262017',1,GETDATE()+6)
GO

--Insert data into 'PackageType' table
INSERT INTO PackageType(PackageType)
VALUES ('Bag'),
('Barrel'),
('Basket or hamper'),
('Box'),
('Bucket'),
('Bundle'),
('Cage'),
('Carton'),
('Case'),
('Chest'),
('Container'),
('Crate'),
('Cylinder'),
('Drum'),
('Envelope'),
('Flyer'),
('Package'),
('Pail'),
('Pallet'),
('Parcel'),
('Pieces'),
('Reel'),
('Roll'),
('Sack'),
('Shrink Wrapped'),
('Skid'),
('Tank'),
('Tote Bin'),
('Tube'),
('Unit'),
('Extra Large Package')
GO

--Insert data into 'Status' table
INSERT INTO [Status](StatusName)
VALUES ('Ordered'),
('Shipped'),
('it is on the Way'),
('Delivered'),
('Hold'),
('Open'),
('In Progress'),
('Resolved'),
('Not Applicable')
GO

/*Insert data into 'PickupPackageRequest' table*/
INSERT INTO PickupPackageRequest(RequestID,CourierID,CustomerName,Address_Line1,Address_Line2,City,StateID,PhoneNumber,EmailID,PickupAddress_Line1,PickupAddress_Line2,PickupCity,PickupStateID,PackageTypeID,PackageStatusID,EmployeeID)																	
VALUES ('RDH1604274802349860',1, 'Jackquile Brady', '4545 W Beadsley Road','2069','Glendale',3,'480-234-9860','brady@gmail.com','W Bell Road',NULL,'Phoneix',3,17,2,5),															
('RDH1604273102349860',1, 'John Ramsey','45 Southern Ave','3003','Tempe',3,'310-234-9860','john.ramsey@gmail.com','45 Southern Ave','3003','Tempe',3,15,4,6),															
('RFe1604276026788860',2,'Tom Bridgewater', '7575 Bell Road','5003','Mesa',3,'602-678-8860','tom.bdgw@gmail.com','7575 Mill Ave',NULL,'Tempe',3,16,4,8),															
('RUS1604273105608861',3,'Thomas Peyton', '1650 Mill Ave', '4112','Chandler',3,'310-560-8861','thomas.peyton@gmail.com','1650 Mill Ave', '4112','Chandler',3,15,3,10),															
('RUS1604273105608860',3,'Russel Wilson', '2660 Second Street',' Mill ave','Chandler',3,'310-560-8860','russel@gmail.com','1890 seventh street',NULL,'Tempe',3,17,3,12),
('RUS1604275849987555',3,'Rudd Van Bumen',' 8090  Trum Ave',' 8224','Cathem City',5,'5849987555','rudd4562@gmail.com','478 Aparet blvd',NULL,'Campbell',5,17,3,10),															
('RUP1604273108699003',4,'Jayshree Ram',' 8090  Tatum Ave',' 8234','Cathedral City',5,'310-869-9003','jayshree.ram@gmail.com','4578 Apache blvd',NULL,'Campbell',5,17,3,13),															
('RDH1604273104570002',1,'Natesh Kumar', '9023 Happy Valley', '1001','Santa Clara',5,'310-457-0002','natesh.kumar@gmail.com',' 9023 Happy Valley', '1001','Santa Clara',5,20,3,6),															
('RUP1604274804573423',4,'Divya Shah', '1001 South Spring Road', '3213','SpringTown',43,'480-457-3423','divyashah@gmail.com', '1001 South Spring Road', '3213','SpringTown',43,20,3,14),															
('RFe1604274806781523',2,'Meera Krishnan', '3456 East Cacus Road', '4243','Walnut grove',43,'480-678-1523','meera.krishnan@gmail.com', '4004 East Cacus Road', '4000','Walnut grove',43,20,3,11),															
('RUP1604273002805990',4,'John Nichols', '5671 South Yellow Street','5634','Margaret',1,'300-280-5990','john.nichols@gmail.com', '5671 South Yellow Street','5634','Margaret',1,31,3,15)															
GO

/*Insert data into 'PickupPackageDetails' table*/
INSERT INTO PickupPackageDetails																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																	
VALUES('RDH1604274802349860','5',10,'GlassItem','Jackquile Brady','480-235-9860',GETDATE()+2,'1001 E Marathan Road','5000','Fulton',NULL,1,NULL,225,'85289'),
('RDH1604273102349860','10',0.50,'Envelope','John Ramsey','310-235-9860',GETDATE()+2,'2060 SouthernAvenue','1665','Tempe',NULL,3,NULL,225,'85281'),														
('RFe1604276026788860','12',1,'Flyer','Tom Bridgewater','602-679-8860',GETDATE()+5,'1094 Mill Ave','3025','Thunderbird',NULL,3,NULL,225,'85826'),														
('RUS1604273105608861','14',0.25,'Envelope','Thomas Peyton','310-568-8860',GETDATE()+5,'1045 Peoria Ave','4545','Phoneix',NULL,3,NULL,225,'85381'),														
('RUS1604273105608860','15',5,'NFL Medium Package','Russel Wilson','310-560-8869',GETDATE()+8,'1045 Spring Street','4545','Seattle',NULL,47,NULL,225,'98101'),														
('RUP1604273108699003','8',2,'Spices','Jayshree Ram','310-869-9006',GETDATE()+5,'56 deer vally','6789','Peoria',NULL,3,NULL,225,'85286'),														
('RDH1604273104570002','9',5,'Sweets Parcel','Natesh Kumar','9878987890',GETDATE()+5,'56 Nehru Street','101/89',NULL,'Chennai',51,'Tamil Nadu',99,'650013'),														
('RUP1604274804573423','15',3,'Medicines Parcel','Divya Shah','9878091123',GETDATE()+6,'101 Gandhi Street','200',NULL,'Vijayawada',51,'Andra pradesh',99,'520001'),														
('RFe1604274806781523','10',2,'Parcel','Meera Krishnan','9809980976',GETDATE()+4,'78 OMR Road','400',NULL,'Chennai',51,'Tamil Nadu',99,'610018'),														
('RUP1604273002805990','10',5,'Extra large Package','John Nichols','123-456-789',GETDATE()+1,'200 Old alabhama road','1400','Columbia',NULL,51,'Columbia',199,'36319'),													
('RUS1604275849987555','15',5,'NFL Medium Package','Russel Wilson','310-500-8869',GETDATE()+8,'1045 Spring Street','4545','Seattle',NULL,47,NULL,225,'98101')
GO															

/*Insert data into 'ApprovedPickups' table*/
INSERT INTO ApprovedPickups(RequestID,PickuptrackingID,ApprovedDate)	
 VALUES('RDH1604274802349860','DHL3462',GETDATE()+2),
 ('RDH1604273102349860','DHL3461',GETDATE()+4),
('RFe1604276026788860','FED2317',GETDATE()+5),						
('RUS1604273105608861','USPS8236',GETDATE()+5),						
('RUS1604273105608860','UPS1678',GETDATE()+5),	
('RDH1604273104570002','DHL3463',GETDATE()+5),
('RUP1604273002805990','UPS1679',GETDATE()+6),
('RUS1604275849987555','USPS8237',GETDATE()+2),
('RUP1604273108699003','UPS1680',GETDATE()+2)
GO

/*Insert data into 'CustomerSupportTracking' table*/
INSERT INTO CustomerSupportTracking VALUES										
('CDH160518','DHL3456',GETDATE()+10,NULL,'Did not receive package',1,'John','John@asu.edu'),										
('CFe160466','FED2312',GETDATE()+12,NULL,'Unable to trace package staus',7,'Joseph','Joseph@asu.edu'),										
('CFe160442','FED2314',GETDATE()+20,NULL,'Received damaged package',8,'Arjun','Arjun@asu.edu'),										
('CUP160476','UPS1673',GETDATE()+15,NULL,'Delivery man broke my package',13,'Venkat','Venkat@asu.edu'),										
('CUP160500','UPS1675',GETDATE()+25,NULL,'Got different package',14,'Srivats','Srivats@asu.edu'),										
('CUS160490','USPS8231',GETDATE()+40,NULL,'I have not received my package',10,'Rayudu','Rayudu@asu.edu'),										
('CUS160506','USPS8235',GETDATE()+17,NULL,'Did not receive package',12,'Kennedy','Kennedy@asu.edu'),										
('CUS160526','USPS8235',GETDATE()+20,NULL,'No response for my previous complaint',12,'Pinky','Pinky@asu.edu'),									
('CUS160504','USPS8231',GETDATE()+23,NULL,'I could not track my package',10,'George','George@asu.edu'), 
('CDH160482','DHL3456',GETDATE()+12,NULL,'No response for my previous complaint',5,'Valdez','Valdez@asu.edu'),            
('CUS160540','USPS8233',GETDATE()+16,NULL,'Ordered items are damaged.',10,'Jason','Jason@asu.edu')	
GO

/*Insert data into 'CustomerSupportPickUp' table*/
INSERT INTO CustomerSupportPickUp VALUES								
('CDH160476','RDH1604274802349860',GETDATE()+3,NULL,'Package delivery problem.',5,'John','John@asu.edu'), 
('CDH160510','RDH1604273102349860',GETDATE()+4,NULL,'no one has not come to get my package',6,'Joseph','Joseph@asu.edu'),             
('CFe160476','RFe1604276026788860',GETDATE()+6,NULL,'charge for picking up my package is high',7,'Arjun','Arjun@asu.edu'), 
('CUS160512','RUS1604273105608861',GETDATE()+10,NULL,'Pickup request has not approved yet',10,'Venkat','Venkat@asu.edu'),  
('CUS160540','RUS1604275849987555',GETDATE()+6,NULL,'Employee did not handle my package properly',12,'Srivats','Srivats@asu.edu'),
('CUS160448','RUS1604275849987555',GETDATE()+15,NULL,'delivered damaged package',10,'Rayudu','Rayudu@asu.edu'),
('CUP160486','RUP1604273002805990',GETDATE()+35,NULL,'Package has not delivered yet',13,'Kennedy','Kennedy@asu.edu'),
('CDH160542','RDH1604273104570002',GETDATE()+60,NULL,'package has not delivered yet',6,'Pinky','Pinky@asu.edu'),
('CUP160514','RUP1604273002805990',GETDATE()+60,NULL,'delivered different package',14,'George','George@asu.edu'),
('CFe160496','RFe1604274806781523',GETDATE()+20,NULL,'Unable to track package',11,'Valdez','Valdez@asu.edu'),
('CDH160446','RDH1604273102349860',GETDATE()+20,NULL,'Please update status of package',1,'Valdez','Valdez@asu.edu'),
('CUP160534','RUP1604273002805990',GETDATE()+14,NULL,' Unable to track package.resolve immediately',14,'Jason','Jason@asu.edu')
GO

/*Insert data into 'CustomerSupportStatus' table*/
Insert into CustomerSupportStatus(ComplaintID,StatusID,Comments) VALUES								
('CUP160534',7,'Package is delivered'),
('CUP160534',6,'Unable to track package. resolve immediately'),
('CDH160446',6,'Please update status of package'),
('CDH160446',7,'Status Updated'),
('CFe160476',6,'charge for picking up my package is high'),
('CUP160486',6,'Package has not delivered yet'),                                              
('CUP160486',7,'Recent status update provided'),
('CFe160496',6,'Unable to track package'),
('CUS160448',6,'delivered damaged package')
GO

--Creating Index
CREATE NONCLUSTERED INDEX IX_TrackID0
ON TrackStatus (TrackingID) INCLUDE (StateID,Status,CountryID,CreatedTimeStamp)
GO

--Creating Triggers
CREATE TRIGGER TR_ComplaintsArchive ON CustomerSupportStatus
AFTER INSERT
AS
DECLARE @cid varchar(20), @status int;
SET @cid = (SELECT ComplaintID from Inserted);
SET @status = (SELECT StatusID from Inserted);
IF (@status=8)
BEGIN
INSERT INTO ComplaintStatusArchive 
SELECT * FROM CustomerSupportStatus WHERE ComplaintID = @cid;
DELETE FROM CustomerSupportStatus WHERE ComplaintID = @cid;
END
GO
CREATE TRIGGER TR_PStatusInsertion ON CustomerSupportPickup
AFTER INSERT
AS
DECLARE @comments varchar(20),@cid varchar(20),@statusID int;
SET @comments= (SELECT ComplaintDesc FROM Inserted);
SET @cid= (SELECT PComplaintID FROM Inserted);
INSERT INTO CustomerSupportStatus
(ComplaintID,StatusID,Comments)VALUES(@cid,'6',@comments)
GO
CREATE TRIGGER TR_TStatusInsertion ON CustomerSupportTracking
AFTER INSERT
AS
DECLARE @comments varchar(20),@cid varchar(20),@statusID int;
SET @comments= (SELECT ComplaintDesc FROM Inserted);
SET @cid= (SELECT TComplaintID FROM Inserted);
INSERT INTO CustomerSupportStatus
(ComplaintID,StatusID,Comments)VALUES(@cid,'6',@comments)
GO

--Procedures
create PROC spGetTrackingDetails
@trackingNumber VARCHAR(30)
AS
BEGIN
   
   	SELECT
	CustomerName AS Cusname,
	TrackingID,
	CourierID,
	OrderDate,
	CAST(ExpectedDeliveryDate as SMALLDATETIME) deliveryDate,
	ShippingAddress,
	ShippedDate
	FROM dbo.TrackingDetails (NOLOCK)
	WHERE TrackingID=@trackingNumber

END
GO
CREATE PROC spGetTrackingStatus
@trackingNumber VARCHAR(30)
AS
BEGIN

		SELECT 
		td.CustomerName,
		td.TrackingID,
		td.CourierID,
		CAST(td.ExpectedDeliveryDate as SMALLDATETIME) ExpectedDeliveryDate,
		CAST(ts.CreatedTimestamp as SMALLDATETIME) CreatedDatetime,
		ts.[Status],
		CONCAT((CASE WHEN TS.StateID=51 THEN TD.OtherState ELSE states.StateName END),',',country.CountryRegionCode) Location
		FROM dbo.TrackingDetails td (NOLOCK)
		INNER JOIN TrackStatus TS ON td.TrackingID=ts.TrackingID
		INNER JOIN Country country ON country.CountryID = TS.CountryID
		INNER JOIN States states ON states.StateID = TS.StateID
		WHERE TD.TrackingID=@trackingNumber

		IF @@ROWCOUNT>=1
		BEGIN
		  INSERT INTO customeraudit(TrackingID,AuditTimeStamp,RequestedDate) 
		  VALUES(@trackingNumber,GETDATE(),GETDATE());

		END
END
GO
CREATE PROC USP_ValidateLogin
 @Carrier VARCHAR(20),
 @LoginId VARCHAR(20),
 @Password VARCHAR(20)
AS
  BEGIN
    DECLARE @CarrierName VARCHAR(20)
	DECLARE @LoginName VARCHAR(20)
	DECLARE @PasswordValue VARCHAR(20)
	DECLARE @ParmDefinition NVARCHAR(1024)
    DECLARE  @SQL NVARCHAR(MAX)
    SELECT @SQL = 'select LD.UserName from LoginDetails LD inner join Employee E
                   ON LD.EmployeeID=E.EmployeeID inner join Couriers C on C.CourierID=E.CourierID 
				   where LD.UserName=@LoginName and LD.Password=@PasswordValue and C.CourierName=@CarrierName and LD.IsActive=1'

   SET @ParmDefinition=N'@CarrierName varchar(20),@LoginName varchar(20),@PasswordValue varchar(20)'
   EXECUTE sp_executeSQL      -- Dynamic T-SQL
            @SQL,
            @ParmDefinition,
            @CarrierName = @Carrier,
			@LoginName=@LoginId,
			@PasswordValue=@Password
  END
  GO
 CREATE PROCEDURE usp_GetOrders
(
@UserName VARCHAR(20)
)
AS
BEGIN
DECLARE @EmpID INT
--To get the employee id based on UserName
SELECT @EmpID=EmployeeID FROM LoginDetails WHERE UserName=@UserName
--Get the list of orders
SELECT TrackingID FROM TrackingDetails WHERE EmployeeID=@EmpID
END
GO

CREATE PROCEDURE usp_UpdatePackageStatus
(
@TrackingID VARCHAR(20),
@UserName NVARCHAR(100),
@StateName NVARCHAR(60),
@OtherState VARCHAR(20),
@Status NVARCHAR(100),
@CountryName NVARCHAR(100),
@Event VARCHAR(20),
@Output int out
)
AS
BEGIN
DECLARE @EmployeeID INT
DECLARE @StateID INT
DECLARE @CountryID INT
BEGIN TRY
BEGIN TRAN
--Getting EmployeeID based on UserName
SELECT @EmployeeID=EmployeeID FROM LoginDetails(NOLOCK) WHERE UserName=@UserName
--Getting the StateID only is OtherSate value is null
IF(@OtherState IS NULL)
BEGIN
SELECT @StateID=StateID FROM States(NOLOCK) WHERE StateName=@StateName
END
--Getting the CountryID
SELECT @CountryID=CountryID FROM Country(NOLOCK) WHERE Name=@CountryName
--Inserting into TrackStatus table
INSERT INTO TrackStatus(TrackingID,EmployeeID,StateID,OtherState,Status,CountryID,CreatedTimestamp,Event) VALUES
(
@TrackingID,
@EmployeeID,
CASE
WHEN @OtherState is null  THEN @StateID
ELSE 51
END,
CASE
WHEN @OtherState is null THEN NULL
ELSE @OtherState
END,
@Status,
@CountryID,
GETDATE(),
@Event
)
--Updating the tracking details table when with shipped date when the event name is 'Delivered'
IF(@Event ='Delivered')
BEGIN
UPDATE TrackingDetails set ShippedDate=GETDATE() WHERE TrackingID=@TrackingID
END
COMMIT TRAN
set @Output= 0
END TRY
BEGIN CATCH
set @Output= 1
ROLLBACK TRAN
END CATCH
END
GO
CREATE FUNCTION RandGen (
@c_name varchar(20),@P_no varchar(20)) returns varchar(20)
as
begin
declare @C_initial1 varchar(20),@rand1 varchar(20),@value1 varchar(20)
set @C_initial1=substring(@c_name,1,2)
set @rand1=Cast(Convert(varchar(20),GetDate(),12)+@P_no as varchar)
set @value1='R'+@C_initial1+@rand1
Return @value1
end
GO
CREATE proc PickupPackageForm
@CustomerName varchar(50),
@CourierName varchar(7),
@AddressLine1 varchar (100),
@AddressLine2 varchar (100),
@City varchar (20),
@StateName varchar (20),
@PhoneNumber nvarchar (25),
@EmailID nvarchar (50), --done till here
@PackageType varchar(50),
@Height varchar (5),
@Weight decimal(5,2),
@Description nvarchar(400),
@PickupDate datetime,
@PickupAddressLine1 varchar (1000),
@PickupAddressLine2 varchar (1000),
@PickupCity varchar (20),
@PickupState varchar (20),
@PackageStatusName varchar(20),
@RecipientName varchar (50),
@DropOffAdd1 varchar (1000),
@DropOffAdd2 varchar (1000),
@DropOffCity varchar (1000), 
@DropOffState varchar (20),
@DropOffCountry varchar (10),
@DropOffZipCode varchar (10),
@RC varchar(20) Output
as
begin
declare @PackageStatusID int
set @PackageStatusID=(select StatusID from [Status] where StatusName=@PackageStatusName)

declare @PackageTypeID int
set @PackageTypeID=(select PackageTypeID from PackageType where PackageType=@PackageType)
declare @CourierID int
set @CourierID=(select CourierID from Couriers where CourierName=@CourierName)
declare @StateID int
set @StateID=(select StateID from States where StateName=@StateName)

declare @PickupStateID int--done
set @PickupStateID=(select StateID from States where StateName=@PickupState)
declare @DStateID int--done
set @DStateID=(Select StateID from States where StateName=@DropOffState)
declare @DCountryID int--done
set @DCountryID=(select CountryID from Country where Country.Name=@DropOffCountry)
declare @c_name varchar(20)--done
SET @c_name = ( Select CourierName from Couriers where CourierID=@CourierID )
declare @req_id varchar(20)--done
set @req_id=(select dbo.RandGen(@c_name,@PhoneNumber))

insert into PickupPackageRequest  
(RequestID,CourierID,CustomerName,Address_Line1,Address_Line2,City,
StateID,PhoneNumber,EmailID,PickupAddress_Line1,PickupAddress_Line2,PickupCity,PickupStateID,PackageTypeID,PackageStatusID)
values 
(@req_id,@CourierID,@CustomerName,@AddressLine1,@AddressLine2,@City,@StateID,@PhoneNumber,@EmailID,@PickupAddressLine1,@PickupAddressLine2,@PickupCity,@PickupStateID,
@PackageTypeID,@PackageStatusID)


insert into PickupPackageDetails
(RequestID,Height,[Weight],[Description],CustomerName,PhoneNumber,PickupDateTime,DropOffAddressLine1,DropOffAddressLine2,DropOffCity,DropOffStateID,DropOffCountryID,DropOffZipCode)
values 
(@req_id,@Height,@Weight,@Description,@RecipientName,@PhoneNumber,@PickupDate,@DropOffAdd1,@DropOffAdd2,@DropOffCity,@DStateID,@DCountryID,@DropOffZipCode)

set @RC=@req_id
end
GO
CREATE Function UDF_rand_generator (@c_name varchar(20)) RETURNS varchar(20)
AS
BEGIN
DECLARE @C_initial varchar(20),@rand varchar(20),@value varchar(20)
SET @C_initial = substring(@c_name,1,2)
SET @rand = CAST(CONVERT(VARCHAR(20), GETDATE(), 12)+DATEPART(ss,GETDATE())*2 AS varchar)
SET @value = 'C'+@C_initial+@rand
RETURN @value
END
GO
CREATE PROC USP_Validate_ReqID
@Type varchar(50),
@Pkg_ID varchar(50)
AS
BEGIN
IF @Type = 'Package Tracking'
SELECT TrackingID from TrackingDetails WHERE TrackingID=@Pkg_ID AND IsPickupTracking='0'
ELSE
SELECT TrackingID from TrackingDetails WHERE TrackingID=@Pkg_ID AND IsPickupTracking='1'
END
GO
CREATE PROC USP_Dup_check @ReqID varchar(20),@Ctype varchar(20)
AS
BEGIN
IF (@Ctype = 'Package Tracking')
SELECT TComplaintID from CustomerSupportTracking WHERE TrackingID = @ReqID;
ELSE
SELECT PComplaintID from CustomerSupportPickup WHERE RequestID = @ReqID;
END
GO
CREATE PROC USP_Generate_Cid
@Type varchar(50),@Pkg_ID varchar(50),@Desc varchar(MAX),@Name varchar(20), @Mail varchar(20),@cid varchar(20) OUTPUT
AS
BEGIN
DECLARE @Cmp_ID varchar(20), @Cname varchar(10), @Empid int
SET @Cname = ( Select CourierName from Couriers c INNER JOIN TrackingDetails T 
			   ON c.CourierID = T.CourierID
			   WHERE TrackingID = @Pkg_ID )
SET @Cmp_ID = ( SELECT dbo.UDF_rand_generator(@Cname) )
SET @Empid = ( SELECT TOP 1 EmployeeID from Employee e INNER JOIN Couriers c ON e.CourierID=c.CourierID 
			   WHERE CourierName = @Cname )
BEGIN TRY
BEGIN TRAN
IF @Type='Package Tracking'
BEGIN
INSERT INTO CustomerSupportTracking(TComplaintID,TrackingID,CreatedDate,ClosedDate,ComplaintDesc,EmployeeID,CustomerName,MailID)
VALUES (@Cmp_ID,@Pkg_ID,GETDATE(),NULL,@Desc,@Empid,@Name,@Mail);
SELECT @cid=TComplaintID from CustomerSupportTracking WHERE TComplaintID=@Cmp_ID
END
ELSE IF @Type='Package Pickup'
BEGIN
INSERT INTO CustomerSupportPickup(PComplaintID,RequestID,CreatedDate,ClosedDate,ComplaintDesc,EmployeeID)
VALUES (@Cmp_ID,@Pkg_ID,GETDATE(),NULL,@Desc,@Empid);
SELECT @cid=PComplaintID from CustomerSupportPickup WHERE PComplaintID=@Cmp_ID
END
COMMIT TRAN
RETURN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
END
GO
CREATE PROC USP_InsertStatus
@cid varchar(20),@Status varchar(20),@comments varchar(MAX),@check bit OUTPUT
AS
BEGIN TRY
BEGIN TRAN
DECLARE @StatusID int;
DECLARE @ptype varchar(20);

SET @StatusID = (SELECT StatusID from [Status] WHERE StatusName=@Status)
INSERT INTO CustomerSupportStatus (ComplaintID,StatusID,Comments)
values (@cid,@StatusID,@comments);
SET @check = CASE WHEN @@ROWCOUNT = 0 THEN 1 ELSE 0 END
COMMIT TRAN
END TRY
BEGIN CATCH
SET @check =0;
ROLLBACK TRAN
END CATCH
GO
CREATE PROC USP_StatusDisplay
@cid varchar(20),@cid1 varchar(20) OUTPUT,@status varchar(15) OUTPUT,@comments varchar(MAX) OUTPUT
AS
BEGIN TRY
BEGIN TRAN
DECLARE @sid int;
SET @sid = (SELECT TOP 1 StatusID from CustomerSupportStatus WHERE ComplaintID=@cid)
SET @cid1=@cid
SET @status = (SELECT StatusName from [Status] WHERE StatusID=@sid)
SET @comments = (SELECT TOP 1 Comments from CustomerSupportStatus WHERE ComplaintID=@cid)
COMMIT TRAN
END TRY
BEGIN CATCH
ROLLBACK TRAN
END CATCH
GO
CREATE PROC USP_OpenComplaints @empName varchar(20)
AS
BEGIN
DECLARE @CName varchar(20);
SET @CName = (SELECT c.CourierName FROM Employee e JOIN Couriers c 
ON e.CourierID = c.CourierID JOIN LoginDetails l ON l.EmployeeID= e.EmployeeID
WHERE l.UserName = @empName);
SELECT ComplaintID FROM CustomerSupportStatus 
WHERE SUBSTRING(ComplaintID,2,2)=SUBSTRING(@CName,1,2)
GROUP BY ComplaintID HAVING COUNT(StatusID)=1;
END
GO

CREATE PROC USP_UpdateComplaints @empName varchar(20)
AS
BEGIN
DECLARE @CName1 varchar(20);
SET @CName1 = (SELECT c.CourierName FROM Employee e JOIN Couriers c ON e.CourierID = c.CourierID JOIN LoginDetails l ON l.EmployeeID= e.EmployeeID
WHERE l.UserName = @empName);
SELECT ComplaintID FROM CustomerSupportStatus WHERE StatusID!='6' AND SUBSTRING(ComplaintID,2,2)=SUBSTRING(@CName1,1,2);
END
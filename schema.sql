-- Drop existing tables if they exist
DROP TABLE IF EXISTS ProjectSuppliers;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS ProjectResources;
DROP TABLE IF EXISTS Notifications;
DROP TABLE IF EXISTS TimeLogs;
DROP TABLE IF EXISTS TaskTags;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS Notes;
DROP TABLE IF EXISTS EmployeeRoles;
DROP TABLE IF EXISTS Roles;
DROP TABLE IF EXISTS Expenses;
DROP TABLE IF EXISTS Budgets;
DROP TABLE IF EXISTS Files;
DROP TABLE IF EXISTS MeetingAttendees;
DROP TABLE IF EXISTS Meetings;
DROP TABLE IF EXISTS ProjectCustomers;
DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Projects;

-- Create base tables
CREATE TABLE Projects (
    ProjectID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectName TEXT NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Description TEXT,
    Status TEXT
);

CREATE TABLE Departments (
    DepartmentID INTEGER PRIMARY KEY AUTOINCREMENT,
    DepartmentName TEXT NOT NULL,
    Location TEXT
);

CREATE TABLE Employees (
    EmployeeID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE,
    Phone TEXT,
    HireDate DATE,
    DepartmentID INTEGER,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerName TEXT NOT NULL,
    ContactName TEXT,
    Email TEXT,
    Phone TEXT
);

CREATE TABLE Tasks (
    TaskID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectID INTEGER,
    TaskName TEXT NOT NULL,
    StartDate DATE,
    EndDate DATE,
    Status TEXT,
    AssignedEmployeeID INTEGER,
    Description TEXT,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (AssignedEmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE ProjectCustomers (
    ProjectCustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectID INTEGER,
    CustomerID INTEGER,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Meetings (
    MeetingID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectID INTEGER,
    MeetingDate DATETIME,
    Location TEXT,
    Summary TEXT,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

CREATE TABLE MeetingAttendees (
    MeetingAttendeeID INTEGER PRIMARY KEY AUTOINCREMENT,
    MeetingID INTEGER,
    EmployeeID INTEGER,
    FOREIGN KEY (MeetingID) REFERENCES Meetings(MeetingID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Files (
    FileID INTEGER PRIMARY KEY AUTOINCREMENT,
    TaskID INTEGER,
    FileName TEXT NOT NULL,
    FilePath TEXT,
    UploadDate DATETIME,
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID)
);

CREATE TABLE Budgets (
    BudgetID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectID INTEGER,
    BudgetAmount REAL,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

CREATE TABLE Expenses (
    ExpenseID INTEGER PRIMARY KEY AUTOINCREMENT,
    BudgetID INTEGER,
    ExpenseDate DATE,
    Amount REAL,
    Description TEXT,
    FOREIGN KEY (BudgetID) REFERENCES Budgets(BudgetID)
);

CREATE TABLE Roles (
    RoleID INTEGER PRIMARY KEY AUTOINCREMENT,
    RoleName TEXT NOT NULL
);

CREATE TABLE EmployeeRoles (
    EmployeeRoleID INTEGER PRIMARY KEY AUTOINCREMENT,
    EmployeeID INTEGER,
    RoleID INTEGER,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE Notes (
    NoteID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectID INTEGER,
    NoteText TEXT,
    CreatedDate DATETIME,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

CREATE TABLE Tags (
    TagID INTEGER PRIMARY KEY AUTOINCREMENT,
    TagName TEXT NOT NULL
);

CREATE TABLE TaskTags (
    TaskTagID INTEGER PRIMARY KEY AUTOINCREMENT,
    TaskID INTEGER,
    TagID INTEGER,
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID),
    FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);

CREATE TABLE TimeLogs (
    TimeLogID INTEGER PRIMARY KEY AUTOINCREMENT,
    TaskID INTEGER,
    EmployeeID INTEGER,
    StartTime DATETIME,
    EndTime DATETIME,
    HoursWorked REAL,
    FOREIGN KEY (TaskID) REFERENCES Tasks(TaskID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Notifications (
    NotificationID INTEGER PRIMARY KEY AUTOINCREMENT,
    EmployeeID INTEGER,
    NotificationType TEXT,
    Message TEXT,
    CreatedAt DATETIME,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE ProjectResources (
    ProjectResourceID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectID INTEGER,
    ResourceName TEXT,
    Quantity INTEGER,
    UnitCost REAL,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

CREATE TABLE Suppliers (
    SupplierID INTEGER PRIMARY KEY AUTOINCREMENT,
    SupplierName TEXT,
    ContactName TEXT,
    Phone TEXT,
    Email TEXT
);

CREATE TABLE ProjectSuppliers (
    ProjectSupplierID INTEGER PRIMARY KEY AUTOINCREMENT,
    ProjectID INTEGER,
    SupplierID INTEGER,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Sample data insertion
INSERT INTO Projects (ProjectName, Description, StartDate, EndDate, Status)
VALUES 
    ('Web Development Project', 'Company website redesign project', '2024-01-01', '2024-06-30', 'In Progress'),
    ('Mobile App Development', 'iOS and Android app development', '2024-02-01', '2024-08-31', 'Planning'),
    ('ERP Implementation', 'Enterprise Resource Planning System', '2024-03-15', '2024-12-31', 'Not Started');

INSERT INTO Departments (DepartmentName, Location)
VALUES
    ('Software Development', 'Floor 3'),
    ('Project Management', 'Floor 2'),
    ('Quality Assurance', 'Floor 3');

INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, DepartmentID)
VALUES
    ('John', 'Smith', 'john.smith@company.com', '555-0101', '2023-01-15', 1),
    ('Emma', 'Johnson', 'emma.j@company.com', '555-0102', '2023-02-20', 2),
    ('Michael', 'Brown', 'michael.b@company.com', '555-0103', '2023-03-10', 1);

INSERT INTO Tasks (ProjectID, TaskName, StartDate, EndDate, Status, AssignedEmployeeID, Description)
VALUES
    (1, 'Database Design', '2024-01-05', '2024-01-20', 'Completed', 1, 'Design and implement database schema'),
    (1, 'Frontend Development', '2024-01-21', '2024-03-15', 'In Progress', 3, 'Develop user interface'),
    (2, 'API Development', '2024-02-05', '2024-04-15', 'Not Started', 1, 'Create REST APIs');

INSERT INTO Customers (CustomerName, ContactName, Email, Phone)
VALUES
    ('Tech Solutions Inc.', 'Sarah Wilson', 'sarah@techsolutions.com', '555-0201'),
    ('Digital Innovations', 'Robert Clark', 'robert@digitalinno.com', '555-0202');

INSERT INTO Meetings (ProjectID, MeetingDate, Location, Summary)
VALUES
    (1, '2024-01-10 10:00:00', 'Conference Room A', 'Project Kickoff Meeting'),
    (1, '2024-01-24 14:00:00', 'Virtual Meeting', 'Sprint Planning');

INSERT INTO Roles (RoleName)
VALUES
    ('Project Manager'),
    ('Developer'),
    ('QA Engineer');

INSERT INTO EmployeeRoles (EmployeeID, RoleID)
VALUES
    (2, 1),
    (1, 2),
    (3, 2);

INSERT INTO Tags (TagName)
VALUES
    ('High Priority'),
    ('Backend'),
    ('Frontend');

INSERT INTO TaskTags (TaskID, TagID)
VALUES
    (1, 1),
    (1, 2),
    (2, 3);

INSERT INTO TimeLogs (TaskID, EmployeeID, StartTime, EndTime, HoursWorked)
VALUES
    (1, 1, '2024-01-05 09:00:00', '2024-01-05 17:00:00', 8),
    (2, 3, '2024-01-21 09:00:00', '2024-01-21 16:00:00', 7);

INSERT INTO Notes (ProjectID, NoteText, CreatedDate)
VALUES
    (1, 'Initial requirements gathered from client', '2024-01-02 10:30:00'),
    (2, 'Technology stack decided: React Native', '2024-02-02 14:15:00');

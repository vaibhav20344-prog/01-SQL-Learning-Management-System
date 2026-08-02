-- ==========================================
-- DATABASE INITIALIZATION
-- ==========================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'Techstack')
BEGIN
    CREATE DATABASE Techstack;
END;
GO

USE Techstack;
GO

-- ==========================================
-- 1. CORE TABLES (NO FOREIGN KEYS)
-- ==========================================

-- Students Master Table
CREATE TABLE Students (
    Student_ID INT PRIMARY KEY,
    Student_Name VARCHAR(60) NOT NULL,
    Phone_No VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(120),
    DOB DATE,
    Gender VARCHAR(50) CHECK (Gender IN ('Male', 'Female', 'Other')),
    Registration_Date DATETIME DEFAULT GETDATE()
);

-- Staff Master Table
CREATE TABLE Staff (
    Staff_ID INT PRIMARY KEY,
    Staff_Name VARCHAR(50) NOT NULL,
    Designation VARCHAR(50) CHECK (Designation IN ('Counsellor', 'Receptionist', 'Help Care', 'Admin', 'Office Assistant')),
    Phone_No VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

-- Faculty Master Table
CREATE TABLE Faculty (
    Faculty_ID INT PRIMARY KEY,
    Faculty_Name VARCHAR(50) NOT NULL,
    Phone_No VARCHAR(15),
    Email VARCHAR(100),
    Qualification VARCHAR(40)
);

-- Courses Master Table
CREATE TABLE Courses (
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(50) NOT NULL,
    Duration VARCHAR(30),
    Fees DECIMAL(10, 2)
);

-- Batches Master Table
CREATE TABLE Batches (
    Batch_ID INT PRIMARY KEY,
    Batch_Name VARCHAR(50) NOT NULL,
    Start_Date DATE,
    End_Date DATE
);

-- Companies Master Table
CREATE TABLE Companies (
    Company_ID INT PRIMARY KEY,
    Company_Name VARCHAR(50) NOT NULL,
    Location VARCHAR(70),
    Contact_Person VARCHAR(50)
);

-- ==========================================
-- 2. TRANSACTION & RELATIONAL TABLES
-- ==========================================

-- Student Enquiries
CREATE TABLE Student_Enquiries (
    Enquiry_ID INT PRIMARY KEY,
    Student_ID INT,
    Enquiry_Date DATE,
    Course_Interested VARCHAR(60),
    Source VARCHAR(50),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Student Counselling
CREATE TABLE Counselling (
    Counselling_ID INT PRIMARY KEY,
    Student_ID INT,
    Counsellor_ID INT,
    Counselling_Date DATE,
    Remarks VARCHAR(255),
    FOREIGN KEY (Counsellor_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Demo Classes
CREATE TABLE Demo_Class (
    Demo_ID INT PRIMARY KEY,
    Student_ID INT,
    Faculty_ID INT,
    Demo_Date DATE,
    Status VARCHAR(40),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Student Feedback
CREATE TABLE Feedback (
    Feedback_ID INT PRIMARY KEY,
    Student_ID INT,
    Rating INT,
    Comments VARCHAR(100),
    Feedback_Date DATE,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Batch Student Mapping
CREATE TABLE Batch_Students (
    Batch_StudentID INT PRIMARY KEY,
    Batch_ID INT,
    Student_ID INT,
    FOREIGN KEY (Batch_ID) REFERENCES Batches(Batch_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Fee Payments
CREATE TABLE Fees (
    Fee_ID INT PRIMARY KEY,
    Student_ID INT,
    Amount DECIMAL(10, 2),
    Payment_Date DATE,
    Payment_Mode VARCHAR(50),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Course Tests
CREATE TABLE Tests (
    Test_ID INT PRIMARY KEY,
    Test_Name VARCHAR(50) NOT NULL,
    Course_ID INT,
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Student Test Results
CREATE TABLE Student_Tests (
    StudentTest_ID INT PRIMARY KEY,
    Student_ID INT,
    Test_ID INT,
    Marks INT,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Test_ID) REFERENCES Tests(Test_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Interviews Management
CREATE TABLE Interviews (
    Interview_ID INT PRIMARY KEY,
    Student_ID INT,
    Company_ID INT,
    Interview_Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Company_ID) REFERENCES Companies(Company_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Job Placements
CREATE TABLE Placements (
    Placements_ID INT PRIMARY KEY,
    Student_ID INT,
    Company_ID INT,
    Package VARCHAR(50),
    Joining_Date DATE,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Company_ID) REFERENCES Companies(Company_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Online Class Schedules
CREATE TABLE Online_Classes (
    OnlineClass_ID INT PRIMARY KEY,
    Batch_ID INT,
    Class_Date DATE,
    Meeting_Link VARCHAR(70),
    Platform VARCHAR(40),
    FOREIGN KEY (Batch_ID) REFERENCES Batches(Batch_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Faculty Attendance
CREATE TABLE Faculty_Attendance (
    Attendance_ID INT PRIMARY KEY,
    Faculty_ID INT,
    Phone_No VARCHAR(15),
    Attendance_Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Faculty Work Timings
CREATE TABLE Faculty_Timing (
    Timing_ID INT PRIMARY KEY,
    Faculty_ID INT,
    Start_Time TIME,
    End_Time TIME,
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Faculty Payroll
CREATE TABLE Faculty_Salary (
    Salary_ID INT PRIMARY KEY,
    Faculty_ID INT,
    Month VARCHAR(20),
    Amount DECIMAL(10, 2),
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Faculty Class Schedules
CREATE TABLE Faculty_Timetable (
    Timetable_ID INT PRIMARY KEY,
    Faculty_ID INT,
    Batch_ID INT,
    Day_Name VARCHAR(20),
    Time_Slot TIME,
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Batch_ID) REFERENCES Batches(Batch_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Staff Attendance
CREATE TABLE Staff_Attendance (
    Attendance_ID INT PRIMARY KEY,
    Staff_ID INT,
    Attendance_Date DATE,
    Status VARCHAR(50),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Staff Payroll
CREATE TABLE Staff_Salary (
    Salary_ID INT PRIMARY KEY,
    Staff_ID INT,
    Month VARCHAR(30),
    Amount DECIMAL(10, 2),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Student Support Queries
CREATE TABLE Help_Tickets (
    Ticket_ID INT PRIMARY KEY,
    Student_ID INT,
    Issue VARCHAR(100),
    Status VARCHAR(50),
    Created_Date DATE,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

-- ==========================================
-- 3. DATA INSERTION
-- ==========================================

INSERT INTO Students (Student_ID, Student_Name, Phone_No, Email, Address, DOB, Gender) VALUES
(1,'Vaibhav','9876543210','vaibhav@gmail.com','Delhi','2004-05-20','Male'),
(2,'Rahul','9876543220','rahul@gmail.com','Noida','2003-08-15','Male'),
(3,'Priya','9876543230','priya@gmail.com','Gurgaon','2004-01-10','Female'),
(4,'Aman','9876543240','aman@gmail.com','Delhi','2003-06-12','Male'),
(5,'Neha','9876543250','neha@gmail.com','Faridabad','2004-09-25','Female'),
(6,'Karan','9876543260','karan@gmail.com','Ghaziabad','2002-11-18','Male'),
(7,'Pooja','9876543270','pooja@gmail.com','Delhi','2003-07-14','Female'),
(8,'Rohit','9876543280','rohit@gmail.com','Noida','2004-02-21','Male'),
(9,'Sneha','9876543290','sneha@gmail.com','Gurgaon','2003-12-11','Female'),
(10,'Arjun','9876543300','arjun@gmail.com','Delhi','2002-10-30','Male');

INSERT INTO Student_Enquiries VALUES
(1,1,'2026-05-01','Data Analytics','Instagram'),
(2,2,'2026-05-02','Python','YouTube'),
(3,3,'2026-05-03','Power BI','Reference'),
(4,4,'2026-05-04','SQL','Google'),
(5,5,'2026-05-05','Data Analytics','Website'),
(6,6,'2026-05-06','Python','Instagram'),
(7,7,'2026-05-07','Power BI','YouTube'),
(8,8,'2026-05-08','SQL','Reference'),
(9,9,'2026-05-09','Data Analytics','Google'),
(10,10,'2026-05-10','Python','Website');

INSERT INTO Staff VALUES
(101,'Neha','Counsellor','1111111110','neha@techstack.com'),
(102,'Amit','Receptionist','1111111120','amit@techstack.com'),
(103,'Ravi','Help Care','1111111130','ravi@techstack.com'),
(104,'Pooja','Counsellor','1111111140','pooja@techstack.com'),
(105,'Karan','Admin','1111111150','karan@techstack.com'),
(106,'Ritu','Receptionist','1111111160','ritu@techstack.com'),
(107,'Ajay','Help Care','1111111170','ajay@techstack.com'),
(108,'Deepak','Counsellor','1111111180','deepak@techstack.com'),
(109,'Meena','Office Assistant','1111111190','meena@techstack.com'),
(110,'Suresh','Admin','1111111200','suresh@techstack.com');

INSERT INTO Counselling VALUES
(1,1,101,'2026-05-02','Interested in Data Analytics'),
(2,2,104,'2026-05-03','Interested in Python'),
(3,3,108,'2026-05-04','Interested in Power BI'),
(4,4,101,'2026-05-05','Asked for fee details'),
(5,5,104,'2026-05-06','Requested weekend batch'),
(6,6,108,'2026-05-07','Will join next month'),
(7,7,101,'2026-05-08','Interested in placement support'),
(8,8,104,'2026-05-09','Demo class requested'),
(9,9,108,'2026-05-10','Looking for certification'),
(10,10,101,'2026-05-11','Confirmed admission');

INSERT INTO Faculty VALUES
(201,'Rahul Sharma','2222210000','rahul@techstack.com','MCA'),
(202,'Priya Verma','2222220000','priya@techstack.com','B.Tech'),
(203,'Amit Singh','2222230000','amit@techstack.com','M.Tech'),
(204,'Rohit Gupta','2222240000','rohit@techstack.com','MCA'),
(205,'Neha Kapoor','2222250000','nehak@techstack.com','MBA'),
(206,'Ankit Jain','2222260000','ankit@techstack.com','BCA'),
(207,'Pooja Sharma','2222270000','poojas@techstack.com','MCA'),
(208,'Deepak Kumar','2222280000','deepak@techstack.com','B.Tech'),
(209,'Riya Mehta','2222290000','riya@techstack.com','M.Sc'),
(210,'Arun Verma','2222300000','arun@techstack.com','MCA');

INSERT INTO Demo_Class VALUES
(1,1,201,'2026-05-10','Attended'),
(2,2,202,'2026-05-11','Attended'),
(3,3,203,'2026-05-12','Attended'),
(4,4,204,'2026-05-13','Pending'),
(5,5,205,'2026-05-14','Attended'),
(6,6,206,'2026-05-15','Attended'),
(7,7,207,'2026-05-16','Pending'),
(8,8,208,'2026-05-17','Attended'),
(9,9,209,'2026-05-18','Attended'),
(10,10,210,'2026-05-19','Attended');

INSERT INTO Feedback VALUES
(1,1,5,'Excellent','2026-05-11'),
(2,2,4,'Good','2026-05-12'),
(3,3,5,'Very Good','2026-05-13'),
(4,4,3,'Average','2026-05-14'),
(5,5,5,'Excellent','2026-05-15'),
(6,6,4,'Good','2026-05-16'),
(7,7,5,'Very Good','2026-05-17'),
(8,8,4,'Nice Session','2026-05-18'),
(9,9,5,'Excellent','2026-05-19'),
(10,10,5,'Outstanding','2026-05-20');

INSERT INTO Courses VALUES
(1,'Data Analytics','6 Months',40000),
(2,'Python','4 Months',25000),
(3,'Power BI','3 Months',20000),
(4,'SQL Server','2 Months',15000),
(5,'Excel','1 Month',10000),
(6,'Tableau','3 Months',22000),
(7,'Java','5 Months',30000),
(8,'Web Development','6 Months',45000),
(9,'AI Basics','4 Months',35000),
(10,'Data Science','8 Months',60000),
(11,'Data Analytics Advance','6 Months',60000);

INSERT INTO Batches VALUES
(1,'DA-Morning','2026-06-01','2026-12-01'),
(2,'Python-Evening','2026-06-05','2026-10-05'),
(3,'PowerBI-Morning','2026-06-10','2026-09-10'),
(4,'SQL-Evening','2026-06-15','2026-08-15'),
(5,'Excel-Morning','2026-06-20','2026-07-20'),
(6,'Tableau-Evening','2026-06-25','2026-09-25'),
(7,'Java-Morning','2026-07-01','2026-12-01'),
(8,'WebDev-Evening','2026-07-05','2027-01-05'),
(9,'AI-Morning','2026-07-10','2026-11-10'),
(10,'DS-Evening','2026-07-15','2027-03-15');

INSERT INTO Batch_Students VALUES
(1,1,1),(2,2,2),(3,3,3),(4,4,4),(5,5,5),
(6,6,6),(7,7,7),(8,8,8),(9,9,9),(10,10,10);

INSERT INTO Fees VALUES
(1,1,20000,'2026-06-01','UPI'),
(2,2,15000,'2026-06-02','Cash'),
(3,3,10000,'2026-06-03','Card'),
(4,4,12000,'2026-06-04','UPI'),
(5,5,8000,'2026-06-05','Cash'),
(6,6,15000,'2026-06-06','Card'),
(7,7,18000,'2026-06-07','UPI'),
(8,8,20000,'2026-06-08','Cash'),
(9,9,25000,'2026-06-09','Card'),
(10,10,30000,'2026-06-10','UPI');

INSERT INTO Tests VALUES
(1,'Data Analytics Test',1),
(2,'Python Test',2),
(3,'Power BI Test',3),
(4,'SQL Test',4),
(5,'Excel Test',5),
(6,'Tableau Test',6),
(7,'Java Test',7),
(8,'Web Dev Test',8),
(9,'AI Test',9),
(10,'Data Science Test',10);

INSERT INTO Student_Tests VALUES
(1,1,1,85),(2,2,2,78),(3,3,3,92),(4,4,4,75),(5,5,5,88),
(6,6,6,80),(7,7,7,91),(8,8,8,84),(9,9,9,89),(10,10,10,95);

INSERT INTO Companies VALUES
(1,'TCS','Noida','Rohit Sharma'),
(2,'Infosys','Gurugram','Ankit Verma'),
(3,'Wipro','Delhi','Neha Gupta'),
(4,'HCL Technologies','Noida','Amit Kumar'),
(5,'Tech Mahindra','Gurugram','Priya Sharma'),
(6,'Accenture','Bengaluru','Rahul Mehta'),
(7,'Capgemini','Pune','Sneha Jain'),
(8,'Cognizant','Chennai','Vikas Singh'),
(9,'Deloitte','Hyderabad','Pooja Verma'),
(10,'IBM','Bengaluru','Arjun Gupta');

INSERT INTO Interviews VALUES
(1,1,1,'2026-11-01','Selected'),
(2,2,2,'2026-11-02','Pending'),
(3,3,3,'2026-11-03','Selected'),
(4,4,1,'2026-11-04','Rejected'),
(5,5,2,'2026-11-05','Selected'),
(6,6,3,'2026-11-06','Pending'),
(7,7,1,'2026-11-07','Selected'),
(8,8,2,'2026-11-08','Rejected'),
(9,9,3,'2026-11-09','Selected'),
(10,10,1,'2026-11-10','Selected');

INSERT INTO Placements VALUES
(1,1,1,'6 LPA','2026-12-01'),
(2,2,2,'5 LPA','2026-12-02'),
(3,3,3,'7 LPA','2026-12-03'),
(4,5,2,'4.5 LPA','2026-12-04'),
(5,7,1,'6.5 LPA','2026-12-05'),
(6,9,3,'8 LPA','2026-12-06');

INSERT INTO Online_Classes VALUES
(1,1,'2026-06-05','meet1.com','Google Meet'),
(2,2,'2026-06-06','meet2.com','Zoom'),
(3,3,'2026-06-07','meet3.com','Teams'),
(4,4,'2026-06-08','meet4.com','Google Meet'),
(5,5,'2026-06-09','meet5.com','Zoom'),
(6,6,'2026-06-10','meet6.com','Teams'),
(7,7,'2026-06-11','meet7.com','Google Meet'),
(8,8,'2026-06-12','meet8.com','Zoom'),
(9,9,'2026-06-13','meet9.com','Teams'),
(10,10,'2026-06-14','meet10.com','Google Meet');

INSERT INTO Faculty_Attendance VALUES
(1,201,'9876500001','2026-06-01','Present'),
(2,202,'9876500002','2026-06-01','Present'),
(3,203,'9876500003','2026-06-01','Absent'),
(4,204,'9876500004','2026-06-01','Present'),
(5,205,'9876500005','2026-06-01','Present'),
(6,206,'9876500006','2026-06-01','Absent'),
(7,207,'9876500007','2026-06-01','Present'),
(8,208,'9876500008','2026-06-01','Present'),
(9,209,'9876500009','2026-06-01','Present'),
(10,210,'9876500010','2026-06-01','Present');

INSERT INTO Faculty_Timing VALUES
(1,201,'09:00','17:00'),(2,202,'10:00','18:00'),(3,203,'09:30','17:30'),
(4,204,'11:00','19:00'),(5,205,'09:00','17:00'),(6,206,'10:00','18:00'),
(7,207,'09:00','17:00'),(8,208,'11:00','19:00'),(9,209,'10:00','18:00'),
(10,210,'09:30','17:30');

INSERT INTO Faculty_Salary VALUES
(1,201,'June',50000),(2,202,'June',45000),(3,203,'June',55000),
(4,204,'June',48000),(5,205,'June',47000),(6,206,'June',43000),
(7,207,'June',52000),(8,208,'June',51000),(9,209,'June',49000),
(10,210,'June',53000);

INSERT INTO Faculty_Timetable VALUES
(1,201,1,'Monday','09:00'),(2,202,2,'Tuesday','10:00'),
(3,203,3,'Wednesday','11:00'),(4,204,4,'Thursday','12:00'),
(5,205,5,'Friday','09:00'),(6,206,6,'Saturday','10:00'),
(7,207,7,'Monday','11:00'),(8,208,8,'Tuesday','12:00'),
(9,209,9,'Wednesday','09:00'),(10,210,10,'Thursday','10:00');

INSERT INTO Staff_Attendance VALUES
(1,101,'2026-06-01','Present'),(2,102,'2026-06-01','Present'),
(3,103,'2026-06-01','Absent'),(4,104,'2026-06-01','Present'),
(5,105,'2026-06-01','Present'),(6,106,'2026-06-01','Absent'),
(7,107,'2026-06-01','Present'),(8,108,'2026-06-01','Present'),
(9,109,'2026-06-01','Present'),(10,110,'2026-06-01','Present');

INSERT INTO Staff_Salary VALUES
(1,101,'June',30000),(2,102,'June',25000),(3,103,'June',22000),
(4,104,'June',32000),(5,105,'June',35000),(6,106,'June',25000),
(7,107,'June',22000),(8,108,'June',33000),(9,109,'June',20000),
(10,110,'June',36000);

INSERT INTO Help_Tickets VALUES
(1,1,'Fee Receipt Required','Open','2026-06-01'),
(2,2,'Batch Change Request','Closed','2026-06-02'),
(3,3,'Class Recording Needed','Open','2026-06-03'),
(4,4,'Certificate Query','In Progress','2026-06-04'),
(5,5,'Login Issue','Closed','2026-06-05'),
(6,6,'Fee Installment Query','Open','2026-06-06'),
(7,7,'Placement Support Request','In Progress','2026-06-07'),
(8,8,'Assignment Submission Issue','Open','2026-06-08'),
(9,9,'Exam Schedule Query','Closed','2026-06-09'),
(10,10,'Course Material Access','Open','2026-06-10');
GO

-- ==========================================
-- 4. ANALYTICAL & REPORTING QUERIES
-- ==========================================

--- SECTION A: AGGREGATIONS & METRICS
-- High Level Business Summary
SELECT COUNT(*) AS Total_Students FROM Students;
SELECT COUNT(*) AS Total_Faculty FROM Faculty;
SELECT SUM(Amount) AS Total_Revenue FROM Fees;
SELECT AVG(Marks) AS Average_Student_Score FROM Student_Tests;

--- SECTION B: GROUP BY & HAVING CLAUSES
-- Gender Distribution
SELECT Gender, COUNT(*) AS Student_Count 
FROM Students 
GROUP BY Gender;

-- Payment Collection by Mode
SELECT Payment_Mode, SUM(Amount) AS Total_Collection 
FROM Fees 
GROUP BY Payment_Mode;

-- High Performing Students (Avg Marks > 80)
SELECT Student_ID, AVG(Marks) AS Avg_Marks 
FROM Student_Tests 
GROUP BY Student_ID 
HAVING AVG(Marks) > 80;

-- Companies with Multiple Interviews Scheduled
SELECT Company_ID, COUNT(*) AS Total_Interviews 
FROM Interviews 
GROUP BY Company_ID 
HAVING COUNT(*) >= 2;

--- SECTION C: JOINS & RELATIONAL REPORTS
-- Detailed Student Placement Report
SELECT 
    S.Student_Name, 
    C.Company_Name, 
    P.Package, 
    P.Joining_Date
FROM Students S
INNER JOIN Placements P ON S.Student_ID = P.Student_ID
INNER JOIN Companies C ON P.Company_ID = C.Company_ID;

-- Student Enrollment with Batches
SELECT 
    S.Student_Name, 
    B.Batch_Name
FROM Students S
INNER JOIN Batch_Students BS ON S.Student_ID = BS.Student_ID
INNER JOIN Batches B ON BS.Batch_ID = B.Batch_ID;

-- Students without any Fee Records (LEFT JOIN)
SELECT 
    S.Student_ID, 
    S.Student_Name
FROM Students S
LEFT JOIN Fees F ON S.Student_ID = F.Student_ID
WHERE F.Student_ID IS NULL;

--- SECTION D: ADVANCED WINDOW FUNCTIONS & CTEs
-- CTE to get top academic performers
WITH HighScorers AS (
    SELECT Student_ID, Test_ID, Marks
    FROM Student_Tests
    WHERE Marks > 80
)
SELECT * FROM HighScorers;

-- Student Ranking based on Test Performance
SELECT 
    Student_ID,
    Marks,
    RANK() OVER (ORDER BY Marks DESC) AS Test_Rank,
    DENSE_RANK() OVER (ORDER BY Marks DESC) AS Dense_Rank_No,
    ROW_NUMBER() OVER (ORDER BY Marks DESC) AS Row_Seq
FROM Student_Tests;
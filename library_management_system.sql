-- =============================================
-- Library Management System Database
-- Created by: [Your Name]
-- Date: [Current Date]
-- =============================================

-- Create database
DROP DATABASE IF EXISTS LibraryDB;
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- =============================================
-- Table: Members (Library Members/Users)
-- =============================================
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    library_card_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    date_of_birth DATE NOT NULL,
    membership_date DATE NOT NULL,
    membership_status ENUM('Active', 'Suspended', 'Expired') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_library_card (library_card_number),
    INDEX idx_membership_status (membership_status)
);

-- =============================================
-- Table: Authors (Book Authors)
-- =============================================
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(50),
    biography TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_author_name (last_name, first_name)
);

-- =============================================
-- Table: Publishers (Book Publishers)
-- =============================================
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    address TEXT,
    phone VARCHAR(15),
    email VARCHAR(100),
    website VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_publisher_name (name)
);

-- =============================================
-- Table: Books (Library Books Collection)
-- =============================================
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    edition VARCHAR(50),
    publication_year YEAR,
    genre VARCHAR(50) NOT NULL,
    language VARCHAR(30) DEFAULT 'English',
    page_count INT,
    description TEXT,
    publisher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id) ON DELETE SET NULL,
    
    INDEX idx_isbn (isbn),
    INDEX idx_title (title),
    INDEX idx_genre (genre),
    INDEX idx_publication_year (publication_year)
);

-- =============================================
-- Table: Book_Authors (Many-to-Many Relationship)
-- =============================================
CREATE TABLE Book_Authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id) ON DELETE CASCADE,
    
    INDEX idx_author_book (author_id, book_id)
);

-- =============================================
-- Table: Book_Copies (Physical Copies of Books)
-- =============================================
CREATE TABLE Book_Copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) UNIQUE NOT NULL,
    acquisition_date DATE NOT NULL,
    condition ENUM('New', 'Good', 'Fair', 'Poor', 'Damaged') DEFAULT 'Good',
    status ENUM('Available', 'Checked Out', 'Reserved', 'Under Maintenance', 'Lost') DEFAULT 'Available',
    location VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    
    INDEX idx_barcode (barcode),
    INDEX idx_status (status),
    INDEX idx_book_status (book_id, status)
);

-- =============================================
-- Table: Loans (Book Checkouts)
-- =============================================
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    late_fee DECIMAL(8,2) DEFAULT 0.00,
    status ENUM('Active', 'Returned', 'Overdue', 'Lost') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (copy_id) REFERENCES Book_Copies(copy_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    
    INDEX idx_member_loans (member_id, status),
    INDEX idx_due_date (due_date),
    INDEX idx_checkout_date (checkout_date),
    INDEX idx_active_loans (status, due_date)
);

-- =============================================
-- Table: Reservations (Book Reservations)
-- =============================================
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') DEFAULT 'Pending',
    priority INT DEFAULT 1,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (book_id) REFERENCES Books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    
    INDEX idx_member_reservations (member_id, status),
    INDEX idx_book_reservations (book_id, status),
    INDEX idx_reservation_date (reservation_date)
);

-- =============================================
-- Table: Fines (Late Fees and Penalties)
-- =============================================
CREATE TABLE Fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    loan_id INT,
    amount DECIMAL(8,2) NOT NULL,
    reason ENUM('Late Return', 'Damage', 'Lost Book', 'Other') NOT NULL,
    issue_date DATE NOT NULL,
    paid_date DATE,
    status ENUM('Pending', 'Paid', 'Waived') DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id) ON DELETE SET NULL,
    
    INDEX idx_member_fines (member_id, status),
    INDEX idx_issue_date (issue_date),
    INDEX idx_unpaid_fines (status, issue_date)
);

-- =============================================
-- Table: Staff (Library Staff Members)
-- =============================================
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    position VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    status ENUM('Active', 'Inactive', 'On Leave') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_staff_email (email),
    INDEX idx_staff_position (position)
);

-- =============================================
-- Insert Sample Data
-- =============================================

-- Insert Publishers
INSERT INTO Publishers (name, address, phone, email, website) VALUES
('Penguin Random House', '1745 Broadway, New York, NY', '212-782-9000', 'info@penguinrandomhouse.com', 'https://www.penguinrandomhouse.com'),
('HarperCollins', '195 Broadway, New York, NY', '212-207-7000', 'contact@harpercollins.com', 'https://www.harpercollins.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY', '212-698-7000', 'info@simonandschuster.com', 'https://www.simonandschuster.com');

-- Insert Authors
INSERT INTO Authors (first_name, last_name, birth_date, death_date, nationality, biography) VALUES
('George', 'Orwell', '1903-06-25', '1950-01-21', 'British', 'English novelist, essayist, journalist, and critic.'),
('J.K.', 'Rowling', '1965-07-31', NULL, 'British', 'Author of the Harry Potter series.'),
('Stephen', 'King', '1947-09-21', NULL, 'American', 'Author of horror, supernatural fiction, suspense, and fantasy novels.');

-- Insert Books
INSERT INTO Books (isbn, title, edition, publication_year, genre, language, page_count, description, publisher_id) VALUES
('9780451524935', '1984', '1st', 1949, 'Dystopian', 'English', 328, 'A dystopian social science fiction novel', 1),
('9780439554930', 'Harry Potter and the Philosopher''s Stone', '1st', 1997, 'Fantasy', 'English', 320, 'First book in the Harry Potter series', 2),
('9781501142970', 'The Shining', '1st', 1977, 'Horror', 'English', 447, 'A horror novel by Stephen King', 3);

-- Insert Book-Authors relationships
INSERT INTO Book_Authors (book_id, author_id) VALUES
(1, 1), -- 1984 by George Orwell
(2, 2), -- Harry Potter by J.K. Rowling
(3, 3); -- The Shining by Stephen King

-- Insert Book Copies
INSERT INTO Book_Copies (book_id, barcode, acquisition_date, condition, status, location) VALUES
(1, 'BC001001', '2023-01-15', 'Good', 'Available', 'Fiction Section A'),
(1, 'BC001002', '2023-01-15', 'Fair', 'Available', 'Fiction Section A'),
(2, 'BC002001', '2023-02-20', 'New', 'Available', 'Children Section B'),
(3, 'BC003001', '2023-03-10', 'Good', 'Checked Out', 'Horror Section C');

-- Insert Members
INSERT INTO Members (library_card_number, first_name, last_name, email, phone, address, date_of_birth, membership_date, membership_status) VALUES
('LC1001', 'John', 'Doe', 'john.doe@email.com', '555-0101', '123 Main St, Anytown', '1990-05-15', '2023-01-10', 'Active'),
('LC1002', 'Jane', 'Smith', 'jane.smith@email.com', '555-0102', '456 Oak St, Anytown', '1985-08-22', '2023-02-05', 'Active');

-- Insert Loans
INSERT INTO Loans (copy_id, member_id, checkout_date, due_date, return_date, status) VALUES
(4, 1, '2023-10-01', '2023-10-15', NULL, 'Active'); -- The Shining checked out

-- Insert Staff
INSERT INTO Staff (first_name, last_name, email, phone, position, department, hire_date, salary, status) VALUES
('Sarah', 'Johnson', 'sarah.johnson@library.org', '555-0201', 'Librarian', 'Circulation', '2020-06-15', 55000.00, 'Active'),
('Mike', 'Chen', 'mike.chen@library.org', '555-0202', 'Assistant Librarian', 'Reference', '2021-03-10', 45000.00, 'Active');

-- =============================================
-- Create Views for Common Queries
-- =============================================

-- View: Available Books
CREATE VIEW Available_Books AS
SELECT 
    b.book_id,
    b.title,
    b.isbn,
    a.first_name AS author_first_name,
    a.last_name AS author_last_name,
    bc.copy_id,
    bc.barcode,
    bc.condition,
    bc.location
FROM Books b
JOIN Book_Authors ba ON b.book_id = ba.book_id
JOIN Authors a ON ba.author_id = a.author_id
JOIN Book_Copies bc ON b.book_id = bc.book_id
WHERE bc.status = 'Available';

-- View: Current Active Loans
CREATE VIEW Active_Loans AS
SELECT 
    l.loan_id,
    m.first_name,
    m.last_name,
    m.library_card_number,
    b.title,
    bc.barcode,
    l.checkout_date,
    l.due_date,
    l.late_fee
FROM Loans l
JOIN Members m ON l.member_id = m.member_id
JOIN Book_Copies bc ON l.copy_id = bc.copy_id
JOIN Books b ON bc.book_id = b.book_id
WHERE l.status = 'Active';

-- =============================================
-- Comments and Documentation
-- =============================================

/*
LIBRARY MANAGEMENT SYSTEM DATABASE SCHEMA

This database design supports a comprehensive library management system with:
- Member management and tracking
- Book catalog with authors and publishers
- Physical copy inventory management
- Loan and reservation tracking
- Fine management system
- Staff management

TABLES:
1. Members - Library members/users
2. Authors - Book authors
3. Publishers - Book publishers
4. Books - Book metadata
5. Book_Authors - Many-to-many relationship
6. Book_Copies - Physical copies
7. Loans - Checkout records
8. Reservations - Book reservations
9. Fines - Late fees and penalties
10. Staff - Library staff

RELATIONSHIPS:
- One Publisher to Many Books
- Many Books to Many Authors (through Book_Authors)
- One Book to Many Book_Copies
- One Member to Many Loans
- One Book_Copy to Many Loans
- One Member to Many Reservations
- One Member to Many Fines

INDEXES: Appropriate indexes created for performance optimization
VIEWS: Created for common reporting queries
*/

-- =============================================
-- End of Library Management System SQL Script
-- =============================================
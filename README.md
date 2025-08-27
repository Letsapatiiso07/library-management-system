# Library Management System Database

## 📚 Project Description
A comprehensive relational database system for managing library operations including book cataloging, member management, loan tracking, and fine management.

## 🚀 Features
- Member registration and management
- Book catalog with authors and publishers
- Physical copy inventory tracking
- Loan and reservation system
- Fine management for late returns
- Staff management
- Comprehensive reporting views

## 🛠️ Technologies Used
- MySQL
- Relational Database Design
- SQL Constraints and Relationships

## 📋 Setup Instructions

1. **Prerequisites**: Install MySQL Server and MySQL Workbench
2. **Create Database**: Run the entire SQL script in MySQL Workbench
3. **Verify**: Check that all tables and sample data are created successfully

## 🗄️ Database Schema
The database includes 10 main tables with proper relationships:
- Members ↔ Loans (One-to-Many)
- Books ↔ Book_Copies (One-to-Many)
- Books ↔ Authors (Many-to-Many via Book_Authors)
- And other supporting tables

## 📝 Usage
Use the provided views for common queries:
- `Available_Books` - See all available books
- `Active_Loans` - View current checked-out books

## 🤝 Contributing
This is a academic project. Feel free to extend and improve the database design.

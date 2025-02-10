# MySQL Data Backup & Stored Procedures Project

## Overview
This project was independently developed without any external guidance. It demonstrates how to use **Stored Procedures**, **Triggers**, and **Data Backup Handling** in MySQL for better database management and security. The project aims to replicate real-world database operations by ensuring data integrity and maintaining logs of modifications.

## Features
- **Stored Procedures:** For inserting, updating, and deleting payment records.
- **Triggers:** Automatically log changes into backup tables.
- **Data Backup Handling:** Keeps track of modified and deleted records.

## Real-World Application
This project simulates a real-world **database audit system** where financial transactions need to be securely updated, deleted, and tracked. Organizations that deal with sensitive payment information can benefit from such a backup system to maintain historical records of transactions.

## Database Schema
The project consists of the following tables:
1. `payments` - Stores original payment records.
2. `backupdata` - Stores old payment details before updates.
3. `delete_backup` - Stores deleted payment records.
4. `new_data` - Stores newly inserted payment records.

## Setup Instructions
### Prerequisites
- MySQL installed on your system
- A MySQL database created (`your_database_name`)

### Steps to Set Up
1. **Create the required tables:**
   ```sql
   CREATE TABLE payments (
       customerNumber INT,
       checkNumber VARCHAR(50) PRIMARY KEY,
       paymentDate DATE,
       amount DECIMAL(10,2)
   );
   
   CREATE TABLE backupdata (
       customerNumber INT,
       checkNumber VARCHAR(50),
       paymentDate DATE,
       amount DECIMAL(10,2),
       update_date TIMESTAMP DEFAULT NOW(),
       PRIMARY KEY (customerNumber, checkNumber)
   );
   
   CREATE TABLE delete_backup (
       id INT PRIMARY KEY AUTO_INCREMENT,
       customerNumber INT,
       checkNumber VARCHAR(50),
       paymentDate DATE,
       amount DECIMAL(10,2),
       delete_time TIMESTAMP DEFAULT NOW()
   );
   
   CREATE TABLE new_data (
       id INT PRIMARY KEY AUTO_INCREMENT,
       customerNumber INT,
       checkNumber VARCHAR(50),
       amount DECIMAL(10,2),
       paymentDate TIMESTAMP DEFAULT NOW()
   );
   ```

2. **Create Stored Procedures:**
   ```sql
   DELIMITER //
   CREATE PROCEDURE insert_data(IN customerNumber INT, IN checkNumber VARCHAR(50), IN paymentDate DATE, IN amount DECIMAL(10,2))
   BEGIN
       INSERT INTO payments VALUES(customerNumber, checkNumber, paymentDate, amount);
   END //
   DELIMITER ;
   ```

3. **Create Triggers:**
   ```sql
   DELIMITER //
   CREATE TRIGGER update_triggers AFTER UPDATE ON payments
   FOR EACH ROW
   BEGIN
       INSERT INTO backupdata(customerNumber, checkNumber, paymentDate, amount)
       VALUES(OLD.customerNumber, OLD.checkNumber, OLD.paymentDate, OLD.amount);
   END //
   DELIMITER ;
   ```

4. **Insert Sample Data (Use provided SQL script)**

## Sample Data for Testing
Run the following SQL script to insert sample records:
```sql
INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount) VALUES
(101, 'CHK001', '2024-02-01', 250.50),
(102, 'CHK002', '2024-02-02', 350.75),
(103, 'CHK003', '2024-02-03', 150.25);
```

## Usage
- **Insert new payment record:**
  ```sql
  CALL insert_data(104, 'CHK004', '2024-02-04', 400.00);
  ```
- **Update payment record:**
  ```sql
  CALL update_amount('CHK001', 300.00);
  ```
- **Delete a payment record:**
  ```sql
  CALL delete_data('CHK002');
  ```

## Future Enhancements
- Add more advanced data analysis features like trend analysis and visualization.
- Implement audit log tracking with detailed user actions.

## License
This project is open-source and free to use!

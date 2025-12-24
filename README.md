# Vehicle Rental System - Database Design & SQL Implementation

## 📋 Project Overview

This project implements a comprehensive **Vehicle Rental System** database designed to manage users, vehicles, and bookings efficiently. The system demonstrates professional database design principles, including entity relationships, constraints, and SQL query optimization.

### Key Features

- User management with role-based access (Admin/Customer)
- Vehicle inventory tracking with availability status
- Booking system with date validation and cost calculation
- Comprehensive data integrity through constraints and foreign keys

---

## 🎯 Project Objectives

This assignment demonstrates proficiency in:

- **Database Design**: Creating normalized tables with proper relationships
- **ERD Modeling**: Implementing One-to-Many and Many-to-One relationships
- **SQL Queries**: Writing complex queries using JOIN, EXISTS, WHERE, GROUP BY, and HAVING
- **Data Integrity**: Implementing primary keys, foreign keys, and constraints

---

## 🗄️ Database Schema

### **Users Table**

Stores user information with role-based access control.

| Column     | Type         | Constraints                           |
| ---------- | ------------ | ------------------------------------- |
| `user_id`  | SERIAL       | PRIMARY KEY                           |
| `role`     | ENUM         | ('Admin', 'Customer') NOT NULL        |
| `name`     | VARCHAR(100) | NOT NULL                              |
| `email`    | VARCHAR(255) | UNIQUE NOT NULL                       |
| `password` | VARCHAR(150) | NOT NULL CHECK(LENGTH(password) >= 8) |
| `phone`    | VARCHAR(255) | NOT NULL                              |

### **Vehicles Table**

Manages vehicle inventory with availability tracking.

| Column                | Type         | Constraints                                     |
| --------------------- | ------------ | ----------------------------------------------- |
| `vehicle_id`          | SERIAL       | PRIMARY KEY                                     |
| `type`                | ENUM         | ('car', 'bike', 'truck') NOT NULL               |
| `name`                | VARCHAR(100) | NOT NULL                                        |
| `registration_number` | VARCHAR(255) | UNIQUE NOT NULL                                 |
| `model`               | VARCHAR(150) | NOT NULL                                        |
| `rental_price`        | INTEGER      | NOT NULL CHECK(rental_price >= 0)               |
| `status`              | ENUM         | ('available', 'rented', 'maintenance') NOT NULL |

### **Bookings Table**

Tracks rental bookings with date validation and cost management.

| Column       | Type    | Constraints                                                 |
| ------------ | ------- | ----------------------------------------------------------- |
| `booking_id` | SERIAL  | PRIMARY KEY                                                 |
| `user_id`    | INTEGER | FOREIGN KEY REFERENCES users(user_id)                       |
| `vehicle_id` | INTEGER | FOREIGN KEY REFERENCES vehicles(vehicle_id)                 |
| `start_date` | DATE    | NOT NULL                                                    |
| `end_date`   | DATE    | CHECK(end_date >= start_date)                               |
| `total_cost` | INTEGER | NOT NULL CHECK(total_cost >= 0)                             |
| `status`     | ENUM    | ('pending', 'confirmed', 'completed', 'cancelled') NOT NULL |

---

## 🔗 Entity Relationships

### **ERD Overview**

The database implements the following relationships:

1. **One-to-Many**: `Users → Bookings`

   - One user can make multiple bookings
   - Foreign Key: `bookings.user_id` → `users.user_id`

2. **Many-to-One**: `Bookings → Vehicles`

   - Multiple bookings can reference one vehicle
   - Foreign Key: `bookings.vehicle_id` → `vehicles.vehicle_id`

3. **Logical One-to-One**: Each booking connects exactly one user to one vehicle at a specific time

---

## 📊 SQL Queries & Solutions

### **Query 1: Retrieve Booking Information with Customer and Vehicle Details**

**Concept**: INNER JOIN

**Solution:**

```sql
SELECT
    b.booking_id,
    u.name AS customer_name,
    v.name AS vehicle_name,
    b.start_date,
    b.end_date,
    b.status
FROM bookings AS b
INNER JOIN users AS u ON u.user_id = b.user_id
INNER JOIN vehicles AS v ON v.vehicle_id = b.vehicle_id;
```

**Explanation:**

- This query performs two INNER JOINs to combine data from three tables: `bookings`, `users`, and `vehicles`
- First, it joins `bookings` with `users` using `user_id` to get the customer's name
- Then, it joins with `vehicles` using `vehicle_id` to get the vehicle's name
- The result displays booking details along with readable customer and vehicle names instead of just IDs
- INNER JOIN ensures only bookings with valid user and vehicle references are returned

---

### **Query 2: Find Vehicles That Have Never Been Booked**

**Concept**: NOT EXISTS

**Solution:**

```sql
SELECT *
FROM vehicles v
WHERE NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.vehicle_id = v.vehicle_id
)
ORDER BY vehicle_id;
```

**Explanation:**

- This query uses a subquery with `NOT EXISTS` to find vehicles without any booking records
- The outer query selects all columns from the `vehicles` table
- The subquery checks if there are any bookings for each vehicle
- `NOT EXISTS` returns true when the subquery finds no matching rows
- This efficiently identifies vehicles that have never been rented
- Results are ordered by `vehicle_id` for better readability

---

### **Query 3: Retrieve Available Vehicles of a Specific Type**

**Concept**: SELECT with WHERE clause

**Solution:**

```sql
SELECT *
FROM vehicles
WHERE type = 'car' AND status = 'available';
```

**Explanation:**

- This query uses the WHERE clause to filter vehicles based on two conditions
- First condition: `type = 'car'` filters only car-type vehicles (can be changed to 'bike' or 'truck')
- Second condition: `status = 'available'` ensures only available vehicles are shown
- The `AND` operator ensures both conditions must be true
- This query is useful for customers browsing available vehicles of a specific type
- Returns all columns for matching vehicles

---

### **Query 4: Find Vehicles with More Than 2 Bookings**

**Concept**: GROUP BY and HAVING

**Solution:**

```sql
SELECT
    v.name AS vehicle_name,
    COUNT(*) AS total_bookings
FROM vehicles AS v
INNER JOIN bookings AS b ON b.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_id, v.name
HAVING COUNT(*) > 2;
```

**Explanation:**

- This query analyzes booking frequency to identify popular vehicles
- First, it joins `vehicles` and `bookings` tables to connect vehicles with their bookings
- `GROUP BY v.vehicle_id, v.name` groups all bookings by each vehicle
- `COUNT(*)` counts the number of bookings for each vehicle
- `HAVING COUNT(*) > 2` filters the grouped results to show only vehicles with more than 2 bookings
- Note: HAVING is used instead of WHERE because it filters grouped/aggregated data
- This helps identify which vehicles are in high demand

---

## 🚀 Getting Started

### **Prerequisites**

- PostgreSQL 12+ or compatible SQL database
- Database client (pgAdmin, DBeaver, or psql CLI)

### **Setup Instructions**

1. **Create Database**

```sql
CREATE DATABASE vehicle_rental_system;
```

2. **Create Tables** (Run in order)

```sql
-- Create Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    role VARCHAR(20) CHECK(role IN ('Admin', 'Customer')) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(150) NOT NULL CHECK(LENGTH(password) >= 8),
    phone VARCHAR(255) NOT NULL
);

-- Create Vehicles table
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    type VARCHAR(20) CHECK(type IN ('car', 'bike', 'truck')) NOT NULL,
    name VARCHAR(100) NOT NULL,
    registration_number VARCHAR(255) UNIQUE NOT NULL,
    model VARCHAR(150) NOT NULL,
    rental_price INTEGER NOT NULL CHECK(rental_price >= 0),
    status VARCHAR(20) CHECK(status IN ('available', 'rented', 'maintenance')) NOT NULL
);

-- Create Bookings table
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    vehicle_id INTEGER REFERENCES vehicles(vehicle_id),
    start_date DATE NOT NULL,
    end_date DATE CHECK(end_date >= start_date),
    total_cost INTEGER NOT NULL CHECK(total_cost >= 0),
    status VARCHAR(20) CHECK(status IN ('pending', 'confirmed', 'completed', 'cancelled')) NOT NULL
);
```

3. **Run Queries**

- Execute queries from `queries.sql` file

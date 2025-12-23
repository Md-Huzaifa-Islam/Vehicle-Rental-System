## Query - 1

**Description:** What is a foreign key and why is it important in relational databases?

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

---

## Query - 2

**Description:** What is the difference between WHERE and HAVING clauses in SQL?

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

---

## Query - 3

**Description:** What is a primary key and what are its characteristics?

```sql
SELECT *
FROM vehicles
WHERE type = 'car';
```

---

## Query - 4

**Description:** What is the difference between INNER JOIN and LEFT JOIN in SQL?

```sql
SELECT
    v.name AS vehicle_name,
    COUNT(*) AS total_bookings
FROM vehicles AS v
INNER JOIN bookings AS b ON b.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_id
HAVING COUNT(*) > 2;
```

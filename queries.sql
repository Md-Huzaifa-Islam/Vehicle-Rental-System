-- Query 1
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


-- Query 2
SELECT *
FROM vehicles v
WHERE NOT EXISTS (
    SELECT 1
    FROM bookings b
    WHERE b.vehicle_id = v.vehicle_id
)
ORDER BY vehicle_id;


-- Query 3
SELECT *
FROM vehicles
WHERE type = 'car' AND status = 'available';


-- Query 4
SELECT
    v.name AS vehicle_name,
    COUNT(*) AS total_bookings
FROM vehicles AS v
INNER JOIN bookings AS b ON b.vehicle_id = v.vehicle_id
GROUP BY v.vehicle_id, v.name
HAVING COUNT(*) > 2;

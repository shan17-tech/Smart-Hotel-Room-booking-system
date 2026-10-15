-- SQL QUERIES FOR DEMONSTRATION
-- Run in terminal:  sqlite3 hotel_backend.db < 03_queries.sql
-- Or open hotel_backend.db in "DB Browser for SQLite" and paste a query.
.headers on
.mode column

-- Q1. All bookings with customer, room and room type (JOINS via view)
SELECT * FROM v_booking_details;

-- Q2. Rooms free from 2026-10-20 to 2026-10-23 (SUBQUERY)
SELECT r.room_no, rt.type_name, rt.base_price
FROM Room r JOIN RoomType rt ON r.type_id = rt.type_id
WHERE r.room_id NOT IN (
    SELECT room_id FROM Booking
    WHERE status IN ('Booked','Checked-In')
      AND check_in < '2026-10-23' AND check_out > '2026-10-20');

-- Q3. Monthly revenue (GROUP BY)
SELECT strftime('%Y-%m', pay_date) AS month, SUM(amount) AS revenue
FROM Payment GROUP BY month ORDER BY month;

-- Q4. Top customers by amount paid (JOINS + GROUP BY)
SELECT c.name, COUNT(DISTINCT b.booking_id) AS bookings, SUM(p.amount) AS total_spent
FROM Customer c
JOIN Booking b ON c.customer_id = b.customer_id
JOIN Payment p ON b.booking_id = p.booking_id
GROUP BY c.customer_id ORDER BY total_spent DESC;

-- Q5. Customers spending above average (NESTED SUBQUERY)
SELECT name FROM Customer WHERE customer_id IN (
  SELECT b.customer_id FROM Booking b JOIN Payment p ON b.booking_id = p.booking_id
  GROUP BY b.customer_id
  HAVING SUM(p.amount) > (SELECT AVG(t) FROM (
      SELECT SUM(p2.amount) AS t FROM Payment p2
      JOIN Booking b2 ON p2.booking_id = b2.booking_id GROUP BY b2.customer_id)));

-- Q6. Cancellation rate by room type
SELECT rt.type_name, COUNT(*) AS total, SUM(b.status='Cancelled') AS cancelled,
       ROUND(100.0 * SUM(b.status='Cancelled') / COUNT(*), 1) AS cancel_percent
FROM Booking b JOIN Room r ON b.room_id = r.room_id
JOIN RoomType rt ON r.type_id = rt.type_id GROUP BY rt.type_name;

-- Q7. Average rating per room type
SELECT rt.type_name, ROUND(AVG(f.rating),2) AS avg_rating, COUNT(*) AS reviews
FROM Feedback f JOIN Booking b ON f.booking_id = b.booking_id
JOIN Room r ON b.room_id = r.room_id JOIN RoomType rt ON r.type_id = rt.type_id
GROUP BY rt.type_name;

-- Q8. Bill for every booking = nights x price x 1.12 (12% GST)
SELECT booking_id,
       CAST(julianday(check_out) - julianday(check_in) AS INTEGER) AS nights,
       ROUND((julianday(check_out) - julianday(check_in)) * price_per_night * 1.12, 2) AS bill
FROM Booking;

-- Q9. Current occupancy (VIEW)
SELECT * FROM v_occupancy;

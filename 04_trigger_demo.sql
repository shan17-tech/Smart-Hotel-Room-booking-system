-- TRIGGER DEMONSTRATION
-- Run in terminal:  sqlite3 hotel_backend.db < 04_trigger_demo.sql
-- (This changes the data. To reset, rebuild the database - see README.)
.headers on
.mode column

-- 1) Before: room 102 is Occupied (booking 6 is Checked-In)
SELECT room_no, status FROM Room WHERE room_no = '102';

-- 2) Check-out booking 6  ->  trg_release_room sets the room to Available
UPDATE Booking SET status = 'Checked-Out' WHERE booking_id = 6;
SELECT room_no, status FROM Room WHERE room_no = '102';

-- 3) Check-in booking 7  ->  trg_checkin sets room 302 to Occupied
UPDATE Booking SET status = 'Checked-In' WHERE booking_id = 7;
SELECT room_no, status FROM Room WHERE room_no = '302';

-- 4) Cancel booking 7  ->  trg_cancel_count adds 1 to the customer's cancellations
SELECT name, prev_cancellations FROM Customer WHERE customer_id = 6;
UPDATE Booking SET status = 'Cancelled' WHERE booking_id = 7;
SELECT name, prev_cancellations FROM Customer WHERE customer_id = 6;
SELECT room_no, status FROM Room WHERE room_no = '302';

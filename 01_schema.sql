-- HOTEL ROOM BOOKING SYSTEM : DATABASE SCHEMA (SQLite)
-- Tables, constraints, triggers and views
PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS Customer(
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT UNIQUE NOT NULL,
    email TEXT,
    id_proof TEXT,
    prev_cancellations INTEGER DEFAULT 0
);
CREATE TABLE IF NOT EXISTS RoomType(
    type_id INTEGER PRIMARY KEY,
    type_name TEXT NOT NULL,
    base_price REAL NOT NULL CHECK(base_price > 0),
    capacity INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS Room(
    room_id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_no TEXT UNIQUE NOT NULL,
    type_id INTEGER NOT NULL REFERENCES RoomType(type_id),
    floor INTEGER,
    status TEXT DEFAULT 'Available' CHECK(status IN ('Available','Occupied','Maintenance'))
);
CREATE TABLE IF NOT EXISTS Staff(
    staff_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    role TEXT
);
CREATE TABLE IF NOT EXISTS Booking(
    booking_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL REFERENCES Customer(customer_id),
    room_id INTEGER NOT NULL REFERENCES Room(room_id),
    booking_date TEXT,
    check_in TEXT NOT NULL,
    check_out TEXT NOT NULL,
    guests INTEGER NOT NULL,
    deposit_type INTEGER DEFAULT 0,
    price_per_night REAL NOT NULL,
    status TEXT DEFAULT 'Booked'
        CHECK(status IN ('Booked','Checked-In','Checked-Out','Cancelled')),
    CHECK(check_out > check_in)
);
CREATE TABLE IF NOT EXISTS Payment(
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER NOT NULL REFERENCES Booking(booking_id),
    amount REAL NOT NULL CHECK(amount > 0),
    mode TEXT,
    pay_date TEXT
);
CREATE TABLE IF NOT EXISTS Feedback(
    feedback_id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER NOT NULL REFERENCES Booking(booking_id),
    rating INTEGER CHECK(rating BETWEEN 1 AND 5),
    comments TEXT
);

-- TRIGGERS ---------------------------------------------------------
CREATE TRIGGER IF NOT EXISTS trg_checkin
AFTER UPDATE OF status ON Booking WHEN NEW.status = 'Checked-In'
BEGIN
    UPDATE Room SET status = 'Occupied' WHERE room_id = NEW.room_id;
END;

CREATE TRIGGER IF NOT EXISTS trg_release_room
AFTER UPDATE OF status ON Booking WHEN NEW.status IN ('Checked-Out','Cancelled')
BEGIN
    UPDATE Room SET status = 'Available' WHERE room_id = NEW.room_id;
END;

CREATE TRIGGER IF NOT EXISTS trg_cancel_count
AFTER UPDATE OF status ON Booking WHEN NEW.status = 'Cancelled'
BEGIN
    UPDATE Customer SET prev_cancellations = prev_cancellations + 1
    WHERE customer_id = NEW.customer_id;
END;

-- VIEWS ------------------------------------------------------------
CREATE VIEW IF NOT EXISTS v_occupancy AS
SELECT rt.type_name AS room_type,
       COUNT(r.room_id) AS total_rooms,
       SUM(r.status = 'Occupied') AS occupied_now
FROM Room r JOIN RoomType rt ON r.type_id = rt.type_id
GROUP BY rt.type_name;

CREATE VIEW IF NOT EXISTS v_booking_details AS
SELECT b.booking_id, c.name AS customer, r.room_no, rt.type_name AS room_type,
       b.check_in, b.check_out, b.guests, b.price_per_night, b.status
FROM Booking b
JOIN Customer c  ON b.customer_id = c.customer_id
JOIN Room r      ON b.room_id = r.room_id
JOIN RoomType rt ON r.type_id = rt.type_id;

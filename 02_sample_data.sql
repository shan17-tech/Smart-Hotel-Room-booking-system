-- SAMPLE DATA
PRAGMA foreign_keys = ON;
INSERT INTO RoomType VALUES (1,'Single',1500,1),(2,'Double',2500,2),(3,'Deluxe',4000,3),(4,'Suite',6500,4);

INSERT INTO Room(room_no,type_id,floor) VALUES
 ('101',1,1),('102',1,1),('201',2,2),('202',2,2),('301',3,3),('302',3,3),('401',4,4),('402',4,4);

INSERT INTO Staff(name,role) VALUES
 ('Ramesh Patil','Manager'),('Sneha Joshi','Receptionist'),('Amit Kulkarni','Housekeeping');

INSERT INTO Customer(name,phone,email,id_proof,prev_cancellations) VALUES
 ('Aarav Sharma','9876510000','aarav@mail.com','ID-1000',0),
 ('Priya Nair','9876510001','priya@mail.com','ID-1001',0),
 ('Rohan Mehta','9876510002','rohan@mail.com','ID-1002',1),
 ('Ananya Iyer','9876510003','ananya@mail.com','ID-1003',0),
 ('Karan Singh','9876510004','karan@mail.com','ID-1004',0),
 ('Neha Gupta','9876510005','neha@mail.com','ID-1005',0);

INSERT INTO Booking(customer_id,room_id,booking_date,check_in,check_out,guests,deposit_type,price_per_night,status) VALUES
 (1,1,'2026-08-25','2026-09-01','2026-09-04',1,0,1500,'Checked-Out'),
 (2,3,'2026-08-30','2026-09-05','2026-09-08',2,1,2500,'Checked-Out'),
 (3,5,'2026-09-01','2026-09-10','2026-09-12',2,0,4000,'Cancelled'),
 (4,7,'2026-09-08','2026-09-15','2026-09-18',3,1,6500,'Checked-Out'),
 (1,4,'2026-09-20','2026-10-01','2026-10-03',2,0,2500,'Checked-Out'),
 (5,2,'2026-10-10','2026-10-13','2026-10-16',1,0,1500,'Checked-In'),
 (6,6,'2026-10-12','2026-10-20','2026-10-23',2,1,4000,'Booked');
UPDATE Room SET status='Occupied' WHERE room_id=2;

-- bill = nights x price x 1.12 (12% GST)
INSERT INTO Payment(booking_id,amount,mode,pay_date) VALUES
 (1,5040,'UPI','2026-09-04'),
 (2,8400,'Card','2026-09-08'),
 (4,21840,'Cash','2026-09-18'),
 (5,5600,'UPI','2026-10-03'),
 (6,1000,'UPI','2026-10-13'),
 (7,2000,'Card','2026-10-12');

INSERT INTO Feedback(booking_id,rating,comments) VALUES
 (1,4,'Clean room'),(2,5,'Great stay'),(4,5,'Excellent service'),(5,4,'Good value');

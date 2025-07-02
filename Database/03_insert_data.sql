set search_path to cinema;

-- Cities
INSERT INTO City (city_name) VALUES
('Ahmedabad'),
('Surat'),
('Vadodara');

-- Admins
INSERT INTO Admin (admin_email, name, phone_number, password) VALUES
('admin1@example.com', 'Ravi Shah', '9876543210', 'Admin@1234'),
('admin2@example.com', 'Nikita Mehta', '9123456789', 'Pass@2024');

-- Cinemas
INSERT INTO Cinema (cinema_name, cinema_area, cinema_city, cinema_pincode, total_screens, admin_email) VALUES
('PVR', 'SG Highway', 'Ahmedabad', '380054', 3, 'admin1@example.com'),
('INOX', 'Ghod Dod Road', 'Surat', '395007', 2, 'admin2@example.com');

-- Screens
INSERT INTO Screen (screen_id, cinema_name, cinema_pincode, capacity) VALUES
(1, 'PVR', '380054', 100),
(2, 'PVR', '380054', 120),
(3, 'INOX', '395007', 90);

-- Users
INSERT INTO Users (user_email, name, phone_number, password) VALUES
('user1@example.com', 'Aarav', '9988776655', 'User@1234'),
('user2@example.com', 'Diya', '9876567890', 'Hello@2024');

-- Movies
INSERT INTO Movie (movie_title, genre, duration, release_date, price) VALUES
('Dunki', 'Comedy', 140, '2024-06-15', 180.0),
('Avengers', 'Action', 180, '2024-06-10', 250.0),
('Oppenheimer', 'Drama', 180, '2024-06-12', 220.0);

-- Showtimes
INSERT INTO Showtime (movie_title, screen_id, show_date, start_time, end_time) VALUES
('Dunki', 1, '2025-07-05', '10:00:00', '12:20:00'),
('Avengers', 2, '2025-07-05', '13:00:00', '16:00:00'),
('Oppenheimer', 3, '2025-07-05', '17:00:00', '20:00:00');

-- Bookings (assuming IDs 100000, 100001 auto-assigned due to sequence reset)
INSERT INTO Booking (user_email, showtime_id) VALUES
('user1@example.com', 100000),
('user2@example.com', 100001);

-- Booking Seats
INSERT INTO booking_seat (booking_id, seat_number) VALUES
(100000, 10),
(100000, 11),
(100001, 5);

-- Payments
INSERT INTO Payment (booking_id, amount, user_email, is_refunded) VALUES
(100000, 360.0, 'user1@example.com', FALSE),
(100001, 250.0, 'user2@example.com', FALSE);



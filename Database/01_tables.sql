create schema cinema_ticket_booking;
set search_path to cinema_ticket_booking;



----------------------------------------------------



CREATE TABLE users
(
	user_email varchar(250) primary key CHECK (user_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(10) CHECK (phone_number ~ '^[0-9]{10}$'), -- Phone number must be 10 digits
		password VARCHAR(255) CHECK (
        password ~ '[a-z]' AND  -- at least one lowercase letter
        password ~ '[A-Z]' AND  -- at least one uppercase letter
        password ~ '[0-9]' AND  -- at least one digit
        password ~ '[@$!%?&]' AND  -- at least one special character
        length(password) >= 8  -- minimum length of 8 characters
    )
);




----------------------------------------------------------------------------------------------
CREATE TABLE City 
(
    city_name VARCHAR(255) PRIMARY KEY
);
-----------------------------------------------------------------------------

CREATE TABLE Admin
(
    admin_email varchar(250) primary key CHECK (admin_email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(10) CHECK (phone_number ~ '^[0-9]{10}$'), -- Phone number must be 10 digits
   password VARCHAR(255) CHECK (
        password ~ '[a-z]' AND  -- at least one lowercase letter
        password ~ '[A-Z]' AND  -- at least one uppercase letter
        password ~ '[0-9]' AND  -- at least one digit
        password ~ '[@$!%?&]' AND  -- at least one special character
	    length(password) >= 8 ) -- minimum length of 8 characters
	);

-----------------------------------------------------------------------------

CREATE TABLE Movie 
(
    movie_title VARCHAR(255) PRIMARY KEY CHECK (movie_title IS NOT NULL AND movie_title <> ''),
    genre VARCHAR(50) NOT NULL CHECK (genre IN ('Action', 'Comedy', 'Drama', 'Horror', 'Sci-Fi', 'Documentary')), -- Add other genres as necessary
    duration INT CHECK (duration <= 240), -- Maximum duration is 4 hours (240 minutes)
    release_date DATE NOT NULL,
    price DECIMAL(10, 2) not null CHECK (price >= 0) -- Ticket price must be non-negative
);


-----------------------------------------------------------------------------
CREATE TABLE Cinema 
(
    cinema_name VARCHAR(255) NOT NULL,
    cinema_area VARCHAR(255) not null,
	admin_email varchar(250) not null,
    cinema_city VARCHAR(255) REFERENCES City(city_name) ON DELETE CASCADE ON UPDATE CASCADE,
    cinema_pincode VARCHAR(6) not null CHECK (cinema_pincode ~ '^[0-9]{6}$' AND cinema_pincode <> '000000'),
    total_screens INT not null CHECK (total_screens > 0), -- Ensure total screens is greater than 0
    PRIMARY KEY (cinema_name, cinema_pincode),
	FOREIGN KEY (admin_email) REFERENCES Admin(admin_email) ON DELETE CASCADE ON UPDATE CASCADE,
	UNIQUE (admin_email)
);

-----------------------------------------------------------------------------
CREATE TABLE Screen 
(
    screen_id INT PRIMARY KEY,
    cinema_name VARCHAR(255) not null,
    cinema_pincode VARCHAR(6) not null,
    capacity INT not null CHECK (capacity > 0), -- Ensure capacity is greater than 0
    FOREIGN KEY (cinema_name, cinema_pincode) REFERENCES Cinema(cinema_name, cinema_pincode) ON DELETE CASCADE ON UPDATE CASCADE
);

-----------------------------------------------------------------------------

CREATE TABLE Showtime 
(
    showtime_id SERIAL PRIMARY KEY,
    movie_title VARCHAR(255) not null,
	is_active BOOLEAN DEFAULT TRUE CHECK (is_active IN (FALSE, TRUE)),
    screen_id INT not null,
    show_date DATE NOT NULL CHECK (show_date > CURRENT_DATE),  -- Ensures show_date is in the future (not today or in the past)
    start_time TIME NOT NULL,
    end_time TIME NOT NULL CHECK (start_time < end_time), -- Ensure start time is before end time
    FOREIGN KEY (movie_title) REFERENCES Movie(movie_title) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (screen_id) REFERENCES Screen(screen_id) ON DELETE CASCADE ON UPDATE CASCADE

);
ALTER SEQUENCE showtime_showtime_id_seq RESTART WITH 100000;
-----------------------------------------------------------------------------

CREATE TABLE Booking 
(
    booking_id SERIAL PRIMARY KEY, -- SERIAL will handle auto-increment for booking_id
    user_email VARCHAR(250) NOT NULL,
    showtime_id INT NOT NULL,
	is_deleted BOOLEAN DEFAULT FALSE CHECK (is_deleted IN (FALSE, TRUE)),
    booking_date DATE DEFAULT CURRENT_DATE, -- Default to current date
    FOREIGN KEY (user_email) REFERENCES Users(user_email) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (showtime_id) REFERENCES Showtime(showtime_id) ON DELETE CASCADE ON UPDATE CASCADE
);

create table booking_seat
(
booking_id INT not null,
seat_number INT NOT NULL CHECK (seat_number > 0),
primary key(booking_id,seat_number),
FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Set the starting value for the auto-increment sequence
ALTER SEQUENCE booking_booking_id_seq RESTART WITH 100000;


-- Set the auto-increment value to start from 100000

-----------------------------------------------------------------------------

CREATE TABLE Payment 
(
    transaction_id SERIAL PRIMARY KEY, -- SERIAL handles auto-increment
    amount DECIMAL(10, 2) CHECK (amount >= 0), -- Amount must be non-negative
    booking_id INT NOT NULL,
	is_refunded BOOLEAN DEFAULT FALSE CHECK (is_refunded IN (FALSE, TRUE)),
    user_email VARCHAR(255) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_email) REFERENCES Users(user_email) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Set the starting value for the auto-increment sequence

ALTER SEQUENCE payment_transaction_id_seq RESTART WITH 1000000;

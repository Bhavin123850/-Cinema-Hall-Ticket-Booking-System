
--overlaping
CREATE OR REPLACE FUNCTION check_showtime_overlap()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Showtime 
        WHERE screen_id = NEW.screen_id
        AND show_date = NEW.show_date
        AND (
            (start_time < NEW.end_time AND end_time > NEW.start_time)
        )
    ) THEN
        RAISE EXCEPTION 'Showtime overlaps with another showtime on this screen';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_showtime_overlap
BEFORE INSERT OR UPDATE ON Showtime
FOR EACH ROW EXECUTE FUNCTION check_showtime_overlap();

-------------------------------------------------------------------




------------------------------------------

---check duration

CREATE OR REPLACE FUNCTION check_showtime_duration() 
RETURNS TRIGGER AS $$
BEGIN
    -- Check if the movie duration is within the valid range for the showtime duration
    IF EXTRACT(EPOCH FROM (NEW.end_time - NEW.start_time)) / 60 < 
       (SELECT duration FROM Movie WHERE movie_title = NEW.movie_title) 
       OR EXTRACT(EPOCH FROM (NEW.end_time - NEW.start_time)) / 60 > 
       (SELECT duration FROM Movie WHERE movie_title = NEW.movie_title) + 30 THEN
        RAISE EXCEPTION 'The showtime duration must be between the movie duration and movie duration + 30 minutes';
    END IF;

    -- Return the new row if everything is valid
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER validate_showtime_duration
BEFORE INSERT OR UPDATE ON Showtime
FOR EACH ROW
EXECUTE FUNCTION check_showtime_duration();
-----------------------------------------------------------------------

--seat number check

CREATE OR REPLACE FUNCTION check_seat_limit()
RETURNS TRIGGER AS $$
BEGIN
    -- Fetch the screen_id from the Showtime table related to the given booking_id
    DECLARE
        screen_capacity INT;
    BEGIN
        -- Get the screen capacity from the Screen table
        SELECT capacity
        INTO screen_capacity
        FROM Screen
        WHERE screen_id = (
            SELECT screen_id
            FROM Showtime
            WHERE showtime_id = (
                SELECT showtime_id
                FROM Booking
                WHERE booking_id = NEW.booking_id
            )
        );

        -- Check if the seat_number exceeds the screen capacity
        IF NEW.seat_number > screen_capacity THEN
            RAISE EXCEPTION 'Seat number cannot exceed the screen capacity of %', screen_capacity;
        END IF;

        -- If everything is fine, return the row
        RETURN NEW;
    END;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER seat_limit_trigger
BEFORE INSERT ON booking_seat
FOR EACH ROW
EXECUTE FUNCTION check_seat_limit();
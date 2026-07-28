-- Index for organization searches
CREATE INDEX idx_hotel_bookings_org_id
ON hotel_bookings(org_id);

-- Index for city searches
CREATE INDEX idx_hotel_bookings_city
ON hotel_bookings(city);

-- Index for booking status
CREATE INDEX idx_hotel_bookings_status
ON hotel_bookings(status);

-- Composite index for date range queries
CREATE INDEX idx_hotel_bookings_dates
ON hotel_bookings(checkin_date, checkout_date);

-- Index for booking events lookup
CREATE INDEX idx_booking_events_booking_id
ON booking_events(booking_id);

-- Index for event type
CREATE INDEX idx_booking_events_event_type
ON booking_events(event_type);

-- Index for created_at
CREATE INDEX idx_booking_events_created_at
ON booking_events(created_at);

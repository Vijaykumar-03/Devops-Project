INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    gen_random_uuid(),
    'HOTEL-' || gs,
    (
        ARRAY[
            'Hyderabad',
            'Bangalore',
            'Chennai',
            'Mumbai',
            'Delhi',
            'Pune'
        ]
    )[floor(random()*6+1)],
    CURRENT_DATE + (gs % 30),
    CURRENT_DATE + (gs % 30) + 2,
    ROUND((1000 + random()*9000)::numeric,2),
    (
        ARRAY[
            'BOOKED',
            'COMPLETED',
            'CANCELLED',
            'PENDING'
        ]
    )[floor(random()*4+1)],
    NOW() - (gs || ' days')::interval
FROM generate_series(1,100) gs;
INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    'BOOKED',
    jsonb_build_object(
        'payment_method','Credit Card',
        'status','SUCCESS'
    ),
    created_at
FROM hotel_bookings;

-- Deploy ochalet:sql_create_update_functions to pg

BEGIN;

-- OFFER FUNCTIONS

CREATE FUNCTION new_offer(myRecord json) RETURNS int AS $$
	INSERT INTO "offer" ("title", "body", "zip_code", "city_name", "country", "street_name", "street_number", "price_ht", "tax", "main_picture", "galery_picture_1", "galery_picture_2", "galery_picture_3", "galery_picture_4", "galery_picture_5", "location_id")
	VALUES (
		myRecord->>'title',
		myRecord->>'body',
		myRecord->>'zip_code',
		myRecord->>'city_name',
		myRecord->>'country',
		myRecord->>'street_name',
		myRecord->>'street_number',
		(myRecord->>'price_ht')::int,
		(myRecord->>'tax')::int,
		myRecord->>'main_picture',
		myRecord->>'galery_picture_1',
		myRecord->>'galery_picture_2',
		myRecord->>'galery_picture_3',
		myRecord->>'galery_picture_4',
		myRecord->>'galery_picture_5',
        (myRecord->>'location_id')::int
	) RETURNING id
$$ LANGUAGE SQL STRICT;

CREATE FUNCTION update_offer(json) RETURNS void AS $$
	UPDATE "offer" SET
		title=$1->>'title',
		body=$1->>'body',
		zip_code=$1->>'zip_code',
		city_name=$1->>'city_name',
		country=$1->>'country',
		street_name=$1->>'street_name',
		street_number=$1->>'street_number',
		latitude=$1->>'latitude',
		longitude=$1->>'longitude',
		price_ht=($1->>'price_ht')::int,
		tax=($1->>'tax')::int,
		main_picture=$1->>'main_picture',
		galery_picture_1=$1->>'galery_picture_1',
		galery_picture_2=$1->>'galery_picture_2',
		galery_picture_3=$1->>'galery_picture_3',
		galery_picture_4=$1->>'galery_picture_4',
		galery_picture_5=$1->>'galery_picture_5',
        location_id=($1->>'location_id')::int,
        offer_status=($1->>'offer_status')::boolean
	WHERE id=($1->>'id')::int;
$$ LANGUAGE SQL STRICT;


-- MESSAGE FUNCTIONS

CREATE FUNCTION new_message(myRecord json) RETURNS int AS $$
	INSERT INTO "message" ("reservation_start", "reservation_end", "body", "offer_id", "user_id")
	VALUES (
		(myRecord->>'reservation_start')::timestamptz,
		(myRecord->>'reservation_end')::timestamptz,
		myRecord->>'body',
		(myRecord->>'offer_id')::int,
		(myRecord->>'user_id')::int
	) RETURNING id
$$ LANGUAGE SQL STRICT;

CREATE FUNCTION update_message(json) RETURNS void AS $$
	UPDATE "message" SET
		reservation_start=($1->>'reservation_start')::timestamptz,
		reservation_end=($1->>'reservation_end')::timestamptz,
        nb_persons=($1->>'nb_persons')::int,
		body=$1->>'body',
		message_status=($1->>'message_status')::boolean,
		offer_id=($1->>'offer_id')::int,
		user_id=($1->>'user_id')::int
	WHERE id=($1->>'id')::int;
$$ LANGUAGE SQL STRICT;

--BOOKING FUNCTIONS

CREATE FUNCTION new_booking(myRecord json) RETURNS int AS $$
	INSERT INTO "booking" ("reservation_start", "reservation_end", "offer_id", "user_id")
	VALUES (
		(myRecord->>'reservation_start')::timestamptz,
		(myRecord->>'reservation_end')::timestamptz,
		(myRecord->>'offer_id')::int,
		(myRecord->>'user_id')::int
	) RETURNING id
$$ LANGUAGE SQL STRICT;

CREATE FUNCTION update_booking(json) RETURNS void AS $$
	UPDATE "booking" SET
		reservation_start=($1->>'reservation_start')::timestamptz,
		reservation_end=($1->>'reservation_end')::timestamptz,
        message=$1->>'message',
		reservation_status=($1->>'reservation_status')::boolean,
		offer_id=($1->>'offer_id')::int,
		user_id=($1->>'user_id')::int
	WHERE id=($1->>'id')::int;
$$ LANGUAGE SQL STRICT;

-- COMMENT FUNCTIONS

CREATE FUNCTION new_comment(myRecord json) RETURNS int AS $$
	INSERT INTO "comment" ("body", "note", "offer_id", "user_id")
	VALUES (
		myRecord->>'body',
		(myRecord->>'note')::int,
		(myRecord->>'offer_id')::int,
		(myRecord->>'user_id')::int
	) RETURNING id
$$ LANGUAGE SQL STRICT;

CREATE FUNCTION update_comment(json) RETURNS void AS $$
	UPDATE "comment" SET
		body=$1->>'body',
        note=($1->>'note')::int,
		offer_id=($1->>'offer_id')::int,
		user_id=($1->>'user_id')::int
	WHERE id=($1->>'id')::int;
$$ LANGUAGE SQL STRICT;

COMMIT;

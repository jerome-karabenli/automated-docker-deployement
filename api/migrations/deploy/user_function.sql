-- Deploy ochalet:user_function to pg

BEGIN;

CREATE FUNCTION new_user(myRecord json) RETURNS int AS $$
	INSERT INTO "user" ("firstname", "lastname", "email", "password")
	VALUES (
		myRecord->>'firstname',
		myRecord->>'lastname',
		myRecord->>'email',
		myRecord->>'password'
	) RETURNING id
$$ LANGUAGE SQL STRICT;

CREATE FUNCTION update_user(json) RETURNS void AS $$
	UPDATE "user" SET
		firstname=$1->>'firstname',
		lastname=$1->>'lastname',
		email=$1->>'email',
		phone=$1->>'phone',
		birth_date=($1->>'birth_date')::timestamptz,
		zip_code=$1->>'zip_code',
		city_name=$1->>'city_name',
		country=$1->>'country',
		street_name=$1->>'street_name',
		street_number=$1->>'street_number',
		password=$1->>'password'
	WHERE id=($1->>'id')::int;
$$ LANGUAGE SQL STRICT;

COMMIT;

-- Verify ochalet:init on pg

BEGIN;

SELECT "id" FROM "user" WHERE 'false';
SELECT "id" FROM "comment" WHERE 'false';
SELECT "id" FROM "message" WHERE 'false';
SELECT "id" FROM "location" WHERE 'false';
SELECT "id" FROM "offer" WHERE 'false';
SELECT "id" FROM "booking" WHERE 'false';

ROLLBACK;

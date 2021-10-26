-- Revert ochalet:init from pg

BEGIN;

DROP TABLE "user", "location", "offer", "comment", "message", "booking";

COMMIT;

-- Revert ochalet:sql_create_update_functions from pg

BEGIN;

DROP FUNCTION new_offer(json);
DROP FUNCTION update_offer(json);

DROP FUNCTION new_message(json);
DROP FUNCTION update_message(json);

DROP FUNCTION new_booking(json);
DROP FUNCTION update_booking(json);

DROP FUNCTION new_comment(json);
DROP FUNCTION update_comment(json);

COMMIT;

-- Revert ochalet:user_function from pg

BEGIN;

DROP FUNCTION new_user(json);
DROP FUNCTION update_user(json);

COMMIT;

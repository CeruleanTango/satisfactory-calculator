BEGIN;

CREATE TABLE IF NOT EXISTS recipe_outputs (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    item_id INTEGER REFERENCES items(id),
    quantity DECIMAL(10, 2) NOT NULL,
    is_primary BOOLEAN DEFAULT TRUE,
    UNIQUE(recipe_id, item_id)
);

INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT
    r.id,
    r.output_item_id,
    (r.output_rate * r.crafting_time) / 60,
    TRUE
FROM recipes r
WHERE r.output_item_id IS NOT NULL;

ALTER TABLE recipes DROP COLUMN IF EXISTS output_item_id;
ALTER TABLE recipes DROP COLUMN IF EXISTS output_rate;

DO $$
DECLARE
    recipe_count INTEGER;
    output_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO recipe_count FROM recipes;
    SELECT COUNT(*) INTO output_count FROM recipe_outputs WHERE is_primary = TRUE

    IF recipe_count != output_count THEN
        RAISE EXCEPTION 'Migration verification failed: recipe count (%) != output count (%)',
            recipe_count, output_count
    END IF;

    RAISE NOTICE 'Migration verification passed: % recipes = % outputs',
        recipe_count, output_count;

END $$;

COMMIT;

SELECT 'Migration 001_multi_output_recipes completed!'
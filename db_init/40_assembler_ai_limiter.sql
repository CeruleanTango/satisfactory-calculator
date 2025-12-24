-- Recipe: AI Limiter
-- Building: Assembler
-- Crafting Time: 12.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('AI Limiter', 'intermediate'),
  ('Copper Sheet', 'intermediate'),
  ('Quickwire', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Assembler', 15.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'AI Limiter', b.id, 12.0, False
FROM buildings b
WHERE b.name = 'Assembler'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 1.0, TRUE
FROM recipes r, items i
WHERE r.name = 'AI Limiter'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 5.0
FROM recipes r, items i
WHERE r.name = 'AI Limiter' AND i.name = 'Copper Sheet'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 20.0
FROM recipes r, items i
WHERE r.name = 'AI Limiter' AND i.name = 'Quickwire'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

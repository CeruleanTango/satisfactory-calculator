-- Recipe: Silica
-- Building: Constructor
-- Crafting Time: 8.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Quartz', 'intermediate'),
  ('Silica', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Constructor', 4.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Silica', b.id, 8.0, False
FROM buildings b
WHERE b.name = 'Constructor'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 5.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Silica'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3.0
FROM recipes r, items i
WHERE r.id = 'Silica' AND i.name = 'Quartz'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

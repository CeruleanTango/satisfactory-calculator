-- Recipe: Steel Pipe
-- Building: Constructor
-- Crafting Time: 6.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Steel Ingot', 'intermediate'),
  ('Steel Pipe', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Constructor', 4.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Steel Pipe', b.id, 6.0, False
FROM buildings b
WHERE b.name = 'Constructor'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 2.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Steel Pipe'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3.0
FROM recipes r, items i
WHERE r.id = 'Steel Pipe' AND i.name = 'Steel Ingot'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

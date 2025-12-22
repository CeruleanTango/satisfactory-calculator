-- Recipe: Diluted Fuel
-- Building: Blender
-- Crafting Time: 6.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Fuel', 'intermediate'),
  ('Heavy Oil Residue', 'intermediate'),
  ('Water', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Blender', 75.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Diluted Fuel', b.id, 6.0, True
FROM buildings b
WHERE b.name = 'Blender'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 10.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Diluted Fuel'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 5.0
FROM recipes r, items i
WHERE r.name = 'Diluted Fuel' AND i.name = 'Heavy Oil Residue'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 10.0
FROM recipes r, items i
WHERE r.name = 'Diluted Fuel' AND i.name = 'Water'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

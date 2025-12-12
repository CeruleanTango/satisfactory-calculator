-- Recipe: Solid Biofuel
-- Building: Constructor
-- Crafting Time: 4.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Biomass', 'intermediate'),
  ('Solid Biofuel', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Constructor', 4.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Solid Biofuel', b.id, 4.0, False
FROM buildings b
WHERE b.name = 'Constructor'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 4.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Solid Biofuel'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 8.0
FROM recipes r, items i
WHERE r.id = 'Solid Biofuel' AND i.name = 'Biomass'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Recipe: Recycled Rubber
-- Building: Refinery
-- Crafting Time: 12.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Fuel', 'intermediate'),
  ('Plastic', 'intermediate'),
  ('Rubber', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Refinery', 30.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Recycled Rubber', b.id, 12.0, True
FROM buildings b
WHERE b.name = 'Refinery'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 12.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Recycled Rubber'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 6.0
FROM recipes r, items i
WHERE r.name = 'Recycled Rubber' AND i.name = 'Plastic'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 6.0
FROM recipes r, items i
WHERE r.name = 'Recycled Rubber' AND i.name = 'Fuel'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

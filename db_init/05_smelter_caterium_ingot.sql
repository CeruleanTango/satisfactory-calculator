-- Recipe: Caterium Ingot
-- Building: Smelter
-- Crafting Time: 4.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Caterium Ingot', 'intermediate'),
  ('Caterium Ore', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Smelter', 4.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Caterium Ingot', b.id, 4.0, False
FROM buildings b
WHERE b.name = 'Smelter'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 1.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Caterium Ingot'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3.0
FROM recipes r, items i
WHERE r.id = 'Caterium Ingot' AND i.name = 'Caterium Ore'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Recipe: Quickwire
-- Building: Constructor
-- Crafting Time: 5.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Caterium Ingot', 'intermediate'),
  ('Quickwire', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Constructor', 4.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Quickwire', b.id, 5.0, False
FROM buildings b
WHERE b.name = 'Constructor'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 5.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Quickwire'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 1.0
FROM recipes r, items i
WHERE r.name = 'Quickwire' AND i.name = 'Caterium Ingot'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Recipe: Petroleum Coke
-- Building: Refinery
-- Crafting Time: 6.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Heavy Oil Residue', 'intermediate'),
  ('Petroleum Coke', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Refinery', 30.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Petroleum Coke', b.id, 6.0, False
FROM buildings b
WHERE b.name = 'Refinery'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 12.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Petroleum Coke'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 4.0
FROM recipes r, items i
WHERE r.name = 'Petroleum Coke' AND i.name = 'Heavy Oil Residue'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

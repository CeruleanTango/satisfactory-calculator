-- Recipe: Aluminum Scrap
-- Building: Refinery
-- Crafting Time: 1.0s

-- Ensure items exist
INSERT INTO items (name, category) VALUES
  ('Alumina Solution', 'intermediate'),
  ('Aluminum Scrap', 'intermediate'),
  ('Coal', 'intermediate'),
  ('Water', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Ensure building exists
INSERT INTO buildings (name, power_consumption) VALUES
  ('Refinery', 30.0)
ON CONFLICT (name) DO NOTHING;

-- Add recipe
INSERT INTO recipes (name, building_id, crafting_time, is_alternate)
SELECT 'Aluminum Scrap', b.id, 1.0, False
FROM buildings b
WHERE b.name = 'Refinery'
ON CONFLICT (name) DO NOTHING;

-- Add recipe outputs
INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 6.0, TRUE
FROM recipes r, items i
WHERE r.name = 'Aluminum Scrap'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)
SELECT r.id, i.id, 2.0, FALSE
FROM recipes r, items i
WHERE r.name = 'Aluminum Scrap'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Add recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 4.0
FROM recipes r, items i
WHERE r.name = 'Aluminum Scrap' AND i.name = 'Alumina Solution'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 2.0
FROM recipes r, items i
WHERE r.name = 'Aluminum Scrap' AND i.name = 'Coal'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

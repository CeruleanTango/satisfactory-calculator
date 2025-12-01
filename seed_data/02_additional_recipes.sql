-- Extended Satisfactory Recipe Data
-- This adds more items, buildings, and recipes to the base schema

-- Additional Items
INSERT INTO items (name, category) VALUES
    ('Coal', 'raw'),
    ('Caterium Ore', 'raw'),
    ('Crude Oil', 'raw'),
    ('Water', 'raw'),
    ('Sulfur', 'raw'),
    ('Bauxite', 'raw'),
    ('Quartz', 'raw'),
    ('Steel Ingot', 'intermediate'),
    ('Steel Beam', 'intermediate'),
    ('Steel Pipe', 'intermediate'),
    ('Encased Industrial Beam', 'intermediate'),
    ('Caterium Ingot', 'intermediate'),
    ('Quickwire', 'intermediate'),
    ('Plastic', 'intermediate'),
    ('Rubber', 'intermediate'),
    ('Petroleum Coke', 'intermediate'),
    ('Heavy Oil Residue', 'intermediate'),
    ('Fuel', 'intermediate'),
    ('Compacted Coal', 'intermediate'),
    ('Quartz Crystal', 'intermediate'),
    ('Silica', 'intermediate'),
    ('Copper Sheet', 'intermediate'),
    ('Alclad Aluminum Sheet', 'intermediate'),
    ('Aluminum Scrap', 'intermediate'),
    ('Aluminum Ingot', 'intermediate'),
    ('Stator', 'intermediate'),
    ('Motor', 'intermediate'),
    ('Automated Wiring', 'intermediate'),
    ('Smart Plating', 'intermediate'),
    ('Versatile Framework', 'intermediate'),
    ('Heavy Modular Frame', 'intermediate'),
    ('Computer', 'intermediate'),
    ('High-Speed Connector', 'intermediate')
ON CONFLICT (name) DO NOTHING;

-- Additional Buildings
INSERT INTO buildings (name, power_consumption) VALUES
    ('Foundry', 16.0),
    ('Manufacturer', 55.0),
    ('Refinery', 30.0),
    ('Blender', 75.0)
ON CONFLICT (name) DO NOTHING;

-- Get building IDs for reference
-- Smelter = 1, Constructor = 2, Assembler = 3, Foundry = 4, Manufacturer = 5, Refinery = 6, Blender = 7

-- Steel Ingot (Foundry)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Steel Ingot', b.id, i.id, 45, 4
FROM buildings b, items i
WHERE b.name = 'Foundry' AND i.name = 'Steel Ingot'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3
FROM recipes r, items i
WHERE r.name = 'Steel Ingot' AND i.name = 'Iron Ore'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3
FROM recipes r, items i
WHERE r.name = 'Steel Ingot' AND i.name = 'Coal'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Steel Beam (Constructor)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Steel Beam', b.id, i.id, 15, 4
FROM buildings b, items i
WHERE b.name = 'Constructor' AND i.name = 'Steel Beam'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 4
FROM recipes r, items i
WHERE r.name = 'Steel Beam' AND i.name = 'Steel Ingot'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Steel Pipe (Constructor)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Steel Pipe', b.id, i.id, 20, 6
FROM buildings b, items i
WHERE b.name = 'Constructor' AND i.name = 'Steel Pipe'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3
FROM recipes r, items i
WHERE r.name = 'Steel Pipe' AND i.name = 'Steel Ingot'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Encased Industrial Beam (Assembler)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Encased Industrial Beam', b.id, i.id, 6, 10
FROM buildings b, items i
WHERE b.name = 'Assembler' AND i.name = 'Encased Industrial Beam'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 4
FROM recipes r, items i
WHERE r.name = 'Encased Industrial Beam' AND i.name = 'Steel Beam'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 5
FROM recipes r, items i
WHERE r.name = 'Encased Industrial Beam' AND i.name = 'Concrete'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Caterium Ingot (Smelter)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Caterium Ingot', b.id, i.id, 15, 4
FROM buildings b, items i
WHERE b.name = 'Smelter' AND i.name = 'Caterium Ingot'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3
FROM recipes r, items i
WHERE r.name = 'Caterium Ingot' AND i.name = 'Caterium Ore'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Quickwire (Constructor)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Quickwire', b.id, i.id, 60, 5
FROM buildings b, items i
WHERE b.name = 'Constructor' AND i.name = 'Quickwire'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 1
FROM recipes r, items i
WHERE r.name = 'Quickwire' AND i.name = 'Caterium Ingot'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Stator (Assembler)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Stator', b.id, i.id, 5, 12
FROM buildings b, items i
WHERE b.name = 'Assembler' AND i.name = 'Stator'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3
FROM recipes r, items i
WHERE r.name = 'Stator' AND i.name = 'Steel Pipe'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 8
FROM recipes r, items i
WHERE r.name = 'Stator' AND i.name = 'Wire'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Motor (Assembler)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Motor', b.id, i.id, 5, 12
FROM buildings b, items i
WHERE b.name = 'Assembler' AND i.name = 'Motor'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 2
FROM recipes r, items i
WHERE r.name = 'Motor' AND i.name = 'Rotor'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 2
FROM recipes r, items i
WHERE r.name = 'Motor' AND i.name = 'Stator'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Heavy Modular Frame (Manufacturer)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Heavy Modular Frame', b.id, i.id, 2, 30
FROM buildings b, items i
WHERE b.name = 'Manufacturer' AND i.name = 'Heavy Modular Frame'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 5
FROM recipes r, items i
WHERE r.name = 'Heavy Modular Frame' AND i.name = 'Modular Frame'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 15
FROM recipes r, items i
WHERE r.name = 'Heavy Modular Frame' AND i.name = 'Steel Pipe'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 5
FROM recipes r, items i
WHERE r.name = 'Heavy Modular Frame' AND i.name = 'Encased Industrial Beam'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 100
FROM recipes r, items i
WHERE r.name = 'Heavy Modular Frame' AND i.name = 'Screw'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Computer (Manufacturer)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Computer', b.id, i.id, 2.5, 24
FROM buildings b, items i
WHERE b.name = 'Manufacturer' AND i.name = 'Computer'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 10
FROM recipes r, items i
WHERE r.name = 'Computer' AND i.name = 'Cable'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 9
FROM recipes r, items i
WHERE r.name = 'Computer' AND i.name = 'Quickwire'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 18
FROM recipes r, items i
WHERE r.name = 'Computer' AND i.name = 'Screw'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Smart Plating (Assembler)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Smart Plating', b.id, i.id, 2, 30
FROM buildings b, items i
WHERE b.name = 'Assembler' AND i.name = 'Smart Plating'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 1
FROM recipes r, items i
WHERE r.name = 'Smart Plating' AND i.name = 'Reinforced Iron Plate'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 1
FROM recipes r, items i
WHERE r.name = 'Smart Plating' AND i.name = 'Rotor'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

-- Versatile Framework (Assembler)
INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Versatile Framework', b.id, i.id, 5, 24
FROM buildings b, items i
WHERE b.name = 'Assembler' AND i.name = 'Versatile Framework'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 1
FROM recipes r, items i
WHERE r.name = 'Versatile Framework' AND i.name = 'Modular Frame'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 12
FROM recipes r, items i
WHERE r.name = 'Versatile Framework' AND i.name = 'Steel Beam'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE buildings (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    power_consumption DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    building_id INTEGER REFERENCES buildings(id),
    output_item_id INTEGER REFERENCES items(id),
    output_rate DECIMAL(10, 2) NOT NULL,
    crafting_time DECIMAL(10, 2) NOT NULL,
    is_alternate BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE recipe_ingredients (
    id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(id) ON DELETE CASCADE,
    item_id INTEGER REFERENCES items(id),
    quantity DECIMAL(10, 2) NOT NULL,
    UNIQUE(recipe_id, item_id)
);

INSERT INTO items (name, category) VALUES
    ('Iron Ore', 'raw'),
    ('Copper Ore', 'raw'),
    ('Limestone', 'raw'),
    ('Iron Ingot', 'intermediate'),
    ('Copper Ingot', 'intermediate'),
    ('Iron Plate', 'intermediate'),
    ('Iron Rod', 'intermediate'),
    ('Wire', 'intermediate'),
    ('Cable', 'intermediate'),
    ('Concrete', 'intermediate'),
    ('Screw', 'intermediate'),
    ('Reinforced Iron Plate', 'intermediate'),
    ('Rotor', 'intermediate'),
    ('Modular Frame', 'intermediate');

INSERT INTO buildings (name, power_consumption) VALUES
    ('Smelter', 4.0),
    ('Constructor', 4.0),
    ('Assembler', 15.0);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Iron Ingot', 1, 4, 30, 2);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (1, 1, 1);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Iron Plate', 2, 6, 20, 6);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (2, 4, 3);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Copper Ingot', 1, 5, 30, 2);
INSERT INTO recipe_ingredients(recipe_id, item_id, quantity)
VALUES (3, 2, 1);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Iron Rod', 2, 7, 15, 4);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (4, 4, 1);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Screw', 2, 11, 40, 6);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (5, 7, 1);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Wire', 2, 8, 30, 4);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (6, 5, 1);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Cable', 2, 9, 30, 2);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (7, 8, 2);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Concrete', 2, 10, 15, 4);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (8, 3, 3);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Reinforced Iron Plate' 3, 12, 5, 12);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (9, 6, 6), (9, 11, 12);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
VALUES ('Rotor', 3, 13, 4, 15);
INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
VALUES (10, 7, 5), (10, 11, 25);

INSERT INTO recipes (name, building_id, output_item_id, output_rate, crafting_time)
SELECT 'Modular Frame', b.id, i.id, 2, 60
FROM buildings b, items i
WHERE b.name = 'Assembler' AND i.name = 'Modular Frame'
ON CONFLICT (name) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 3
FROM recipes r, items i
WHERE r.name = 'Modular Frame' AND i.name = 'Reinforced Iron Plate'
ON CONFLICT (recipe_id, item_id) DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)
SELECT r.id, i.id, 12
FROM recipes r, items i
WHERE r.name = 'Modular Frame' AND i.name = 'Iron Rod'
ON CONFLICT (recipe_id, item_id) DO NOTHING;


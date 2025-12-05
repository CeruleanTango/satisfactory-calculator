-- Liquids Satisfactory Recipe Data
-- This adds items and recipes related to liquid processing in Satisfactory

INSERT INTO items(name, category)
VALUES ('Plastic', 'intermediate')
on conflict(name) do nothing;

insert into items(name, category)
values ('Heavy Oil Residue', 'intermediate')
on conflict(name) do nothing;

insert into buildings(name, power_consumption)
values ('Refinery', 30)
on conflict(name) do nothing;

-- Plastic

insert into recipes(name, building_id, crafting_time, is_alternate)
select 'Plastic', b.id, 6, FALSE
from buildings b
where b.name = 'Refinery'
on conflict (name) do nothing;

insert into recipe_outputs(recipe_id, item_id, quantity, is_primary)
select r.id, i.id, 2, TRUE
from recipes r, items i
where r.name = 'Plastic' and i.name = 'Plastic'
on conflict (recipe_id, item_id) do nothing;

insert into recipe_outputs(recipe_id, item_id, quantity, is_primary)
select r.id, i.id, 1, FALSE
from recipes r, items i
where r.name = 'Plastic' and i.name = 'Heavy Oil Residue'
on conflict(recipe_id, item_id) do nothing;

insert into recipe_ingredients(recipe_id, item_id, quantity)
select r.id, i.id, 3
from recipes r, items i
where r.name = 'Plastic' and i.name = 'Crude Oil'
on conflict (recipe_id, item_id) do nothing;

-- Rubber

insert into items (name, category)
values ('Rubber', 'intermediate')
on conflict (name) do nothing;

insert into recipes (name, building_id, crafting_time, is_alternate)
select 'Rubber', b.id, 6, FALSE
from buildings b
where b.name = 'Refinery'
on conflict (name) do nothing;

insert into recipe_ingredients(recipe_id, item_id, quantity)
select r.id, i.id, 3
from recipes r, items i
where r.name = 'Rubber' and i.name = 'Crude Oil'
on conflict(recipe_id, item_id) do nothing;

insert into recipe_outputs(recipe_id, item_id, quantity, is_primary)
select r.id, i.id, 2, TRUE
from recipes r, items i
where r.name = 'Rubber' and i.name = 'Rubber'
on conflict (recipe_id, name_id) do nothing;

insert into recipe_outputs(recipe_id, item_id, quantity, is_primary)
select r.id, i.id, 2, FALSE
from recipes r, items i
where r.name = 'Rubber' and i.name = 'Heavy Oil Residue'
on conflict (recipe_id, name_id) do nothing;
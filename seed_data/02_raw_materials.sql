-- Satisfactory Raw Materials Data
-- Includes all raw (non-processed) materials

INSERT INTO items (name, category) VALUES
  ('Nitrogen Gas', 'raw'),
  ('SAM', 'raw'),
  ('Sulfur', 'raw'),
  ('Uranium', 'raw'),
  ('Bauxite', 'raw'),
  ('Caterium Ore', 'raw'),
  ('Coal', 'raw'),
  ('Copper Ore', 'raw'),
  ('Iron Ore', 'raw'),
  ('Limestone', 'raw'),
  ('Quartz', 'raw'),
  ('Water', 'raw'),
  ('Somersloop', 'raw'),
  ('Mycelia', 'raw'),
  ('Wood', 'raw'),
  ('Leaves', 'raw'),
  ('Blue Power Slug', 'raw'),
  ('Yellow Power Slug', 'raw'),
  ('Purple Power Slug', 'raw'),
  ('Mercer Sphere', 'raw'),
  ('Beryl Nut', 'raw'),
  ('Bacon Agaric', 'raw'),
  ('Paleberry', 'raw')
ON CONFLICT (name) DO NOTHING;

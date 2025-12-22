-- Satisfactory Processing Buildings Data
-- Adds all buildings and associated power consumption

-- Buildings
INSERT INTO buildings (name, power_consumption) VALUES
  ('Foundry', 16.0),
  ('Manufacturer', 55.0),
  ('Refinery', 30.0),
  ('Blender', 75.0),
  ('Constructor', 4.0),
  ('Assembler', 15.0),
  ('Converter', 400.0),
  ('Quantum Encoder', 2000.0),
  ('Smelter', 4.0),
  ('Particle Accelerator', 1500.0)
ON CONFLICT (name) DO NOTHING;

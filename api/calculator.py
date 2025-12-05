from sqlalchemy import text
from typing import Dict, List

class ProductionCalculator:
    def __init__(self, engine):
        self.engine = engine

    def get_recipe_for_item(self, item_name: str) -> Dict:
        """Get the recipe that produces the specified item"""
        with self.engine.connect() as conn:
            result = conn.execute(text("""
                SELECT r.id, r.name, r.crafting_time, b.name, b.power_consumption, ro.quantity as output_quantity, i.name as output_item
                FROM recipes r
                JOIN recipe_outputs ro ON r.id = ro.recipe_id
                JOIN items i on ro.item_id = i.id
                JOIN buildings b on r.building_id = b.id
                WHERE i.name = :item_name AND r.is_alternate = FALSE
                  AND ro.is_primary = TRUE
                LIMIT 1
            """), {"item_name": item_name})

            row = result.fetchone()
            if not row:
                raise ValueError(f"No recipe found for item: {item_name}")

            recipe_id = row[0]
            recipe_name = row[1]
            crafting_time = float(row[2])
            building = row[3]
            power_consumption = float(row[4])
            output_quantity = float(row[5])

            output_rate = (output_quantity * 60) / crafting_time

            # Get ingredients
            outputs_result = conn.execute(text("""
                SELECT i.name, ro.quantity, ro.is_primary
                FROM recipe_outputs ro
                JOIN items i ON ro.item_id = i.id
                WHERE ro.recipe_id = :recipe_id
                ORDER BY ro.is_primary DESC, i.name
            """), {"recipe_id": recipe_id})

            outputs = [{
                "item": r[0], 
                "quantity": float(r[1]),
                "rate": (float(r[1]) * 60) / crafting_time,
                "is_primary": r[2]
            } for r in outputs_result]

            ingredients_result = conn.execute(text("""
                SELECT i.name, ri.quantity
                FROM recipe_ingredients ri
                JOIN items i ON ri.item_id = i.id
                WHERE ri.recipe_id = :recipe_id
                ORDER BY i.name
            """), {"recipe_id": recipe_id})

            ingredients = [{"item": r[0], "quantity": float(r[1])} for r in ingredients_result]

            return {
                "recipe_name": recipe_name,
                "output_rate": output_rate,
                "output_quantity": output_quantity,
                "crafting_time": crafting_time,
                "building": building,
                "power_consumption": power_consumption,
                "outputs": outputs,
                "ingredients": ingredients
            }

    def is_raw_material(self, item_name: str) -> bool:
        """Check if an item is a raw material"""
        with self.engine.connect() as conn:
            result = conn.execute(text("""
                SELECT category FROM items WHERE name = :item_name
            """), {"item_name": item_name})
            row = result.fetchone()
            return row and row[0] == 'raw'

    def calculate_requirements(self, item_name: str, target_rate: float):
        """
        Calculate all requirements for producing an item at a target rate
        Returns a breakdown of buildings needed and raw materials required for the specified item
        """
        production_chain = []
        raw_materials = {}
        total_power = 0
        building_summary = {}

        def calculate_recursive(item: str, rate: float, depth: int = 0):
            nonlocal total_power
        
            if self.is_raw_material(item):
                raw_materials[item] = raw_materials.get(item, 0) + rate
                return

            recipe = self.get_recipe_for_item(item)
        
            buildings_needed = rate / recipe["output_rate"]
            power_for_this_step = buildings_needed * recipe["power_consumption"]
            total_power += power_for_this_step

            building_name = recipe["building"]
            if building_name not in building_summary:
                building_summary[building_name] = {
                    "count": 0,
                    "power": 0
                }
            building_summary[building_name]["count"] += buildings_needed
            building_summary[building_name]["power"] += power_for_this_step

            chain_entry = {
                "depth": depth,
                "item": item,
                "target_rate": round(rate, 2),
                "recipe": recipe["recipe_name"],
                "building": recipe["building"],
                "buildings_needed": round(buildings_needed, 2),
                "power_required": round(power_for_this_step, 2)
            }

            byproducts = [output for output in recipe["outputs"] if not output["is_primary"]]

            if byproducts:
                chain_entry[byproducts] = [
                    {
                        "item": bp["item"],
                        "rate": round(bp["rate"] * buildings_needed, 2)
                    }
                    for bp in byproducts
                ]

            production_chain.append(chain_entry)

            for ingredient in recipe["ingredients"]:
                output_per_craft = recipe["output_rate"] / (60 / recipe["crafting_time"])
                crafts_per_minute = rate / output_per_craft
                ingredient_rate = crafts_per_minute * ingredient["quantity"]
                calculate_recursive(ingredient["item"], ingredient_rate, depth + 1)

        calculate_recursive(item_name, target_rate)

        for building in building_summary:
            building_summary[building]["count"] = round(building_summary[building]["count"], 2)
            building_summary[building]["power"] = round(building_summary[building]["power"], 2)

        return {
            "target_item": item_name,
            "target_rate": target_rate,
            "production_chain": production_chain,
            "raw_materials_per_minute": {k: round(v, 2) for k,v in raw_materials.items()},
            "building_summary": building_summary,
            "total_power_consumption": round(total_power, 2),
            "total_buildings": round(sum(step["buildings_needed"] for step in production_chain), 2)
        }

"""
   Interactive script to add recipes to the Satisfactory calculator database
   Generates SQL that can be run directly or saved to a file
"""

import sys
from typing import List, Dict, Optional

class RecipeBuilder:
    def __init__(self):
        self.recipe_name = ""
        self.building = ""
        self.building_power = 0.0
        self.crafting_time = 0.0
        self.is_alternate = False
        self.outputs: List[Dict] = []
        self.ingredients: List[Dict] = []
    
    def prompt_basic_info(self):
        """Prompt for recipe name, building, crafting time, and if alternate"""
        print("\n--- Recipe Basic Information ---")
        self.recipe_name = input("Recipe name: ").strip()
        self.building = input("Building (Constructor, Assembler, Manufacturer, Refinery, etc.): ").strip()
        
        while True:
            try:
                self.crafting_time = float(input("Power consumption of building (MW): ").strip())
                if self.crafting_time <= 0:
                    print("Power consumption must be a positive number")
                    continue
                break
            except ValueError:
                print("Please enter a valid building power consumption")

        while True:
            try:
                self.crafting_time = float(input("Crafting time (seconds): ").strip())
                if self.crafting_time <= 0:
                    print("Crafting time must be a positive number")
                    continue
                break
            except ValueError:
                print("Please enter a valid crafting time")

        is_alt = input("Is this an alternate recipe? (y/n): ").strip()
        self.is_alternate = is_alt == 'y'
    
    def prompt_outputs(self):
        """Prompt for recipe outputs"""
        print("\n--- Recipe Outputs ---")
        
        while True:
            output = {}
            output['item'] = input("Output item name: ").strip()

            while True:
                try:
                    output['quantity'] = float(input("Quantity per craft: ").strip())
                    if output['quantity'] <= 0:
                        print("Quantity must be a positive integer")
                        continue
                    break
                except ValueError:
                    print("Please enter a valid quantity")
            
            is_primary = input("Is this the primary output? (y/n): ").strip()
            output['is_primary'] = is_primary == 'y'

            rate_per_min = (output['quantity'] * 60) / self.crafting_time
            print(f" -> This produces {rate_per_min:.2f} {output['item']} per minute")

            self.outputs.append(output)

            add_another = input("\nAdd more recipe outputs? (y/n): ").strip()
            if add_another != 'y':
                break

        primary_count = sum(1 for o in self.outputs if o['is_primary'])
        if primary_count == 0:
            print("\nWarning: No primary output. Setting first output as primary")
            print(f"\nPrimary output will be set to: {self.outputs[0]['item']}")
            self.outputs[0]['is_primary'] = True
        elif primary_count > 1:
            print("\nWarning: Multiple outputs have been set to primary")
        
    def prompt_ingredients(self):
        """Prompt for recipe ingredients"""
        print("\n--- Recipe Ingredients ---")

        while True:
            ingredient = {}
            ingredient['item'] = input("Ingredient item name: ").strip()

            while True:
                try:
                    ingredient['quantity'] = float(input("Quantity per craft: ").strip())
                    if ingredient['quantity'] <= 0:
                        print("Quantity must be a positive integer")
                        continue
                    break
                except ValueError:
                    print("Pleas enter a valid ingredient quantity")

            rate_per_min = (ingredient['quantity'] * 60) / self.crafting_time
            print(f" -> This requires {rate_per_min:.2f} {ingredient['item']} per minute")

            self.ingredients.append(ingredient)

            add_another = input("\nAdd another ingredient? (y/n): ")
            if add_another != 'y':
                break

    def display_summary(self):
        """Display a summary of the recipe"""
        print("\n" + "-"*15)
        print("RECIPE SUMMARY")
        print("-"*15)
        print(f"Name: {self.recipe_name}")
        print(f"Building: {self.building}")
        print(f"Crafting Time: {self.crafting_time}s")
        print(f"Alternate: {'Yes' if self.is_alternate else 'No'}")

        print("\nOutputs:")
        for output in self.outputs:
            rate = (output['quantity'] * 60) / self.crafting_time
            primary = " (PRIMARY)" if output['is_primary'] else " (byproduc)"
            print(f" - {output['quantity']} {output['item']} per craft = {rate:.2f}/min{primary}")

        print("\nIngredients:")
        for ingredient in self.ingredients:
            rate = (ingredient['quantity'] * 60) / self.crafting_time
            print(f" - {ingredient['quantity']} {ingredient['item']} per craft = {rate:.2f}/min")
            
        print("-"*15)
        
    def generate_sql(self) -> str:
        """Generate SQL statements for this recipe"""
        sql_parts = []

        sql_parts.append(f"-- Recipe: {self.recipe_name}")
        sql_parts.append(f"-- Building: {self.building}")
        sql_parts.append(f"-- Crafting Time: {self.crafint_time}s")
        sql_parts.append("")

        all_items = set()
        for output in self.outputs:
            all_items.add(output['item'])
        for ingredient in self.ingredients:
            all_items.add(ingredient['item'])

        if all_items:
            # Add items
            sql_parts.append("-- Ensure items exist")
            sql_parts.append("INSERT INTO items (name, category) VALUES")
            item_lines = [f"  ('{item}', 'intermediate')" for item in sorted(all_items)]
            sql_parts.append(",\n".join(item_lines))
            sql_parts.append("ON CONFLICT (name) DO NOTHING;")
            sql_parts.append("")
              
        # Add building
        sql_parts.append("-- Ensure building exists")
        sql_parts.append("INSERT INTO buildings (name, power_consumption) VALUES")
        sql_parts.append(f"  ('{self.building}', {self.building_power})")
        sql_parts.append("ON CONFLICT (name) DO NOTHING;")
        sql_parts.append("")

        # Add recipe
        sql_parts.append("-- Add recipe")
        sql_parts.append("INSERT INTO recipes (name, building_id, crafting_time, is_alternate)")
        sql_parts.append(f"SELECT '{self.recipe_name}', b.id, {self.crafting}, {self.is_alternate}")
        sql_parts.append("FROM buildings b")
        sql_parts.append(f"WHERE b.name = '{self.building}'")
        sql_parts.append("ON CONFLICT (name) DO NOTHING;")
        sql_parts.append("")

        # Add outputs
        if self.outputs:
            sql_parts.append("-- Add recipe outputs")
            for output in self.outputs:
                sql_parts.append("INSERT INTO recipe_outputs (recipe_id, item_id, quantity, is_primary)")
                sql_parts.append(f"SELECT r.id, i.id, {output['quantity']}, {'TRUE' if output['is_primary'] else 'FALSE'}")
                sql_parts.append("FROM recipes r, items i")                 
                sql_parts.append(f"WHERE r.name = '{self.recipe_name}'")
                sql_parts.append("ON CONFLICT (recipe_id, item_id) DO NOTHING;")
                sql_parts.append("")

        # Add ingredients
        if self.ingredients:
            sql_parts.append("-- Add recipe ingredients")
            for ingredient in ingredients:
                sql_parts.append("INSERT INTO recipe_ingredients (recipe_id, item_id, quantity)")
                sql_parts.append(f"SELECT r.id, i.id, {ingredient['quantity']}")
                sql_parts.append("FROM recipes r, items i")
                ingredient_name = ingredient['item']
                sql_parts.append(f"WHERE r.id = '{self.recipe_name}' AND i.name = '{ingredient_name}'")
                sql_parts.append("ON CONFLICT (recipe_id, item_id) DO NOTHING;")
                sql_parts.append("")

        return "\n".join(sql_parts)

def main():
    print("*"*20)
    print("Satisfactory Recipe Builder")
    print("*"*20)

    builder = RecipeBuilder()

    try:
        builder.prompt_basic_info()
        builder.prompt_outputs()
        builder.prompt_ingredients()

        building.display_summary()

        sql = builder.generate_sql()

        print("\n --- Choose method for saving recipe ---")
        print("-1- Display SQL to console")
        print("-2- Save to file")
        print("-3- Both")
        print("-4- Cancel")

        choice = input("\n(1-4): ").strip()
        input_check = FALSE

        if(choice == '1' or choice == '3'):
            print("\n" + "-"*30)
            print("Generated SQL...")
            print("\n" + "-"*30)
            print(sql)
            input_check = TRUE
        
        if(choice == '2' or choice == '3'):
            print("\n"+"-"*30)
            filename = input("\nEnter filename: ").strip()
            with open(filename, 'w') as f:
                f.write(sql)
            print(f"Saved to {filename}")
            input_check = TRUE

        if choice == '4':
            print("Operation cancelled.")
            return

        if not input_check:
            print("Invalid choice - cancelling operation.")
            return
        
        print("\nOperation complete.")
    
    except KeyboardInterrupt:
        print("\n\nCancelled by user.")
        sys.exit(0)
    except Exception as e:
        print(f"\nError occurred: {e}")
        sys.exit(1)
        
if __name__ == "__main__":
    main()

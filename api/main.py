from fastapi import FastAPI, HTTPException
from sqlalchemy import create_engine, text
from pydantic import BaseModel
import os
from calculator import ProductionCalculator

app = FastAPI(
    title="Satisfactory Production Calculator",
    description="Calculate production chains and resource requirements for Satisfactory",
    version="1.0.0"
)

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://factory_user:factory_pass@db:5432/satisfactory")
engine = create_engine(DATABASE_URL)

class ProductionRequest(BaseModel):
    item_name: str
    target_rate: float

@app.get("/")
def root():
    return {
        "message": "Satisfactory Production Calculator API",
        "version": "1.0.0",
        "endpoints": {
          "items": "/items",
          "recipes": "/recipes",
          "buildings": "/buildings",
          "calculate": "/calculate (POST)",
          "health": "/health"
        }
    }

@app.get("/items")
def list_items():
    """List all items in the database"""
    with engine.connect() as conn:
        result = conn.execute(text("SELECT name, category FROM items ORDER BY category, name;"))
        items = [{"name": row[0], "category": row[1]} for row in result]
    return {"count": len(items), "items": items}

@app.get("/items/{category}")
def list_items_by_category(category: str):
    """List items by category (raw, intermediate, or final)"""
    if category not in ['raw', 'intermediate', 'final']:
        raise HTTPException(status_code=400, detail="Category must be raw, intermediate, or final")

    with engine.connect() as conn:
        result = conn.execute(
          text("SELECT name FROM items WHERE category = :category ORDER BY name"),
          {"category": category}
        )
        items = [row[0] for row in result]
    return {"category": category, "count": len(items), "items": items}

@app.get("/recipes")
def list_recipes():
    """List all recipes"""
    with engine.connect() as conn:
        result = conn.execute(text("""
          SELECT r.name, r.crafting_time, b.name as building,
              STRING_AGG(DISTINCT i.name, ', ') as outputs
          FROM recipes r
          JOIN recipe_outputs ro ON r.id = ro.recipe_id
          JOIN items i ON ro.item_id = i.id
          JOIN buildings b ON r.building_id = b.id
          GROUP BY r.id, r.name, r.crafting_time, b.name
          ORDER BY r.name
        """))
        recipes = [
            {
                "name": row[0],
                "outputs": row[3],
                "crafting_time": float(row[1]),
                "building": row[2]
            } for row in result
        ]
    return {"count": len(recipes), "recipes": recipes}

@app.get("/recipes/{item_name}")
def get_recipe_for_item(item_name: str):
    """Get the recipe that produces a specific item"""
    calculator = ProductionCalculator(engine)
    try:
        recipe = calculator.get_recipe_for_item(item_name)
        return recipe
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))

@app.get("/buildings")
def list_buildings():
    """Lists all buildings"""
    with engine.connect() as conn:
      result = conn.execute(text("""
        SELECT name, power_consumption
        FROM buildings
        ORDER BY name
      """))
      buildings = [
          {
            "name":row[0],
            "power_consumption":float(row[1])
          } for row in result
      ]
    return {"count": len(buildings), "buildings":buildings}	

@app.post("/calculate")
def calculate_production(request: ProductionRequest):
    """Calculate complete production requirements for an item.
    Returns:
    - Production chain (intermediate steps)
    - Raw materials needed per minute
    - Total buildings required
    - Total power consumption
    """
    calculator = ProductionCalculator(engine)
    try:
        result = calculator.calculate_requirements(request.item_name, request.target_rate)
        return result
    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))

@app.get("/health")
def health_check():
    """Check API and database health"""
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        return {
            "status": "healthy",
            "database": "connected",
            "api": "running"
        }
    except Exception as e:
        return {
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(e)
        }

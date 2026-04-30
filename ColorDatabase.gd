extends Node
class_name ColorDatabase

# ─────────────────────────────────────────────────────────────
# DEFINITIONS
# ─────────────────────────────────────────────────────────────
const COLORS = {
	# 1. Primaries
	"red": Color(1.0, 0.2, 0.2),
	"blue": Color(0.2, 0.4, 1.0),
	"yellow": Color(1.0, 0.9, 0.2),
	
	# 2. Secondaries
	"purple": Color(0.6, 0.2, 0.8), 
	"orange": Color(1.0, 0.6, 0.0), 
	"green": Color(0.2, 0.8, 0.2), 
	
	# 3. Tertiaries
	"magenta": Color(0.8, 0.0, 0.4), 
	"violet": Color(0.4, 0.2, 0.9), 
	"vermilion": Color(1.0, 0.4, 0.2),
	"amber": Color(1.0, 0.75, 0.0), 
	"teal": Color(0.0, 0.6, 0.6), 
	"lime": Color(0.5, 0.9, 0.2), 

	# 4. Complex (Secondary + Secondary)
	"russet": Color(0.6, 0.3, 0.2), 
	"slate": Color(0.4, 0.4, 0.5), 
	"olive": Color(0.5, 0.5, 0.0), 
	
	# 5. Neutrals
	"grey": Color(0.5, 0.5, 0.5), 
	"brown": Color(0.4, 0.25, 0.1),
	"black": Color(0.1, 0.1, 0.1)
}

# ─────────────────────────────────────────────────────────────
# RECIPES
# ─────────────────────────────────────────────────────────────
# Keys are "color1_color2" (Must be Alphabetical!)
const RECIPES = {
	# --- TIER 1: Standard Secondaries ---
	"blue_red": "purple",
	"red_yellow": "orange",
	"blue_yellow": "green",
	
	# --- TIER 2: Tertiaries ---
	"purple_red": "magenta",
	"blue_purple": "violet",
	"orange_red": "vermilion",
	"orange_yellow": "amber",
	"blue_green": "teal",
	"green_yellow": "lime", 

	# --- TIER 3: Complex Mixes ---
	"orange_purple": "russet", 
	"green_purple": "slate",
	"green_orange": "olive",

	# --- TIER 4: Complementary (Opposites) ---
	"green_red": "grey",
	"blue_orange": "grey",
	"purple_yellow": "grey",
}

# ─────────────────────────────────────────────────────────────
# SPLIT RECIPES
# ─────────────────────────────────────────────────────────────
const SPLIT_RECIPES = {
	"purple": ["red", "blue"],
	"orange": ["red", "yellow"],
	"green": ["blue", "yellow"],
	
	"magenta": ["purple", "red"],
	"violet": ["purple", "blue"],
	"vermilion": ["orange", "red"],
	"amber": ["orange", "yellow"],
	"teal": ["blue", "green"],
	"lime": ["green", "yellow"], 
	
	"russet": ["orange", "purple"],
	"slate": ["green", "purple"],
	"olive": ["green", "orange"],
	
	"grey": ["red", "green"], 
	"black": ["grey", "blue"] 
}

# ─────────────────────────────────────────────────────────────
# HELPER FUNCTIONS (FIXED)
# ─────────────────────────────────────────────────────────────

static func mix_colors(a: String, b: String) -> String:
	a = a.to_lower()
	b = b.to_lower()
	
	# 1. Identity Check (Blue + Blue = Blue)
	if a == b:
		return a

	# 2. Sort names alphabetically to generate Key (e.g., "red" + "blue" -> "blue_red")
	var key = ""
	if a < b:
		key = a + "_" + b
	else:
		key = b + "_" + a
	
	# 3. Look up in RECIPES
	if RECIPES.has(key):
		return RECIPES[key]
		
	# 4. Fallback (If no recipe exists, it turns to sludge/black)
	return "black"

static func split_color(color_name: String) -> Array:
	var key = color_name.to_lower()
	if SPLIT_RECIPES.has(key):
		return SPLIT_RECIPES[key]
	
	# FIXED: Return empty array instead of null to prevent crashes
	return []

static func get_color_value(name: String) -> Color:
	if COLORS.has(name.to_lower()):
		return COLORS[name.to_lower()]
	return Color.WHITE

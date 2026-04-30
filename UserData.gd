extends Node

# --- LEVEL PROGRESS TRACKERS ---
# 1 = Level 1 is open. 
# 2 = Levels 1 & 2 are open.
var data_level_unlocked = 1
var expression_level_unlocked = 1
var function_level_unlocked = 1

# --- GENERIC UNLOCK FUNCTION ---
# Call this when a level is won: 
# UserData.unlock_next_level("data", 1)  <- Won Data Level 1
# UserData.unlock_next_level("expression", 1) <- Won Expression Level 1
func unlock_next_level(category: String, current_level_finished: int):
	var next_level = current_level_finished + 1
	
	if category == "data":
		if next_level > data_level_unlocked:
			data_level_unlocked = next_level
			
	elif category == "expression":
		if next_level > expression_level_unlocked:
			expression_level_unlocked = next_level
			
	elif category == "function":
		if next_level > function_level_unlocked:
			function_level_unlocked = next_level
	
	print(category, " progress saved! Level ", next_level, " is now unlocked.")

# Helper to check if a specific button should be active
func is_level_unlocked(category: String, level_number: int) -> bool:
	if category == "data":
		return level_number <= data_level_unlocked
	elif category == "expression":
		return level_number <= expression_level_unlocked
	elif category == "function":
		return level_number <= function_level_unlocked
	return false

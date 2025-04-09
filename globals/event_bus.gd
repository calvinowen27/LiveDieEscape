extends Node

signal start_game
signal change_room(level_idx: int, room_idx: int)
signal item_pickup(item: Item)
signal level_reset(level_idx: int)
signal player_death
signal player_respawn
signal powerup_pickup(powerup_name: String)
signal powerup_over(powerup_name: String)
signal materials_update
signal recipe_select(recipe: Recipe)

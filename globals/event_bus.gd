extends Node

signal start_game
signal change_room(level_idx: int, room_idx: int)
signal item_pickup(item: Item, idx: int)
signal item_drop(item_idx: int)
signal item_use(item_idx: int)
signal level_reset(level_idx: int)
signal player_death
signal player_respawn
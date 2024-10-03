extends Node

var _base_stats = {
			"health": 3,
			"speed": 2,
			"endurance": 3
			}

var _stats = {}

func _ready() -> void:
	_stats = _base_stats

# add stat: val to _stats, returns false if stat already in _base_stats
# returns true if successful
func add_base_stat(stat: String, val: int) -> bool:
	if stat in _base_stats.keys():
		print_debug("add_stat(): Stat %s already exists in _base_stats" % stat)
		return false
	
	_base_stats[stat] = val
	
	return true

# set value of stat to val, returns false if stat doesn't exist,
# returns true otherwise (success)
func set_base_stat(stat: String, val: int) -> bool:
	if stat not in _base_stats.keys():
		print_debug("set_stat(): Stat %s doesn't exist in _base_stats" % stat)
		return false
	
	_base_stats[stat] = val
	
	return true

# change stat by dval, returns false on failure, true on success
func change_stat(stat: String, dval: int) -> bool:
	if stat not in _stats.keys():
		print_debug("change_stat(): Stat %s doesn't exist in _stats" % stat)
		return false
	
	_stats[stat] += dval
	
	return true

# change base stat by dval, returns false on failure, true on success
func change_base_stat(stat: String, dval: int) -> bool:
	if stat not in _base_stats.keys():
		print_debug("change_stat(): Stat %s doesn't exist in _base_stats" % stat)
		return false
	
	_base_stats[stat] += dval
	
	return true

func get_stats() -> Dictionary:
	return _stats

func get_base_stats() -> Dictionary:
	return _base_stats

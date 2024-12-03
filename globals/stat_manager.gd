extends Node

var _base_stats = {
	"speed": 7,
	"speed_mult": 1
}

var _stats = {}

# 2nd dimension (entries) are of form [stat_name: String, new_val: int]
var _stat_changes: Array[Array] = []

func _ready() -> void:
	_stats = _base_stats.duplicate(true)

func get_stat(stat: String) -> float:
	if stat not in _stats.keys():
		print_debug("get_stat(): stat %s not in _stats.keys()" % stat)
		return -1
	
	return _stats[stat]

# add stat change to array and overwrite current stat
func change_stat(stat: String, new_val: float) -> bool:
	if stat not in _stats.keys():
			print_debug("change_stat(): stat %s not in _stats.keys()" % stat)
			return false
	
	_stat_changes.append([stat, new_val])

	_stats[stat] = new_val

	return true

# remove first instance of stat from stat change array
func revert_stat_change(stat: String, check_val: float) -> bool:
	var found_idx: int = -1
	for i in range(_stat_changes.size()):
		if _stat_changes[i][0] == stat and _stat_changes[i][1] == check_val:
			found_idx = i
	
	if found_idx == -1:
		return false
	
	_stat_changes.remove_at(found_idx)

	# check if stat still being altered
	var stat_altered: bool = false
	for change in _stat_changes:
		if change[0] == stat:
			stat_altered = true
			break
	
	# if stat not altered anymore, revert to base value
	if not stat_altered:
		_stats[stat] = _base_stats[stat]
		return true

	return false

func reset_stats() -> void:
	_stats.clear()

	_stats = _base_stats.duplicate(true)

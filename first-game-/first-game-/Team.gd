extends Node2D
@export var team_id: String
func _ready() -> void:
	print(" → [frame 0] TeamA.global_position (immediately): ", global_position)
	await get_tree().process_frame
	print(" → [frame 1] TeamA.global_position (after one frame): ", global_position)

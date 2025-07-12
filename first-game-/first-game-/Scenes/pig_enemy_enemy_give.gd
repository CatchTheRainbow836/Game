extends BaseEnemy
class_name Pig
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(500, 650)
	ui.attack  = randi_range(70, 100)
	ui.defense = randi_range(60, 80)
	ui.speed   = randi_range(30, 50)
	ui.type    = [13, 11] # Normal / Ground
	ui.moves = MovesFactory.get_moves("pig")

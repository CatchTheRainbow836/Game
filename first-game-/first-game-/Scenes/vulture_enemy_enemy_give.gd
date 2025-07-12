extends BaseEnemy
class_name Vulture
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(400, 550)
	ui.attack  = randi_range(80, 110)
	ui.defense = randi_range(30, 50)
	ui.speed   = randi_range(90, 120)
	ui.type    = [8, 2]   # Flying / Dark
	ui.moves = MovesFactory.get_moves("vulture")

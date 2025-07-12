extends BaseEnemy
class_name Eagle
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(400, 550)
	ui.attack  = randi_range(80, 110)
	ui.defense = randi_range(40, 60)
	ui.speed   = randi_range(100, 130)
	ui.type    = [8, 13]  # Flying / Normal
	ui.moves = MovesFactory.get_moves("eagle")

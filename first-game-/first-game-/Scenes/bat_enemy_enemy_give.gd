extends BaseEnemy
class_name Bat
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(300, 450)
	ui.attack  = randi_range(50, 80)
	ui.defense = randi_range(20, 40)
	ui.speed   = randi_range(80, 110)
	ui.type    = [8, 2]   # Flying / Dark
	ui.moves = MovesFactory.get_moves("bat")

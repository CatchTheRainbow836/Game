extends BaseEnemy
class_name Bird
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(300, 450)
	ui.attack  = randi_range(60, 90)
	ui.defense = randi_range(30, 50)
	ui.speed   = randi_range(90, 120)
	ui.type    = [8, 13]  # Flying / Normal
	ui.moves = MovesFactory.get_moves("bird")

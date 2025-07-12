extends BaseEnemy
class_name Ghost
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(350, 500)
	ui.attack  = randi_range(90, 120)
	ui.defense = randi_range(30, 50)
	ui.speed   = randi_range(60, 90)
	ui.type    = [9, 14]  # Ghost / Poison
	ui.moves = MovesFactory.get_moves("ghost")

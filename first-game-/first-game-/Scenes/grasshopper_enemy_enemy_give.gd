extends BaseEnemy
class_name Grasshopper
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(250, 400)
	ui.attack  = randi_range(40, 70)
	ui.defense = randi_range(20, 40)
	ui.speed   = randi_range(80, 110)
	ui.type    = [1, 10]  # Bug / Grass
	ui.moves = MovesFactory.get_moves("grasshopper")

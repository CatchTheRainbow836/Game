extends BaseEnemy
class_name Mushroom
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(250, 350)
	ui.attack  = randi_range(20, 40)
	ui.defense = randi_range(50, 80)
	ui.speed   = randi_range(20, 40)
	ui.type    = [12, 14] # Ice / Poison
	ui.moves = MovesFactory.get_moves("mushroom")

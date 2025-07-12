extends BaseEnemy
class_name Opossum
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(400, 550)
	ui.attack  = randi_range(50, 80)
	ui.defense = randi_range(40, 60)
	ui.speed   = randi_range(50, 80)
	ui.type    = [13, 14] # Normal / Poison
	ui.moves = MovesFactory.get_moves("opossum")

extends BaseEnemy
class_name Winterfox
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(450, 600)
	ui.attack  = randi_range(80, 110)
	ui.defense = randi_range(40, 60)
	ui.speed   = randi_range(80, 110)
	ui.type    = [13, 14] # Normal / Poison
	ui.moves = MovesFactory.get_moves("winterfox")

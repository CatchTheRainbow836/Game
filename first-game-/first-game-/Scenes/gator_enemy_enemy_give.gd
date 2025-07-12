extends BaseEnemy
class_name Gator
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(700, 900)
	ui.attack  = randi_range(110, 140)
	ui.defense = randi_range(80, 100)
	ui.speed   = randi_range(40, 70)
	ui.type    = [18, 11] # Water / Ground
	ui.moves = MovesFactory.get_moves("gator")

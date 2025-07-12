extends BaseEnemy
class_name Bear
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(900, 1200)
	ui.attack  = randi_range(120, 160)
	ui.defense = randi_range(100, 140)
	ui.speed   = randi_range(30, 50)
	ui.type    = [13, 11] # Normal / Ground
	ui.moves = MovesFactory.get_moves("bear")

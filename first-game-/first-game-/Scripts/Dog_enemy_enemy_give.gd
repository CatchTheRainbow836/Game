extends BaseEnemy
class_name Dog
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(500, 700)
	ui.attack  = randi_range(90, 120)
	ui.defense = randi_range(50, 75)
	ui.speed   = randi_range(70, 100)
	ui.type    = [13, 6]  # Normal / Fighting
	ui.moves = MovesFactory.get_moves("Dog_enemy")

	

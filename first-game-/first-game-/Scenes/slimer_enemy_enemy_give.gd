extends BaseEnemy
class_name Slimer
func _randomize_stats(ui: InvItem) -> void:
	ui.health  = randi_range(300, 450)
	ui.attack  = randi_range(40, 70)
	ui.defense = randi_range(20, 40)
	ui.speed   = randi_range(50, 80)
	ui.type    = [9, 18]  # Ghost / Water
	ui.moves = MovesFactory.get_moves("slimer")
